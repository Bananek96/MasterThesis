function model = train_decision_tree(ModelPath, processedData, maxTrainingTime)
    % Przygotowanie danych treningowych
    [XTrain, YTrain] = prepare_data_for_tree(processedData);

    % Sprawdzenie, czy istnieje model i czy należy go dotrenować
    startTime = tic; % Mierzenie czasu treningu
    totalTrainingTime = 0; % Domyślny czas, jeśli brak danych w pliku

    if isfile(ModelPath)
        disp("Wczytywanie istniejącego modelu...");
        loadedData = load(ModelPath, 'model');
        model = loadedData.model;
        disp("Dotrenowanie istniejącego modelu...");
    else
        disp("Tworzenie nowego modelu...");
        model = fitctree(XTrain, YTrain, 'Surrogate', 'on', 'MergeLeaves', 'off', 'CategoricalPredictors', 'all', 'Weights', []);
    end

    % Dotrenowanie modelu przez określony czas
    while toc(startTime) + totalTrainingTime < maxTrainingTime
        % W przypadku nowych danych można zastąpić model przez ponowne trenowanie
        model = fitctree(XTrain, YTrain, 'Surrogate', 'on', 'MergeLeaves', 'off', 'CategoricalPredictors', 'all', 'Weights', []);
    end

    % Aktualizacja całkowitego czasu treningu
    totalTrainingTime = totalTrainingTime + toc(startTime);
    
    % Zapis modelu i czasu treningu do osobnych plików
    trainingTime = totalTrainingTime; % Czas treningu
    save(ModelPath, 'model', '-v7.3');
    save('training_time.mat', 'trainingTime', '-v7.3'); % Zapisz czas treningu do oddzielnego pliku
    
    disp(["Czas treningu: ", num2str(totalTrainingTime), " sekund"]);
end
