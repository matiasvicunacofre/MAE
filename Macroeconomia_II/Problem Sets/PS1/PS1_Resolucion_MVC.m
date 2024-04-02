%% Resolución Problem Set 1
% Autor: Matías Vicuña Cofré
% Magíster en Economía
% Universidad Alberto Hurtado

% Configuraciones Iniciales de entorno de trabajo
clear global; % Limpiamos Workspace
clearvars; % Limpiamos las variables del Workspace
clc; % Limpia ventanas

% determinamos las rutas de acceso a las funciones y datos a utilizar
addpath('data');
addpath('functions');
%% 1.a)
% Variables y condiciones de la muestra aleatoria
N = 1000; % Número de muestras
T = 300; % Número de observaciones por muestra
coeficientes = [0.9, 0.7, 0.4, -0.1]; % Coeficientes del modelo MA(q)
semilla = 123; % Número de semilla para condicionar la simulación

% Simulamos la muestra
datos = Simulacion_MA(T,N,coeficientes,semilla);

%% 1.b)
% Creamos los objetos que contendrán la media y la varianza
esperanzas = zeros(1,N);
varianzas  = zeros(1,N);

% Creamos el bucle que realizara el promedio y varianza de las últimas 200
% observaciones de cada una de las muestras de la base
for n = 1:N
    esperanzas(1,n) = mean(datos(101:1:300,n));
    varianzas(1,n) = var(datos(101:1:300,n));
end

% Abrir o crear un archivo para escribir
carpeta_destino = 'C:/Users/matei/Dropbox/1- Matias/Universidad/MAE/Segundo Semestre/Macroeconomía II/Problem Sets/PS1/outputs/tables';
nombre_archivo = 'tabla_1.txt';
ruta_completa = fullfile(carpeta_destino, nombre_archivo);
fid = fopen(ruta_completa, 'w');

% Imprimimos los resultados
fprintf(fid,'-------------------------------------------- \n');
fprintf(fid,'     Tabla 1: Resultados de la Muestra \n');
fprintf(fid,'-------------------------------------------- \n');
fprintf(fid,'Esperanza promedio de las muestras: %f\n', round(mean(esperanzas),2));
fprintf(fid,'Varianza promedio de las muestras: %f\n', round(mean(varianzas),2));
fprintf(fid,'-------------------------------------------- \n');

% Cerrar el archivo
fclose(fid);
disp(['Tabla guardada como: ' nombre_archivo]);
%% 1.c) Model AR(p) e IRF
% Condiciones para el calculo.
p_values = [1 2 4 8]; % valores de rezagos
horizonte = 10; % horizonte del IRF
desviacion = 1; % shock en t.

% Resultados del IRF
Res = IRF_AR(datos,horizonte,p_values,desviacion);

Res = [0.1 0.1 0.1 0.1; Res];

% Gráfica de los IRF
H = 0:10;
figure;
for i = 1:length(p_values)
    subplot(length(p_values),1,i);
    plot(H,Res(:,i));
    title(['Modelo AR(',num2str(p_values(i)), ')']);
    xlabel('Horizonte');
    ylabel('IRF');
end

% Definir la carpeta donde se guardará el gráfico
carpeta_destino = 'C:/Users/matei/Dropbox/1- Matias/Universidad/MAE/Segundo Semestre/Macroeconomía II/Problem Sets/PS1/outputs/figures';

% Guardar el gráfico en la carpeta especificada
nombre_archivo = 'figura_1.png';
ruta_completa = fullfile(carpeta_destino, nombre_archivo);
saveas(gcf, ruta_completa);
disp(['Gráfico guardado en: ' ruta_completa]);
%% 2.e) Resolución Hodrick-Prescott Filter
% Resolución del filtro en la función "HP_filter.m" de la carpeta
% "functions"

%% 2.f)
% Cargamos los datos de la FRED de St. Louis
opts = spreadsheetImportOptions("NumVariables", 2);

% Especificamos Hoja de Ruta y Rango
opts.Sheet = "FRED Graph";
opts.DataRange = "A2:B270";

