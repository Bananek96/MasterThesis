function compare(SignalFile, ModelPath)
    % Funkcja porównująca jakość sygnału na podstawie adnotacji i modelu
    disp("Wczytywanie sygnału...");
    [sig, Fs, tm] = rdsamp(SignalFile, 1); % Wczytanie sygnału

    disp("Wczytywanie adnotacji...");
    AnnotationFile = strrep(SignalFile, '_ECG', '_ANN'); % Automatyczna nazwa pliku z adnotacjami
    anntr = [1, 2, 3, 4]; % Wybór annotatorów
    fromSample = 1; % Początkowa próbka
    toSample = length(sig); % Końcowa próbka
    ann = ann_reader(AnnotationFile, anntr, fromSample, toSample);

    % Wybieramy pierwszego annotatora jako bazowego
    annotationClasses = ann(1, :); 

    disp("Analiza jakości na podstawie adnotacji...");
    % Obliczanie procentowego podziału sygnału na klasy wg adnotacji
    uniqueClasses = unique(annotationClasses);
    annotationDistribution = histcounts(annotationClasses, [uniqueClasses, max(uniqueClasses)+1]) / length(annotationClasses) * 100;

    disp("Wczytywanie modelu drzewa decyzyjnego...");
    if ~isfile(ModelPath)
        error("Plik modelu nie istnieje: %s", ModelPath);
    end
    loadedModel = load(ModelPath);
    model = loadedModel.model;

    disp("Przetwarzanie sygnału...");
    % Ekstrakcja cech z sygnału
    featureSet = extract_features(sig, Fs); % Przekazanie Fs do funkcji

    disp("Klasyfikacja sygnału...");
    % Klasyfikacja sygnału na podstawie modelu
    predictedClasses = predict(model, featureSet);

    % Obliczanie procentowego podziału sygnału na klasy wg modelu
    predictedDistribution = histcounts(predictedClasses, [uniqueClasses, max(uniqueClasses)+1]) / length(predictedClasses) * 100;

    % Wyświetlenie rozkładu procentowego
    disp("Udział procentowy każdej klasy w sygnale (adnotacje):");
    for i = 1:length(uniqueClasses)
        disp(["Klasa", uniqueClasses(i), ": ", annotationDistribution(i), "%"]);
    end

    disp("Udział procentowy każdej klasy w sygnale (model):");
    for i = 1:length(uniqueClasses)
        disp(["Klasa", uniqueClasses(i), ": ", predictedDistribution(i), "%"]);
    end
end
