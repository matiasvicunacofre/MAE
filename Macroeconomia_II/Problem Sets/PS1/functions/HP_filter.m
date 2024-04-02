function [trend, cycle] = HP_filter(y, lambda)
    % Condiciones Iniciales del filtro
    T = length(y);
    I = eye(T);
    
    % Generamos las Segundas Diferencias (Efecto de tendencia)
    D2 = diff(I,2);
    
    % Calculamos la tendencia y el ciclo de la serie
    trend = (I + lambda^2 * D2' * D2) \ y;
    cycle = y - trend;
end
