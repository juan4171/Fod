program ej3NovelasBajas;
{ej3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.

lista invertida = LIFO
}
const
    VALORALTO = 9999;
    DIREC = 'C:\Users\juan8\Desktop\FOD2023\Practica3\archivosFOD\ej3\';
    NOVELASTXT = DIREC+'novelas.txt';
    NOVELASBINARIO = DIREC+'novelas';
type
    novela = record
        cod: integer;
        nom: string[50];
        genero: string[50];
        duracion: double;   {podria ser string}
        director: string[50];
        precio: double;     {podria ser string}
    end;
    archivoNovelas = file of novela;

procedure leerNovela(var reg: novela);
begin
    writeln('Nueva novela (nombre = "fin" para terminar la carga):');
    writeln('Ingrese nombre de novela: ');
    readln(reg.nom);
    if (reg.nom <> 'fin')then
    begin
        writeln('Ingrese codigo de novela:');
        readln(reg.cod);
        writeln('Ingrese genero:');
        readln(reg.genero);
        writeln('Ingrese director:');
        readln(reg.director);
        writeln('Ingrese duracion:');
        readln(reg.duracion);
        writeln('Ingrese precio:');
        readln(reg.precio);
    end;
end;

procedure crearArchivo(var arc_logico : archivoNovelas);
var
    reg: novela;
begin
    rewrite( arc_logico );
    reg.cod:=0;
    write(arc_logico, reg );
    writeln( 'Comienza la carga de novelas al archivo: ' );
    leerNovela(reg);
    while reg.nom <> 'fin' do
    begin
        write( arc_logico, reg );
        writeln( 'novela cod: ',reg.cod,' cargada exitosamente');
        leerNovela(reg);
    end;
    close(arc_logico);
    writeln( 'Archivo creado en: ',NOVELASBINARIO);
end;

procedure leer(var archivo: archivoNovelas; var dato: novela);
begin
    if (not(EOF(archivo))) then 
        read(archivo, dato)
    else 
        dato.cod := VALORALTO;
end;

{WARNING no controlo que no se ingresen novelas repetidas}
procedure darDeAlta(var archivo : archivoNovelas);  
var 
    reg, reg_aux, cabecera: novela;
begin   
    reset(archivo);
    writeln( 'Comienza la carga de novela al archivo(cuidado de no repetir novelas): ' );
    leerNovela(reg);
    leer(archivo, cabecera);
    if (cabecera.cod < 0) then
    begin
        seek(archivo,  (cabecera.cod * -1)); {-(cabecera.cod)}   {busco la pos libre}
        leer(archivo, reg_aux);     {guardo lo que hay en la pos libre}
        seek(archivo,  FilePos(archivo)-1);
        write(archivo, reg);    {escribo dato en la pos libre}
        seek(archivo,  0);
        write(archivo, reg_aux);    {lo que habia en la pos libre lo pongo 
        en la cabecera, puede ser un nro negativo o 0}
    end
    else
    begin
        seek(archivo, filesize(archivo) );         
        write(archivo, reg);            
    end;
    close(archivo);
end;
procedure borrarNovela(var archivo : archivoNovelas);
var
    reg, cabecera: novela;
    c, pos_borrado: integer;
    encontre: boolean;
begin
    reset(archivo);
    leer(archivo, cabecera);
    leer(archivo, reg);
    writeln('Ingrese codigo de novela a borrar (se borrara la primera coincidencia): ');
    readln(c);
    encontre:=false;
    while ((reg.cod <> VALORALTO) and (not encontre)) do
    begin
        if (reg.cod = c) then
        begin 
            pos_borrado:= filepos(archivo)-1;   {guardo la posicion borrada}
            seek(archivo, filepos(archivo)-1 );  {borro sobre escribiendo con lo que estaba en cabecera}      
            write(archivo, cabecera);   {borro sobre escribiendo con lo que estaba en cabecera}
            seek(archivo, 0 );
            cabecera.cod:= pos_borrado * -1; {-(pos_borrado)}
            write(archivo, cabecera); {reutilizo la variable cabecera y le pongo la pos libre (negativa)}
            encontre:= true;
        end;
        leer(archivo, reg);
    end;
    if encontre then
        writeln('Novela eliminada exitosamente.')
    else
    begin
        writeln('Novela no enontrada, intente nuevamente.');
    end;
    close(archivo);
