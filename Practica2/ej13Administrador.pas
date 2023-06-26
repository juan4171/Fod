program ej13Administrador;
{ej13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs
del mismo (información guardada acerca de los movimientos que ocurren en el server) que
se encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.
a- Realice el procedimiento necesario para actualizar la información del log en
un día particular. Defina las estructuras de datos que utilice su procedimiento.
b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema.

WARNING: no hago el punto b porque no lo entendi, consultar
}
const

    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej13\';
    MAESTRO_BINARIO = DIREC+'logmail';
    MAESTRO_TXT = MAESTRO_BINARIO+'.txt';
    DETALLE_BINARIO = DIREC+'mails';
    DETALLE_TXT = DETALLE_BINARIO+'.txt';
    {INFORME_TXT = DIREC+'informe.txt';}

type
    log = record
        nro_usuario: integer;
        nom: string[50]; {ignoro nombre, apellido}
        cant_enviados: integer;
    end;
    mail = record
        nro_usuario: integer;
        destino: string[50];
        cuerpo: string[255];
    end;

    maestro = file of log;
    detalle = file of mail;

procedure leer(var archivo: detalle; var dato: mail);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.nro_usuario := valoralto;
end;

procedure actualizar(var mae1: maestro; var det1: detalle);
var
    regd: mail;
    regm: log;
begin
    reset (mae1); reset (det1);
    leer(det1 , regd); {se procesan todos los registros del archivo det1}
    while (regd.nro_usuario <> VALORALTO) do begin
        read(mae1, regm);
        while (regm.nro_usuario <> regd.nro_usuario) do
            read (mae1,regm);
        { se procesan codigos iguales }
        while (regm.nro_usuario = regd.nro_usuario) do begin
            regm.cant_enviados := regm.cant_enviados + 1;
            leer(det1, regd);
        end;
        {reubica el puntero}
        seek (mae1, filepos(mae1)-1);
        write(mae1,regm);
    end;
    writeln('Actualizacion finalizada.')
end;

procedure exportar_a_txt(var arch_binario : maestro; var arch_texto: text);
var
    reg: log;
begin
    reset(arch_binario);
    rewrite(arch_texto);
    writeln('Archivo de texto creado en: ', MAESTRO_TXT);
    while(not eof(arch_binario))do begin
        read(arch_binario, reg);
        with reg do
        begin
            writeln( arch_texto, nro_usuario,' ', cant_enviados,' ', nom);
        end;
    end;
    close(arch_binario);
    close(arch_texto);
end;

procedure detalle_txt_a_binario(var carga: text; var det: detalle);
var
    reg: mail;  {registro del tipo que se guarda en detalle}
    espacio: char;
begin
    reset(carga);
    rewrite(det);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, nro_usuario, espacio, destino);
            readln(carga, cuerpo);
        end;
        write(det, reg);
    end;
    close(det);
    close(carga);
end;

procedure maestro_txt_a_binario(var carga: text; var mae: maestro);
var
    reg: log;
    espacio: char;
begin
    reset(carga);
    rewrite(mae);
    while(not EOF(carga))do begin
        with reg do
        begin
            readln(carga, nro_usuario, cant_enviados, espacio, nom);
        end;
        write(mae, reg);
    end;
    close(mae);
    close(carga);
end;

var
    mae1 : maestro;
    det1 : detalle;
    mae1_txt, det1_txt : text;
begin
    writeln('----');
    writeln('Programa Administrador mails: ');
    writeln('----');
    {-------------Archivos del maestro binario y txt-------------}
    assign(mae1, MAESTRO_BINARIO);
    assign(mae1_txt, MAESTRO_TXT);   {*}
    assign(det1_txt, DETALLE_TXT);   {*}
    assign(det1, DETALLE_BINARIO);
    detalle_txt_a_binario(det1_txt, det1);   {*}
    maestro_txt_a_binario(mae1_txt, mae1);   {*}
    actualizar(mae1, det1);

    exportar_a_txt(mae1, mae1_txt);          {*}
    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
