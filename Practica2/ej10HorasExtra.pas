program ej10HorasExtra;
{ej10. Se tiene información en un archivo de las horas extras realizadas por los empleados de
una empresa en un mes. Para cada empleado se tiene la siguiente información:
departamento, división, número de empleado, categoría y cantidad de horas extras
realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
departamento, luego por división, y por último, por número de empleados.

}
const
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej10\';
    MAESTRO_BINARIO = DIREC+'extras';
    MAESTRO_TXT = MAESTRO_BINARIO+'.txt';
    CANT_CATEGORIAS = 15;
    CATEGORIAS_TXT = DIREC+'categorias.txt';

type
    horas = record
        depto: integer;
        division: integer;
        nro_emp: integer;
        cant_hs: double;
        categoria: integer;
    end;
    maestro = file of horas;
    categorias = array[1..CANT_CATEGORIAS] of Double;

procedure leer(var archivo: maestro; var dato: horas);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.depto := VALORALTO;
end;

procedure reporte(var archivo: maestro; v: categorias);
var
    reg: horas;
    div_aux , depto_aux: integer;
    hs_total_depto, total_depto, hs_total_div, total_div: double;
begin
    reset(archivo);
    leer(archivo, reg);
    while (reg.depto <> VALORALTO) do begin
        writeln('DEPARTAMENTO ', reg.depto,':');
        depto_aux := reg.depto;
        total_depto := 0;
        hs_total_depto := 0;
        while (depto_aux = reg.depto) do begin
            writeln('Division ', reg.division,':');
            div_aux := reg.division;
            total_div := 0;
            hs_total_div := 0;
            while (depto_aux = reg.depto) and (div_aux = reg.division) do begin
                writeln('Empleado ', reg.nro_emp,' - ',reg.cant_hs:0:2,'hs extra - ',(reg.cant_hs*v[reg.categoria]):0:2,'$.');
                hs_total_div := hs_total_div + reg.cant_hs; 
                total_div := total_div + (reg.cant_hs*v[reg.categoria]);   {sumo hs y monto de empleados al total de la div}
                leer(archivo, reg);
            end;
            writeln('Total de horas Division: ', hs_total_div:0:2,'hs extra.');
            writeln('Monto total por Division: ', total_div:0:2,'$.');
            writeln();  
            hs_total_depto:= hs_total_depto + hs_total_div; {sumo hs y monto de divs al total del depto}
            total_depto:= total_depto + total_div;
        end;
        writeln('Total horas departamento: ', hs_total_depto:0:2,' hs extra.');
        writeln('Monto total departamento: ', total_depto:0:2,'$.');
        writeln();
    end;
    close(archivo);	
    writeln('Reporte Finalizado.')
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: horas;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, depto, division, nro_emp, categoria, cant_hs);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

procedure cargar_vector(var carga: text; var v: categorias);
var
    valor: double;
    i:integer;
begin
    reset(carga);
    for i:= 1 to CANT_CATEGORIAS do
    begin
        readln(carga, valor);
        v[i]:= valor;
    end;
    close(carga);
end;

var
    mae1: maestro;
    mae1_txt: text;
    v_txt: text;
    v: categorias;
begin
    writeln('Programa Horas Extra: ');
    writeln('----');
    assign(mae1, MAESTRO_BINARIO);
    assign(v_txt, CATEGORIAS_TXT);
    {-------------Archivos del maestro binario y txt-------------}
    {* no son necesarios si ya tenes el/los archivos binarios necesarios como yo no 
    los tengo y quiero probar el programa, primero los creo en .txt y los paso a binario}
    assign(mae1_txt, MAESTRO_TXT);   {*}
    maestro_txt_a_binario(mae1_txt, mae1);   {*}

    cargar_vector(v_txt, v);
    reporte(mae1, v);

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
