function evaluate_model(ModelPath, ProcessedDataPath)
    % Wczytanie modelu lasów losowych
    load(ModelPath, 'randomForestModel');

    % Wczytanie przetworzonych danych
    load(ProcessedDataPath, 'waveletData');

    % Przygotowanie danych
    X = [];
    Y = [];
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

    % Rozpoczęcie walidacji krzyżowej
    disp("Rozpoczynanie walidacji krzyżowej...");
    
    % Przygotowanie walidacji krzyżowej (5-krotną walidację)
    cv = cvpartition(Y, 'KFold', 5); % Tworzymy kroswalidację na 5 zbiorach
    confusionMat = zeros(3, 3);  % Macierz pomyłek dla 3 klas (zakładając 3 klasy jakości)

    % Iteracja po zbiorach walidacyjnych
    for i = 1:cv.NumTestSets
        % Podział na dane treningowe i testowe
        trainIdx = training(cv, i);
        testIdx = test(cv, i);

        XTrain = X(trainIdx, :);
        YTrain = Y(trainIdx);
        XTest = X(testIdx, :);
        YTest = Y(testIdx);

        % Trenowanie modelu na danych treningowych
        model = TreeBagger(100, XTrain, YTrain, 'Method', 'classification');  % 100 drzew w lesie losowym

        % Predykcja na zbiorze testowym
        YPred = predict(model, XTest);
        YPred = str2double(YPred);  % Konwersja z komórek na liczby

        % Obliczanie macierzy pomyłek
        confusionMat = confusionMat + confusionmat(YTest, YPred);
    end

    % Wyświetlanie wyników w konsoli
    disp("Macierz pomyłek:");
    disp(confusionMat);

    % Obliczanie dokładności, czułości i specyficzności
    accuracy = sum(diag(confusionMat)) / sum(confusionMat(:));
    fprintf('Dokładność: %.2f%%\n', accuracy * 100);

    % Przygotowanie do zapisania wyników do pliku CSV
    fileID = fopen('evaluation_results.csv', 'w');
    
    if fileID == -1
        disp('Błąd przy otwieraniu pliku.');
        return;
    end

    % Zapis do pliku CSV
    fprintf(fileID, 'Macierz pomyłek:\n');
    fprintf(fileID, 'Predykcja 1, Predykcja 2, Predykcja 3\n');
    for i = 1:3
        fprintf(fileID, '%d, %d, %d\n', confusionMat(i,1), confusionMat(i,2), confusionMat(i,3));
    end
    
    fprintf(fileID, '\n');
    fprintf(fileID, 'Dokładność: %.2f%%\n', accuracy * 100);
    
    % Obliczanie miar klasyfikacji dla każdej klasy
    for i = 1:3  % 3 klasy
        truePositives = confusionMat(i,i);
        falsePositives = sum(confusionMat(:,i)) - truePositives;
        falseNegatives = sum(confusionMat(i,:)) - truePositives;
        trueNegatives = sum(confusionMat(:)) - (truePositives + falsePositives + falseNegatives);

        sensitivity = truePositives / (truePositives + falseNegatives);  % True Positive Rate
        specificity = trueNegatives / (trueNegatives + falsePositives);  % True Negative Rate

        fprintf(fileID, 'Klasa %d:\n', i);
        fprintf(fileID, '    Czułość: %.2f%%\n', sensitivity * 100);
        fprintf(fileID, '    Specyficzność: %.2f%%\n', specificity * 100);
    end
    
    % Zamykanie pliku
    fclose(fileID);
    disp("Wyniki zostały zapisane do pliku 'evaluation_results.csv'.");
end
