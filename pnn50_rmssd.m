% Ruta de la carpeta principal
rutaPrincipal = '/home/david/Documents/Epilepsia/pnn50_rmssd';
segmentacion_temp = 5; % segmentacion en tiempo real por minutos
% Obtener la lista de carpetas en la carpeta principal
listaCarpetas = dir(fullfile(rutaPrincipal, '*'));

% Iterar sobre las carpetas
for i = 3:length(listaCarpetas) % Empieza desde 3 para evitar '.' y '..'
    carpetaActual = fullfile(rutaPrincipal, listaCarpetas(i).name);
    
    % Obtener la lista de archivos .txt en la carpeta actual
    Archivo = dir(fullfile(carpetaActual, '*.txt'));
    
    archivoActual = fullfile(carpetaActual, Archivo.name);
        
    % Leer el vector de valores desde el archivo .txt
    data = (load(archivoActual))*0.001;
    pnn50 = [];
    rmssd = [];

    temp_index = [0];
    for j=1:length(data)
        aux = sum(data(1:j));
        temp_index = [temp_index;aux];
    end
        
    cont_segmento = segmentacion_temp * 60;
    initial_ind = 0;
    inic = 1;
    while cont_segmento < temp_index(end)
        fin = find(temp_index < cont_segmento, 1, "last");
        aux_diff = diff(data(inic:(fin-1)));
        n = length(aux_diff);
        aux_pnn50_ind = length(find(abs(aux_diff)>=0.05));
        pnn50 = [pnn50; aux_pnn50_ind/n];
        aux_rmssd = sum(aux_diff.^2);
        aux_rmssd = sqrt(aux_rmssd/n);
        rmssd = [rmssd; aux_rmssd];
        inic = fin;
        initial_ind = initial_ind + cont_segmento;
        cont_segmento = cont_segmento + segmentacion_temp*60;
    end
    
    % Crear el nombre del archivo de salida
    archivoSalida1 = fullfile(carpetaActual, 'pnn50.txt');
    archivoSalida2 = fullfile(carpetaActual, 'rmssd.txt');
    
    % Guardar el valor medio en el nuevo archivo .txt
    save(archivoSalida1,"pnn50","-ascii");
    save(archivoSalida2,"rmssd","-ascii");
end