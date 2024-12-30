function model = train_decision_tree(ModelPath, processedData, maxTrainingTime)
    % Przygotowanie danych treningowych
    [XTrain, YTrain] = prepare_data_for_tree(processedData);

    % Sprawdzenie, czy istnieje model i czy należy go dotrenować
    startTime = tic; % Mierzenie czasu treningu
    totalTrainingTime = 0; % Domyślny czas, jeśli brak danych w pliku

    if isfile(ModelPath)
        disp("Wczytywanie istniejącego modelu...");
        loadedData = load(ModelPath, 'model', 'trainingTime');
        
        % Sprawdzenie, czy 'trainingTime' istnieje w załadowanych danych
        if isfield(loadedData, 'trainingTime')
            totalTrainingTime = loadedData.trainingTime;
        else
            disp("Ostrzeżenie: Zmienna 'trainingTime' nie istnieje w pliku modelu. Ustawiam 0.");
        end
        
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
    
    % Zapis modelu i czasu treningu
    trainingTime = totalTrainingTime; % Upewniamy się, że zmienna istnieje
    save(ModelPath, 'model', 'trainingTime', '-v7.3');
    disp(["Całkowity czas treningu: ", num2str(totalTrainingTime), " sekund"]);
end
