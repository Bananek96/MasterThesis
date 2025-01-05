function features = extract(data)
    % Funkcja ekstrakcji cech z sygnału EKG
    % Możesz dodać swoje cechy, takie jak: średnia, wariancja, współczynniki falkowe
    windowSize = length(data); % Dostosowanie do długości segmentu
    
    if length(data) < windowSize
        warning('Długość sygnału jest mniejsza niż wymagane okno.');
    end
    
    % Obliczanie cech
    meanVal = mean(data);             % Średnia
    stdVal = std(data);               % Odchylenie standardowe
    skewnessVal = skewness(data);     % Skośność
    kurtosisVal = kurtosis(data);     % Kurtoza
    
    % Tworzenie wektora cech
    features = [meanVal, stdVal, skewnessVal, kurtosisVal];
end