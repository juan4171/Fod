program ej6Ropa;
{ej6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas.

* hay algunos metodos que no pide el ej pero yo los uso para generar los archivos
binarios necesarios, creandolos desde archivos .txt con el objetivo de poder probar el program

}

const
    VALORALTO = 9999;
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica3\archivosFOD\ej6\';
    MAESTRO_BINARIO = DIREC+'maestro';
    DETALLE_BINARIO = DIREC+'detalle';
    MAESTRO_AUX = DIREC+'maestro_aux';

    MAESTRO_TXT = DIREC+'maestro.txt';            {* no lo pide el ej}
    DETALLE_TXT = DIREC+'detalle.txt';            {* no lo pide el ej}
    RESULTADO_TXT = DIREC+'RESULTADO.TXT';       {* no lo pide el ej}
type
    prenda = record
        cod: integer;
        desc: string[50];
        colores: string[50];
        stock: integer;
        precio: double;
    end;
    prenda_obsoleta = record
        cod: integer;
    end;
    maestro = file of prenda;
    detalle = file of prenda_obsoleta;

procedure leer(var archivo: detalle; var dato: prenda_obsoleta);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := valoralto;
end;

procedure actualizar(var mae1: maestro; var det1: detalle);
var
    regd: prenda_obsoleta;
    regm: prenda;
begin
    reset (mae1); reset (det1);
    leer(det1 , regd); {se procesan todos los registros del archivo det1}
    while (regd.cod <> valoralto) do begin
        read(mae1, regm);
        while (regm.cod <> regd.cod) do
            read (mae1,regm);
        { se procesan cÃ³digos iguales }
        regm.stock := -(regm.stock);
        leer(det1, regd);
        {reubica el puntero}
        seek (mae1, filepos(mae1)-1);
        write(mae1,regm);
    end;
    writeln('Actualizacion del archivo de prendas ',MAESTRO_BINARIO
    ,' con el archivo de prendas obsoletas ',DETALLE_BINARIO,' finalizada.')
end;

procedure compactar(var mae1: maestro; var mae_aux : maestro);
var
    regm: prenda;
begin
    assign( mae_aux, MAESTRO_AUX);
    reset (mae1); 
    rewrite (mae_aux);
    while(not eof(mae1))do begin
        read(mae1, regm);
        if regm.stock > 0 then
        begin
            with regm do
            begin
                write(mae_aux, regm);
            end;
        end;
    end;
    close(mae1);
    close(mae_aux);
    erase(mae1);
    rename(mae_aux, MAESTRO_BINARIO);
    writeln('Compactacion (baja fisica) del archivo ', MAESTRO_BINARIO ,' finalizada.')
end;

{* no lo pide el ej}
procedure exportar_a_txt(var arch_binario : maestro; var arch_texto: text);
var
    reg: prenda;
begin
    reset(arch_binario);
    rewrite(arch_texto);
    writeln('Archivo de texto creado en: ',RESULTADO_TXT );
    while(not eof(arch_binario))do begin
        read(arch_binario, reg);
        with reg do
        begin
            writeln(arch_texto, cod,' ', stock,' ', precio:0:2,' ', colores);
            writeln(arch_texto, desc);
        end;
    end;
    close(arch_binario);
    close(arch_texto);
end;

{* no lo pide el ej}
procedure detalle_txt_a_binario(var carga: text; var det: detalle);
var
    reg: prenda_obsoleta;  {registro del tipo que se guarda en detalle}
begin
    reset(carga);
    rewrite(det);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod);
        end;
        write(det, reg);
    end;
    close(det);
    close(carga);
end;

{* no lo pide el ej}
procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: prenda;
    espacio: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod, stock, precio, espacio, colores);
            readln(carga, desc);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

var
    mae1 : maestro;
    mae_aux : maestro;
    det1 : detalle;

    mae1_txt : text;    {* no lo pide el ej}
    det1_txt : text;    {* no lo pide el ej}
    resultado: text;    {* no lo pide el ej}
begin
    assign( mae1, MAESTRO_BINARIO); 
    assign( det1, DETALLE_BINARIO);

    assign( mae1_txt, MAESTRO_TXT);     {* no lo pide el ej}
    assign( det1_txt, DETALLE_TXT);     {* no lo pide el ej}
    maestro_txt_a_binario(mae1_txt, mae1);     {* no lo pide el ej}
    detalle_txt_a_binario(det1_txt, det1);     {* no lo pide el ej}

    actualizar(mae1, det1);
    compactar(mae1, mae_aux);

    assign( resultado, RESULTADO_TXT);       {* no lo pide el ej}
    exportar_a_txt(mae_aux, resultado);      {* no lo pide el ej}

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
