function random_forest(InputFile, ModelPath, MinTrainingTime, retrain)
    % Wczytanie przetworzonych danych
    load(InputFile, 'waveletData');
    
    % Przygotowanie danych
    X = []; % Dane wejściowe
    Y = []; % Etykiety
    for i = 1:numel(waveletData)
        for annotator = 1:4
            for qualityClass = 1:3
                data = waveletData(i).annotatorClassData{annotator, qualityClass};
                if ~isempty(data)
                    % Przygotowanie fragmentów sygnału o długości 2 minut
                    segmentLength = 2 * 60 * 1000;  % 2 minuty przy Fs = 1000 Hz
                    numSegments = floor(length(data) / segmentLength);
                    
                    for seg = 1:numSegments
                        segment = data((seg-1)*segmentLength + 1 : seg*segmentLength);
                        features = extract_features(segment, 1000);  % Oczekujemy, że 'features' to wiersz
                        X = [X; features];  % Łączenie cech wiersz po wierszu
                        Y = [Y; repmat(qualityClass, size(features, 1), 1)];
                    end
                end
            end
        end
    end
    
    if isempty(X) || isempty(Y)
        error("Brak danych do trenowania modelu. Upewnij się, że plik wejściowy zawiera poprawne dane.");
    end
    
    % Sprawdzanie, czy istnieje model do dotrenowywania
    if retrain && isfile(ModelPath)
        load(ModelPath, 'randomForestModel', 'totalTrainingTime');
        disp("Dotrenowywanie istniejącego modelu...");
        initialTrainingTime = totalTrainingTime; % Początkowy czas treningu
    else
        randomForestModel = [];
        initialTrainingTime = 0;
        disp("Trenowanie nowego modelu...");
    end
    
    % Rozpoczynanie procesu trenowania z wymuszeniem minimalnego czasu
    disp("Rozpoczynanie trenowania modelu z minimalnym czasem treningu...");
    startTime = tic; % Start pomiaru czasu
    trainingTime = 0; % Czas rzeczywistego trenowania w minutach
    
    % Inicjalizacja paska postępu
    progressBar = waitbar(0, 'Trwa trenowanie modelu...', 'Name', 'Trenowanie modelu', ...
                          'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
    setappdata(progressBar, 'canceling', 0); % Dodanie opcji anulowania
    
    while trainingTime < MinTrainingTime
        % Sprawdzenie, czy użytkownik anulował proces
        if getappdata(progressBar, 'canceling')
            disp("Proces trenowania został anulowany przez użytkownika.");
            delete(progressBar); % Usuwanie paska postępu
            return;
        end
        
        % Trenowanie modelu lasu losowego
        try
            if isempty(randomForestModel)
                % Trenowanie nowego modelu lasu losowego
                randomForestModel = TreeBagger(100, X, Y, 'OOBPrediction', 'on'); % 100 drzew w lesie
            else
                % Dotrenowywanie istniejącego modelu
                randomForestModel = compact(randomForestModel); % Kompaktowanie modelu
                randomForestModel = TreeBagger(100, X, Y, 'OOBPrediction', 'on'); % Ponowne trenowanie
            end
        catch ME
            delete(progressBar); % Usuwanie paska postępu w przypadku błędu
            disp("Trenowanie przerwane z powodu błędu.");
            rethrow(ME);
        end
        
        % Aktualizacja czasu treningu
        trainingTime = toc(startTime) / 60; % Zamiana czasu na minuty
        
        % Aktualizacja paska postępu
        progress = min(trainingTime / MinTrainingTime, 1); % Postęp w zakresie [0, 1]
        waitbar(progress, progressBar, sprintf('Trwa trenowanie modelu... %.0f%%', progress * 100));
    end
    
    % Usunięcie paska postępu po zakończeniu
    delete(progressBar);
    
    % Zapis modelu
    totalTrainingTime = initialTrainingTime + trainingTime; % Całkowity czas treningu
    save(ModelPath, 'randomForestModel', 'totalTrainingTime'); % Zapisz model oraz całkowity czas treningu
    
    % Wyświetlanie komunikatów
    disp(['Całkowity czas treningu (w tym dotrenowywanie): ', num2str(totalTrainingTime, '%.2f'), ' minut']);
end
