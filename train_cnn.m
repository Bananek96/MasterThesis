function model = train_cnn(processedData)
    % Przygotowanie danych
    [XTrain, YTrain] = prepare_data_for_cnn(processedData);

    % Wyświetlenie rozmiaru danych
    % disp(['Rozmiar XTrain przed permutacją: ', num2str(size(XTrain))]);
    % disp(['Rozmiar YTrain: ', num2str(size(YTrain))]);

    % Dopasowanie wymiaru wejścia
    inputSize = size(XTrain, 2);  % Liczba cech
    % disp(['Rozmiar wejściowy sieci: ', num2str(inputSize)]);
    
    % Warstwy sieci
    layers = [
        featureInputLayer(inputSize, 'Name', 'input')  % Rozmiar wejścia
        fullyConnectedLayer(32, 'Name', 'fc1')        % Warstwa w pełni połączona
        reluLayer('Name', 'relu1')                   % Warstwa aktywacji ReLU
        fullyConnectedLayer(3, 'Name', 'fc2')        % Warstwa wyjściowa (3 klasy)
        softmaxLayer('Name', 'softmax')              % Warstwa softmax do klasyfikacji
        classificationLayer('Name', 'output')        % Warstwa klasyfikacji
    ];

    % Opcje treningowe
    options = trainingOptions('adam', ...
        'MaxEpochs', 10, ...
        'MiniBatchSize', 32, ...
        'Plots', 'training-progress', ...
        'Verbose', false);

    % Przekształcenie YTrain na kategorię (categorical)
    YTrain = categorical(YTrain);

    % Trening modelu
    model = trainNetwork(XTrain, YTrain, layers, options);
end
