%Programa para calcular la ruta optima entre dos estaciones del metro
% de la Ciudad de Mexico utilizando razonamiento basado en
% casos y basado en modelos (mapa jerarquizado) aplicando el algoritmo
% de busqueda A*.
% Autores: Amanda Velasco CU: 154415 Email: am_tuti@hotmail.com
%          Octavio Ordaz  CU: 158525 Email: octavio.ordaz13@gmail.com
% Fecha: 4 de diciembre de 2018

%-----------------------------Predicados Dinamicos--------------------------------
/*
Los siguientes predicados de la base de conocimientos seran modificados durante
tiempo de ejecucion para cargar datos y casos y para A*:
*/
:-dynamic conexion/5.
:-dynamic caso/3.
:-dynamic frec/1.
%---------------------------------------------------------------------------------

%----------------------------Funcionalidad Auxiliar-------------------------------
%Incluye archivo de funciones comunes
:-['Auxiliares.pl'].

%Incluye archivo de A*
:-['grafoMetro_Final.pl'].

% Establece que la frecuencia para almacenar casos sera de Frec.
% Carga los datos de las estaciones y lee datos de un archivo csv que
% contiene informacion sobre como se interconectan los sectores del mapa
% jerarquizado del metro.
iniciaRouter(Frec):-
    retractall(caso(_,_,_)),
    retractall(frec(_)),
    retractall(conexion(_,_,_,_,_)),
    assert(frec(Frec)),
    cargaDatosA,
    ArchivoC = 'C:/Users/super/Documents/Documentos Escolares/ITAM/Séptimo Semestre/Inteligencia Artificial/IA_GIT/Proyecto3/conexiones_sector.csv',
    get_rows_data(ArchivoC,Conexiones),
    escribeConexiones(Conexiones).
%---------------------------------------------------------------------------------
%
% ---------------------------------Conexiones-------------------------------------
%Una conexion se define de la siguiente manera:
%conexion(sector1, sector2, estacion1, estacion2, sectorInt)
%La conexion puede ser de dos formas:
% 1) mostrar si sector1 y sector2 son contiguos
% (estacion1=estacion2=sectorInt = 0)
% o no (estacion1=estacion2=0 y sectorInt != 0)
% 2) mostrar a traves de cuales estaciones se conectan los sectores
% contiguos
% (estacion1 != 0 y estacion2 != 0 y sectorInt = 0)


%Agrega las conexiones de una lista a la base de conocimientos
/*
Los datos leidos del archivo csv se encuentran en listas con la estructura:
[sector1, sector2, estacion1, estacion2, sectorInt].

Esta funcion realiza asserts para agregar a la base de conocimientos dos
instancias de la conexion (puesto que es no dirigida), ambas con el
mismo sector intermedio, una con sector1 como origen y otra con sector2
como origen.
*/
escribeConexiones([]):-!.
escribeConexiones([[Sector1|[Sector2|[Estacion1|[Estacion2|[SectorInt|_]]]]]|ListsT]):-
    assert(conexion(Sector1, Sector2, Estacion1, Estacion2, SectorInt)),
    assert(conexion(Sector2, Sector1, Estacion2, Estacion1, SectorInt)),
    escribeConexiones(ListsT).

%---------------------------------------------------------------------------------

% -----------------------------------Casos----------------------------------------
% Un caso se define de la siguiente manera:
% caso(estOri,estDest,camino)
% y almacena un camino conocido entre dos estaciones.

% La frecuencia con la que se almacenan los casos se define en el predicado frec.
% ---------------------------------------------------------------------------------

% -----------------------------------Router----------------------------------------
%Calcula el indice en el que se encuentra un elemento Target dentro de una lista
/*
 Se va descabezando la lista hasta llegar a una lista vacia. Ahi se inicializa
 un contador en 1 (porque los indices empiezan en 1) y con cada elemento que se
 devuelve y que no sea igual al Target se va incrementando. Si Target no esta
 contenido en la lista, el valor que se devuelve es la longitud de la lista + 1.
 Si Target esta mas de una vez en la lista, se devuelve el indice de la primera
 ocurrencia.
*/
cuentaPos([],_,1):-!.
cuentaPos([CaminoH|_],CaminoH,1):-!.
cuentaPos([_|CaminoT],Target,Pos):-
    cuentaPos(CaminoT,Target,NewPos),
    Pos is NewPos + 1.

