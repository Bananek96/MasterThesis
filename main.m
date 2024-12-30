% Główne ustawienia
% close all;
% clear;
% clc;

FolderPath = './database';
HowManyData = 1; % Liczba folderów do przetwarzania (0 = wszystkie)
ModelPath = './decision_tree_model.mat'; % Ścieżka do zapisu/wczytania modelu

% Przetwarzanie danych
disp("Rozpoczęcie przetwarzania danych");
processedData = data_processing(FolderPath, HowManyData);
disp("Zakończono przetwarzanie danych");

% Trenowanie modelu drzewa decyzyjnego
disp("Rozpoczęcie treningu modelu drzewa decyzyjnego");
trainedModel = train_decision_tree(ModelPath, processedData);
disp("Zakończono trening modelu drzewa decyzyjnego");

% Ewaluacja modelu
disp("Rozpoczęcie ewaluacji modelu");
evaluate_model(trainedModel, processedData);
disp("Zakończono ewaluację modelu");

% radialna jedna warstwa, drzewa decyzyjne, metoda najblizszych sasiadow lub sigmmuidalana dla dwoch warst
% przeksztalcic na jeden wektor i podawac wektor cech na wejsciu
% macierz po dekompozycji dla surowych sygnalu dla konwolucyjnej
% lasy losowe, drzewa decyzyjne i metoda najblizszych sasiadow
