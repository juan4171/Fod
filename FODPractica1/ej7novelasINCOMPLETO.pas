program ej7novelas;
{ej7. Realizar un programa que permita:
a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”
b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.
NOTA: La información en el archivo de texto consiste en: código de novela, nombre,
género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.

WARNING: nombre de archivo a crear y abrir: novelas

}
const
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\FODPractica1\archivosFOD\';       {direccion de donde se van a cargar y guardar los archivos}
    NOVELASTXT = 'C:\Users\juan8\Desktop\FOD2023\FODPractica1\archivosFOD\novelas.txt';

type
    novela = record
        codigo: integer;
        precio: double;
        nombre: string[70];
        genero: string[70];
    End;
    archivoNovelas = file of novela;

{WARNING: esto no lo pide el ejercicio}
procedure imprimir(var arch : archivoNovelas);
var
    reg : novela;
begin
    writeln('Lista de novelas en el archivo binario:');
    reset(arch);
    while(not eof(arch)) do begin
        read(arch,reg);
        with reg do
        writeln('- Codigo de nov: ',codigo,
        ' / Nombre: ',nombre,
        ' / Genero: ',genero,
        ' / precio: ',precio:0:2,
        ' -');
        end;
    close(arch);
end;

{opcion 1: crear archivo}
procedure cargarNovelas(var novelas : archivoNovelas);
var
    carga :text;
    nov:Novela;
    blanco:char; {lo uso para eliminar el " " que queda cuando se lee un string de un txt}
begin
    assign( carga, NOVELASTXT );
    reset(carga);
    while (not EOF(carga) ) do
    begin
        readln(carga, nov.codigo, nov.precio, blanco, nov.genero);
        readln(carga, nov.nombre);
        write(novelas , nov);
    end;
    close(carga);
end;
procedure crearArchivo(var novelas : archivoNovelas);
var
    arc_fisico: string[70]; {utilizada para obtener el nombre físico del archivo desde teclado}
begin
    write( 'Ingrese el nombre del archivo: ' );
    readln( arc_fisico );
    assign( novelas, DIREC+arc_fisico );
    rewrite( novelas );
    cargarNovelas(novelas);
    close(novelas);
    writeln( 'Archivo ',arc_fisico,' creado en: ',DIREC+arc_fisico);
end;


procedure dibujarMenuMain();
begin
    writeln('----');
    writeln('Programa de novelas, elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. Crear archivo binario de novelas, cargandolo desde "novelas.txt".');
    writeln('2. Abrir el archivo binario y permitir la actualizacion del mismo.');
    writeln('9. Listar celulares.'); {WARNING: esto no lo pide el ejercicio}
    writeln('0. Salir');
    writeln('----');
end;

procedure dibujarMenu2();
begin
    writeln('----');
    writeln('Actualizar novelas, elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. Agregar una novela al archivo binario generado en la opcion 1 del menu anterior.');
    writeln('2. Modificar una novela existente en el archivo binario generado en la opcion 1 del menu anterior.');
    writeln('0. Salir');
    writeln('----');
end;

var
    novelas: archivoNovelas;
    opcionMain, opcionMenu2: integer;
begin
    repeat
        dibujarMenuMain();
        readln(opcionMain);
        case opcionMain of
            1: CrearArchivo(novelas);
            2:
            begin
                repeat
                    dibujarMenu2();
                    readln(opcionMenu2);

                until opcionMenu2 = 0;
            end;
            9: imprimir(novelas);  {WARNING: esto no lo pide el ejercicio}
        end;
    until opcionMain = 0;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
