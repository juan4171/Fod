program ej5Actas;
{ej5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.
Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.
Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.


solucion al ej: hacer un merge con los 100 archivos para generar un maestro ¿como se
que fallecio la persona? buscando primero el acta de nacimiento, si no encuentro un
acta de fallecimiento con el mismo numero de partida de nacimiento, no fallecio.

puedo asumir que no hay fallecimientos sin nacimientos? yo diria que si porque:
 archivos están ordenados por nro partida de nacimiento
}
const
    CANT_DETALLES = 3;
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej4\';
    LOG_CENTRAL_TXT = DIREC+'log_central.txt';
    LOG_CENTRAL_BINARIO = DIREC+'log_central';

type
    nacimiento = record
        nro: integer;
        nom: string[50];
        direccion: string[50;
        matricula_nacimiento: integer;
        nom_madre: string[50];
        DNI_madre: integer;
        nom_padre: string[50];
        DNI_padre: integer;
    end;
    fallecimiento = record
        nro: integer;
        nom: string[50];
        matricula_fallecimiento: integer;
        fecha_hora_lugar: string[50];
    end;
    acta = record
        nac: nacimiento;
        fal: fallecimiento;
    end;

    maestro = file of log_central;
    detalle = file of log_maquina;

    arc_detalle = array[1..MAQUINAS] of detalle;   {file of log_maquina;}   {archivos detalle}
    reg_detalle = array[1..MAQUINAS] of log_maquina;

    arc_detalle_txt = array[1..MAQUINAS] of text;   {archivos detalle txt}



procedure leer(var archivo: detalle; var dato: log_maquina);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := valoralto;
end;

procedure minimo (var reg_det: reg_detalle; var min: log_maquina; var deta: arc_detalle);
var
    i, i_del_minimo: integer;
begin
    min:= reg_det[1];
    i_del_minimo:=1;
    for i:= 2 to MAQUINAS do
    begin
        if (reg_det[i].cod < min.cod) then
        begin
            min:=reg_det[i];
            i_del_minimo:=i;
        end
        else
        begin
            if((reg_det[i].cod = min.cod)and(reg_det[i].fecha <= min.fecha))then
            begin
                min:= reg_det[i];
                i_del_minimo:=i;
            end;
        end;
    end;
    leer( deta[i_del_minimo], reg_det[i_del_minimo] );
end;

procedure merge(var mae1: maestro; var deta: arc_detalle);
var
    i: integer;
    min: log_maquina;
    regm: log_central;
    reg_det: reg_detalle; {registro de los informes que voy sacando del array de detalles}
begin
    {abro los archivos detalle y maestro y leo el 1er reg de cada detalle}
    rewrite(mae1);
    for i:= 1 to MAQUINAS do
    begin
        reset(deta[i]);
        leer( deta[i], reg_det[i] );
    end;
    {calculo el reg de menor codigo de entre todos los detalles}
    minimo (reg_det, min, deta);
    {calculo por cada usuario las horas de sesion tot por dia}
    while (min.cod <> VALORALTO) do
    begin
        regm.cod := min.cod;
        regm.fecha := min.fecha;    {no puedo hacer regm=min porque no son lo mismo}
        regm.tiempo_total_de_sesiones_abiertas := 0;
        {se procesan todos los productos de un mismo codigo y misma fecha}
        while ((regm.cod = min.cod ) and (min.fecha = regm.fecha)) do begin
            regm.tiempo_total_de_sesiones_abiertas := regm.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
            minimo (reg_det, min, deta);
        end;
        { se guarda en el archivo maestro cuando cambio de codigo y/o de fecha}
        write(mae1, regm);
    end;
    {cierro archivos detalle y maestro}
    close(mae1);
    for i:= 1 to MAQUINAS do
    begin
        close(deta[i]);
    end;
end;

procedure exportar_a_txt(var arch_binario : maestro; var arch_texto: text);
var
    registro: log_central;
begin
    reset(arch_binario);
    rewrite(arch_texto);
    writeln('Archivo de texto creado en: ', LOG_CENTRAL_TXT);
    while(not eof(arch_binario))do begin
        read(arch_binario, registro);
        with registro do
        begin
            writeln( arch_texto, cod,' ',fecha,' ',tiempo_total_de_sesiones_abiertas:0:2);
        end;
    end;
    close(arch_binario);
    close(arch_texto);
end;

procedure detalle_txt_a_binario(var carga: text; var det: detalle);
var
    reg: log_maquina;  {registro del tipo que se guarda en detalle}
    espacio: char;
begin
    reset(carga);
    rewrite(det);
    while(not EOF(carga))do begin
        with reg do readln(carga, cod, tiempo_sesion, espacio, fecha);
        write(det, reg);
    end;
    close(det);
    close(carga);
end;

var
    mae1 : maestro;
    mae1_txt : text;
    vector_det_binarios : arc_detalle;
    vector_det_txt : arc_detalle_txt;
    {creo un vector de detalles txt para poder ir pasandolos todos al vector de detalles binarios,
        el ejercicio no lo pide pero para comprobar que funciona lo hago,
        si ya tuviera creados los binarios no necesitaria la linea anterior}
    i: integer;
    indice_str : string[2];
begin
    writeln('----');
    writeln('Programa Red lan y logs: ');
    writeln('----');

    {-------------Archivos del maestro binario y txt-------------}
    assign(mae1, LOG_CENTRAL_BINARIO);
    assign(mae1_txt, LOG_CENTRAL_TXT);
    {-------------Creacion de los detalles binarios--------------}
    {-----------------------------Y------------------------------}
    {-------------Creacion del vector de detalles----------------}
    for i := 1 to MAQUINAS do begin
        Str(i,indice_str);
        assign(vector_det_txt[i], DIREC+'log'+indice_str+'.txt');
        assign(vector_det_binarios[i], DIREC+'log'+indice_str);
        detalle_txt_a_binario(vector_det_txt[i], vector_det_binarios[i]);
        {creo un vector de detalles txt para poder ir pasandolos todos al vector de detalles binarios,
        el ejercicio no lo pide pero para comprobar que funciona lo hago, si ya tuviera creados los binarios no haria falta hacerlo
        voy asignandole direcciones a los archivos binarios y despues (pasando los archivos de texto a binario)
        voy creando archivos en esas direcciones}
    end;


    merge(mae1, vector_det_binarios);
    exportar_a_txt(mae1, mae1_txt);

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
