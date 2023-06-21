program ej11Alfabetizacion;
{ej11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.

}
const
    CANT_DETALLES = 2;
    VALORALTO = 'ZZZZ';
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej11\';
    MAESTRO_BINARIO = DIREC+'alfabetizacion';
    MAESTRO_TXT = MAESTRO_BINARIO+'.txt';
    DETALLE_BINARIO = DIREC+'censo';

type
    info = record
        nom: string[50];
        alfabetizadas: integer;
        encuestadas: integer;
    end;
    censo = record
        cod_loc: integer;
        nom: string[50];
        alfabetizadas: integer;
        encuestadas: integer;
    end;

    maestro = file of info;
    detalle = file of censo;

    {en este ej podria no usar arreglo porque son solo 2 detalles...}
    arc_detalle = array[1..CANT_DETALLES] of detalle;    {archivos detalle}
    reg_detalle = array[1..CANT_DETALLES] of censo;

    arc_detalle_txt = array[1..CANT_DETALLES] of text;   {*}
    {archivos detalle txt que uso porque, como no tengo los detalles en binario,
    uso este arreglo para pasarlos de txt a binario}

procedure leer(var archivo: detalle; var dato: censo);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.nom := VALORALTO;
end;

procedure minimo (var reg_det: reg_detalle; var min: censo; var deta: arc_detalle);
var
    i, i_del_minimo: integer;
begin
    min:= reg_det[1];
    i_del_minimo:=1;
    for i:= 2 to CANT_DETALLES do
    begin
        if ( (reg_det[i].nom < min.nom) or ((reg_det[i].nom = min.nom) and (reg_det[i].cod_loc < min.cod_loc)) ) then
        begin   {devuelvo el nombre mas chico o el nombre mas chico con el codigo de localidad mas chico (no es necesario)}
            min:= reg_det[i];
            i_del_minimo:=i;
        end
    end;
    leer( deta[i_del_minimo], reg_det[i_del_minimo] );
end;

procedure actualizar(var mae1: maestro; var deta: arc_detalle);
var
    i: integer;
    min: censo;
    regm: info;
    reg_det: reg_detalle; {arreglo de los registros que voy sacando del array de detalles}
begin
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
    while (min.nom <> VALORALTO) do
    begin
        while (regm.nom <> min.nom) do
            read(mae1,regm);
        {esta parte el ej es muy parecida a la del ej 6 pero la diferencia es que en este ej el registro
        maestro no tiene ninguna variable para saber cual localidad de la provincia estoy procesando}
        {las provincias pueden tener 1 o mas localidades}
        {no va un if porque SI O SI voy a encontrar un registro maestro para el registro del detalle}
        regm.alfabetizadas := regm.alfabetizadas + min.alfabetizadas;
        regm.encuestadas := regm.encuestadas + min.encuestadas;
        minimo (reg_det, min, deta);
        { se guarda en el archivo maestro cuando cambio de codigo y/o de cepa}
        seek (mae1, filepos(mae1)-1);
        write(mae1, regm);
    end;
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
    reg: censo;  {registro del tipo que se guarda en detalle}
    espacio: char;
begin
    reset(carga);
    rewrite(det);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod_loc, alfabetizadas, encuestadas, espacio, nom);
        end;
        write(det, reg);
    end;
    close(det);
    close(carga);
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: info;
    espacio: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, alfabetizadas, encuestadas, espacio, nom);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

procedure exportar_a_txt(var arch_binario : maestro; var arch_texto: text);
var
    reg: info;
begin
    reset(arch_binario);
    rewrite(arch_texto);
    writeln('Archivo de texto creado en: ', MAESTRO_TXT);
    while(not eof(arch_binario))do begin
        read(arch_binario, reg);
        with reg do
        begin
            writeln( arch_texto, alfabetizadas,' ', encuestadas,' ', nom);
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
    writeln('Programa de alfabetizacion en la Argentina: ');
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
