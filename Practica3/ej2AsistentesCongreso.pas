program ej2AsistentesCongreso;
{ej2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.


}
const
    VALORALTO = 9999;
    NROLIMITE = 1000;
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica3\archivosFOD\ej2\';
    ASISTENTES = DIREC+'asistentes';
type
    asistente = record
        nro: integer;
        nom: string[50];       
        email: string[50];
        dni: string[8];
        tel: string[8];
    End;
    archivoAsistentes = file of asistente;

procedure leerAsistente(var reg: asistente);
begin
    writeln('Nuevo asistente (nombre = "fin" para terminar la carga):');
    writeln('Ingrese nombre y apellido: ');
    readln(reg.nom);
    if (reg.nom <> 'fin')then
    begin
        writeln('Ingrese numero de asistente:');
        readln(reg.nro);
        writeln('Ingrese email:');
        readln(reg.email);
        writeln('Ingrese dni (8 digitos):');
        readln(reg.dni);
        writeln('Ingrese telefono (8 digitos):');
        readln(reg.tel);
    end;
end;

procedure crearArchivo(var arc_logico : archivoAsistentes);
var
    reg:asistente;
begin
    assign( arc_logico, ASISTENTES);
    rewrite( arc_logico );
    writeln( 'Comienza la carga de asistentes al archivo: ' );
    leerAsistente(reg);
    while reg.nom <> 'fin' do
    begin
        write( arc_logico, reg );
        writeln( 'Asistente nro: ',reg.nro,' cargado exitosamente');
        leerAsistente(reg);
    end;
    close(arc_logico);
    writeln( 'Archivo creado en: ',ASISTENTES);
end;

procedure imprimirReg(reg: asistente);   {no lo pide el ej}
begin
    writeln('- Nro de asistente: ',reg.nro,' - Nombre y ap: ',reg.nom,' - email: ',reg.email,' - DNI: ',reg.dni,' - telefono: ',reg.tel);
end;

procedure mostrarListaCompleta(var arc_logico: archivoAsistentes);    {no lo pide el ej}
var
    reg: asistente;
begin
    reset(arc_logico);
    writeln('Lista completa de asistentes:');
    while(not eof(arc_logico))do begin
        read(arc_logico, reg);
        if (reg.nom[1] <> '@') then
        begin
            imprimirReg(reg);
        end;       
    end;
    close(arc_logico);
end;

procedure leer(var archivo: archivoAsistentes; var dato: asistente);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.nro := VALORALTO;
end;

procedure borrarAsistentes(var archivo : archivoAsistentes);
var
    reg: asistente;
begin
    reset(archivo);
    leer(archivo, reg);
    while (reg.nro <> VALORALTO) do
    begin
        if (reg.nro < NROLIMITE) then
        begin
            writeln('ASISTENTE con el numero ',reg.nro,' menor a ',NROLIMITE,
            ' sera borrado logicamente poniendo un @ en su nombre. ');
            reg.nom:='@'+reg.nom;
            seek(archivo, filepos(archivo)-1 );        
            write(archivo, reg); 
            imprimirReg(reg);    {no lo pide el ej}
        end;
        leer(archivo, reg);
    end;
    close(archivo);
end;

var
    arc_logico: archivoAsistentes;
begin
    {asign dentro del crear archivo}
    crearArchivo(arc_logico);
    mostrarListaCompleta(arc_logico); {no lo pide el ej}
    borrarAsistentes(arc_logico);
    mostrarListaCompleta(arc_logico);  {no lo pide el ej}

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
