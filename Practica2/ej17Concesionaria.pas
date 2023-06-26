program ej17Concesionaria;
{ej17. Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con
información de las motos que posee a la venta. De cada moto se registra: código, nombre,
descripción, modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles
con información de las ventas de cada uno de los 10 empleados que trabajan. De cada
archivo detalle se dispone de la siguiente información: código de moto, precio y fecha de la
venta. Se debe realizar un proceso que actualice el stock del archivo maestro desde los
archivos detalles. Además se debe informar cuál fue la moto más vendida.


}
const
    CANT_DETALLES = 2; {en este ej son 10}
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej17\';
    MAESTRO_BINARIO = DIREC+'motos';
    MAESTRO_TXT = MAESTRO_BINARIO+'.txt';
    DETALLE_BINARIO = DIREC+'vendedor';

type
    moto = record
        cod: integer;
        nom: string[50];
        desc: string[50];
        modelo: string[50];
        marca: string[50];
        stock: integer;
    end;
    venta = record
        cod: integer;
        precio: double;
        fecha: string[50];
    end;

    maestro = file of moto;
    detalle = file of venta;

    {en este ej podria no usar arreglo porque son solo 2 detalles...}
    arc_detalle = array[1..CANT_DETALLES] of detalle;    {archivos detalle}
    reg_detalle = array[1..CANT_DETALLES] of venta;

    arc_detalle_txt = array[1..CANT_DETALLES] of text;   {*}
    {archivos detalle txt que uso porque, como no tengo los detalles en binario,
    uso este arreglo para pasarlos de txt a binario}

procedure leer(var archivo: detalle; var dato: venta);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := VALORALTO;
end;

procedure minimo (var reg_det: reg_detalle; var min: venta; var deta: arc_detalle);
var
    i, i_del_minimo: integer;
begin
    min:= reg_det[1];
    i_del_minimo:= 1;
    for i:= 2 to CANT_DETALLES do
    begin
        if ( (reg_det[i].cod < min.cod) ) then
        begin
            min:= reg_det[i];
            i_del_minimo:=i;
        end
    end;
    leer( deta[i_del_minimo], reg_det[i_del_minimo] );
end;

procedure actualizar(var mae1: maestro; var deta: arc_detalle);
var
    i: integer;
    min: venta;
    regm: moto;
    reg_det: reg_detalle; {arreglo de los registros que voy sacando del array de detalles}
    mas_vendida: moto;
    cont_mas_vendida, cont_mas_vendida_aux: integer;
begin
    cont_mas_vendida:= 0;
    cont_mas_vendida_aux:= 0;
    {abro los archivos detalle y maestro y leo el 1er reg de cada detalle}
    reset(mae1);
    for i:= 1 to CANT_DETALLES do
    begin
        reset(deta[i]);
        leer( deta[i], reg_det[i] );
    end;
    {calculo el reg de menor codigo de entre todos los detalles}
    minimo (reg_det, min, deta);
    read(mae1,regm);{asumo que el archivo maestro no esta vacio, si lo esta crashea. uso este read para inicializar el regm pero podria usar regm:='asd' o un if eof}
    while (min.cod <> VALORALTO) do
    begin
        while (regm.cod <> min.cod) do
        begin
            read(mae1,regm);
            cont_mas_vendida:= 0;
        end;
        {las motos pueden tener 1 o mas ventas}
        {no va un if porque SI O SI voy a encontrar un registro maestro para el registro del detalle}
        regm.stock := regm.stock - 1;
        cont_mas_vendida:= cont_mas_vendida + 1;
        if cont_mas_vendida > cont_mas_vendida_aux then
        begin
            mas_vendida:= regm;
            cont_mas_vendida_aux:= cont_mas_vendida;
        end;
        minimo (reg_det, min, deta);
        seek (mae1, filepos(mae1)-1);
        write(mae1, regm);
    end;
    if cont_mas_vendida_aux <> 0 then
        writeln('La moto mas vendida con ', cont_mas_vendida_aux,' ventas es la ', mas_vendida.nom,' ', mas_vendida.marca,' ', mas_vendida.modelo);
    {cierro archivos detalle y maestro}
    close(mae1);
    for i:= 1 to CANT_DETALLES do
    begin
        close(deta[i]);
    end;
    writeln('Actualizacion finalizada.')
end;


procedure detalle_txt_a_binario(var carga: text; var det: detalle);
var
    reg: venta;  {registro del tipo que se guarda en detalle}
    espacio: char;
begin
    reset(carga);
    rewrite(det);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod, precio, espacio, fecha);
        end;
        write(det, reg);
    end;
    close(det);
    close(carga);
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: moto;
    espacio: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod, stock, espacio, nom);
            readln(carga, desc);
            readln(carga, modelo);
            readln(carga, marca);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

procedure exportar_a_txt(var arch_binario : maestro; var arch_texto: text);
var
    reg: moto;
begin
    reset(arch_binario);
    rewrite(arch_texto);
    writeln('Archivo de texto creado en: ', MAESTRO_TXT);
    while(not eof(arch_binario))do begin
        read(arch_binario, reg);
        with reg do
        begin
            writeln(arch_texto, cod,' ', stock,' ', nom);
            writeln(arch_texto, desc);
            writeln(arch_texto, modelo);
            writeln(arch_texto, marca);
        end;
    end;
    close(arch_binario);
    close(arch_texto);
end;

var
    mae1 : maestro;
    mae1_txt: text;
    vector_det_binarios: arc_detalle;
    vector_det_txt: arc_detalle_txt;
    i:integer;
    indice_str:string[5];
begin
    writeln('----');
    writeln('Programa de motos de concesionario: ');
    writeln('----');
    {-------------Archivos del maestro binario y txt-------------}
    assign(mae1, MAESTRO_BINARIO);
    assign(mae1_txt, MAESTRO_TXT);   {*}
    maestro_txt_a_binario(mae1_txt, mae1);   {*}
    {-------------Creacion de los detalles binarios--------------}
    for i := 1 to CANT_DETALLES do begin
        Str(i,indice_str);
        assign(vector_det_txt[i], DETALLE_BINARIO+indice_str+'.txt');   {*}
        assign(vector_det_binarios[i], DETALLE_BINARIO+indice_str);
        detalle_txt_a_binario(vector_det_txt[i], vector_det_binarios[i]);   {*}
        {creo un vector de detalles txt para poder ir pasandolos todos al vector de detalles binarios,
        el ejercicio no lo pide pero para comprobar que funciona lo hago, si ya tuviera creados los binarios no haria falta hacerlo
        voy asignandole direcciones a los archivos binarios y despues (pasando los archivos de texto a binario)
        voy creando archivos en esas direcciones}
    end;

    actualizar(mae1, vector_det_binarios);

    exportar_a_txt(mae1, mae1_txt);          {*}
    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
