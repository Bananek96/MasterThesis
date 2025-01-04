% Główne ustawienia
FolderPath = './database';
HowManyData = 1; % Liczba folderów do przetwarzania (0 = wszystkie)
ModelPath = './decision_tree_model.mat'; % Ścieżka do zapisu/wczytania modelu
ProcessedDataPath = './processed_data.mat'; % Ścieżka do pliku z przetworzonymi danymi
MaxTrainingTime = 60; % Maksymalny czas treningu w sekundach

% Sprawdzenie, czy dane zostały już przetworzone
if isfile(ProcessedDataPath)
    disp("Wczytywanie przetworzonych danych...");
    loadedData = load(ProcessedDataPath, 'processedData');
    processedData = loadedData.processedData;
else
    disp("Rozpoczęcie przetwarzania danych...");
    processedData = data_processing(FolderPath, HowManyData);
    disp("Zakończono przetwarzanie danych");

    % Zapis przetworzonych danych do pliku w wersji 7.3
    save(ProcessedDataPath, 'processedData', '-v7.3');
    disp("Zapisano przetworzone dane do pliku");

end

% Trenowanie modelu drzewa decyzyjnego
disp("Rozpoczęcie treningu modelu");
trainedModel = train_decision_tree(ModelPath, processedData, MaxTrainingTime);
disp("Zakończono trening modelu");
