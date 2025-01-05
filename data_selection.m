function waveletData = data_selection(FolderPath, HowManyData, OutputFile)
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
        numIterations = min(HowManyData, numel(folderNames)); % Ilość folderów
    end
      
    % Przygotowanie zmiennych wyjściowych
    waveletData = struct();
    
    % Iteracja i zapis danych
    for i = 1:numIterations
        currentFolder = folderNames{i};
        
        % Wczytywanie danych i adnotacji
        AnnotationFile = strcat(FolderPath, '/', currentFolder, '/', currentFolder, '_ANN');
        DataFile = strcat(FolderPath, '/', currentFolder, '/', currentFolder, '_ECG');
        [sig, Fs, tm] = rdsamp(DataFile, 1);
        anntr = [1, 2, 3, 4];
        fromSample = 1;
        toSample = length(sig);
        ann = ann_reader(AnnotationFile, anntr, fromSample, toSample);
        
        % Przygotowanie danych dla każdej klasy
        dataPerClass = cell(1, 3);
        for qualityClass = 1:3
            qualityIndices = find(any(ann == qualityClass, 1));
            dataPerClass{qualityClass} = sig(qualityIndices);
        end
        
        % Zapisanie do struktury
        waveletData(i).folderName = currentFolder;
        waveletData(i).classData = dataPerClass;
    end
    
    % Zapis do pliku MAT
    save(OutputFile, 'waveletData', '-v7.3');
end