% Especificamos Nombre variables y tipo
opts.VariableNames = ["date", "GDPC1"];
opts.VariableTypes = ["datetime", "double"];

% Cargamos la base
GDP = readtable("GDPC1.xls", opts, "UseExcel", false);

% Separamos las Fechas de la Serie del GDP
y = GDP.GDPC1;
fechas = GDP.date;

% Linealizamos la Serie
y_ln = log(y);

% Aplicar el filtro Hodrick-Prescott
lambda = 1600; % Valor típico de lambda para datos trimestrales
[trend, cycle]= HP_filter(y_ln,lambda);

% Calculamos las Estadisticas de la Serie
mean_trend = mean(trend);
mean_cycle = mean(cycle);
var_trend = var(trend);
var_cycle = var(cycle);

% Tabla de Estadísticas de la tendencia y el ciclo
% Abrir o crear un archivo para escribir
carpeta_destino = 'C:/Users/matei/Dropbox/1- Matias/Universidad/MAE/Segundo Semestre/Macroeconomía II/Problem Sets/PS1/outputs/tables';
nombre_archivo = 'tabla_2.txt';
ruta_completa = fullfile(carpeta_destino, nombre_archivo);
fid = fopen(ruta_completa, 'w');

% Imprimimos los resultados
fprintf(fid,'-------------------------------------------- \n');
fprintf(fid,'      Tabla 2: Resultados de la Serie\n');
fprintf(fid,'-------------------------------------------- \n');
fprintf(fid,'    Aplicando el filtro Hodrick Prescott\n');
fprintf(fid,'      lambda = 1.600 (Serie Trimestral)\n');
fprintf(fid,'-------------------------------------------- \n');
fprintf(fid,'Tendencia \n');
fprintf(fid,'Esperanza: %f\n', mean_trend);
fprintf(fid,'Varianza:  %f\n', var_trend);
fprintf(fid,'-------------------------------------------- \n');
fprintf(fid,'Ciclo \n');
fprintf(fid,'Esperanza: %f\n', mean_cycle);
fprintf(fid,'Varianza:  %f\n', var_cycle);
fprintf(fid,'-------------------------------------------- \n');

% Cerrar el archivo
fclose(fid);
disp(['Tabla guardada como: ' nombre_archivo]);

% Visualizar los resultados
figure;
subplot(2,1,1);
plot(fechas, trend, 'r');
legend('Tendencia');
title('Figura 2: Filtro Hodrick-Prescott - \lambda = 1.600');
subtitle('Tendencia Serie GDP Estacionalizada');
xlabel('Tiempo');
ylabel('Valor');
subplot(2,1,2);
plot(fechas, cycle, 'b');
legend('Ciclo');
subtitle('Ciclo Serie GDP Estacionalizada');
xlabel('Tiempo');
ylabel('Valor');

% Definir la carpeta donde se guardará el gráfico
carpeta_destino = 'C:/Users/matei/Dropbox/1- Matias/Universidad/MAE/Segundo Semestre/Macroeconomía II/Problem Sets/PS1/outputs/figures';

% Guardar el gráfico en la carpeta especificada
nombre_archivo = 'figura_2.png';
ruta_completa = fullfile(carpeta_destino, nombre_archivo);
saveas(gcf, ruta_completa);
disp(['Gráfico guardado en: ' ruta_completa]);
%% 2.g)
% Cargamos los datos de la FRED de St. Louis
opts = spreadsheetImportOptions("NumVariables", 2);

% Especificamos Hoja de Ruta y Rango
opts.Sheet = "FRED Graph";
opts.DataRange = "A242:B258";

% Especificamos Nombre variables y tipo
opts.VariableNames = ["date", "GDPC1"];
opts.VariableTypes = ["datetime", "double"];

% Cargamos la base
GDP2 = readtable("GDPC1.xls", opts, "UseExcel", false);

% Datos
gdp_2_log = log(GDP2.GDPC1);
fechas_2 = GDP2.date(2:end);

% Filtro HP
[trend_gdp,~] = HP_filter(gdp_2_log,1600);

% Recuperamos el N° de Filas
[m,~] = size(gdp_2_log); 

