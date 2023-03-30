program ej1EmpresaEmpleados;
{ej1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.

WARNING: nombre de archivo a crear y abrir: empleados

}
const
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\';       {direccion de donde se van a cargar y guardar los archivos}
    EMPLEADOSTXT = DIREC+'empleados.txt';  {direccion del empleados.txt que pide el ejercicio }
    EMPLEADOSTXTCOMPACTADO= DIREC+'empleados_compactado.txt';
    VALORALTO = 9999;

type
    empleado = record
        cod: integer;
        nombre: string[50];
        monto: double;
    end;

procedure leer (var archivo:text; var dato:empleado);
var
    blanco:char;
begin
    if (not EOF(archivo)) then
        with dato do readln(archivo, cod, monto, blanco, nombre)
    else
        dato.cod := valoralto;
end;

procedure compactar_archivo(var archivo_original: text; var archivo_nuevo: text);
var
    emp_aux, emp: empleado;
begin
    reset (archivo_original);
    rewrite(archivo_nuevo);
    leer( archivo_original, emp_aux );
    while (emp_aux.cod <> VALORALTO) do
    begin
        emp := emp_aux;
        leer( archivo_original, emp_aux );
        while (emp.cod = emp_aux.cod) do
        begin
            emp.monto := emp.monto + emp_aux.monto;
            leer( archivo_original, emp_aux );
        end;
        with emp do writeln(archivo_nuevo,cod,' ', monto:0:2,' ', nombre);
    end;
    close(archivo_original);
    close(archivo_nuevo);
    writeln('Archivo: ', EMPLEADOSTXT, ' compactado en: ', EMPLEADOSTXTCOMPACTADO);
end;

{ otra forma de hacerlo con total
procedure compactar_archivo(var archivo_original: text; var archivo_nuevo: text);
var
    e, emp: empleado;
    tot: real;
begin
    reset(archivo_original);
    rewrite(archivo_nuevo);
    leer(archivo_original, e);
    while(e.cod <> valoralto)do begin
        emp := e;
        tot := 0;
        while(e.cod = emp.cod)do begin
            tot := tot + e.monto;
            leer(archivo_original, e);
        end;
        with emp do writeln(archivo_nuevo, cod, tot, nombre);
    end;
    close(archivo_original);
    close(archivo_nuevo);
end;
}

var
    archivo_original, archivo_nuevo: text;

begin
    assign (archivo_original, EMPLEADOSTXT);
    assign (archivo_nuevo, EMPLEADOSTXTCOMPACTADO);
    {EN ESTE CASO (donde se puede hacer assign ahora)queda mejor asignarles direc
    en pprincipal asi los siguientes procedures son mas especificos}
    compactar_archivo(archivo_original, archivo_nuevo);
    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