%Depura el camino
/*
 Dado un Camino y un Destino, usa cuentaPos para calcular en que indice esta
 Destino dentro de Camino. Con split_at parte el Camino en dicho indice para 
 en Res devolver el take, es decir, el primer tramo del camino en que se 
 pasa por Destino.
*/
depura(Camino,Destino,Res):-
    cuentaPos(Camino,Destino,Pos),
    split_at(Pos,Camino,Res,_).


% Obtiene en Res el sector intermedio por el que se debe pasar para
% llegar de SecOri a SecDest
/*
 Busca en la base de conocimientos todos los hechos de conexion con el formato
 estacion1 = estacion2 = 0 para asi extraer en Val el sector que conecta al
 origen con el destino.
*/
getSectorInt(SecOri, SecDest, Res):-
    findall(Val, conexion(SecOri, SecDest, 0, 0, Val), [Res|_]).

% Elige en Cam de entre las rutas designadas que conectan sectores
% aquella que acerca mas al destino final
/*
 Busca en la base de conocimientos todas las conexiones con el formato
 estacion1 != 0 y estacion2 != 0 para asi sacar las estaciones del 
 sector origen que se pueden tomar para pasar al sector destino. Pone
 todos los resultados en una lista y con menorCamDes elige aquel que
 este mas cercano a la estacion destino.
*/
eligeCamDes(SecOri, EstDest, SecDest, Cam):-
    findall(Dest, conexion(SecOri, SecDest,Dest,_, _), Res),
    menorCamDes(Res,Cam,EstDest).

% De una lista de estaciones devuelve en Cam el elemento que tenga
% menor distancia haversine a un destino dado
/*
 Dada una lista de estaciones obtiene para cada una su distancia haversine
 a un destino dado, y de manera secuencial compara si el valor obtenido 
 es menor al valor menor. En caso de ser cierto, actualiza el menor valor 
 y avanza sobre los demas valores. Se detiene cuando no quedan mas estaciones 
 por analizar.
*/
menorCamDes([CamH|CamT],Cam,Dest):-
  menorCamDes([CamH|CamT],inf,CamH,Cam,Dest).
menorCamDes([],_,X,X,_):-!.
menorCamDes([CamH|CamT],Menor,Actual,Cam,Dest):-
  distHaversine(CamH,Dest,Val),
  Val < Menor -> menorCamDes(CamT,Val,CamH,Cam,Dest);
  menorCamDes(CamT,Menor,Actual,Cam,Dest).

%Funcion que agrega el conocimiento
/*
 Dado un camino final que se encontro como solucion, aplica secuencialmente 
 split_at tomando una frecuencia F como indice de particion y almacenando 
 cada take como un caso con sus estaciones origen y destino propias. 
 Este proceso continua mientras la lista rest no este vacia. Una vez que 
 rest quede vacia, se debe analizar la longitud de take para, en caso de 
 cumplir con el tamaño deseado F, agregarlo tambien como caso.
*/
agregaConocimiento(CaminoFinal,F):-
    split_at(F,CaminoFinal,[TakeH|TakeT],Res),
    Res \== [] -> devuelveUltimo(TakeT,EstDest), assert(caso(TakeH,EstDest,[TakeH|TakeT])), agregaConocimiento(Res,F);
    split_at(F,CaminoFinal,[TakeH|TakeT],_),
    length([TakeH|TakeT],Tam),
    Tam == F -> devuelveUltimo(TakeT,EstDest), assert(caso(TakeH,EstDest,[TakeH|TakeT]));
    !.

