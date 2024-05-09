% Ruta de la carpeta principal
rutaPrincipal = '/home/david/Documents/Epilepsia/series_resampleadas';

% Obtener la lista de carpetas en la carpeta principal
listaCarpetas = dir(fullfile(rutaPrincipal, '*'));

% Iterar sobre las carpetas
for i = 3:length(listaCarpetas) % Empieza desde 3 para evitar '.' y '..'
    carpetaActual = fullfile(rutaPrincipal, listaCarpetas(i).name);
    
    % Obtener la lista de archivos .txt en la carpeta actual
    Archivo = dir(fullfile(carpetaActual, '*.txt'));
    
    archivoActual = fullfile(carpetaActual, Archivo.name);
        
    % Leer el vector de valores desde el archivo .txt
    data = load(archivoActual);
    
    m = length(data);     
    k = fix((length(data))/4096);          
    espectros = zeros(2049*k,1);
    sd = zeros(k,1);
    media = zeros(k,1);

    for j=1:k
        inic = 4096*j - 4095;
        fin = 4096*j;
        x_aux = data(inic:fin);
        sd(j) = std(x_aux);
        media(j) = mean(x_aux);
        x_aux = (x_aux - media(j))/sd(j);
        inic = 2049*j-2048;
        fin = 2049*j;
        espectros(inic:fin) = pmcov(x_aux, 30, 4096);   
    end
    
        
    
    % Crear el nombre del archivo de salida
    archivoSalida1 = fullfile(carpetaActual, 'media.txt');
    archivoSalida2 = fullfile(carpetaActual, 'sd.txt');
    archivoSalida3 = fullfile(carpetaActual, 'espectros.txt');
    % Guardar el valor medio en el nuevo archivo .txt
    save(archivoSalida1,"media","-ascii");
    save(archivoSalida2,"sd","-ascii");
    save(archivoSalida3,"espectros","-ascii");
end