program ej4y5Flores;
{ej4
lista invertida = LIFO
}
const
    VALORALTO = 9999;
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica3\archivosFOD\ej4\';
    FLORESTXT = DIREC+'flores.txt';
    FLORESBINARIO = DIREC+'flores';
type
    reg_flor = record
        nombre: String[45];
        codigo:integer; 
    end;
    tArchFlores = file of reg_flor;

procedure crearArchivo(var arc_logico : tArchFlores);
var
    reg: reg_flor;
begin
    rewrite( arc_logico );
    reg.codigo:=0;
    write(arc_logico, reg );
    close(arc_logico);
    writeln( 'Archivo creado en: ',FLORESBINARIO);
end;

procedure leer(var archivo: tArchFlores; var dato: reg_flor);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.codigo := VALORALTO;
end;

procedure agregarFlor (var archivo: tArchFlores ; nombre: string; codigo:integer);
var
    reg, cabecera, reg_aux: reg_flor;
begin
    reset(archivo); {se asume que el archivo fue creado}
    reg.nombre:=nombre;
    reg.codigo:=codigo;
    leer(archivo, cabecera);    {WARNING consultar si es lo mismo usar leer o read(archivo, cabecera)}
    if (cabecera.codigo < 0) then
    begin
        seek(archivo,  (cabecera.codigo * -1)); {-(cabecera.cod)}   {busco la pos libre}
        leer(archivo, reg_aux);     {guardo lo que hay en la pos libre}
        seek(archivo,  FilePos(archivo)-1);
        write(archivo, reg);    {escribo dato en la pos libre}
        seek(archivo,  0);
        write(archivo, reg_aux);    {lo que habia en la pos libre lo pongo 
        en la cabecera, puede ser un nro negativo o 0}
    end
    else    {si no, agrego al final}
    begin
        seek(archivo, filesize(archivo) );         
        write(archivo, reg);            
    end;
    writeln(reg.nombre,' codigo: ',reg.codigo,' agregada al archivo.');
    close(archivo);
end;

procedure exportar_a_txt(var arch_binario : tArchFlores; var arch_texto: text);
var
    reg: reg_flor;
begin
    reset(arch_binario);
    rewrite(arch_texto);
    writeln('Archivo de texto creado en: ',FLORESTXT );
    while(not eof(arch_binario))do begin
        read(arch_binario, reg);
        if reg.codigo > 0 then
        begin
            with reg do
            begin
                writeln( arch_texto,'Codigo: ', codigo,' Nombre: ',nombre);
            end;
        end;
    end;
    close(arch_binario);
    close(arch_texto);
end;

procedure eliminarFlor(var archivo : tArchFlores; flor : reg_flor);
var
    reg, cabecera: reg_flor;
    pos_borrado: integer;
    encontre: boolean;
begin
    reset(archivo);
    leer(archivo, cabecera);
    leer(archivo, reg);
    encontre:=false;
    while ((reg.codigo <> VALORALTO) and (not encontre)) do
    begin
        if (reg.codigo = flor.codigo) and (reg.nombre = flor.nombre) then
        begin 
            pos_borrado:= filepos(archivo)-1;   {guardo la posicion borrada}
            seek(archivo, filepos(archivo)-1 );  {borro sobre escribiendo con lo que estaba en cabecera}      
            write(archivo, cabecera);   {borro sobre escribiendo con lo que estaba en cabecera}
            seek(archivo, 0 );
            cabecera.codigo:= pos_borrado * -1; {-(pos_borrado)}
            write(archivo, cabecera); {reutilizo la variable cabecera y le pongo la pos libre (negativa)}
            encontre:= true;
        end;
        leer(archivo, reg);
    end;
    if encontre then
        writeln(flor.nombre,' codigo: ',flor.codigo,' eliminada exitosamente.')
    else
    begin
        writeln(flor.nombre,' codigo: ',flor.codigo,' no enontrada, intente nuevamente.');
    end;
    close(archivo);
end;

var
    arc_logico: tArchFlores;
    listado_txt : Text;
    flor_a_eliminar2, flor_a_eliminar1: reg_flor;
begin
    assign( arc_logico, FLORESBINARIO); 
    assign( listado_txt, FLORESTXT);
    
    flor_a_eliminar1.nombre:='flor 2';
    flor_a_eliminar1.codigo:= 2;
    flor_a_eliminar2.nombre:='flor 4';
    flor_a_eliminar2.codigo:= 4;

    crearArchivo(arc_logico);
    agregarFlor(arc_logico, 'flor 1', 1);
    agregarFlor(arc_logico, 'flor 2', 2);
    agregarFlor(arc_logico, 'flor 3', 3);
    agregarFlor(arc_logico, 'flor 4', 4);
    agregarFlor(arc_logico, 'flor 5', 5);
    eliminarFlor(arc_logico, flor_a_eliminar1);
    eliminarFlor(arc_logico, flor_a_eliminar2);
    exportar_a_txt(arc_logico, listado_txt);

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
