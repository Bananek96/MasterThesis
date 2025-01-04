function features = extract_features(sig, Fs)
    % Funkcja do ekstrakcji cech z sygnału
    disp("Rozpoczynanie ekstrakcji cech...");
    windowSize = Fs * 5; % 5-sekundowe okno
    overlap = Fs * 2.5; % Nakładanie okien co 2.5 sekundy
    numWindows = floor((length(sig) - windowSize) / (windowSize - overlap)) + 1;

    features = [];
    for i = 1:numWindows
        startIdx = (i-1) * (windowSize - overlap) + 1;
        endIdx = startIdx + windowSize - 1;
        if endIdx > length(sig)
            break;
        end
        segment = sig(startIdx:endIdx);

        % Transformacja falkowa
        [c, ~] = wavedec(segment, 4, 'db4');

        % Ekstrakcja cech statystycznych
        stats.mean = mean(c);
        stats.std = std(c);
        stats.skewness = skewness(c);
        stats.kurtosis = kurtosis(c);
        stats.energy = sum(c.^2);

        % Dodatkowe cechy, aby dopasować się do modelu
        stats.median = median(c);
        stats.max = max(c);
        stats.min = min(c);
        stats.range = range(c);

        % Przekształcenie do wektora (łącznie 9 cech)
        featureVector = [stats.mean, stats.std, stats.skewness, stats.kurtosis, ...
                         stats.energy, stats.median, stats.max, stats.min, stats.range];
        features = [features; featureVector]; % Dodanie cech do macierzy
    end
    disp("Ekstrakcja cech zakończona.");
end
