clear; close all; clc;

% Główne ustawienia
FolderPath = './database';
HowManyData = 14; % Liczba folderów do przetwarzania (0 = wszystkie)
ModelPath = './rf_model.mat'; % Ścieżka do zapisu/wczytania modelu lasów losowych
ProcessedDataPath = './data.mat'; % Ścieżka do pliku z przetworzonymi danymi
MinTrainingTime = 10; % Minimalny czas treningu w minutach

% Sprawdzanie, czy istnieje plik z przetworzonymi danymi
if isfile(ProcessedDataPath)
    disp("Plik z przetworzonymi danymi już istnieje. Czy chcesz przeprowadzić selekcję danych na nowo? (tak/nie)");
    userInput = input('', 's');
    if strcmpi(userInput, 'tak')
        disp("Rozpoczynanie selekcji danych...");
        % Uruchomienie selekcji danych
        data_selection(FolderPath, HowManyData, ProcessedDataPath);
        disp("Selekcja danych zakończona.");
    else
        disp("Pomijanie selekcji danych. Korzystanie z istniejącego pliku.");
    end
else
    disp("Rozpoczynanie selekcji danych...");
    % Uruchomienie selekcji danych
    data_selection(FolderPath, HowManyData, ProcessedDataPath);
    disp("Selekcja danych zakończona.");
end

% Sprawdzanie, czy istnieje model lasów losowych
if isfile(ModelPath)
    disp("Model lasów losowych już istnieje. Czy chcesz dotrenować model? (tak/nie)");
    userInput = input('', 's');
    if strcmpi(userInput, 'tak')
        % Dotrenowywanie modelu lasów losowych
        random_forest(ProcessedDataPath, ModelPath, MinTrainingTime, true); % Dotrenowywanie
    else
        disp("Pomijanie dotrenowywania modelu.");
    end
else
    disp("Model lasów losowych nie istnieje.");
    random_forest(ProcessedDataPath, ModelPath, MinTrainingTime, false); % Trenowanie modelu od nowa
end

disp("Uruchamianie oceny nowego sygnału...");

% Ścieżki do nowego sygnału i jego adnotacji
NewDataFiles = {'./database/123001/123001_ECG', './database/124001/124001_ECG', './database/125001/125001_ECG', './database/126001/126001_ECG'};
AnnotationFiles = {'./database/123001/123001_ANN', './database/124001/124001_ANN','./database/125001/125001_ANN','./database/126001/126001_ANN'};

% Uruchomienie oceny sygnału
% Pętla do analizy kolejnych sygnałów
for i = 1:length(NewDataFiles)
    disp(['Przetwarzanie sygnału ', num2str(i), ' z ', num2str(length(NewDataFiles))]);
    evaluate_signal(NewDataFiles{i}, AnnotationFiles{i}, ModelPath);
end
disp("Ocena sygnału zakończona.");
