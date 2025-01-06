function evaluate_signal(NewDataFile, AnnotationFile, ModelPath)
    % Wyciąganie nazwy folderu sygnału (np. 100001) z pełnej ścieżki
    [folderPath, signalName, ~] = fileparts(NewDataFile);
    disp(['Analizowanie sygnału: ', signalName]);

    % Ustalanie częstotliwości próbkowania (1000 Hz)
    Fs = 1000;

    % Wczytanie danych EKG
    [sig, Fs, tm] = rdsamp(NewDataFile, 1);  % Wczytanie surowych danych sygnałowych

    % Wczytanie adnotacji
    anntr = [1, 2, 3, 4]; % Rodzaje adnotacji
    fromSample = 1; % Początkowy próbek
    toSample = length(sig); % Końcowy próbek (cały sygnał)
    ann = ann_reader(AnnotationFile, anntr, fromSample, toSample); % Wczytanie adnotacji

    % Podział na fragmenty 2-minutowe
    segmentLength = 2 * 60 * Fs; % 2 minuty w próbkach (zakładając Fs = 1000 Hz)
    numSegments = floor(length(sig) / segmentLength); % Liczba pełnych segmentów

    % Wczytanie modelu
    load(ModelPath, 'randomForestModel');

    % Przewidywanie jakości dla każdego segmentu
    predictedClasses = [];
    for i = 1:numSegments
        segmentStart = (i - 1) * segmentLength + 1;
        segmentEnd = i * segmentLength;
        segmentData = sig(segmentStart:segmentEnd);
        
        % Ekstrakcja cech z segmentu
        features = extract_features(segmentData, Fs);
        
        % Klasyfikacja
        % Zmieniamy transpozycję, aby upewnić się, że dane mają odpowiedni kształt
        predictedClass = predict(randomForestModel, features);  % bez transponowania
        predictedClasses = [predictedClasses; str2double(predictedClass)];  % Zamiana na liczby
    end
    
    % Liczenie procentów klasyfikacji
    classCounts = histcounts(predictedClasses, 'BinMethod', 'integers', 'BinLimits', [1, 3]);
    totalCount = sum(classCounts);
    fprintf('Procenty klas:\n');
    for i = 1:3
        fprintf('Klasa %d: %.2f%%\n', i, (classCounts(i) / totalCount) * 100);
    end

    % Zliczanie procentów według annotatorów
    annotatorCounts = zeros(4, 3);  % 4 annotatorów, 3 klasy
    for i = 1:4  % Dla każdego annotatora
        for j = 1:3  % Dla każdej klasy
            annotatorCounts(i, j) = sum(ann(i, :) == j);
        end
    end
    fprintf('\nProcenty według annotatorów:\n');
    for i = 1:4
        fprintf('Annotator %d:\n', i);
        for j = 1:3
            fprintf('  Klasa %d: %.2f%%\n', j, (annotatorCounts(i, j) / sum(annotatorCounts(i, :))) * 100);
        end
    end
end
