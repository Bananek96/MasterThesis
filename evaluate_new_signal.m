function evaluate_new_signal(ModelPath, SignalFile)
    % Wczytanie modelu
    if ~isfile(ModelPath)
        error("Model nie istnieje. Upewnij się, że model został przetrenowany.");
    end

    loadedData = load(ModelPath, 'model');
    model = loadedData.model;

    % Wczytanie nowego sygnału
    [sig, Fs, tm] = rdsamp(SignalFile, 1);

    % Przygotowanie danych (zgodnie z procesem przetwarzania danych treningowych)
    disp("Rozpoczynam przetwarzanie nowego sygnału...");
    processedSignal = data_processing_single(sig, tm);

    % Ocena jakości sygnału
    disp("Rozpoczynam ocenę jakości nowego sygnału...");
    [XNew, YPred] = predict_signal(model, processedSignal);

    % Wizualizacja wyników
    visualize_signal_classification(sig, tm, YPred);

    % Obliczenie proporcji klas i wyświetlenie wyników
    totalSamples = numel(YPred);
    proportions = zeros(1, 3); % Dla 3 klas
    for qualityClass = 1:3
        classSamples = sum(YPred == qualityClass);
        proportions(qualityClass) = classSamples / totalSamples * 100;
        disp(['Klasa ', num2str(qualityClass), ': ', num2str(proportions(qualityClass)), '%']);
    end

    % Wyświetlenie proporcji na wykresie
    add_class_proportions_to_plot(proportions);
end
