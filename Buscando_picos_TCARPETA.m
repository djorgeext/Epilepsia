% Ruta de la carpeta principal
rutaPrincipal = '/home/djorget/Documentos/PAPER_ISABEL/SP';

% Obtener la lista de carpetas en la carpeta principal
listaCarpetas = dir(fullfile(rutaPrincipal, '*'));

hf_maxT = 13.653333333333332;%1/load('periodo_remuestreo.txt');         % se define la frecuencia máxima a la que se remuestreo la señal
hf_maxT = hf_maxT/2;                                           % se divide por 2 porque solamente se tienen en cuenta las frecuencias positivas luego de calcular el espectro


t = hf_maxT/2049;                                                  % en t defino el espacio a haber entre cada muestra
                                                                               % vlf_min será la frecuencia mínima a partir de la que buscaré los picos prominentes del espectro y hf_max la máxima
vlf_min = round((1/300)/t);                                     % se toma 2.07 porque es la frecuencia máxima de las series
hf_max = round(2.078/t);

% Iterar sobre las carpetas
for i = 3:length(listaCarpetas) % Empieza desde 3 para evitar '.' y '..'
    carpetaActual = fullfile(rutaPrincipal, listaCarpetas(i).name);
    
    % Obtener la lista de archivos .txt en la carpeta actual
    listaArchivos = dir(fullfile(carpetaActual, '*.txt'));
    
    % Iterar sobre los archivos .txt
    for j = 1:length(listaArchivos)
        archivoActual = fullfile(carpetaActual, listaArchivos(j).name);
        
        % Leer el vector de valores desde el archivo .txt
        data = load(archivoActual);
        
        m = length(data);
        data = data(2:(m-1));               % se eliminan las muestras primera y última de la serie ya que son
        k = (length(data))/2049;           % artefactos añadidos por el matlab y tienen valor NaN que luego distorsiona los resultados
        hf_max = round(2.078/t);
        temp = 0;
        freq = [];                                                                % en locs y pks se guardan las localizaciones frecuencia y las amplitudes de los picos
        pks = [];
    
        for i=1:k
            x_aux = data((2049*i-2048):(2049*i));
            [temp_pks,temp_locs]=findpeaks(x_aux(vlf_min:hf_max));
               
            freq = [freq;temp_locs];
            pks = [pks;temp_pks];    
        end
        
        freq = freq*t;                               % al multiplicar freq por t estoy llevando los valores a Hz
        [freq,I] = sort(freq);                    % ordeno los valores de frecuencia con sus respectivas amplitudes
        pks=pks(I);        
        
        % Crear el nombre del archivo de salida
        archivoSalida1 = fullfile(carpetaActual, 'vector_de_frecuencias.txt');
        archivoSalida2 = fullfile(carpetaActual, 'vector_de_amplitudes.txt');
        % Guardar el valor medio en el nuevo archivo .txt
        save (archivoSalida1,"freq","-ascii");
        save (archivoSalida2,"pks","-ascii");
    end
end
