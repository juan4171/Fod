program ej3ProductosCreadorDeDetalles;
{ej3. este programa lo cree para pasar de txt a binario los detalles.txt que pide el ejercicio 3
este programa en lugar de ser un programa, podria ser un procedure del ej 3... no?...
}
const
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej3\';
    DIRECDETALLES = DIREC+'det';
    CANTDEDETALLES=3;
type
    informe = record
        cod: integer;
        cant_vendida: integer;
    end;
    detalle = file of informe;

procedure detalleTxtABinario(var carga: text; var archivo_informe: detalle);
var
    i: informe;
begin
    reset(carga);
    rewrite(archivo_informe);
    while(not eof(carga))do begin
        with i do readln(carga, cod, cant_vendida);
        write(archivo_informe, i);
    end;
    close(archivo_informe);
    close(carga);
end;

var
    dettxt:text;
    det:detalle;
    s: string[5];
    i: integer;
begin
    for i := 1 to CANTDEDETALLES do
    begin
        Str(i,s);
        assign (det, DIRECDETALLES+s);
        assign (dettxt, DIRECDETALLES+s+'.txt');
        detalletxtabinario(dettxt,det);
    end;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
