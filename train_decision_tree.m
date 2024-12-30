function model = train_decision_tree(ModelPath, processedData)
    % Przygotowanie danych treningowych
    [XTrain, YTrain] = prepare_data_for_tree(processedData);

    % Sprawdzenie, czy istnieje model i czy należy go dotrenować
    if isfile(ModelPath)
        disp("Wczytywanie istniejącego modelu...");
        loadedData = load(ModelPath, 'model');
        model = loadedData.model;
        
        % Dotrenowanie istniejącego modelu
        disp("Dotrenowanie istniejącego modelu...");
        model = fitctree(XTrain, YTrain, 'Surrogate', 'on', 'MergeLeaves', 'off', 'CategoricalPredictors', 'all', 'Weights', []);
    else
        disp("Tworzenie nowego modelu...");
        % Tworzenie nowego modelu drzewa decyzyjnego
        model = fitctree(XTrain, YTrain, 'Surrogate', 'on', 'MergeLeaves', 'off', 'CategoricalPredictors', 'all', 'Weights', []);
    end

    % Zapis modelu
    save(ModelPath, 'model');
    disp("Model zapisany do pliku.");
end