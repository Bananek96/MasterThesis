function qualityClass = evaluate_signal_fragment(signalFragment, model)
    % Przygotowanie danych wejściowych na podstawie cech statystycznych
    stats.mean = mean(signalFragment);
    stats.std = std(signalFragment);
    stats.skewness = skewness(signalFragment);
    stats.kurtosis = kurtosis(signalFragment);
    stats.median = median(signalFragment);
    stats.min = min(signalFragment);
    stats.max = max(signalFragment);
    stats.energy = sum(signalFragment.^2);
    stats.entropy = -sum(signalFragment.^2 .* log(signalFragment.^2 + eps));

    % Tworzenie wektora cech
    features = [
        stats.mean, ...
        stats.std, ...
        stats.skewness, ...
        stats.kurtosis, ...
        stats.median, ...
        stats.min, ...
        stats.max, ...
        stats.energy, ...
        stats.entropy
    ];

    % Klasyfikacja fragmentu sygnału
    qualityClass = classify(model, features');
end
