program ej7Aves;
{ej7. Se cuenta con un archivo que almacena informaci�n sobre especies de aves en
v�a de extinci�n, para ello se almacena: c�digo, nombre de la especie, familia de ave,
descripci�n y zona geogr�fica. El archivo no est� ordenado por ning�n criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deber� realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deber�
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deber� copiar el �ltimo registro del archivo en la posici�n del registro
a borrar y luego eliminar del archivo el �ltimo registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el c�digo 500000

* hay algunos metodos que no pide el ej pero yo los uso para generar los archivos
binarios necesarios, creandolos desde archivos .txt con el objetivo de poder probar el program

}

const
    VALORALTO = 9999;
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica3\archivosFOD\ej7\';
    MAESTRO_BINARIO = DIREC+'maestro';
    MAESTRO_TXT = DIREC+'maestro.txt';            {* no lo pide el ej}
type
    ave = record
        cod: integer;
        fam: integer;
        zona: integer;
        nom: string[50];
        desc: string[50];
    end;
    maestro = file of ave;

procedure leer(var archivo: maestro; var dato: ave);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := valoralto;
end;

procedure actualizar(var mae1: maestro);{WARNING VER SI LO PUEDO HACER CON LEER}
var
    regm: ave;
    c: integer;
    encontre: boolean;
begin
    reset (mae1);
    writeln('Comienza el borrado de aves del archivo:');
    writeln('Ingrese el codigo de ave que quiera eliminar del archivo (500.000 para terminar):');
    readln(c);
    while (c <> 500000) do
    begin
        encontre:=false;
        while((not eof(mae1)) and (not encontre)) do {no asumo que si o si encuentre}
        begin
            read(mae1, regm);
            if (regm.cod = c) then
            begin
                regm.cod:= -(regm.cod);
                seek (mae1, filepos(mae1)-1);
                write(mae1, regm); 
                writeln('Ave codigo ', c ,' marcada como eliminada exitosamente.'); 
                encontre:=true;
            end; 
        end;      
        if (encontre = false) then 
        begin
            writeln('El codigo de ave ingresado no existe en el archivo, intente nuevamente.');
        end; 
        writeln('Ingrese el codigo de ave que quiera eliminar del archivo (500.000 para terminar):');
        readln(c);
        seek (mae1, 0);
    end;
    writeln('Fin de marcado de aves para borrar.');
end;

procedure borrarAves(var archivo : maestro);    {compactar}
var
    pos_de_reemplazo: integer;
    reg, ultimo: ave;
begin
    reset(archivo);
    leer(archivo, reg);
    while (reg.cod <> VALORALTO) do
    begin
        if (reg.cod < 0) then
        begin
            if (filepos(archivo)-1 = filesize(archivo)-1) then {si soy el ultimo o si soy el unico}
            begin
                seek(archivo, filepos(archivo)-1 );
                truncate(archivo);
            end
            else
            begin
                pos_de_reemplazo:= filepos(archivo)-1;  {guardo la pos donde esta lo que voy a sobre escribir}
                seek(archivo, filesize(archivo)-1 );
                read(archivo, ultimo); {guardo el ultimo}

                while ((ultimo.cod < 0) and (pos_de_reemplazo <> filepos(archivo)-1)) do begin
                    seek(archivo, filesize(archivo)-1 );
                    Truncate (archivo);
                    writeln('Se borro avex y el archivo quedo con ',filesize(archivo),' posiciones');
                    seek(archivo, filesize(archivo)-1 );
                    read(archivo, ultimo);
                end;

                seek(archivo, filesize(archivo)-1 );
                Truncate (archivo);    {trunco el archivo en donde se encuentra el puntero}
                seek(archivo, pos_de_reemplazo);
                write(archivo, ultimo);    {pongo el ultimo en el que voy a borrar}
            end;
            
            writeln('Se borro ave y el archivo quedo con ',filesize(archivo),' posiciones');
        end;
        writeln('TODO BIEN', reg.cod);
        writeln('TODO BIEN', filepos(archivo));
        leer(archivo, reg);
        writeln('TODO BIEN', reg.cod);
        writeln('TODO BIEN', filepos(archivo));
    end;
    close(archivo);
end;

{* no lo pide el ej}
procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: ave;
    espacio: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, cod, zona, fam, espacio, nom);
            readln(carga, desc);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

procedure imprimir(reg: ave);
begin
    with reg do
    begin
        writeln('- ave cod: ',cod,' - zona: ', zona,' - familia: ',fam,' - nombre: ',nom,' - descripcion: ',desc);
    end;
end;

procedure mostrarListaCompleta(var arc_logico: maestro);
var
    reg: ave;
begin
    reset(arc_logico);
    writeln('Lista completa de elementos en la lista:');
    while(not eof(arc_logico))do begin
        read(arc_logico, reg);
        imprimir(reg);
    end;
    writeln('Final de la Lista.');
    close(arc_logico);
end;

var
    mae1 : maestro;
    mae1_txt : text;    {* no lo pide el ej}
begin
    assign( mae1, MAESTRO_BINARIO); 

    assign( mae1_txt, MAESTRO_TXT);     {* no lo pide el ej}
    maestro_txt_a_binario(mae1_txt, mae1);     {* no lo pide el ej}

    mostrarListaCompleta(mae1);     {* no lo pide el ej}

    actualizar(mae1);
    mostrarListaCompleta(mae1);     {* no lo pide el ej}
    borrarAves(mae1); {compactar}

    mostrarListaCompleta(mae1);     {* no lo pide el ej}

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
