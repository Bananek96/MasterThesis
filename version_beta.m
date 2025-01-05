clear; close all; clc;

% Główne ustawienia
FolderPath = './database';
HowManyData = 0; % Liczba folderów do przetwarzania (0 = wszystkie)
ModelPath = './tree_model.mat'; % Ścieżka do zapisu/wczytania modelu
ProcessedDataPath = './data.mat'; % Ścieżka do pliku z przetworzonymi danymi
MinTrainingTime = 8; % Minimalny czas treningu w minutach

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

% Sprawdzanie, czy istnieje model drzewa decyzyjnego
if isfile(ModelPath)
    disp("Model drzewa decyzyjnego już istnieje. Czy chcesz dotrenować model? (tak/nie)");
    userInput = input('', 's');
    if strcmpi(userInput, 'tak')
        decision_tree(ProcessedDataPath, ModelPath, MinTrainingTime, true); % Dotrenowywanie
    else
        disp("Pomijanie dotrenowywania modelu.");
    end
else
    disp("Model drzewa decyzyjnego nie istnieje.");
    decision_tree(ProcessedDataPath, ModelPath, MinTrainingTime, false); % Trenowanie od nowa
    disp("Trenowanie modelu zakończone.");
end

disp("Uruchamianie oceny nowego sygnału...");
% Ścieżki do nowego sygnału i jego adnotacji
NewDataFile = './database/100001/100001_ECG';
AnnotationFile = './database/100001/100001_ANN';

% Uruchomienie oceny sygnału
evaluate_signal(NewDataFile, AnnotationFile, ModelPath);
disp("Ocena sygnału zakończona.");