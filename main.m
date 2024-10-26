addpath('./database/');
addpath('./mcode/');
addpath('./database/100001/');
%% Wczytanie adnotacji jakości sygnału za pomocą funkcji ann_reader
annotationFile = '100001_ANN';  % Nazwa pliku z adnotacjami
anntr = [1 2 3];  % Wybór adnotatorów
fromSample = 1;   % Początek sygnału
toSample = 1000000;  % Koniec sygnału

% Wczytanie adnotacji jakości sygnału
ann = ann_reader(annotationFile, anntr, fromSample, toSample);

% jakie wartosci sygnalu podaje sie do oceny jakosci, 
% fragmenty czasu itd.

%% Wczytywanie WaveForm DataBase składających się z plików .dat i .hea
FileName = './database/100001/100001_ECG'; % Introduce you .dat file name
[sig, Fs, tm] = rdsamp(FileName, 1);
plot(tm, sig);
title('Sygnał z pliku .dat');
xlabel('Czas (s)');
ylabel('Amplituda');

[ann, ann_type] = rdann(FileName, 'atr');
plot(ann, ann_type, 'r*');
title('Adnotacje sygnału');
xlabel('Czas (próbki)');
ylabel('Typ adnotacji');