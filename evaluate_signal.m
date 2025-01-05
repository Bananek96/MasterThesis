function evaluate_signal(NewDataFile, AnnotationFile, ModelPath)
    % Wczytanie sygnału
    try
        [sig, Fs, tm] = rdsamp(NewDataFile, 1);
    catch
        error("Nie można wczytać sygnału. Sprawdź ścieżkę: %s", NewDataFile);
    end

    % Wczytanie modelu drzewa decyzyjnego
    if ~isfile(ModelPath)
        error("Model drzewa decyzyjnego nie istnieje. Sprawdź ścieżkę: %s", ModelPath);
    end
    load(ModelPath, 'decisionTreeModel');
    
    if ~exist('decisionTreeModel', 'var')
        error("Model drzewa decyzyjnego nie został poprawnie załadowany.");
    end

    % Wczytanie adnotacji
    anntr = [1, 2, 3, 4]; % Określenie rodzajów adnotacji do wczytania
    fromSample = 1; % Początkowy próbek
    toSample = length(sig); % Końcowy próbek (cały sygnał)
    ann = ann_reader(AnnotationFile, anntr, fromSample, toSample); % Wczytanie adnotacji

    % Analiza jakości na podstawie adnotacji
    annotationClasses = ann(1, :); % Zakładam, że adnotacje są w pierwszej kolumnie

    % Obliczanie procentowego podziału sygnału na klasy wg adnotacji
    uniqueClasses = unique(annotationClasses);
    annotationDistribution = histcounts(annotationClasses, [uniqueClasses, max(uniqueClasses)+1]) / length(annotationClasses) * 100;

    % Wyświetlanie wyników z adnotacji
    disp("Udział procentowy każdej klasy w sygnale (adnotacje):");
    for i = 1:length(uniqueClasses)
        fprintf("Klasa %d: %.2f%%\n", uniqueClasses(i), annotationDistribution(i));
    end

    % Podział sygnału na fragmenty (np. 10-sekundowe segmenty)
    segmentLength = 10 * Fs; % 10 sekund w próbkach
    numSegments = floor(length(sig) / segmentLength);
    
    classifications = zeros(numSegments, 1); % Klasyfikacje segmentów

    % Ekstrakcja cech i klasyfikacja całego sygnału
    for i = 1:numSegments
        % Wyciąganie segmentu
        segmentStart = (i - 1) * segmentLength + 1;
        segmentEnd = i * segmentLength;
        segment = sig(segmentStart:segmentEnd);

        % Ekstrakcja cech z segmentu
        features = extract(segment);

        % Sprawdzanie wartości cech przed normalizacją
        if any(isnan(features(:))) || any(isinf(features(:)))
            error('Cechy zawierają wartości NaN lub Inf. Sprawdź dane.');
        end

        % Standaryzacja cech
        features = standardize(features);

        % Upewniamy się, że dane wejściowe do predict są w odpowiednim formacie (macierz)
        features = features(:)';  % Zamiana na 1xN (jeśli było wektorem)

        % Klasyfikacja segmentu
        try
            classifications(i) = predict(decisionTreeModel, features);
        catch
            error("Nie udało się sklasyfikować segmentu %d. Sprawdź format danych.", i);
        end
    end

    % Obliczanie procentowego podziału sygnału na klasy wg modelu
    predictedDistribution = histcounts(classifications, [uniqueClasses, max(uniqueClasses)+1]) / length(classifications) * 100;

    % Wyświetlanie wyników z modelu
    disp("Udział procentowy każdej klasy w sygnale (model):");
    for i = 1:length(uniqueClasses)
        fprintf("Klasa %d: %.2f%%\n", uniqueClasses(i), predictedDistribution(i));
    end
end
