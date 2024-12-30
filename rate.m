% Główne ustawienia
FolderPath = './database';
HowManyData = 1;
ModelPath = './decision_tree_model.mat';
MaxTrainingTime = 60;
SignalFile = './database/100001/100001_ECG'; % Ścieżka do pliku z nowym sygnałem

% Ocena jakości nowego sygnału bez pliku annotacyjnego
evaluate_new_signal(ModelPath, SignalFile);
