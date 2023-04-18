program ej1empleados;
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

WARNING: nombre de archivo a crear y abrir: archemple

ej4: Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).
b. Modificar edad a uno o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.

ej1: Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.

}
const
    VALORALTO = 9999;
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica3\archivosFOD\ej1\';
    TODOSEMPLEADOSTXT = 'C:\Users\juan8\Desktop\FOD2023\Practica3\archivosFOD\ej1\todos_empleados.txt';
    FALTADNITXT = 'C:\Users\juan8\Desktop\FOD2023\Practica3\archivosFOD\ej1\faltaDNIEmpleado.txt';
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
type
    empleado = record
        apellido: string[20];
        nombre: string[20];
        nro_emp: integer;
        edad: integer;
        dni: string[8]
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
        writeln('Ingrese dni (8 digitos, ingrese 00 si no se sabe el dni):');
        readln(emp.dni);
    end;
end;

procedure crearArchivo(var arc_logico : archivoEmpleados);
var
    arc_fisico: string[12]; {utilizada para obtener el nombre físico del archivo desde teclado}
    emp:empleado;
begin
    write( 'Ingrese el nombre del archivo: ' );
    readln( arc_fisico );
    assign( arc_logico, DIREC+arc_fisico );
    rewrite( arc_logico ); { se crea el archivo }
    writeln( 'Comienza la carga de empleados al archivo: ' );
    leerEmpleado(emp);
    while emp.apellido <> 'fin' do
    begin
        write( arc_logico, emp );
        writeln( 'Empleado nro: ',emp.nro_emp,' cargado exitosamente');
        leerEmpleado(emp);
    end;
    close(arc_logico);
    writeln( 'Archivo ',arc_fisico,' creado en: ',DIREC+arc_fisico );
end;

procedure exportarATxt(var arch_empleados : archivoEmpleados; imprimirSoloSinDni : boolean);
{con este unico procedure hago el punto que pide imprimir todos los empleados y el que pide solo los que tienen dni 00 }
var
    arch_texto: text;
    emp: empleado;
begin
    reset(arch_empleados);
    if (imprimirSoloSinDni) then
    begin
        assign(arch_texto, FALTADNITXT);
        writeln('Archivo de texto creado en: ', FALTADNITXT);
    end
    else
    begin
        assign(arch_texto, TODOSEMPLEADOSTXT);
        writeln('Archivo de texto creado en: ', TODOSEMPLEADOSTXT);
    end;
    rewrite(arch_texto);
    while(not eof(arch_empleados))do begin
        read(arch_empleados, emp);
        if (imprimirSoloSinDni) then
        begin
            if (emp.dni = '00') then
                writeln( arch_texto,'- Nro de emp: ',emp.nro_emp,' - Nombre y ap: ',emp.nombre,' ',emp.apellido,' - edad: ',emp.edad,' - DNI: ',emp.dni);
        end
        else
            writeln( arch_texto,'- Nro de emp: ',emp.nro_emp,' - Nombre y ap: ',emp.nombre,' ',emp.apellido,' - edad: ',emp.edad,' - DNI: ',emp.dni);
    end;
    close(arch_empleados);
    close(arch_texto);
end;

procedure cargarArchivo(var arc_logico : archivoEmpleados);  {WARNING: consultar si este procedure esta bien, no hace falta close en el assign?}
var
    arc_fisico: string[12];
begin
    write( 'Ingrese el nombre del archivo: ' );
    readln( arc_fisico ); {nombre del archivo}
    assign( arc_logico, DIREC+arc_fisico );
    writeln( 'Archivo ',DIREC+arc_fisico,' cargado para operar.' );
end;

procedure imprimirEmpleado(emp: empleado);
begin
    writeln('- Nro de emp: ',emp.nro_emp,' - Nombre y ap: ',emp.nombre,' ',emp.apellido,' - edad: ',emp.edad,' - DNI: ',emp.dni);
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

function controlDeUnicidad(var arc_logico : archivoEmpleados; nro_nuevo:integer) : boolean;
{recibo el archivo abierto y el numero a buscar si esta repetido}
var
    SeRepite : boolean;
    emp:empleado;
begin
    seRepite:=false;
    seek(arc_logico, 0);
    {seek desde el principio del archivo y mientras que no encuentre el EOF y mientras que no encuentre el repetido voy comparando}
    while( (not eof(arc_logico)) and (not SeRepite) )do begin
        read(arc_logico, emp);
        if emp.nro_emp = nro_nuevo then
            SeRepite:= true;
    end;
    controlDeUnicidad:= SeRepite;
end;

procedure agregarEmpleados(var arc_logico : archivoEmpleados); {WARNING: consultar si esta bien hecho
este punto especialmente como controlo que no esten repetidos los numeros ¿la instruccion seek es como un puntero?}
var
    emp:empleado;
begin
    reset( arc_logico );
    writeln( 'Comienza la carga de empleados al final del archivo: ' );
    leerEmpleado(emp);
    while emp.apellido <> 'fin' do   {inicio loop de carga porque puedo agregar 1 o mas empleados}
    begin
        if controlDeUnicidad(arc_logico, emp.nro_emp) then  {si el numero esta repetido then}
        begin
            writeln( 'Nro de empleado ',emp.nro_emp,' ya registrado no se puede cargar, intente nuevamente');
        end
        else
        begin
            seek(arc_logico, filesize(arc_logico)); {seek al final de archivo y escribo}
            write( arc_logico, emp );
            writeln( 'Empleado nro: ',emp.nro_emp,' cargado exitosamente');
        end;
        leerEmpleado(emp);
    end;
    close(arc_logico);
    writeln( 'Archivo actualizado.' );
