% Główne ustawienia
ModelPath = './decision_tree_model.mat'; % Ścieżka do zapisu/wczytania modelu
ProcessedDataPath = './processed_data.mat'; % Ścieżka do pliku z przetworzonymi danymi
MaxTrainingTime = 1000; % Maksymalny czas treningu w sekundach

% Wczytanie przetworzonych danych
disp("Wczytywanie przetworzonych danych...");
loadedData = load(ProcessedDataPath);
processedData = loadedData.processedData;

% Wczytanie czasu treningu z pliku 'training_time.mat'
if isfile('training_time.mat')
    loadedTrainingTime = load('training_time.mat');
    totalTrainingTime = loadedTrainingTime.totalTrainingTime; % Czas zapisany w pliku
    disp(["Wczytano istniejący całkowity czas treningu: ", num2str(totalTrainingTime), " sekund"]);
else
    totalTrainingTime = 0; % Jeśli plik nie istnieje, zaczynamy od 0
    disp("Nie znaleziono pliku z czasem treningu. Zaczynamy od 0.");
end

% Trenowanie modelu drzewa decyzyjnego
disp("Rozpoczęcie treningu modelu...");
trainedModel = train_decision_tree(ModelPath, processedData, MaxTrainingTime);

% Zaktualizowanie całkowitego czasu treningu
totalTrainingTime = totalTrainingTime + MaxTrainingTime;

% Zapisanie zaktualizowanego czasu treningu w pliku 'training_time.mat'
save('training_time.mat', 'totalTrainingTime', '-v7.3');

% Wyświetlenie całkowitego czasu treningu
disp(["Całkowity czas treningu po dotrenowaniu: ", num2str(totalTrainingTime), " sekund"]);
