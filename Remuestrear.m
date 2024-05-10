% Especifica la ruta de la carpeta que contiene las series RR
carpeta = '/home/david/Documents/Epilepsia/series_epilepticos';
%periodo = load('periodo_remuestreo.txt')*1000;
periodo = (1/13.653333333333332)*1000; %%% OJO Remuestreo a 13.653 Hz
%%%%%%%%%%%%%%% Remuestrea y reescribe los archivos segun el periodo
%%%%%%%%%%%%%%% especificado
archivos = dir(fullfile(carpeta, '*.hrv'));

% Inicializa un vector para almacenar los nombres de archivos
nombresArchivos = cell(length(archivos), 1);

% Recorre la lista de archivos y guarda los nombres en el vector
for i = 1:length(archivos)
    nombresArchivos{i} = archivos(i).name;
end
n = length(archivos);

for i=1:n
    nombreArchivo = archivos(i).name;
    rutaArchivo = fullfile(carpeta, nombreArchivo);
    contenido = fileread(rutaArchivo);
        % Crea un nombre de campo válido para la estructura
    nombreCampo = genvarname(nombreArchivo);
    
    % Guarda el contenido en la estructura con el nuevo nombre de campo
    contenidoArchivos.(nombreCampo) = contenido;
    contenidoTexto = contenidoArchivos.(nombreCampo); % Lee el contenido del archivo como texto
    
    % Convierte el contenido de texto en un vector de números (double)
    data = str2double(strsplit(contenidoTexto));
    data(end) = [];                           % se eliminan las muestras primera y última de la serie ya que son
    
    data = resampling(data,periodo);        % se llama a la función de remuestreo
    new_name = 'Resampled13_53';
    new_name = strcat(new_name, nombreArchivo);
    save(new_name,"data","-ascii");
end