end;

procedure dibujarMenuEdades();
begin
    writeln('----');
    writeln('Modificacion de edades, elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. Modificar edad');
    writeln('0. Salir');
    writeln('----');
end;

procedure modificarEdades(var arc_logico : archivoEmpleados);
var
    emp:empleado;
    nro_emp, opcion : integer;
    encontre:boolean;
begin
    reset( arc_logico );

    repeat
        dibujarMenuEdades();
        readln(opcion);
        if opcion= 1 then
        begin
            encontre:= false;
            write( 'Ingrese en numero de empleado a modificar edad: ' );
            readln(nro_emp);
            seek(arc_logico, 0);
            while( (not eof(arc_logico)) and (not encontre) )do begin
                read(arc_logico, emp);
                if emp.nro_emp = nro_emp then
                begin
                    encontre:= true;
                    writeln( 'Empleado encontrado: ');
                    imprimirEmpleado(emp);
                    write( 'Ingrese su nueva edad: ' );
                    readln(emp.edad);
                    seek(arc_logico, filepos(arc_logico) -1);
                    write(arc_logico, emp);
                    writeln( 'Edad actualizada de empleado: ');
                    imprimirEmpleado(emp);
                end;
            end;
            if not encontre then
                writeln('El numero de empleado ingresado ',nro_emp,' no corresponde con ningun empleado registrado en la base de datos.');
        end;
    until opcion = 0;
    close(arc_logico);
    writeln( 'Fin de modificacion de edades.' );
end;

procedure dibujarMenuMain();
begin
    writeln('----');
    writeln('Programa de empleados, elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. Crear archivo de empleados');
    writeln('2. Cargar un archivo de empleados y mostrar opciones');
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
    writeln('4. agregar uno o mas empleados al archivo');
    writeln('5. modificar edad a uno o mas empleados');
    writeln('6. Exportar todo el contenido del archivo a un archivo "todos_empleados.txt"');
    writeln('7. Exportar empleados DNI en 00 a un archivo "faltaDNIEmpleado.txt"');
    writeln('8. Borrar empleado dandolo de baja del archivo');
    writeln('0. Volver');
    writeln('----');
end;


procedure leer(var archivo: archivoEmpleados; var dato: empleado);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.nro_emp := VALORALTO;
end;

procedure borrarEmpleado(var archivo : archivoEmpleados);
var
    n, pos_n:integer;
    reg: empleado;
begin
    reset(archivo);
    writeln('Ingrese en nro del empleado a borrar: ');
    readln(n);
    leer(archivo, reg);
    while ((reg.nro_emp <> n) and (reg.nro_emp <> VALORALTO)) do
        leer(archivo, reg);
    if (reg.nro_emp = n) then
    begin
        writeln('Se encontro empleado con el numero ',n,' en la posicion ',filepos(archivo),
        ' del archivo que tiene ',filesize(archivo),' posiciones');
        pos_n:= filepos(archivo)-1;  {guardo la pos donde esta lo que voy a sobre escribir}
        seek(archivo, filesize(archivo)-1 );
        read(archivo, reg); {reuso reg para guardar el ultimo reg}
        seek(archivo, pos_n);
        write(archivo, reg);    {pongo el ultimo en el que voy a borrar}
        seek(archivo, filesize(archivo)-1 );
        Truncate (archivo);    {trunco el archivo en donde se encuentra el puntero}
        writeln('Se borro empleado y el archivo quedo con ',filesize(archivo),' posiciones');
    end
    else
        writeln('No se encontro empleado con el numero ',n);
    close(archivo);
end;

{WARNINGA: https://github.com/CapitanaBanana/Tercer-cuatri/blob/main/FOD/Clase_3/Ej_1/Ej_1.pas
ALTERNATIVA  que usa una variable que guarda el ultimo aunque igual no se haga el truncado,
no se cual es mejor alternativa es mejor}
{procedure baja();
var arch:archivo; e:empleado; eliminar:integer; ult:empleado;
begin
	write('Ingrese el codigo de empleado a eliminar: ');
	readln(eliminar);
	abrir_archivo(arch);
	seek(arch, filesize(arch)-1);
	read(arch, ult);//guardo el último dato
	seek(arch, 0);//me pongo en el primero
	if (not(eof(arch))) then
		read(arch,e);//leo el 1ro
	while (not(eof(arch)) and (e.num<>eliminar)) do
		read(arch,e);//avanzo
	if (e.num=eliminar) then
	begin
		seek(arch, filepos(arch)-1);//escribo el último en el que quiero borrar
		write(arch, ult);
		seek(arch, filesize(arch)-1);//me paro en el último, trunco
		truncate(arch);
	end
	else writeln('El empelado no existe');
	close(arch);
end;}

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
                cargarArchivo(arc_logico);
                repeat
                    dibujarMenu2();
                    readln(opcion_2);
                    case opcion_2 of
                        1: mostrarDeterminado(arc_logico);
                        2: mostrarListaCompleta(arc_logico);
                        3: mostrarMayores(arc_logico);
                        4: agregarEmpleados(arc_logico);
                        5: modificarEdades(arc_logico);
                        6: exportarATxt(arc_logico,false);
                        7: exportarATxt(arc_logico,true);
                        8: borrarEmpleado(arc_logico);
                    end;
                until opcion_2 = 0;
            end;
        end;
    until opcion_main = 0;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
