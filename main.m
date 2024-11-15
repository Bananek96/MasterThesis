% ANNOTATION READER
% -------------------------------------------------------------------------
% This code is dedicated for reading of quality annotations of BUT QDB.
% Input: annotation - file (.csv)
%        anntr      - choice of annotator (e.g., [1, 2, 3])
%        from       - starting sample
%        to         - ending sample
% Output: variable "ann" - vector of annotations sample-by-sample
close all;
clear;
clc;

addpath(genpath('./database/'));
addpath('./mcode/');

function ann = ann_reader(annotation, anntr, from, to)
    % Odczyt tabeli z pliku CSV
    T = readtable([annotation, '.csv']);
    TA = table2array(T);

    % Kolumny dla każdego annotatora (1, 4, 7, ...)
    sl = [1 4 7 10];  % Kolumny początkowe dla każdego annotatora
    annsize = [length(anntr), TA(end, sl(~isnan(TA(end, sl + 1))) + 1)];
    ann = zeros(annsize);

    % Sprawdzenie, czy zostały podane odpowiednie argumenty wejściowe
    if nargin == 1
        anntr = 1:4; % Domyślne wartości dla annotatorów
        from = 1;
        to = annsize(2);
    elseif nargin == 2
        from = 1;
        to = annsize(2);
    end

    % Inicjalizacja i wypełnienie adnotacji
    poc = 0;
    sl = sl(anntr);
    for i = sl
        Lan = length(TA(~isnan(TA(:, i))));
        poc = poc + 1;

        % Znalezienie pierwszego segmentu w zakresie 'from'
        for j = 1:Lan
            if TA(j, i) >= from
                M = j;
                break
            end
        end

        % Znalezienie ostatniego segmentu w zakresie 'to'
        for j = M+1:Lan
            if TA(j, i+1) >= to
                N = j;
                break
            end
        end

        % Przypisanie klasy jakości do zakresu próbek
        for j = M:N
            ann(poc, TA(j, i):TA(j, i+1)) = TA(j, i+2);
        end
    end
    ann = ann(:, from:to);  % Wyodrębnienie zakresu od 'from' do 'to'
end

%% GŁÓWNY PROGRAM
% Ścieżki i zmienne wejściowe
FolderPath = './database';
HowManyData = 2; % 0-wszystkie foldery

% Pobieranie listy folderów
folders = dir(FolderPath); 
folders = folders([folders.isdir]); % Filtruj tylko katalogi
folders = folders(~ismember({folders.name}, {'.', '..'})); % Pomijanie '.' i '..'

% Tworzenie tablicy nazw folderów
folderNames = {folders.name};

% Pobieranie pierwszego folderu
if isempty(folderNames)
    error('Brak folderów w ścieżce: %s', FolderPath);
end

% Wyznaczenie liczby iteracji na podstawie HowManyData
if HowManyData == 0
    numIterations = numel(folderNames); % Wszystkie foldery
else
    numIterations = min(HowManyData, numel(folderNames)); % Ilosc folderów
end

% Inicjalizacja struktur na dane
annotationData = struct();

