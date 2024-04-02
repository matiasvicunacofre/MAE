function data = Simulacion_MA(Nrows,Ncols,Ncoeff,seed)
% Determinamos la semilla de aleatorización
rng(seed);

% Definimos la dimensiones de la muestra
ma_process = zeros(Nrows,Ncols);

% Bucle para determinación del Modelo MA(q)
for i = 1:Nrows
    % Determinamos una muestra de ~ N(0,1)
    epsilon = randn(Nrows+4,Ncols);

    for t = 5:Nrows
        for j = 1:Ncols
            ma_process(i,j) = epsilon(t,j) + Ncoeff(1)*epsilon(t-1,j) + Ncoeff(2)*epsilon(t-2,j) + Ncoeff(3)*epsilon(t-3,j) + Ncoeff(4)*epsilon(t-4,j);
        end
    end
end

% Guardamos los datos
data = ma_process;
end