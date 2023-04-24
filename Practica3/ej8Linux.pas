program ej8Linux;
{ej8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.
AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.
BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”
}

const
    VALORALTO = '9999';
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica3\archivosFOD\ej8\';
    MAESTRO_BINARIO = DIREC+'maestro';
    MAESTRO_TXT = DIREC+'maestro.txt';            {* no lo pide el ej}
type
    distribucion = record
        nom: string[50];    {El nombre de las distribuciones no puede repetirse}
        ano: integer;
        nro_version: integer;
        cant_d: integer;
        desc: string[50];
    end;
    maestro = file of distribucion;

procedure leer(var archivo: maestro; var dato: distribucion);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.nom := valoralto;
end;

function ExisteDistribucion(var mae1: maestro; nombre_a_buscar: String[50]) : Boolean;
var
    regm: distribucion;
begin
    Reset(mae1);
    leer(mae1, regm);
    while((regm.nom <> VALORALTO) and (regm.nom <> nombre_a_buscar)) do {no asumo que si o si encuentre}
        leer(mae1, regm);
    close(mae1);
    ExisteDistribucion:= (regm.nom = nombre_a_buscar);
end;

procedure BajaDistribucion(var archivo: maestro);    {podria llamarse baja logica}
var
    reg, cabecera: distribucion;
    nombre_a_borrar: String[50];
    pos_borrado: integer;
begin   
    writeln('Ingrese nombre de la distribucion a borrar del archivo: ');
    readln(nombre_a_borrar);
    if ExisteDistribucion(archivo, nombre_a_borrar) then
    begin
        reset(archivo);
        leer(archivo, cabecera);
        leer(archivo, reg);
        while (reg.nom <> nombre_a_borrar) do  {porque ya se que existe}
        begin
            leer(archivo, reg);
        end;
        pos_borrado:= filepos(archivo)-1;   {guardo la posicion borrada}
        seek(archivo, filepos(archivo)-1 );  {borro sobre escribiendo con lo que estaba en cabecera}      
        write(archivo, cabecera);   {borro sobre escribiendo con lo que estaba en cabecera}
        seek(archivo, 0 );
        cabecera.cant_d:= pos_borrado * -1; {-(pos_borrado)}
        write(archivo, cabecera); {reutilizo la variable cabecera y le pongo la pos libre (negativa)}           
        writeln('Distribucion ', nombre_a_borrar ,' marcada como eliminada exitosamente.');
        close(archivo);
    end
    else
        writeln('El nombre de distribucion ingresado no existe en el archivo, intente nuevamente.');
end;


procedure leer_distribucion(var reg: distribucion);
begin
    writeln('Nueva distribucion: ');
    writeln('Ingrese nombre:');
    readln(reg.nom);
    writeln('Ingrese ano de lanzamiento:');
    readln(reg.ano);
    writeln('Ingrese numero de version de kernel:');
    readln(reg.nro_version);
    writeln('Ingrese cantidad de desarrolladores:');
    readln(reg.cant_d);
    writeln('Ingrese descripcion:');
    readln(reg.desc);
end;

procedure AltaDistribucion(var archivo: maestro);
var
    reg, cabecera, reg_aux: distribucion;
begin   
    leer_distribucion(reg);
    if (not ExisteDistribucion(archivo, reg.nom)) then
    begin
        reset (archivo);
        leer(archivo, cabecera);
        if (cabecera.cant_d < 0) then
        begin
            seek(archivo,  (cabecera.cant_d * -1)); {-(cabecera.cod)}   {busco la pos libre}
            leer(archivo, reg_aux);     {guardo lo que hay en la pos libre,
             puede haber 0 u otro negativo}
            seek(archivo,  FilePos(archivo)-1);
            write(archivo, reg);    {escribo dato en la pos libre}
            seek(archivo,  0);
            write(archivo, reg_aux);   {lo que habia en la pos libre lo pongo en la cabecera}
        end
        else    {si no, agrego al final}
        begin
            seek(archivo, filesize(archivo) );         
            write(archivo, reg);            
        end;
        writeln(reg.nom,' agregado al archivo.');
        close(archivo);
    end
    else
        writeln('El nombre de distribucion ingresado no existe en el archivo, intente nuevamente.');
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: distribucion;
    espacio: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, ano, nro_version, cant_d, espacio, nom);
            readln(carga, desc);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

procedure imprimir(reg: distribucion);      {* no lo pide el ej}
begin
    with reg do
    begin
        writeln('- ano de lanzamiento: ',ano,' - version: ',nro_version,' - cant_d: ',cant_d,' - descripcion: ',desc,' - nombre: ',nom);
    end;
end;

procedure mostrarListaCompleta(var arc_logico: maestro);   {* no lo pide el ej}
var
    reg: distribucion;
begin
    reset(arc_logico);
    writeln('Lista completa de elementos en la lista:');
    while(not eof(arc_logico))do begin
        read(arc_logico, reg);
        imprimir(reg);
    end;
    writeln('Final de la Lista.');
    close(arc_logico);
end;

var
    mae1 : maestro;
    mae1_txt : text;    {* no lo pide el ej}
    opcion: char;
begin
    assign( mae1, MAESTRO_BINARIO); 
    assign( mae1_txt, MAESTRO_TXT);         {* no lo pide el ej}
    maestro_txt_a_binario(mae1_txt, mae1);     {* no lo pide el ej}
    mostrarListaCompleta(mae1);             {* no lo pide el ej}


    writeln('-Proceso de BAJA de distribuciones iniciado, ingrese "x" para cancelar, cualquier tecla para continuar-');
    readln(opcion);
    while (opcion <> 'x') do
    begin
        BajaDistribucion(mae1);
        mostrarListaCompleta(mae1);     {* no lo pide el ej}
        writeln('-Proceso de BAJA de distribuciones iniciado, ingrese "x" para cancelar, cualquier tecla para continuar-');
        readln(opcion);
    end;
    writeln('-Proceso de ALTA de distribuciones iniciado, ingrese "x" para cancelar, cualquier tecla para continuar-');
    readln(opcion);
    while (opcion <> 'x') do
    begin
        AltaDistribucion(mae1);
        mostrarListaCompleta(mae1);     {* no lo pide el ej}
        writeln('-Proceso de ALTA de distribuciones iniciado, ingrese "x" para cancelar, cualquier tecla para continuar-');
        readln(opcion);
    end;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