% Iteracja i zapis nazw folderów do pliku AnnotationFile
for i = 1:numIterations
    % Pobieranie aktualnej nazwy folderu
    currentFolder = folderNames{i};
    
    % Podawanie nazwy pliku z danymi i AnnotationFile
    AnnotationFile = strcat('./database/', currentFolder, '/', currentFolder, '_ANN');
    DataFile = strcat('./database/', currentFolder, '/', currentFolder, '_ECG');

    % Wczytanie sygnału EKG
    [sig, Fs, tm] = rdsamp(DataFile, 1);
    
    % Wczytanie adnotacji jakości sygnału dla zakresu próbek
    anntr = [1, 2, 3, 4];  % Wybór annotatorów
    fromSample = 1;     % Początkowa próbka
    toSample = length(sig);  % Końcowa próbka (cały sygnał)
    ann = ann_reader(AnnotationFile, anntr, fromSample, toSample);
    AnnotationCSV = strcat(AnnotationFile, '.csv');
    AnnData = importdata(AnnotationCSV);
    
    % Podział na klasy jakości dla każdego annotatora
    for annotator = 1:length(anntr)
        for qualityClass = 1:3
            % Indeksy próbek dla bieżącej klasy jakości
            qualityIndices = find(ann(annotator, :) == qualityClass);
            
            % Jeśli są próbkami tej klasy, zapisz do tablicy w strukturze
            if ~isempty(qualityIndices)
                % Wyciąganie czasów dla próbek (tutaj zakłada się, że tm zawiera czasy próbek)
                qualityTimes = tm(qualityIndices);  % lub inna metoda uzyskania czasów próbek
                
                % Tworzenie dynamicznego pola w strukturze
                % Zmieniamy nazwę, by upewnić się, że nie zaczyna się od cyfry
                variableName = sprintf('%sA%dC%d', currentFolder, annotator, qualityClass);
        
                % Jeśli nazwa zmiennej zaczyna się od cyfry, dodajemy prefiks
                if isstrprop(variableName(1), 'digit')  % Sprawdzamy, czy pierwszy znak to cyfra
                    variableName = ['field_' variableName];  % Dodajemy 'field_' na początku
                end
        
                % Zapisanie danych do struktury - zapisujemy zarówno próbki, jak i czas
                annotationData.(variableName).indices = qualityIndices;
                annotationData.(variableName).times = qualityTimes;
            end
        end
    end
end

currentFolder = folderNames{1};
    
% Podawanie nazwy pliku z danymi i AnnotationFile
AnnotationFile = strcat('./database/', currentFolder, '/', currentFolder, '_ANN');
DataFile = strcat('./database/', currentFolder, '/', currentFolder, '_ECG');

% Wczytanie sygnału EKG
[sig, Fs, tm] = rdsamp(DataFile, 1);

% Wczytanie adnotacji jakości sygnału dla zakresu próbek
anntr = [1, 2, 3, 4];  % Wybór annotatorów
fromSample = 1;     % Początkowa próbka
toSample = length(sig);  % Końcowa próbka (cały sygnał)
ann = ann_reader(AnnotationFile, anntr, fromSample, toSample);
AnnotationCSV = strcat(AnnotationFile, '.csv');
AnnData = importdata(AnnotationCSV);

% Wizualizacja sygnału i jego jakości
figure(1);
plot(tm, sig);
title('Sygnał EKG');
xlabel('Czas (s)'); ylabel('Amplituda');

% Wyświetlenie adnotacji jakości
figure(2);
for i = 1:length(anntr)
    subplot(2, 2, i);
    plot(1:toSample, ann(i, :));  % Wyświetlanie jakości dla annotatora 'i'
    title(['Adnotacje jakości sygnału - Annotator ', num2str(i)]);
    xlabel('Próbka'); ylabel('Klasa jakości');
    ylim([0 3]); % Ustawienie osi Y dla klas jakości (0, 1, 2, 3)
end
    
% Wizualizacja sygnału z segmentami dla każdej klasy jakości (1, 2, 3)
for i = 1:length(anntr)
    figure(2+i);
    sgtitle(['Annotator ', num2str(i)]);
    
    % Podział na klasy jakości dla każdego annotatora
    for qualityClass = 1:3
        % Indeksy próbek dla bieżącej klasy jakości
        qualityIndices = find(ann(i, :) == qualityClass);
        
        % Wyszukanie segmentów przylegających do siebie w bieżącej klasie
        segments = diff([0, qualityIndices]) > 1;
        segmentStarts = [1, find(segments)] + 1;
        segmentEnds = [find(segments) - 1, length(qualityIndices)];

        % Rysowanie fragmentów sygnału dla każdej klasy jakości
        subplot(3, 1, qualityClass);
        hold on;
        for j = 1:length(segmentStarts)
            % Próbki dla bieżącego segmentu
            segmentIndices = qualityIndices(segmentStarts(j):segmentEnds(j));
            plot(tm(segmentIndices), sig(segmentIndices));
        end
        hold off;
        title(['Klasa jakości ', num2str(qualityClass)]);
        xlabel('Czas (s)'); ylabel('Amplituda');
    end
end

disp('Zakończono program!');
disp('Trwa wyświetlanie wykresów!')