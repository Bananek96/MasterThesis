function evaluate_model(model, processedData)
    % Przygotowanie danych do ewaluacji
    [XTest, YTest] = prepare_data_for_cnn(processedData);

    % Dokonanie predykcji na zestawie testowym
    YPred = classify(model, XTest);

    % Przekształcenie YTest na kategorie
    YTest = categorical(YTest);

    % Obliczenie dokładności (accuracy)
    accuracy = sum(YPred == YTest) / numel(YTest);
    disp(['Dokładność: ', num2str(accuracy)]);

    % Obliczenie dodatkowych metryk
    confMat = confusionmat(YTest, YPred);
    precision = confMat(1,1) / sum(confMat(:,1)); % Precision dla klasy 1
    recall = confMat(1,1) / sum(confMat(1,:));   % Recall dla klasy 1
    f1 = 2 * (precision * recall) / (precision + recall);  % F1-score dla klasy 1

    disp(['Precision: ', num2str(precision)]);
    disp(['Recall: ', num2str(recall)]);
    disp(['F1-score: ', num2str(f1)]);
end
