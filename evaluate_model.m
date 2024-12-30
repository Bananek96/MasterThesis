function evaluate_model(model, processedData)
    % Przygotowanie danych do ewaluacji
    [XTest, YTest] = prepare_data_for_tree(processedData);

    % Dokonanie predykcji na zestawie testowym
    YPred = predict(model, XTest);

    % Obliczenie dokładności (accuracy)
    accuracy = sum(YPred == YTest) / numel(YTest);
    disp(['Dokładność: ', num2str(accuracy)]);

    % Obliczenie dodatkowych metryk
    confMat = confusionmat(YTest, YPred);
    precision = diag(confMat) ./ sum(confMat, 2); % Precision dla każdej klasy
    recall = diag(confMat) ./ sum(confMat, 1)';  % Recall dla każdej klasy
    f1 = 2 * (precision .* recall) ./ (precision + recall);  % F1-score dla każdej klasy

    disp(['Precision: ', num2str(mean(precision, 'omitnan'))]);
    disp(['Recall: ', num2str(mean(recall, 'omitnan'))]);
    disp(['F1-score: ', num2str(mean(f1, 'omitnan'))]);
end
