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
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej2\';
    ALUMNOSTXT = DIREC+'alumnos.txt';
    ALUMNOSBINARIO = DIREC+'alumnos';
    MATERIASTXT= DIREC+'materias.txt';

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
        end;
    until opcion = 0;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
