function processedSignal = data_processing_single(sig, tm)
    % Przygotowanie próbek
    qualityIndices = 1:length(sig);

    % Transformacja falkowa
    [c, ~] = wavedec(qualityIndices, 4, 'db4');
    coefficients = c;

    % Cechy statystyczne
    stats.mean = mean(coefficients);
    stats.std = std(coefficients);
    stats.skewness = skewness(coefficients);
    stats.kurtosis = kurtosis(coefficients);
    stats.median = median(coefficients);
    stats.min = min(coefficients);
    stats.max = max(coefficients);
    stats.energy = sum(coefficients.^2);
    stats.entropy = -sum(coefficients.^2 .* log(coefficients.^2 + eps));

    % Zwrócenie struktury danych
    processedSignal = struct('statistics', stats, 'times', tm);
end