% Variación del GDP
delta_trend_gdp = zeros(m-1,1);
for i = 1:m-1
    delta_trend_gdp(i) = ((trend_gdp(i+1) - trend_gdp(i)) / trend_gdp(i))*100;
end

% Grafica de la Variación entre los periodos del 2007 al 2010 (Crisis
% Sub-Prime
figure;
plot(fechas_2,delta_trend_gdp,'r');
xlabel('Fecha (Trimestre)');
ylabel('%');
title('Variación Porcentual Tendencia GDP Estacionalizado');
subtitle('Periodos Q1 2007 - Q1 2010');

% Definir la carpeta donde se guardará el gráfico
carpeta_destino = 'C:/Users/matei/Dropbox/1- Matias/Universidad/MAE/Segundo Semestre/Macroeconomía II/Problem Sets/PS1/outputs/figures';

% Guardar el gráfico en la carpeta especificada
nombre_archivo = 'figura_3.png';
ruta_completa = fullfile(carpeta_destino, nombre_archivo);
saveas(gcf, ruta_completa);
disp(['Gráfico guardado en: ' ruta_completa]);

%% 2.h)
% Aplicar el filtro Hodrick-Prescott
lambda = 10000000; % Valor típico de lambda para datos trimestrales
[trend, cycle]= HP_filter(y_ln,lambda);

% Calculamos las Estadisticas de la Serie
mean_trend = mean(trend);
mean_cycle = mean(cycle);
var_trend = var(trend);
var_cycle = var(cycle);

% Tabla de Estadísticas de la tendencia y el ciclo
% Abrir o crear un archivo para escribir
carpeta_destino = 'C:/Users/matei/Dropbox/1- Matias/Universidad/MAE/Segundo Semestre/Macroeconomía II/Problem Sets/PS1/outputs/tables';
nombre_archivo = 'tabla_3.txt';
ruta_completa = fullfile(carpeta_destino, nombre_archivo);
fid = fopen(ruta_completa, 'w');
% Imprimimos los resultados
fprintf(fid,'-------------------------------------------- \n');
fprintf(fid,'      Tabla 3: Resultados de la Serie\n');
fprintf(fid,'-------------------------------------------- \n');
fprintf(fid,'    Aplicando el filtro Hodrick Prescott\n');
fprintf(fid,'            lambda = 10.000.000\n');
fprintf(fid,'-------------------------------------------- \n');
fprintf(fid,'Tendencia \n');
fprintf(fid,'Esperanza: %f\n', mean_trend);
fprintf(fid,'Varianza:  %f\n', var_trend);
fprintf(fid,'-------------------------------------------- \n');
fprintf(fid,'Ciclo \n');
fprintf(fid,'Esperanza: %f\n', mean_cycle);
fprintf(fid,'Varianza:  %f\n', var_cycle);
fprintf(fid,'-------------------------------------------- \n');

% Cerrar el archivo
fclose(fid);
disp(['Tabla guardada como: ' nombre_archivo]);

% Visualizar los resultados
figure;
subplot(2,1,1);
plot(fechas, trend, 'r');
legend('Tendencia');
title('Figura 3: Filtro Hodrick-Prescott - \lambda = 10.000.000');
subtitle('Tendencia Serie GDP Estacionalizada');
xlabel('Tiempo');
ylabel('Valor');
subplot(2,1,2);
plot(fechas, cycle, 'b');
legend('Ciclo');
subtitle('Ciclo Serie GDP Estacionalizada');
xlabel('Tiempo');
ylabel('Valor');


% Definir la carpeta donde se guardará el gráfico
carpeta_destino = 'C:/Users/matei/Dropbox/1- Matias/Universidad/MAE/Segundo Semestre/Macroeconomía II/Problem Sets/PS1/outputs/figures';

% Guardar el gráfico en la carpeta especificada
nombre_archivo = 'figura_4.png';
ruta_completa = fullfile(carpeta_destino, nombre_archivo);
saveas(gcf, ruta_completa);
disp(['Gráfico guardado en: ' ruta_completa]);