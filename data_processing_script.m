% Główne ustawienia
FolderPath = './database';
HowManyData = 0; % Liczba folderów do przetwarzania (0 = wszystkie)
ProcessedDataPath = './processed_data.mat'; % Ścieżka do pliku z przetworzonymi danymi

% Sprawdzamy, czy plik z przetworzonymi danymi istnieje
if isfile(ProcessedDataPath)
    disp("Wczytywanie przetworzonych danych...");
    loadedData = load(ProcessedDataPath);
    
    % Sprawdzamy, czy zmienna 'processedData' jest w załadowanych danych
    if isfield(loadedData, 'processedData')
        processedData = loadedData.processedData;
    else
        disp("Brak zmiennej 'processedData' w pliku. Trzeba ponownie przetworzyć dane.");
        processedData = data_processing(FolderPath, HowManyData);  % Uruchom proces przetwarzania
        save(ProcessedDataPath, 'processedData', '-v7.3');
    end
else
    disp("Plik z przetworzonymi danymi nie istnieje. Trzeba przetworzyć dane.");
    processedData = data_processing(FolderPath, HowManyData);  % Uruchom proces przetwarzania
    save(ProcessedDataPath, 'processedData', '-v7.3');
end

disp("Zakończono proces przetwarzania danych.");
