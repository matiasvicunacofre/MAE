function Res = Modelo_AR(data,p)
    % Generamos la matriz para los coeficientes
    X = ones(length(data)-p, p+1);
    % Iteración para determinar los rezagos (lags)
    for i = 1:p
        X(:, i+1) = data(p+1-i:end-i);
    end
    % Determinamos la variable de respuesta
    Y = data(p+1:end);

    % Utilizando el Modelo MCO Matricial, Estimamos.
    Res = (X'*X)^-1*X'*Y;
end