function analyze_quality(times, signal, predictedClasses)
    % Wyodrębnienie informacji o klasach
    classLabels = unique(predictedClasses);
    classPercentages = zeros(size(classLabels));
    signalLength = length(signal);

    % Obliczanie udziału każdej klasy
    for i = 1:length(classLabels)
        classPercentages(i) = sum(predictedClasses == classLabels(i)) / signalLength * 100;
    end

    % Wyświetlenie wyników w konsoli
    disp("Udział procentowy każdej klasy w sygnale:");
    for i = 1:length(classLabels)
        disp(["Klasa ", num2str(classLabels(i)), ": ", num2str(classPercentages(i)), "%"]);
    end

    % Wizualizacja wyników
    figure;
    subplot(2, 1, 1);
    plot(times, signal);
    title('Oryginalny sygnał');
    xlabel('Czas [s]');
    ylabel('Amplituda');

    subplot(2, 1, 2);
    bar(classLabels, classPercentages);
    title('Udział procentowy klas jakości');
    xlabel('Klasa jakości');
    ylabel('Procent sygnału [%]');
end
