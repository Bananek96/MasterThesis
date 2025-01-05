function standardizedFeatures = standardize(features)
    % Funkcja standaryzacji cech (zmienia średnią na 0 i odchylenie standardowe na 1)
    meanVal = mean(features);
    stdVal = std(features);
    
    % Standaryzacja
    standardizedFeatures = (features - meanVal) / stdVal;
end