program ej3empleadosMenu;
{ej3: Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario

nombre de archivo a crear y abrir: archemple
}
const
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\FODPractica1\archivosFOD\';
type
    empleado = record
        apellido: string[20];
        nombre: string[20];
        nro_emp: integer;
        edad: integer;
        dni: integer
    End;
    archivoEmpleados = file of empleado;

procedure leerEmpleado(var emp: empleado);
begin
    writeln('Nuevo empleado (apellido = "fin" para terminar la carga):');
    writeln('Ingrese apellido:');
    readln(emp.apellido);
    if (emp.apellido <> 'fin')then
    begin
        writeln('Ingrese nombre:');
        readln(emp.nombre);
        writeln('Ingrese numero de empleado:');
        readln(emp.nro_emp);
        writeln('Ingrese edad:');
        readln(emp.edad);
        writeln('Ingrese dni:');
        readln(emp.dni);
    end;
end;

procedure crearArchivo(var arc_logico : archivoEmpleados);
var
    arc_fisico: string[12]; {utilizada para obtener el nombre físico del archivo desde teclado}
    emp:empleado;
begin
    write( 'Ingrese el nombre del archivo: ' );
    readln(arc_fisico);
    assign( arc_logico, DIREC+arc_fisico );
    rewrite( arc_logico ); { se crea el archivo }
    writeln( 'Comienza la carga de empleados al archivo: ' );
    leerEmpleado(emp);
    while emp.apellido <> 'fin' do
    begin
        write( arc_logico, emp );
        leerEmpleado(emp);
    end;
    close(arc_logico);
    writeln( 'Archivo ',arc_fisico,' creado.' );
end;

procedure cargarArchivo(var arc_logico : archivoEmpleados);  {TODO consultar si este procedure esta bien, no hace falta close en el assign?}
var
    arc_fisico: string[12];
begin
    write( 'Ingrese el nombre del archivo: ' );
    readln( arc_fisico ); {nombre del archivo}
    assign( arc_logico, DIREC+arc_fisico );
    writeln( 'Archivo ',arc_fisico,' cargado para operar.' );
end;

procedure imprimirEmpleado(emp: empleado);
begin
    writeln('Nombre y apellido: ',emp.nombre,' ',emp.apellido,' - Nro de empleado: ',
    emp.nro_emp,' - edad: ',emp.edad,' - DNI: ',emp.dni);
end;

procedure mostrarListaCompleta(var arc_logico: archivoEmpleados);
var
    emp: empleado;
begin
    reset(arc_logico);
    writeln('Lista completa de empleados:');
    while(not eof(arc_logico))do begin
        read(arc_logico, emp);
        imprimirEmpleado(emp);
    end;
    close(arc_logico);
end;

procedure mostrarMayores(var arc_logico: archivoEmpleados);
var
    emp: empleado;
begin
    reset(arc_logico);
    writeln('Empleados proximos a jubilarse mayores de 70 anyos:');
    while(not eof(arc_logico))do begin
        read(arc_logico, emp);
        if(emp.edad > 70)then
            imprimirEmpleado(emp);
    end;
    close(arc_logico);
end;

procedure mostrarDeterminado(var arc_logico: archivoEmpleados);
var
    nombre, apellido: string[20];
    emp: empleado;
begin
    reset(arc_logico);
    writeln('Ingrese un nombre determinado:');
    readln(nombre);
    writeln('Ingrese un apellido determinado:');
    readln(apellido);
    writeln('Empleados con nombre ',nombre,' o apellido ',apellido,':');
    while(not eof(arc_logico))do begin
        read(arc_logico, emp);
        if((emp.nombre = nombre) or (emp.apellido = apellido))then
            imprimirEmpleado(emp);
    end;
    close(arc_logico);
end;

procedure dibujarMenuMain();
begin
    writeln('----');
    writeln('Programa de empleados, elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. Crear archivo de empleados');
    writeln('2. Cargar un archivo de empleados anteriormente generado');
    writeln('0. Salir');
    writeln('----');
end;
procedure dibujarMenu2();
begin
    writeln('----');
    writeln('elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. empleados con un nombre o apellido particular');
    writeln('2. lista completa de empleados');
    writeln('3. lista de empleados proximos a jubilarse');
    writeln('0. Volver');
    writeln('----');
end;

var
    arc_logico: archivoEmpleados;
    opcion_main, opcion_2: integer; {2 variables para 2 menus}
begin
    repeat
        dibujarMenuMain();
        readln(opcion_main);
        case opcion_main of
            1:begin
                crearArchivo(arc_logico);
            end;
            2:begin
                cargarArchivo(arc_logico); {TODO hago este procedure para poder abrir archivos ya hechos ingresando su nombre,
                 si quisiera podria borrarlo y usar solo el archivo generado en la opcion anterior del menu, todo funcionaria igual}
                repeat
                    dibujarMenu2();
                    readln(opcion_2);
                    case opcion_2 of
                        1: mostrarDeterminado(arc_logico);
                        2: mostrarListaCompleta(arc_logico);
                        3: mostrarMayores(arc_logico);
                    end;
                until opcion_2 = 0;
            end;
        end;
    until opcion_main = 0;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