end;

procedure exportar_a_txt(var arch_binario : archivoNovelas; var arch_texto: text);
var
    reg: novela;
begin
    reset(arch_binario);
    rewrite(arch_texto);
    writeln('Archivo de texto creado en: ',NOVELASTXT );
    while(not eof(arch_binario))do begin
        read(arch_binario, reg);
        with reg do
        begin
            writeln( arch_texto,'Codigo: ', cod,' Precio: ', precio:0:2,' Nombre: ',nom
            ,' Genero: ',genero ,' Director: ',director,' Duracion: ', duracion:0:2 );
        end;
    end;
    close(arch_binario);
    close(arch_texto);
end;

procedure modificar(var archivo : archivoNovelas);
var
    reg: novela;
    c: integer;
begin
    reset(archivo);   
    writeln('Ingrese codigo de novela a modificar (se modificara la primera coincidencia): ');
    readln(c);
    leer(archivo, reg);
    while ((reg.cod <> VALORALTO) and (reg.cod <> c)) do
        leer(archivo, reg);
    if (reg.cod = c) then
    begin 
        writeln('Ingrese NUEVO nombre de novela: ');
        readln(reg.nom);
        writeln('Ingrese NUEVO genero:');
        readln(reg.genero);
        writeln('Ingrese NUEVO director:');
        readln(reg.director);
        writeln('Ingrese NUEVA duracion:');
        readln(reg.duracion);
        writeln('Ingrese NUEVO precio:');
        readln(reg.precio);
        seek(archivo, filepos(archivo)-1 ); 
        write(archivo, reg);  
        writeln('Novela modificada exitosamente.');
    end
    else
    begin
        writeln('Novela no econtrada, intente nuevamente.');    
    end;            
    close(archivo);
end;

procedure dibujarMenuMain();
begin
    writeln('----');
    writeln('Programa de novelas, elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. Crear archivo de novelas ',NOVELASBINARIO);
    writeln('2. Cargar archivo de novelas ',NOVELASBINARIO,' y mostrar opciones');
    writeln('0. Salir');
    writeln('----');
end;
procedure dibujarMenu2();
begin
    writeln('----');
    writeln('elija una de las siguientes opciones: ');
    writeln('----');
    writeln('1. dar de alta novela');
    writeln('2. modificar novelas');
    writeln('3. borrar novela');
    writeln('4. lista completa de novelas');
    writeln('0. Volver');
    writeln('----');
end;

var
    arc_logico: archivoNovelas;
    listado_txt : Text;
    opcion_main, opcion_2: integer; {2 variables para 2 menus}
begin
    assign( arc_logico, NOVELASBINARIO); {ignoro la nota. NOTA: Tanto en la creación como
    en la apertura el nombre del archivo debe ser proporcionado por el usuario.}
    assign( listado_txt, NOVELASTXT);
    repeat
        dibujarMenuMain();
        readln(opcion_main);
        case opcion_main of
            1:begin
                crearArchivo(arc_logico);
            end;
            2:begin
                {cargarArchivo(arc_logico);}
                repeat
                    dibujarMenu2();
                    readln(opcion_2);
                    case opcion_2 of
                        1: darDeAlta(arc_logico); {lista invertida = LIFO}
                        2: modificar(arc_logico);
                        3: borrarNovela(arc_logico);
                        4: exportar_a_txt(arc_logico, listado_txt);
                    end;
                until opcion_2 = 0;
            end;
        end;
    until opcion_main = 0;

    writeln('----');
    writeln('-Programa finalizado.-');
    readln();
end.
