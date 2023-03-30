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

WARNING: nombre de archivo a crear y abrir: archcelulares

}
const
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\';       {direccion de donde se van a cargar y guardar los archivos}
    DIRECTXT = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\celulares.txt';  {direccion del celulares.txt que pide el ejercicio }
    VALORALTO = 9999;

type
    empleado = record
        cod: integer;
        nombre: string[50];
        comision: double;
    End;
    archivoEmpleados = file of empleado;
    archivoEmpleadosCompactado = file of empleado;

procedure imprimirCelular(cel : celular);  {lo uso siempre que haya que imprimir/listar en otros procesos}
begin
    with cel do
        writeln('- Codigo de cel: ',codigo,' / marca y modelo: ',marca,' ',nombre,' / descripcion: ',descripcion,
        ' / precio: ',precio:0:2,' / Stock Disponible: ',stock_disp,' / Stock Minimo: ',stock_min);
        {WARNING: los strings (menos el ultimo del registro) como tienen un espacio antes hay que manejarlos con cuidado
        WARNING DEL WARNING: con el procedure EliminarPrimerosEspacios solucione ese problema}
end;

procedure mostrarListaCompleta(var celulares: archivoCelulares);    {WARNING: esto no lo pide el ejercicio}
var
    cel: celular;
begin
    reset(celulares);
    writeln('Lista completa de celulares:');
    while(not eof(celulares))do begin
        read(celulares, cel);
        imprimirCelular(cel);
    end;
    close(celulares);
end;


{opcion 1: crear archivo}
procedure EliminarPrimerosEspacios(var C: string);
{uso este procedure recursivo para eliminar el primer
espacio que aparece cuando leo un string desde un archivo .txt}
begin
    if C[1] = ' ' then
    begin
        delete(C,1,1);
        EliminarPrimerosEspacios(C);
    end;
end;
procedure cargarCelulares(var celulares : archivoCelulares);
var
    carga :text;
    cel:celular;
begin
    assign( carga, DIRECCELULARESTXT );
    reset(carga);
    while (not EOF(carga) ) do
    begin
        readln(carga, cel.codigo, cel.precio, cel.marca);
        readln(carga, cel.stock_disp, cel.stock_min, cel.descripcion);
        readln(carga, cel.nombre);
        EliminarPrimerosEspacios(cel.marca);
        EliminarPrimerosEspacios(cel.descripcion);
        {write(cel.marca); write(cel.descripcion); write(cel.nombre);write('-');}  {WARNING: imprimo para ver como salen los strings}
        write(celulares , cel);
    end;
    close(carga);
end;
procedure crearArchivo(var celulares : archivoCelulares);
var
    arc_fisico: string[20]; {utilizada para obtener el nombre físico del archivo desde teclado}
begin
    write( 'Ingrese el nombre del archivo: ' );
    readln( arc_fisico );
    assign( celulares, DIREC+arc_fisico );
    rewrite( celulares ); { se crea el archivo }
    cargarCelulares(celulares);
    close(celulares);
    writeln( 'Archivo ',arc_fisico,' creado en: ',DIREC+arc_fisico);
end;

{opcion 4: Exportar a "celulares.txt"}
procedure exportarATxt(var celulares : archivoCelulares);
var
    arch_texto: text;
    cel: celular;
begin
    reset(celulares);
    assign(arch_texto, DIRECCELULARESTXT );
    writeln('Archivo de texto creado en: ', DIRECCELULARESTXT );
    rewrite(arch_texto);
    while(not eof(celulares))do begin
        read(celulares, cel);
        with cel do
        begin
            writeln( arch_texto, codigo,' ',precio:0:2,' ',marca);
            writeln( arch_texto, stock_disp,' ',stock_min,' ',descripcion);
            writeln( arch_texto, nombre);
            {WARNING: los strings (menos el ultimo del registro) como tienen un espacio antes hay que manejarlos con cuidado
            WARNING DEL WARNING: con el procedure EliminarPrimerosEspacios solucione ese problema}
        end;
    end;
    close(celulares);
    close(arch_texto);
end;


procedure dibujarMenuMain();
begin
    writeln('----');
    writeln('Programa de celulares, elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. Crear archivo binario de celulares, cargandolo desde "celulares.txt".');
    writeln('2. Listar en pantalla celulares con stock inferior al minimo.');
    writeln('9. Listar celulares.'); {WARNING: esto no lo pide el ejercicio}
    writeln('0. Salir');
    writeln('----');
end;

var
    celulares: archivoCelulares;
    opcion: integer;
begin
    repeat
        dibujarMenuMain();
        readln(opcion);
        case opcion of
            1: CrearArchivo(celulares);
            2: mostrarListaStockBajo(celulares);
            9: mostrarListaCompleta(celulares);  {WARNING: esto no lo pide el ejercicio}
        end;
    until opcion = 0;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
