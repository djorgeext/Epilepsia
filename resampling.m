% Funcion para remuestrear las series a 6.83 Hz
% Se toma 6.83 Hz porque es la frecuencia requerida para tener aproximadamente 
% 2048 muestras en 5 minutos y ademas cumple con el crietrio de Shannon (fs > 2.2*fmáx)
% como parametros se le introduce la serie y el periodo de remuestreo 
% t= (1 / 6.83) * 1000

function y = resampling(data, periodo) 
data = data';                   % se pasa la serie a un vector columna para mejor visualización posteriormente
a_temp = [];                    % se crea una variable temporal (inicialmente un arreglo vacío) que contendrá el valor del tiempo en el cual cambian las muestras
a_temp(1,1) = 0;
for i = 1:length(data)      % en este lazo se rellena a_temp
    a_temp(i+1,1) = a_temp(i,1) + data(i,1);
end

a_resampled = [];           % se crea otra variable temporal para almacenar la serie resultante que será la salida de la función
contador = 0;                 % contador que aumentará tomando los valores de a_temp en la misma medida que aumente la cantidad de muestras de la serie resultante
contador2 = 1;               % contador2 será el índice de las muestras nuevas en la serie resultante
for i=1:length(data)
    
    while contador <= a_temp(i+1)         % se utiliza un ciclo while para rellenar a_resampled
        a_resampled(contador2,1) = data(i);
        contador = contador + periodo;
        contador2 = contador2 + 1;
    end
    
end

y = a_resampled;
end