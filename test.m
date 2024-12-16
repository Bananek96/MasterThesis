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
disp("Rozpoczęto pracę");
% Ścieżki i zmienne wejściowe
FolderPath = './database';
HowManyData = 1; % 0-wszystkie foldery

% Pobieranie listy folderów
folders = dir(FolderPath); 
folders = folders([folders.isdir]); % Filtruj tylko katalogi
folders = folders(~ismember({folders.name}, {'.', '..'})); % Pomijanie '.' i '..'

% Tworzenie tablicy nazw folderów
folderNames = {folders.name};

% Wyznaczenie liczby iteracji na podstawie HowManyData
if HowManyData == 0
    numIterations = numel(folderNames); % Wszystkie foldery
else
    numIterations = min(HowManyData, numel(folderNames)); % Ilosc folderów
end

disp("Rozpoczęto selekcję danych");

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
    
    % Przygotowanie tablic do przechowywania wyników
    maxAnnotators = length(anntr);
    maxClasses = 3; % Liczba klas jakości
    
    % Macierz przechowująca czasy i indeksy dla każdej klasy jakości i annotatora
    annotationMatrix = cell(maxAnnotators, maxClasses); 
    
    for annotator = 1:maxAnnotators
        for qualityClass = 1:maxClasses
            % Indeksy próbek dla bieżącej klasy jakości
            qualityIndices = find(ann(annotator, :) == qualityClass);
            
            if ~isempty(qualityIndices)
                % Wyciąganie czasów próbek
                qualityTimes = tm(qualityIndices); 
                
                % Przechowywanie w macierzy
                annotationMatrix{annotator, qualityClass} = [qualityIndices(:), qualityTimes(:)];
            else
                % Jeśli brak danych, przypisujemy pustą macierz
                annotationMatrix{annotator, qualityClass} = [];
            end
        end
    end
end

disp("Zakończono selekcje danych");

% disp("Rozpoczęsto resampling danych");
% % Nowa częstotliwość próbkowania
% newFs = 200;  % Docelowa częstotliwość próbkowania
% oldFs = 1000; % Oryginalna częstotliwość próbkowania
% timeStep = 1 / newFs; % Krok czasowy dla nowej częstotliwości próbkowania
% 
% % Resampling danych w annotationMatrix
% for annotator = 1:maxAnnotators
%     for qualityClass = 1:maxClasses
%         % Pobranie danych dla aktualnej kombinacji annotator i klasa
%         data = annotationMatrix{annotator, qualityClass};
% 
%         if ~isempty(data)
%             % Oddzielenie indeksów i czasów
%             qualityIndices = data(:, 1);  % Indeksy próbek
%             qualityTimes = data(:, 2);    % Czasy próbek
% 
%             % Nowy wektor czasów równomiernie rozmieszczonych
%             newTimes = qualityTimes(1):timeStep:qualityTimes(end);
% 
%             % Interpolacja indeksów próbek w nowych punktach czasowych
%             resampledIndices = interp1(qualityTimes, qualityIndices, newTimes, 'linear', 'extrap');
% 
%             % Zachowanie wyników jako macierz [indeksy, czasy]
%             annotationMatrix{annotator, qualityClass} = [round(resampledIndices(:)), newTimes(:)];
%         end
%     end
% end
% 
% disp("Zakończono resampling danych");

disp("Rozpoczęto transformację falkową");

% Przechowywanie wyników transformacji
waveletTransformedData = cell(maxAnnotators, maxClasses);

for annotator = 1:maxAnnotators
    for qualityClass = 1:maxClasses
        % Pobranie danych dla aktualnej kombinacji annotator i klasa
        data = annotationMatrix{annotator, qualityClass};
        
        if ~isempty(data)
            % Oddzielenie indeksów i czasów
            qualityIndices = data(:, 1);  % Indeksy próbek
            qualityTimes = data(:, 2);    % Czasy próbek
            
            % Transformacja falkowa - użycie współczynnika "db4"
            [c, l] = wavedec(qualityIndices, 4, 'db4'); % 4 poziomy dekompozycji
            
            % Przechowywanie współczynników falkowych i długości
            waveletTransformedData{annotator, qualityClass} = struct(...
                'coefficients', c, ...   % Współczynniki falkowe
                'lengths', l, ...        % Długości poziomów
                'times', qualityTimes);  % Oryginalne czasy próbek
        else
            % Jeśli brak danych, przypisujemy pustą strukturę
            waveletTransformedData{annotator, qualityClass} = struct(...
                'coefficients', [], ...
                'lengths', [], ...
                'times', []);
        end
    end
end

disp("Zakończono transformację falkową");

disp("Rozpoczynam wizualizację transformacji falkowej");

% Iteracja przez annotatorów i klasy jakości
for annotator = 1:maxAnnotators
    for qualityClass = 1:maxClasses
        % Pobranie danych transformacji falkowej
        waveletData = waveletTransformedData{annotator, qualityClass};

        if ~isempty(waveletData.coefficients)
            % Współczynniki falkowe i czasy
            coefficients = waveletData.coefficients;
            lengths = waveletData.lengths;
            times = waveletData.times;

            % Odtworzenie sygnałów dla poszczególnych poziomów
            figure;
            sgtitle(['Annotator: ', num2str(annotator), ...
                     ', Quality Class: ', num2str(qualityClass)]);
            % Liczba poziomów dekompozycji
            numLevels = length(lengths) - 2; % Ostatnie poziomy zawierają detale

            for level = 1:numLevels
                % Ekstrakcja współczynników na poziomie
                d = detcoef(coefficients, lengths, level);

                % Odtworzenie sygnału na danym poziomie
                subplot(numLevels, 1, level);
                plot(times, wrcoef('d', coefficients, lengths, 'db4', level));
                title(['Level ', num2str(level), ' Details']);
                xlabel('Time [s]');
                ylabel('Amplitude');
            end
        end
    end
end

disp("Zakończono wizualizację transformacji falkowej");
