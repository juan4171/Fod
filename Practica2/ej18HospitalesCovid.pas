program ej18HospitalesCovid;
{ej18. Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene:
cod_localidad, nombre_localidad, cod_municipio, nombre_minucipio, cod_hospital,
nombre_hospital, fecha y cantidad de casos positivos detectados.
El archivo está ordenado por localidad, luego por municipio y luego por hospital.
a. Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga
un listado con el siguiente formato:

b. Exportar a un archivo de texto la siguiente información nombre_localidad,
nombre_municipio y cantidad de casos de municipio, para aquellos municipios cuya
cantidad de casos supere los 1500. El formato del archivo de texto deberá ser el
adecuado para recuperar la información con la menor cantidad de lecturas posibles.
NOTA: El archivo debe recorrerse solo una vez.
}
const
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej18\';
    MAESTRO_BINARIO = DIREC+'info';
    MAESTRO_TXT = MAESTRO_BINARIO+'.txt';
    EXPORTAR_TXT = DIREC+'1500 casos o mas.txt';

type
    info = record
        cod_loc: integer;
        nom_loc: string[20];
        cod_mun: integer;
        nom_mun: string[20];
        cod_hos: integer;
        nom_hos: string[20];
        positivos: integer;
        fecha: string[20];
    end;
    maestro = file of info;

procedure leer(var archivo: maestro; var dato: info);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod_loc := valoralto;
end;

procedure reporte(var archivo: maestro; var muchos_casos_txt:Text);
var
    reg: info;
    cod_loc_aux , cod_mun_aux: integer;
    nom_loc_aux , nom_mun_aux: string[20];
    total_general, total_loc, total_mun: integer;
begin
    reset(archivo);
    rewrite(muchos_casos_txt);
    leer(archivo, reg);
    total_general := 0;
    while (reg.cod_loc <> VALORALTO) do begin
        writeln('Localidad ', reg.cod_loc,' ', reg.nom_loc);
        cod_loc_aux := reg.cod_loc;
        nom_loc_aux := reg.nom_loc;
        total_loc := 0;
        while (cod_loc_aux = reg.cod_loc) do begin
            writeln('--Municipio ', reg.cod_mun,' ', reg.nom_mun);
            cod_mun_aux := reg.cod_mun;
            nom_mun_aux := reg.nom_mun;
            total_mun := 0;
            while (cod_loc_aux = reg.cod_loc) and (cod_mun_aux = reg.cod_mun) do begin
                writeln('----Hospital ', reg.cod_hos,' ',reg.nom_hos,' Cantidad de casos: ', reg.positivos);
                total_mun := total_mun + reg.positivos;   {sumo votos de mesas al total de la localidad}
                leer(archivo, reg);
            end;
            writeln('--Cantidad de casos Municipio ', cod_mun_aux,' ', nom_mun_aux,': ',total_mun);
            total_loc := total_loc + total_mun;  {sumo votos de localidades al total de la provincia}
            if (total_mun > 1500) then
            begin
				writeln(muchos_casos_txt, nom_mun_aux);
				writeln(muchos_casos_txt, total_mun,' ', nom_loc_aux);
			end;
            {el enunciado dice: "El formato del archivo de texto debera ser el
            adecuado para recuperar la informacion con la menor cantidad de lecturas posibles."
            imagino que se refiere a poner los writeln como los puse, ni idea.}
        end;
        writeln('Cantidad de casos Localidad ', cod_loc_aux,' ', nom_loc_aux,': ',total_loc);
        writeln();
        total_general := total_general + total_loc;   {sumo votos de provincias al total general}
    end;
    writeln('Cantidad de casos Totales en la provincia: ', total_general);
    close(archivo);	
    close(muchos_casos_txt);
    writeln('Reporte Finalizado.')
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: info;
    blanco: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod_loc, blanco, nom_loc);
            readln(carga, cod_mun, blanco, nom_mun);
            readln(carga, cod_hos, blanco, nom_hos);
            readln(carga, positivos, blanco, fecha);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

var
    mae1 : maestro;
    mae1_txt: text;
    muchos_casos_txt: text;
begin
    writeln('Programa informe de casos covid 19: ');
    writeln('----');
    assign(mae1, MAESTRO_BINARIO);
    assign (muchos_casos_txt, EXPORTAR_TXT);
    {-------------Archivos del maestro binario y txt-------------}
    {* no son necesarios si ya tenes el/los archivos binarios necesarios como yo no 
    los tengo y quiero probar el programa, primero los creo en .txt y los paso a binario}
    assign(mae1_txt, MAESTRO_TXT);   {*}
    maestro_txt_a_binario(mae1_txt, mae1);   {*}

    reporte(mae1, muchos_casos_txt);

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
