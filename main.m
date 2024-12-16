% Główne ustawienia
% close all;
% clear;
% clc;

FolderPath = './database';
HowManyData = 1;

% Przetwarzanie danych
disp("Rozpoczęcie przetwarzania danych");
processedData = data_processing(FolderPath, HowManyData);
disp("Zakończono przetwarzanie danych");

% Trenowanie modelu CNN
disp("Rozpoczęcie treningu modelu CNN");
trainedModel = train_cnn(processedData);
disp("Zakończono trening modelu CNN");

% Ewaluacja modelu
disp("Rozpoczęcie ewaluacji modelu");
evaluate_model(trainedModel, processedData);
disp("Zakończono ewaluację modelu");
