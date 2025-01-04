function visualize_signal_classification(sig, tm, YPred)
    % Wizualizacja całego sygnału z oznaczeniem klas
    figure;
    hold on;
    colors = ['r', 'g', 'b']; % Kolory dla 3 klas
    for qualityClass = 1:3
        classIndices = find(YPred == qualityClass);
        plot(tm(classIndices), sig(classIndices), 'Color', colors(qualityClass), 'LineWidth', 1.5);
    end
    hold off;
    title('Przypisanie klas do sygnału');
    xlabel('Czas (s)');
    ylabel('Amplituda');
    legend({'Klasa 1', 'Klasa 2', 'Klasa 3'});
end