%Busca entre los casos almacenados aquellos que le puedan servir para 
% resolver el problema dado. Llama a otra funcion si no pudo encontrar
% casos utiles.
/*
 Dadas una estacion origen y una estacion final, busca si en la base de
 conocimientos existe algun camino que conecte a ambas estaciones en
 cualquier direccion. Si existe, lo devuelve en X (de ser necesario
 antes invierte el camino). De lo contrario, busca todos los casos que le
 puedan servir como subcasos (en cualquier direccion). Si no encuentra, 
 se remite a creaCaso y depura el camino encontrado en X. Si si encuentra,
 elige al caso cuya estacion siguiente lo acerque mas al destino y busca
 un caso recursivamente a partir de la estacion siguiente. Al regresar, 
 aplica eliminaUltimo para borrar repetidos entre el camino que va de la
 estacion origen a la siguiente, junta ambos caminos, depura el camino
 resultante y lo devuelve en X.
*/
buscaCaso(EstOri, EstDest, X):-
    EstOri == EstDest -> X = [EstOri], !;
    findall(Camino, caso(EstOri,EstDest,Camino),[X|_]) -> !;
    findall(Camino, caso(EstDest,EstOri,Camino),[Aux|_]) -> invierte(Aux,X),!;
    findall(Camino, caso(EstOri,_,Camino),CasoOri),
    CasoOri == [] -> creaCaso(EstOri, EstDest, Y), depura(Y,EstDest,X);
    findall(Camino, caso(_,EstOri,Camino),CasoOri),
    CasoOri == [] -> creaCaso(EstOri, EstDest, Y), depura(Y,EstDest,X);
    findall(EstSig, caso(EstOri,EstSig,_), Destinos1),
    findall(EstSig, caso(EstSig,EstOri,_), Destinos2),
    append(Destinos1,Destinos2,Destinos),
    menorCamDes(Destinos,Siguiente,EstDest),
    buscaCaso(Siguiente,EstDest,Aux),
    findall(Camino, caso(EstOri,Siguiente,Camino), [Creo|_]),
    eliminaUltimo(Creo,Creemos),
    append(Creemos,Aux,Y),
    depura(Y,EstDest,X).

%Dadas una estacion origen y una destino, utiliza el razonamiento basado
% en modelos para reducir el problema a nivel sector y resolverlo ya sea
% buscando casos o con A*.
/*
 Obtiene los sectores a los que pertenecen la estacion origen y la destino.
 Si pertenecen al mismo, se realiza A* y se devuelve el resultado en X.
 Si no pertenecen al mismo, se verifica si hay un sector intermedio entre
 ellos. Si no hay, se busca entre los caminos designados cual acerca mas
 al destino y se aplica buscaCaso para encontrar una ruta entre el origen
 y la estacion designada y una entre la estacion siguiente a la designada
 y el destino. Se juntan ambos caminos y se devuelven en X. Si si hay un
 sector intermedio, se procede de la misma forma solamente que encontrando
 tres caminos en vez de dos.
*/
creaCaso(EstOri, EstDest, X):-
    getSector(EstOri,S1),
    getSector(EstDest,S2),
    S1 == S2 -> aEstrellaGeo(EstOri,EstDest,X);
    getSector(EstOri,S1),
    getSector(EstDest,S2),
    getSectorInt(S1,S2,SInt),
    SInt == 0 -> (eligeCamDes(S1,EstDest,S2,Con1),
                  findall(Siguiente, conexion(S1,S2,Con1,Siguiente,_),[Con1Next|_]),
                  buscaCaso(EstOri,Con1,C1),
                  buscaCaso(Con1Next,EstDest,C2),
                  append(C1,C2,X));
    getSector(EstOri,S1),
    getSector(EstDest,S2),
    getSectorInt(S1,S2,SInt),
    SInt \== 0 -> (eligeCamDes(S1,EstDest,SInt,ConInt1),
                   buscaCaso(EstOri,ConInt1,CInt1),
                   findall(Siguiente1, conexion(S1,SInt,ConInt1,Siguiente1,_),[ConI1Next|_]),
                   eligeCamDes(SInt,EstDest,S2,ConInt2),
                   buscaCaso(ConI1Next,ConInt2,CInt2),
                   findall(Siguiente2, conexion(SInt,S2,ConInt2,Siguiente2,_),[ConI2Next|_]),
                   buscaCaso(ConI2Next,EstDest,CInt3),
                   append(CInt1,CInt2,Aux),
                   append(Aux,CInt3,X)).

%Funcion que llama el usuario
/*
 Dadas una estacion origen y una destino, verifica que las estaciones
 esten en la base de conocimientos. En caso positivo, imprime el camino
 mas corto que las conecta. Si el camino encontrado tiene longitud
 mayor a 1, se almacena completo a la base de casos y se llama a 
 agregaConocimiento para almacenar los subcasos con la frecuencia dada.
*/
router(EstOri,EstDest):-
    findall(Est,estacion(EstOri),XH),
    member(Est,XH),
    findall(Est,estacion(EstDest),YH),
    member(Est,YH),
    buscaCaso(EstOri,EstDest,X),
    findall(Frec, frec(Frec), [F|_]),
    agregaConocimiento(X,F),
    imprimeCamino(X),
    length(X,Tam),
    Tam > 1 -> assert(caso(EstOri,EstDest,X));fail.
%---------------------------------------------------------------------------------











