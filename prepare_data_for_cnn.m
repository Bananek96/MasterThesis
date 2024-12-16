function [X, Y] = prepare_data_for_cnn(processedData)
    % Przygotowanie danych wejściowych na podstawie cech statystycznych
    X = []; % Macierz cech
    Y = []; % Odpowiednie klasy

    % Przygotowanie danych
    for annotator = 1:size(processedData, 1)
        for qualityClass = 1:size(processedData, 2)
            if ~isempty(processedData{annotator, qualityClass})
                stats = processedData{annotator, qualityClass}.statistics;
                
                % Tworzenie wektora cech
                features = [...
                    stats.mean, ...
                    stats.std, ...
                    stats.skewness, ...
                    stats.kurtosis, ...
                    stats.median, ...
                    stats.min, ...
                    stats.max, ...
                    stats.energy, ...
                    stats.entropy];
                
                % Debugging: wyświetl wymiar wektora cech
                % Sdisp(['Liczba cech: ', num2str(length(features))]);
                
                % Dodanie wektora cech jako wiersz do macierzy X
                X = [X; features];
                % Klasa jakości jako etykieta
                Y = [Y; qualityClass]; 
            end
        end
    end
end
