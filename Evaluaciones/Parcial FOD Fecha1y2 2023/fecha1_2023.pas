program fecha1_2023;
{Parcial FOD Fecha1 2023 06/06/23 tema 1 
No lo corregi ni lo probe si anda pero IMAGINO que esta bien}
const
    VALORALTO = 9999; {Al final no necesite la const porque no uso modulo leer()}
type
    producto = record
        cod:integer;
        nom:string[20];
        des:string[50];
        compra:double;
        venta:double;
        ubic:integer;
    end;    
    arch = file of producto;

procedure leer_producto(var p : producto)
begin
    writeln('Ingrese uno por linea los datos del nuevo producto');
    readln(p.cod);
    readln(p.nom);
    readln(p.des);
    readln(p.compra);
    readln(p.venta);
    readln(p.ubic);
    writeln('Datos registrados.');
end;

procedure agregar_producto(var a : arch)
var
    new_prod, prod_aux, cabecera: producto;
begin  
    leer_producto(prod);
    if (existe_producto(prod.cod, a)) then  {asumo que el existe producto abre y cierra el archivo, por eso se lo mando cerrado}
    begin
        WriteLn('El producto ingresado ya existe en el archivo, no se puede guardar.');
    end
    else
    begin
        reset(a);   {abro y cierro el archivo dentro del if porque solo lo abro si es necesario}
        read(cabecera, a);
        if (cabecera.cod < 0) then
        begin
            seek(a, cabecera.cod * -1);
            read(a, prod_aux);
            seek(a, filepos(a)-1);
            write(a, new_prod);
            seek(a, 0);
            write(prod_aux);
        end
        else
        begin
            seek(a, filesize(a));
            write(a, new_prod);
        end;
        writeLn('Producto guardado en el archivo exitosamente.');
        close(a);   {abro y cierro el archivo dentro del if porque solo lo abro si es necesario}
    end;
end;

procedure quitar_producto(var a : arch)
var
    c, pos_borrado:integer;
    cabecera, prod:producto;
begin
    writeln('Ingrese codigo del producto a eliminar:');
    readln(c);
    if (existe_producto(c,a)) then {asumo que el existe producto abre y cierra el archivo, por eso se lo mando cerrado}
    begin
        reset(a); {abro y cierro el archivo dentro del if porque solo lo abro si es necesario}
        read(a, cabecera);
        read(a, prod);
        while (prod.cod <> c) do {no necesito controlar si se me acaba el archivo porque se que existe el producto}
            read(a, prod);          {no necesito procedure leer()}
        pos_borrado:= filepos(a)-1;
        seek(a, filepos(a)-1);
        write(a, cabecera);
        seek(a, 0);
        cabecera.cod:= pos_borrado * -1;
        write(a,cabecera);
        writeln('Producto eliminado exitosamente.');
        close(a);   {abro y cierro el archivo dentro del if porque solo lo abro si es necesario}
    end
    else
    begin
        writeln('Codigo ingresado no existe en el archivo.');
    end;
end;

var
    a : arch;
begin
    assign(a, 'productos');    
    {"suponga que tiene un archivo" osea 
    supongo que ya lo tengo creado en alguna parte del disco, 
    no necesito crearlo, solo lo abro dentro de los procedures}
    agregar_producto(a);
    quitar_producto(a);
end.