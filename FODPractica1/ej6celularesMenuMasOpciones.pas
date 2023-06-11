program ej6celularesMenuMasOpciones;
{ej5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripción, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”

WARNING: nombre de archivo a crear y abrir: ej6celus

}
const
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\FODPractica1\archivosFOD\';       {direccion de donde se van a cargar y guardar los archivos}
    DIRECCELULARESTXT = 'C:\Users\juan8\Desktop\FOD2023\FODPractica1\archivosFOD\celulares.txt';  {direccion del celulares.txt que pide el ejercicio }
    DIRECCELULARESSINSTOCKTXT = 'C:\Users\juan8\Desktop\FOD2023\FODPractica1\archivosFOD\SinStock.txt';  {direccion del SinStock.txt que pide el ejercicio 6c}

type
    celular = record
        codigo: integer;
        nombre: string[12];
        descripcion: string[20];
        marca: string[12];
        precio: double;
        stock_min: integer;
        stock_disp: integer;
    End;
    archivoCelulares = file of celular;

procedure imprimirCelular(cel : celular);  {lo uso siempre que haya que imprimir/listar en otros procesos}
begin
    with cel do
        writeln('- Codigo de cel: ',codigo,' / marca y modelo: ',marca,' ',nombre,' / descripcion: ',descripcion,
        ' / precio: ',precio:0:2,' / Stock Disponible: ',stock_disp,' / Stock Minimo: ',stock_min);
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

{opcion 2: listar Stock Bajo}
procedure mostrarListaStockBajo(var celulares: archivoCelulares);
var
    cel: celular;
begin
    reset(celulares);
    writeln('Lista de celulares que tengan un stock menor al stock minimo:');
    while(not eof(celulares))do begin
        read(celulares, cel);
        if (cel.stock_min > cel.stock_disp) then
            imprimirCelular(cel);
    end;
    close(celulares);
end;

{opcion 3: listar Descripciones Con Cadena}
procedure mostrarListaDescripcionConCadena(var celulares: archivoCelulares);
var
    cel: celular;
    cadena:string;
begin
    write('Ingrese la cadena a buscar en las descripciones de los celulares: ');
    readln(cadena);
    reset(celulares);
    writeln('Lista de celulares cuya descripcion contenga: "',cadena,'":');
    while(not eof(celulares))do begin
        read(celulares, cel);
        {pos() me devuelve el numero de la pos donde se encuentra la cadena, si no se encuentra devuelve 0}
        if ( pos( cadena, cel.descripcion) <> 0 ) then
            imprimirCelular(cel);
    end;
    close(celulares);
end;

{opcion 1: crear archivo}
procedure cargarCelulares(var celulares : archivoCelulares);
var
    carga :text;
    cel:celular;
    espacio:char;  {se usa para sacar el espacio que hay antes de los strings}
begin
    assign( carga, DIRECCELULARESTXT );
    reset(carga);
    while (not EOF(carga) ) do
    begin
        readln(carga, cel.codigo, cel.precio, espacio, cel.marca);
        readln(carga, cel.stock_disp, cel.stock_min, espacio, cel.descripcion);
        readln(carga, cel.nombre);
        {write(cel.marca); write(cel.descripcion); write(cel.nombre); }  {WARNING: imprimo para ver como salen los strings}
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
        end;
    end;
    close(celulares);
    close(arch_texto);
end;

{opcion 7: Exportar a "SinStock.txt"}
procedure exportarSinStockATxt(var celulares : archivoCelulares);
var
    arch_texto: text;
    cel: celular;
    contadorCelulares : integer;
begin
    contadorCelulares := 0;
    reset(celulares);
    assign(arch_texto, DIRECCELULARESSINSTOCKTXT );
    rewrite(arch_texto);
    while(not eof(celulares))do begin
        read(celulares, cel);
        if(cel.stock_disp = 0)then
        begin
            contadorCelulares := contadorCelulares + 1;
            with cel do
            begin
                writeln( arch_texto, codigo,' ',precio:0:2,' ',marca);
                writeln( arch_texto, stock_disp,' ',stock_min,' ',descripcion);
                writeln( arch_texto, nombre);
            end;
        end;
    end;
    writeln('Archivo .txt creado en: ', DIRECCELULARESSINSTOCKTXT,' con un total de ',contadorCelulares,
    ' celulares (ATENCION: si en el archivo binario creado en la opcion 1 no habia celulares con stock 0, el archivo "SinStock.txt" estara vacio.)' );
    close(celulares);
    close(arch_texto);
