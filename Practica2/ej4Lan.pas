program ej4Lan;
{ej4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.

WARNING: no use esta ubicacion /var/log. nota para el futuro: algunas variables de los procesos
podrian ser mejores.

}
const
    MAQUINAS = 5;
    VALORALTO = 9999;
    {WARNING: para ejecutar este programa en otra pc cambiar estas direcciones}
    {direccion de donde se van a cargar y guardar los archivos}
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica2\archivosFOD\ej4\';
    LOG_CENTRAL_TXT = DIREC+'log_central.txt';
    LOG_CENTRAL_BINARIO = DIREC+'log_central';

type
    log_central = record
        cod: integer;
        fecha: string[50];
        tiempo_total_de_sesiones_abiertas: double;
    end;
    log_maquina = record
        cod: integer;
        fecha: string[50];
        tiempo_sesion: double;
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
