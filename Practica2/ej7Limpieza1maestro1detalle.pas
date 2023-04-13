program ej7Limpieza1maestro1detalle;
{ej7- El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
los productos que comercializa. De cada producto se maneja la siguiente información:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
Se pide realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
? Ambos archivos están ordenados por código de producto.
? Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
? El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.

WARNING: resto los productos vendidos al stock, no compruebo si no hay mas
WARNING: uso el archivo "productos original.txt" para restablecer el archivo "productos.txt"
porque este programa lo actualiza
}
const

    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej7\';
    MAESTRO_BINARIO = DIREC+'productos';
    MAESTRO_TXT = MAESTRO_BINARIO+'.txt';
    DETALLE_BINARIO = DIREC+'ventas';
    DETALLE_TXT = DETALLE_BINARIO+'.txt';
    STOCK_MINIMO_TXT = DIREC+'stock_minimo.txt';

type
    productos = record
        cod: integer;
        nom: string[50];
        precio: double;
        stock: integer;
        stock_min: integer;
    end;
    ventas = record
        cod: integer;
        vendidos: integer;
    end;

    maestro = file of productos;
    detalle = file of ventas;


procedure leer(var archivo: detalle; var dato: ventas);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := valoralto;
end;


procedure actualizar(var mae1: maestro; var det1: detalle);
var
    regd: ventas;
    regm: productos;
begin
    reset (mae1); reset (det1);
    leer(det1 , regd); {se procesan todos los registros del archivo det1}
    while (regd.cod <> valoralto) do begin
        read(mae1, regm);
        while (regm.cod <> regd.cod) do
            read (mae1,regm);
        { se procesan códigos iguales }
        while (regm.cod = regd.cod) do begin
            regm.stock := regm.stock - regd.vendidos;
            leer(det1,regd);
        end;
        {reubica el puntero}
        seek (mae1, filepos(mae1)-1);
        write(mae1,regm);
    end;
    writeln('Actualizacion finalizada.')
end;

procedure exportar_a_txt(var arch_binario : maestro; var arch_texto: text);
var
    reg: productos;
begin
    reset(arch_binario);
    rewrite(arch_texto);
    writeln('Archivo de texto creado en: ', MAESTRO_TXT);
    while(not eof(arch_binario))do begin
        read(arch_binario, reg);
        with reg do
        begin
            writeln( arch_texto, cod,' ', precio:0:2,' ', stock,' ', stock_min,' ', nom);
        end;
    end;
    close(arch_binario);
    close(arch_texto);
end;

procedure exportar_a_txt_stock_minimo(var arch_binario : maestro; var arch_texto: text);
var
    reg: productos;
begin
    reset(arch_binario);
    rewrite(arch_texto);
    writeln('Archivo de texto creado en: ', STOCK_MINIMO_TXT);
    while(not eof(arch_binario))do begin
        read(arch_binario, reg);
        if (reg.stock < reg.stock_min) then
        begin
            with reg do
            begin
                writeln( arch_texto, cod,' ', precio:0:2,' ', stock,' ', stock_min,' ', nom);
            end;
        end;
    end;
    close(arch_binario);
    close(arch_texto);
end;

procedure detalle_txt_a_binario(var carga: text; var det: detalle);
var
    reg: ventas;  {registro del tipo que se guarda en detalle}
begin
    reset(carga);
    rewrite(det);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod, vendidos);
        end;
        write(det, reg);
    end;
    close(det);
    close(carga);
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: productos;
    espacio: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod, precio, stock, stock_min, espacio, nom);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;


var
    mae1 : maestro;
    mae1_txt, det1_txt, lista_stock_minimo : text;
    det1 : detalle;
begin
    writeln('----');
    writeln('Programa productos de limpieza: ');
    writeln('----');
    {-------------Archivos del maestro binario y txt-------------}
    assign(mae1, MAESTRO_BINARIO);
    assign(mae1_txt, MAESTRO_TXT);   {*}
    assign(det1_txt, DETALLE_TXT);   {*}
    assign(det1, DETALLE_BINARIO);
    detalle_txt_a_binario(det1_txt, det1);   {*}
    maestro_txt_a_binario(mae1_txt, mae1);   {*}

    actualizar(mae1, det1);
    assign(lista_stock_minimo, STOCK_MINIMO_TXT);
    exportar_a_txt_stock_minimo(mae1, lista_stock_minimo);

    exportar_a_txt(mae1, mae1_txt);          {*}
    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
