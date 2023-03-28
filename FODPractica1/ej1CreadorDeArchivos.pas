program ej1CreadorDeArchivos;
{ej1: Realizar un algoritmo que cree un archivo de n�meros enteros no ordenados y permita
incorporar datos al archivo. Los n�meros son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el n�mero 30000, que no debe incorporarse al archivo.

nombre de archivo a generar: ej1archint;
}
const
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\FODPractica1\archivosFOD\';
type
    archivo = file of integer; {definici�n del tipo de dato para el archivo }
var
    arc_logico: archivo; {define el nombre l�gico del archivo}
    nro: integer; {utilizada para obtener la informaci�n de teclado}
    arc_fisico: string[12]; {utilizada para obtener el nombre f�sico del archivo desde teclado}

begin
    writeln( '-Generador de archivo de numeros.-' );
    write( 'Ingrese el nombre del archivo: ' );
    readln( arc_fisico ); {nombre del archivo}
    assign( arc_logico, DIREC+arc_fisico );
    rewrite( arc_logico ); { se crea el archivo }
    writeln( 'Comienza carga de numeros al archivo, al ingresar el numero 30000 terminara la carga.' );
    write( 'Ingrese numero al archivo: ' );
    readln( nro ); { se obtiene de teclado el primer valor }
    while nro <> 30000 do begin
        write( arc_logico, nro );
        write( 'Ingrese numero al archivo: ' );
        readln( nro );
    end;
    close( arc_logico ); { se cierra el archivo abierto oportunamente con la instrucci�n rewrite }

    writeln();
    writeln('-Programa finalizado.-');
    readln();
end.
