program ej9Votos;
{ej9 Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: codigo de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
NOTA: La información se encuentra ordenada por código de provincia y codigo de
localidad.

}
const
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej9\';
    MAESTRO_BINARIO = DIREC+'mesas';
    MAESTRO_TXT = MAESTRO_BINARIO+'.txt';

type
    mesa = record
        cod_prov: integer;
        cod_loc: integer;
        nro_mesa: integer;
        votos: integer;
    end;
    maestro = file of mesa;

procedure leer(var archivo: maestro; var dato: mesa);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod_prov := valoralto;
end;

procedure reporte(var archivo: maestro);
var
    reg: mesa;
    cod_prov_aux , cod_loc_aux: integer;
    total_general, total_provincia, total_localidad: integer;
begin
    reset(archivo);
    leer(archivo, reg);
    total_general := 0;
    while (reg.cod_prov <> VALORALTO) do begin
        writeln('Provincia ', reg.cod_prov,':');
        cod_prov_aux := reg.cod_prov;
        total_provincia := 0;
        while (cod_prov_aux = reg.cod_prov) do begin
            cod_loc_aux := reg.cod_loc;
            total_localidad := 0;
            while (cod_prov_aux = reg.cod_prov) and (cod_loc_aux = reg.cod_loc) do begin
                total_localidad := total_localidad + reg.votos;   {sumo votos de mesas al total de la localidad}
                leer(archivo, reg);
            end;
            writeln('Localidad ', cod_loc_aux,' - ',total_localidad,' votos');
            total_provincia := total_provincia + total_localidad;  {sumo votos de localidades al total de la provincia}
        end;
        writeln('Total de Votos Provincia: ', total_provincia);
        writeln();
        total_general := total_general + total_provincia;   {sumo votos de provincias al total general}
    end;
    writeln('Total General de Votos: ', total_general);
    close(archivo);	
    writeln('Reporte Finalizado.')
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: mesa;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod_prov, cod_loc, nro_mesa, votos);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

var
    mae1 : maestro;
    mae1_txt: text;
begin
    writeln('Programa votos: ');
    writeln('----');
    assign(mae1, MAESTRO_BINARIO);
    {-------------Archivos del maestro binario y txt-------------}
    {* no son necesarios si ya tenes el/los archivos binarios necesarios como yo no 
    los tengo y quiero probar el programa, primero los creo en .txt y los paso a binario}
    assign(mae1_txt, MAESTRO_TXT);   {*}
    maestro_txt_a_binario(mae1_txt, mae1);   {*}

    reporte(mae1);

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
