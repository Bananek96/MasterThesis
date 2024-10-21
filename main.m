addpath('./ecg_brno_data/');
% Wczytanie adnotacji jakości sygnału za pomocą funkcji ann_reader
annotationFile = '100001_ANN';  % Nazwa pliku z adnotacjami
anntr = [1 2 3];  % Wybór adnotatorów
fromSample = 1;   % Początek sygnału
toSample = 1000000;  % Koniec sygnału

% Wczytanie adnotacji jakości sygnału
ann = ann_reader(annotationFile, anntr, fromSample, toSample);