end;

{opcion 5: Añadir celulares al final}
procedure leerCelular(var reg: celular);
begin
    writeln('Nuevo celular (codigo = 99 para terminar la carga):');
    writeln('Ingrese codigo del celular:');
    readln(reg.codigo);
    if (reg.codigo <> 99)then
    begin
        writeln('Ingrese marca:');
        readln(reg.marca);
        writeln('Ingrese modelo (ATENCION: no ingresar repetidos.):');
        {WARNING: al ingresar repetidos el modulo actualizarStock funcionaria mal,
        podria agregar algo que controle que no se ingresen repetidos pero nada controla
        que no haya repetidos en el celulares.txt que se lee al principio en la opcion 1}
        readln(reg.nombre);
        writeln('Ingrese precio:');
        readln(reg.precio);
        writeln('ingrese descripcion:');
        readln(reg.descripcion);
        writeln('ingrese stock disponilbe:');
        readln(reg.stock_disp);
        writeln('ingrese stock minimo:');
        readln(reg.stock_min);
    end;
end;
procedure agregar(var celulares : archivoCelulares);
{WARNING: no controlo si hay celulares repetidos}
var
    cel:celular;
begin
    reset( celulares );
    writeln( 'Comienza la carga de celulares al final del archivo: ' );
    leerCelular(cel);
    while cel.codigo <> 99 do   {inicio loop de carga porque puedo agregar 1 o mas celulares}
    begin
        seek(celulares, filesize(celulares)); {seek al final de archivo y escribo}
        write( celulares, cel );
        writeln( 'Se agrego un celular de codigo: ',cel.codigo,' al final del registro:');
        imprimirCelular(cel); {WARNING como imprime}
        leerCelular(cel);
    end;
    close(celulares);
    writeln( 'Archivo actualizado.' );
end;

{opcion 6: actualizar Stock busqueda de celular por nombre}
procedure actualizarStock(var celulares : archivoCelulares);
var
    cel:celular;
    n:string[20];
begin
    {WARNING: se busca por nombre la primera coincidencia la reemplazo, no controlo que haya repetidos...}
    reset(celulares);
    writeln('Ingrese el nombre (modelo) del celular a cual desea actualizar el stock:');
    readln(n);
    read(celulares,cel);
    while((not eof (celulares)) and (n <> cel.nombre))do
    begin
        read(celulares,cel);
    end;
    if(cel.nombre <> n)then
        writeln('El modelo de celular ingresado no existe en la base de datos, intente nuevamente.')
    else
    begin
        writeln('Celular ', cel.nombre, ' encontrado: ');
        imprimirCelular(cel);
        writeln('Ingrese nuevo valor entero para actualizar el stock disponible: ');
        readln(cel.stock_disp);
        writeln('Operacion realizada con exito');
        imprimirCelular(cel);
        seek(celulares, filepos(celulares) -1);
        write(celulares,cel);
    end;
    close(celulares);
end;


procedure dibujarMenuMain();
begin
    writeln('----');
    writeln('Programa de celulares, elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. Crear archivo binario de celulares, cargandolo desde "celulares.txt".');
    writeln('2. Listar en pantalla celulares con stock inferior al minimo.');
    writeln('3. Listar en pantalla celulares cuya descripcion contenga una cadena de caracteres proporcionada por el usuario.');
    writeln('4. Exportar el archivo creado en la opcion 1 a un archivo .txt llamado "celulares.txt".');
    writeln('5. Añadir celulares al final del archivo ingresando datos por teclado.');
    writeln('6. Modificar el stock de un celular dado.');
    writeln('7. Exportar a un archivo .txt llamado "SinStock.txt" aquellos celulares que tengan stock 0.');
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
            3: mostrarListaDescripcionConCadena(celulares);
            4: exportarATxt(celulares);
            5: agregar(celulares);
            6: actualizarStock(celulares);
            7: exportarSinStockATxt(celulares);
            9: mostrarListaCompleta(celulares);  {WARNING: esto no lo pide el ejercicio}
        end;
    until opcion = 0;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
