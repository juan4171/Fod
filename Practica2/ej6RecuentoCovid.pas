program ej6RecuentoCovid;
{ej6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
covid para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
nuevos, cantidad recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).

WARNING: marque con * las cosas que si tuviera directamente desde un principio los archivos binarios
no necesitaria, pero como tengo que crear los archivos primero en txt y despues pasarlos
a binario, las uso.
}
const
    CANT_DETALLES = 3;      {3 para no usar 10}
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej6\';
    MAESTRO_TXT = DIREC+'informe_ministerio.txt';
    MAESTRO_BINARIO = DIREC+'informe_ministerio';
    DETALLE_BINARIO = DIREC+'informe_municipio';

type
    ministerio = record
        cod: integer;
        cepa: integer;
        nom_localidad: string[50];
        nom_cepa: string[50];
        casos_activos: integer;
        casos_nuevos: integer;
        casos_recuperados: integer;
        casos_fallecidos: integer;
    end;
    municipio = record
        cod: integer;
        cepa: integer;
        casos_activos: integer;
        casos_nuevos: integer;
        casos_recuperados: integer;
        casos_fallecidos: integer;
    end;

    maestro = file of ministerio;
    detalle = file of municipio;

    arc_detalle = array[1..CANT_DETALLES] of detalle;    {archivos detalle}
    reg_detalle = array[1..CANT_DETALLES] of municipio;

    arc_detalle_txt = array[1..CANT_DETALLES] of text;
    {archivos detalle txt que uso porque, como no tengo los detalles en binario,
    uso este arreglo para pasarlos de txt a binario}


procedure leer(var archivo: detalle; var dato: municipio);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := VALORALTO;
end;

procedure leerMaestro (var archivo: maestro; var dato: ministerio);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := VALORALTO;
end;

procedure minimo (var reg_det: reg_detalle; var min: municipio; var deta: arc_detalle);
var
    i, i_del_minimo: integer;
begin
    min:= reg_det[1];
    i_del_minimo:=1;
    for i:= 2 to CANT_DETALLES do
    begin
        if ( (reg_det[i].cod < min.cod) or ((reg_det[i].cod = min.cod) and (reg_det[i].cepa < min.cepa)) ) then
        begin
            min:=reg_det[i];
            i_del_minimo:=i;
        end
    end;
    leer( deta[i_del_minimo], reg_det[i_del_minimo] );
end;

procedure informar(var mae1: maestro);
var
    reg_actual, reg_aux: ministerio;
    total: integer;
begin
    writeln('Lista de localidades con mas de 50 casos activos: ');
    reset(mae1);
    leerMaestro(mae1, reg_actual);
    while (reg_actual.cod <> VALORALTO) do
    begin
        total:=0;
        reg_aux:= reg_actual;
        while (reg_actual.cod = reg_aux.cod) do begin
            total:= total + reg_actual.casos_activos;
            leerMaestro(mae1, reg_actual);
        end;
        if (total > 50) then
            writeln('la localidad: ',reg_aux.cod,' nombre: ', reg_aux.nom_localidad,' tiene mas de 50 casos activos.');
    end;
    close(mae1);
    writeln('Fin del listado.');
end;

procedure actualizar(var mae1: maestro; var deta: arc_detalle);
var
    i: integer;
    min: municipio;
    regm: ministerio;
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
    while (min.cod <> VALORALTO) do
    begin
        while ((regm.cod <> min.cod ) or (min.cepa <> regm.cepa)) do
            read(mae1,regm);
        {re mindfuck este while pero basicamente se tienen que cumplir las 2 condiciones para salir,
        osea si el codigo y la cepa son iguales salgo del while}
        {las localidades pueden tener 1 o mas cepas}
        {no va un if porque SI O SI voy a encontrar un registro maestro para el registro del detalle}
        regm.casos_activos := min.casos_activos;
        regm.casos_nuevos := min.casos_nuevos;
        regm.casos_fallecidos := regm.casos_fallecidos + min.casos_fallecidos;
        regm.casos_recuperados := regm.casos_recuperados + min.casos_recuperados;
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

procedure exportar_a_txt(var arch_binario : maestro; var arch_texto: text);
var
    reg: ministerio;
begin
    reset(arch_binario);
    rewrite(arch_texto);
    writeln('Archivo de texto creado en: ', MAESTRO_TXT);
    while(not eof(arch_binario))do begin
        read(arch_binario, reg);
        with reg do
        begin
            writeln( arch_texto, cod,' ', cepa,' ', nom_localidad);
            writeln( arch_texto, casos_activos,' ', casos_nuevos,' ', casos_recuperados,' ', casos_fallecidos,' ', nom_cepa);
        end;
    end;
    close(arch_binario);
    close(arch_texto);
end;

procedure detalle_txt_a_binario(var carga: text; var det: detalle);
var
    reg: municipio;  {registro del tipo que se guarda en detalle}
begin
    reset(carga);
    rewrite(det);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod, cepa, casos_activos, casos_nuevos, casos_recuperados, casos_fallecidos);
        end;
        write(det, reg);
    end;
    close(det);
    close(carga);
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: ministerio;
    espacio: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod, cepa, espacio, nom_localidad);
            readln(carga, casos_activos, casos_nuevos, casos_recuperados, casos_fallecidos, espacio, nom_cepa);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;


var
    mae1 : maestro;
    mae1_txt : text;
    vector_det_binarios : arc_detalle;
    vector_det_txt : arc_detalle_txt;
    {creo un vector de detalles txt para poder ir pasandolos todos al vector de detalles binarios,
        el ejercicio no lo pide pero para comprobar que funciona lo hago,
        si ya tuviera creados los binarios no necesitaria la linea anterior}
    i: integer;
    indice_str : string[2];
begin
    writeln('----');
    writeln('Programa ministerio de salud covid: ');
    writeln('----');
    {-------------Archivos del maestro binario y txt-------------}
    assign(mae1, MAESTRO_BINARIO);
    assign(mae1_txt, MAESTRO_TXT);   {*}
    {-------------Creacion de los detalles binarios--------------}
    {-----------------------------Y------------------------------}
    {-------------Creacion del vector de detalles----------------}
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
    maestro_txt_a_binario(mae1_txt, mae1);   {*}
    informar(mae1); {informo antes y despues de actualizar, no lo pide el ej}
    actualizar(mae1, vector_det_binarios);
    informar(mae1);
    exportar_a_txt(mae1, mae1_txt);          {*}
    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
