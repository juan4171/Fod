program ej2Alumnos;
{ej2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.

WARNING: nombre de archivo a crear y abrir:

COMO HICE ESTE EJERCICIO: fue medio confuso como hacerlo pero en resumen: decidi primero pasar
el archivo de alumnos (el maestro) de texto a binario para poder editar sus datos, no pase a binario
el detalle porque de ahi solo leo. se me hizo medio confuso donde poner los assing, lo voy a consultar
en clase porque en ese punto en especifico, no veo por que usar assing en el pprincipal.
la ventaja de hacer los assign en pprincipal es que puedo mandar los archivos por ref a los procesos y
ahi son modificados y puedo usarlos en otros procesos.

probablemente en un futuro lo corrija y tambien revise y unifique los nombres de las variables
}
const
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej2\';
    ALUMNOSTXT = DIREC+'alumnos.txt';
    ALUMNOSBINARIO = DIREC+'alumnos';
    MATERIASTXT= DIREC+'materias.txt';
    ALUMNOSDEBEN4FINALES = DIREC+'alumnos_deben_4_finales.txt';

    VALORALTO = 9999;

type
    alumno = record
        cod: integer;
        nomYAp: string[50];
        materiasAprobadasSinFinal: integer;
        materiasAprobadasConFinal: integer;
    end;
    materiaAprobada = record
        cod: integer;
        finalAprobado: char;  {A o D}
    end;

    maestro = file of alumno;
    {detalle = file of materiaAprobada; no lo uso porque lo manejo directamente en txt}



{paso el maestro de txt a binario para poder trabajar mejor con el,
considero que no es necesario hacer un detalleTxtABinario()
porque solo leo los detalles y eso puedo hacerlo con el mismo txt}
procedure maestroTxtABinario(var archivo_alumnos: text; var maes: maestro);
var
    a: alumno;
    blanco: char;
begin
    reset(archivo_alumnos);
    assign (maes, ALUMNOSBINARIO );
    rewrite(maes);
    while(not EOF(archivo_alumnos))do begin
        with a do readln(archivo_alumnos, cod, materiasAprobadasSinFinal,
                         materiasAprobadasConFinal, blanco, nomYAp);
        write(maes, a);
    end;
    close(archivo_alumnos);
    close(maes);
end;

procedure leer (var archivo : text; var dato : materiaAprobada);
begin
    if (not(EOF(archivo))) then
    begin
        readln(archivo, dato.cod);
        readln(archivo, dato.finalAprobado);
    end
    else
    begin
        dato.cod := VALORALTO;
    end;
end;

procedure sobreEscribirMaestroTxt(var mae1: maestro);
var
    a: alumno;
    archivo_alumnos: text;
begin
    reset(mae1);
    assign (archivo_alumnos, ALUMNOSTXT ); {sobre escribo porque el ej dice ACTUALIZAR maestro}
    rewrite(archivo_alumnos); {sobre escribo porque el ej dice ACTUALIZAR maestro}
    while(not EOF(mae1))do
    begin
        read(mae1, a);
        with a do writeln(archivo_alumnos, cod, ' ', materiasAprobadasSinFinal, ' ',
                          materiasAprobadasConFinal, ' ', nomYAp);
    end;
    close(mae1);
    close(archivo_alumnos);
end;

procedure actualizarMaestro(var archivo_alumnostxt:text; var archivo_materiastxt:text);   {alumnostxt = maestro, materiastxt = detalle}
var
    mae1 : maestro;
    regm : alumno;
    regd : materiaAprobada;
begin
    assign (archivo_materiastxt, MATERIASTXT );
    assign (archivo_alumnostxt, ALUMNOSTXT );
    maestroTxtABinario(archivo_alumnostxt, mae1);   {paso el maestro de txt a binario para trabajar mejor con el}
    reset (mae1);
    reset (archivo_materiastxt);
    leer(archivo_materiastxt, regd);
    while (regd.cod <> valoralto) do
    begin
        {leo alumnos hasta encontrar uno con codigo igual al que lei en el detalle (seguro voy a encontrar)}
        read(mae1, regm);
        while (regm.cod <> regd.cod) do
        begin
            read(mae1, regm);
        end;
        { se procesan códigos iguales }
        while (regm.cod = regd.cod) do
        begin
            if (regd.finalAprobado = 'A') then
                regm.materiasAprobadasConFinal:= regm.materiasAprobadasConFinal + 1
            else
                regm.materiasAprobadasSinFinal:= regm.materiasAprobadasSinFinal + 1;
            {voy sumando en el mismo regm porque no considero necesario en este caso usar totales}
            leer(archivo_materiastxt, regd);
        end;
        {reubica el puntero}
        seek (mae1, filepos(mae1)-1);
        write(mae1,regm);
    end;
    close(mae1);
    close(archivo_materiastxt);
    sobreEscribirMaestroTxt(mae1);  {sobre escribo porque el ej dice ACTUALIZAR maestro}
end;

{b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias}
procedure crearTxtAlumnos4Finales(var archivo_alumnostxt:text);   {alumnostxt = maestro, materiastxt = detalle}
var
    regm : alumno;
    deben4Finales: text;
    blanco : char;
begin
    assign (archivo_alumnostxt, ALUMNOSTXT );
    reset(archivo_alumnostxt);
    assign (deben4Finales, ALUMNOSDEBEN4FINALES );
    rewrite(deben4Finales);
    with regm do 
    begin
        while(not EOF(archivo_alumnostxt))do
        begin
            readln(archivo_alumnostxt, cod, materiasAprobadasSinFinal, materiasAprobadasConFinal, blanco, nomYAp);
            if (materiasAprobadasSinFinal > 4)then
                writeln(deben4Finales, cod, ' ', materiasAprobadasSinFinal, ' ',materiasAprobadasConFinal, ' ', nomYAp);
        end;
    end;
    close(deben4Finales);
    close(archivo_alumnostxt);
end;


procedure dibujarMenu();
begin
    writeln('----');
    writeln('Programa alumnos, elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. Actualizar el archivo maestro con archivo detalle');
    writeln('2. Crear archivo .txt con alumnos que tengan más de cuatro materias con cursada aprobada pero no aprobaron el final.');
    writeln('0. Salir');
    writeln('----');
end;

var
    materias, alumnos : text;
    opcion: integer;
begin
    repeat
        dibujarMenu();
        readln(opcion);
        case opcion of
            1: actualizarMaestro(alumnos, materias);
            2: crearTxtAlumnos4Finales(alumnos);
        end;
    until opcion = 0;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
