function waveletTransformedData = data_processing(FolderPath, HowManyData)
    % Pobieranie listy folderów
    folders = dir(FolderPath); 
    folders = folders([folders.isdir]); % Filtruj tylko katalogi
    folders = folders(~ismember({folders.name}, {'.', '..', 'database'})); % Pomijanie '.' i '..'
    
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
        fromSample = 1;     % Poczatkowa próbka
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
      
    disp("Rozpoczęto transformację falkową");
    
    % Przechowywanie wyników transformacji i cech statystycznych
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
                
                % Wyliczenie cech statystycznych
                coefficients = c; % Współczynniki falkowe
                stats.mean = mean(coefficients);
                stats.std = std(coefficients);
                stats.skewness = skewness(coefficients);
                stats.kurtosis = kurtosis(coefficients);
                stats.median = median(coefficients);
                stats.min = min(coefficients);
                stats.max = max(coefficients);
                stats.energy = sum(coefficients.^2);
                stats.entropy = -sum(coefficients.^2 .* log(coefficients.^2 + eps));
                
                % Przechowywanie współczynników falkowych i cech
                waveletTransformedData{annotator, qualityClass} = struct(...
                    'coefficients', c, ...   % Współczynniki falkowe
                    'lengths', l, ...        % Długości poziomów
                    'times', qualityTimes, ...  % Oryginalne czasy próbek
                    'statistics', stats);    % Cechy statystyczne
            else
                % Jeśli brak danych, przypisujemy pustą strukturę
                waveletTransformedData{annotator, qualityClass} = struct(... 
                    'coefficients', [], ...
                    'lengths', [], ...
                    'times', [], ...
                    'statistics', []);
            end
        end
    end
    
    disp("Zakończono transformację falkową");
end 