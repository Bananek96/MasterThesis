function visualize_signal_classification(sig, tm, YPred)
    figure;
    plot(tm, sig, 'b', 'DisplayName', 'Sygnał EKG');
    hold on;

    % Kolory dla każdej klasy
    colors = {'r', 'g', 'm'};
    for qualityClass = 1:3
        indices = find(YPred == qualityClass);
        scatter(tm(indices), sig(indices), '.', 'MarkerEdgeColor', colors{qualityClass}, ...
            'DisplayName', ['Klasa ', num2str(qualityClass)]);
    end

    title('Klasyfikacja jakości sygnału');
    xlabel('Czas [s]');
    ylabel('Amplituda');
    legend;
    hold off;
end
