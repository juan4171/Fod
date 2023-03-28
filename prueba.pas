program ejemplo;
const
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\FODPractica1\archivosFOD\';

var
  entrada, salida: text;
  linea: string;
  cantidad : integer;
  i:integer;

begin
    assign(entrada, direc+'saludo.txt');
    assign(salida, direc+'saludo2.txt');

    reset(entrada);
    rewrite(salida);

    cantidad := filesize(entrada);
    if cantidad = 0 then
        writeln('No hay datos')
    else
        for i := 1 to cantidad do
        begin
            readln(entrada, linea);
            writeln(salida, linea);
            writeln(linea);
        end;

    close(salida);
    close(entrada);
    writeln('Volcado terminado');
    readln();
end.
