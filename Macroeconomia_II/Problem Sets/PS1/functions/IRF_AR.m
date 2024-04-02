function IRF_Res = IRF_AR(data,horizon,p_values,std_desv)

% Determinamos el tamaño de la muestra
[~,Ncols] = size(data);

% Matriz Inicial para los IRF
IRF_avg = zeros(horizon, length(p_values));

% Determinado el valor de p, generamos el IRF de cada uno.
for i = 1:length(p_values)
    % determinamos en que rezagos se encuentra el VAR.
    p = p_values(i);
    IRF_sum = zeros(horizon,1);
    for j = 1:Ncols
        % Utilizamos la funcion "Modelo_AR" para estimar por MCO
        AR_coef = Modelo_AR(data(:,j), p);

        % Construir Matriz VAR(p)
        if p == 1
            VAR_C = [[AR_coef(2:end)' zeros(1,1)]; [eye(1,1) zeros(1,1)]];
        else
            VAR_C = [AR_coef(2:end)'; [eye(p-1) zeros(p-1,1)]];
        end
        
            % Ahora se calcula el impulso respuesta
            IRF = zeros(horizon,1);
            % Definimos la desviación estándar de efecto en epsilon.
            shock = std_desv;

            % Bucle de calculo del shock
            for k = 1:horizon
                % Aplica el shock en el VAR.
                var = VAR_C.^k * shock;
                % IRF mediante el shock
                IRF(k) = var(1,1);
            end

            % Sumar los IRF
            IRF_sum = IRF_sum + IRF;
    end
    % Promediamos cada IRF de cada Muestra
    IRF_avg(:,i) = IRF_sum / Ncols;

    % Guardamos los resultados
    IRF_Res = IRF_avg;
end