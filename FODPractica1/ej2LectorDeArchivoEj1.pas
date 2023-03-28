program ej2LectorDeArchivoEj1;
{ej2: Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.

nombre de archivo a leer: ej1archint
}
const
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\FODPractica1\archivosFOD\';
type
    archivo = file of integer; {definición del tipo de dato para el archivo }
var
    arc_logico: archivo;
    nro: integer;   { para leer elemento del archivo}
    suma, cantNros: integer;    {para calcular el promedio}
    menoresA1500: integer;
    arc_fisico: string[12]; {utilizada para obtener el nombre físico del archivo desde teclado}

begin
    suma:=0;
    cantNros:=0;
    menoresA1500:=0;

    writeln( '-lector de archivo de enteros generado en ej1.-' );
    write( 'Ingrese el nombre del archivo: ' );
    readln( arc_fisico ); {nombre del archivo}
    writeln( 'Numeros encontrados en el archivo: ' );
    assign( arc_logico, DIREC+arc_fisico );
    reset( arc_logico ); {archivo ya creado, para operar debe abrirse como de lect/escr}
    while not eof( arc_logico ) do begin
        read( arc_logico, nro ); {se obtiene elemento desde archivo }
        write( nro, ' ' ); {se presenta cada valor en pantalla}
        suma:=suma+nro;
        inc(cantNros);
        if (nro < 1500) then
        begin
            inc(menoresA1500);
        end;
    end;
    close( arc_logico );
    writeln;
    writeln('El promedio de numeros ingresados es: ',(suma/cantNros):0:2 );
    writeln('Cant de numeros menores a 1500: ',menoresA1500);

    writeln();
    writeln('-Programa finalizado.-');
    readln();
end.
