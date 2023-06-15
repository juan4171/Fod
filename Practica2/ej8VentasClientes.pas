program ej8VentasClientes;
{ej8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente.
Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta.
El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras.

}
const
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej8\';
    MAESTRO_BINARIO = DIREC+'ventas';
    MAESTRO_TXT = MAESTRO_BINARIO+'.txt';

type
    venta = record
        cod: integer;
        nom: string[50];
        ano: integer;
        mes: integer;
        dia: integer;
        monto: double;
    end;
    maestro = file of venta;

procedure leer(var archivo: maestro; var dato: venta);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := valoralto;
end;

procedure reporte(var archivo: maestro);
var
    reg: venta;
    cod_aux , mes_aux, ano_aux: integer;
    cliente_mensual, cliente_anual, cliente_total, empresa_total: double;
begin
    reset(archivo);
    leer(archivo, reg);
    empresa_total := 0;
    while (reg.cod <> VALORALTO) do begin
        writeln('REPORTE de cliente: ', reg.nom, ' codigo: ' , reg.cod);
        cod_aux := reg.cod;
        cliente_total := 0;
        while (cod_aux = reg.cod) do begin
            writeln('ano: ', reg.ano);
            ano_aux := reg.ano;
            cliente_anual := 0;
            while (cod_aux = reg.cod) and (ano_aux = reg.ano) do begin
                writeln('mes: ', reg.mes);
                mes_aux := reg.mes;
                cliente_mensual := 0;
                while (cod_aux = reg.cod) and (ano_aux = reg.ano) and (mes_aux = reg.mes) do begin
                    cliente_mensual := cliente_mensual + reg.monto;   {sumo monto de dias al total del mes}
                    leer(archivo, reg);
                end;
                writeln('monto por compras en mes ', mes_aux ,': ', cliente_mensual:0:2 );
                cliente_anual := cliente_anual + cliente_mensual;     {sumo monto de meses al total del ano}
            end;
            writeln('monto por compras en ano ', ano_aux ,': ', cliente_anual:0:2 );
            cliente_total := cliente_total + cliente_anual;   {sumo monto de anos al total del cliente}
        end;       
        writeln('monto TOTAL de compras: ', cliente_total:0:2 );       
        empresa_total := empresa_total + cliente_total;  {sumo monto de clientes al total de la empresa}
        writeln('----');
    end;
    writeln('Monto TOTAL ingresado a Empresa: ', empresa_total:0:2);
    close(archivo);	
    writeln('Reporte Finalizado.')
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: venta;
    espacio: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod, dia, mes, ano, monto, espacio, nom);
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
    writeln('Programa ventas a clientes: ');
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
