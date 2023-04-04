program ej3Productos;
{ej3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.

WARNING: nombre de archivo a crear y abrir:

}
const
    SUCURSALES = 3;
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej3\';
    PRODUCTOSTXT = DIREC+'productos.txt';
    PRODUCTOSBINARIO = DIREC+'productos';
    PRODUCTOSTXT_ACTUALIZADO= DIREC+'productos_actualizado.txt';

type
    producto = record
        cod: integer;
        nom: string[50];
        descrip: string[50];
        stock_minimo: integer;
        stock_disp: integer;
        precio: double;
    end;
    informe = record
        cod: integer;
        cant_vendida: integer;
    end;

    maestro = file of producto;
    detalle = file of informe;
    arc_detalle = array[1..SUCURSALES] of detalle;    {file of detalle; o} {file of informe;}
    reg_detalle = array[1..SUCURSALES] of informe;

procedure dibujarMenu();
begin
    writeln('----');
    writeln('Programa productos e informes de sucursales, elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. Actualizar el archivo maestro "productos.txt" con los ', SUCURSALES,' archivos detalle "det(nro de sucursal).txt"');
    writeln('2. Crear archivo .txt .');
    writeln('0. Salir');
    writeln('----');
end;

procedure maestroTxtABinario(var carga: text; var archivo_maestro: maestro);
var
    p: producto;
    espacio:char;
begin
    reset(carga);
    rewrite(archivo_maestro);
    while(not eof(carga))do begin
        with p do
        begin
            readln(carga, cod, precio, espacio, nom);
            readln(carga, stock_disp, stock_minimo, espacio, descrip);
        end;
        write(archivo_maestro, p);
    end;
    close(archivo_maestro);
    close(carga);
end;

procedure detalleTxtABinario(var carga: text; var archivo_informe: detalle);
var
    i: informe;
begin
    reset(carga);
    rewrite(archivo_informe);
    while(not eof(carga))do begin
        with i do readln(carga, cod, cant_vendida);
        write(archivo_informe, i);
    end;
    close(archivo_informe);
    close(carga);
end;

procedure leer(var archivo: detalle; var dato: informe);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := valoralto;
end;

procedure minimo (var reg_det: reg_detalle; var min:informe; var deta:arc_detalle);
var
    i, i_del_minimo: integer;
begin
    min:= reg_det[1];
    i_del_minimo:=1;
    for i:= 2 to SUCURSALES do
    begin
        if (reg_det[i].cod < min.cod) then
        begin
            min:=reg_det[i];
            i_del_minimo:=i;
        end;
    end;
    leer( deta[i_del_minimo], reg_det[i_del_minimo] );
end;

procedure actualizar_stock_maestro(var mae1: maestro; var deta: arc_detalle);
var
    i: integer;
    s: string[5];
    min: informe;
    regm: producto;
    reg_det: reg_detalle; {registro de los informes que voy sacando del array de detalles}
begin
    reset(mae1);
    for i:= 1 to SUCURSALES do
    begin
        Str(i,s);
        assign (deta[i], DIREC+'det'+s);   //abro cada archivo, les asigno un nombre correspondiente a su pos (OJO no se puede)
        reset(deta[i]); {WARNING, cuando los cierro?}
        leer( deta[i], reg_det[i] );
    end;
    minimo (reg_det, min, deta);
    while (min.cod <> VALORALTO) do
    begin
        read(mae1,regm);
        while (regm.cod <> min.cod) do
            read(mae1,regm);
        {se procesan todos los productos de un mismo codigo}
        while (regm.cod = min.cod ) do begin
            regm.stock_disp := regm.stock_disp - min.cant_vendida;
            minimo (reg_det, min, deta);
        end;
        { se guarda en el archivo maestro}
        seek (mae1, filepos(mae1)-1);
        write(mae1, regm);
    end;

    close(mae1);
    for i:= 1 to SUCURSALES do
    begin
        close(deta[i]); {WARNING, nunca los cierro?}
    end;
end;

procedure exportarATxt(var arch_binario : maestro);
var
    arch_texto: text;
    p: producto;
begin
    reset(arch_binario);
    assign(arch_texto, PRODUCTOSTXT_ACTUALIZADO );
    writeln('Archivo de texto creado en: ', PRODUCTOSTXT_ACTUALIZADO );
    rewrite(arch_texto);
    while(not eof(arch_binario))do begin
        read(arch_binario, p);
        with p do
        begin
            writeln( arch_texto, cod,' ',precio:0:2,' ',nom);
            writeln( arch_texto, stock_disp,' ',stock_minimo,' ',descrip);
        end;
    end;
    close(arch_binario);
    close(arch_texto);
end;

var
    carga_productos_txt : text;
    carga_informes_binarios : arc_detalle;
    mae1 : maestro;
    opcion: integer;
begin
    assign(carga_productos_txt, PRODUCTOSTXT);
    assign(mae1, PRODUCTOSBINARIO);
    repeat
        dibujarMenu();
        readln(opcion);
        case opcion of
            1: begin
                maestroTxtABinario(carga_productos_txt, mae1);
                actualizar_stock_maestro(mae1, carga_informes_binarios);
                exportarATxt(mae1);
            end;
        end;
    until opcion = 0;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
