function features = extract_features(sig, Fs)
    % Funkcja ekstrakcji cech z surowego sygnału
    % sig - dane sygnałowe (np. EKG)
    % Fs - częstotliwość próbkowania sygnału
    
    % 1. Cechy statystyczne
    mean_val = mean(sig);  % Średnia
    std_val = std(sig);    % Odchylenie standardowe
    max_val = max(sig);    % Maksymalna wartość
    min_val = min(sig);    % Minimalna wartość
    
    % 2. Cechy częstotliwościowe (FFT)
    N = length(sig);       % Długość sygnału
    f = (0:N-1)*(Fs/N);    % Wektor częstotliwości
    Y = fft(sig);          % Transformata Fouriera
    mag = abs(Y);          % Amplituda
    mag = mag(1:floor(N/2));  % Tylko dla dodatnich częstotliwości
    f = f(1:floor(N/2));   % Częstotliwości dla dodatnich wartości
    
    % 3. Cechy z analizy FFT - np. średnia amplituda w paśmie
    mean_mag = mean(mag);  % Średnia amplituda
    peak_freq = f(find(mag == max(mag))); % Częstotliwość o największej amplitudzie
    
    % Połączenie cech do wektora
    features = [mean_val, std_val, max_val, min_val, mean_mag, peak_freq];
end
