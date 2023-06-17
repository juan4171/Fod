program ej12AccesosServidor;
{ej12. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de
la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio.
La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y
tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado por los
siguientes criterios: año, mes, dia e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe

}
const
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej12\';
    MAESTRO_BINARIO = DIREC+'accesos';
    MAESTRO_TXT = MAESTRO_BINARIO+'.txt';

type
    accesos = record
        ano: integer;
        mes: integer;
        dia: integer;
        id: integer;
        hs: integer;
    end;
    maestro = file of accesos;

procedure leer(var archivo: maestro; var dato: accesos);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.ano := VALORALTO;
end;

procedure reporte(var archivo: maestro; ano: integer);
var
    reg: accesos;
    ano_aux, mes_aux, dia_aux: integer;
    total_ano, total_mes, total_dia: integer;
begin
    reset(archivo);
    leer(archivo, reg);
    while ((reg.ano <> VALORALTO) and (reg.ano < ano)) do begin
        leer(archivo, reg);
    end;
    if (reg.ano <> ano) or (reg.ano = VALORALTO) then  {el VALORALTO no cuenta como ano valido}
    begin
        writeln('Ano no encontrado.');       
    end
    else
    begin
        writeln('ANO :', reg.ano);
        ano_aux := reg.ano;
        total_ano := 0;
        while (ano_aux = reg.ano) do begin
        {no hace falta poner (ano_aux = reg.ano) and (reg.ano <> valoralto) porque cuando reg.ano sea 9999 ano_aux = reg.ano ya va a dar falso}
            writeln('Mes: ', reg.mes);
            mes_aux := reg.mes;
            total_mes := 0;
            while (ano_aux = reg.ano) and (mes_aux = reg.mes) do begin
                writeln('Dia: ', reg.dia);
                dia_aux := reg.dia;
                total_dia := 0;
                while (ano_aux = reg.ano) and (mes_aux = reg.mes) and (dia_aux = reg.dia) do begin
                    writeln('Usuario ', reg.id,' - ',reg.hs,' horas de acceso en el dia ',reg.dia,' mes ',reg.mes);
                    total_dia := total_dia + reg.hs; {sumo hs y monto de empleados al total de la div}
                    leer(archivo, reg);
                end;
                writeln('Total tiempo de acceso dia ',dia_aux,' mes ', mes_aux,': ', total_dia,'hs');
                total_mes := total_mes + total_dia;
            end;
            writeln('Total tiempo de acceso mes ', mes_aux,': ', total_mes,'hs');  
            writeln();
            total_ano := total_ano + total_mes; {sumo hs y monto de divs al total del depto}
        end;
        writeln('Total tiempo de acceso ano ', ano_aux,': ', total_ano,'hs');
        writeln()
    end;
    close(archivo);	
    writeln('Reporte Finalizado.')
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: accesos;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, ano, mes, dia, id, hs);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

var
    mae1: maestro;
    mae1_txt: text;
begin
    writeln('Programa de Accesos al servidor de la empresa: ');
    writeln('----');
    assign(mae1, MAESTRO_BINARIO);
    {-------------Archivos del maestro binario y txt-------------}
    {* no son necesarios si ya tenes el/los archivos binarios necesarios como yo no 
    los tengo y quiero probar el programa, primero los creo en .txt y los paso a binario}
    assign(mae1_txt, MAESTRO_TXT);   {*}
    maestro_txt_a_binario(mae1_txt, mae1);   {*}

    reporte(mae1, 2023);    {el VALORALTO no cuenta como ano valido}

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
