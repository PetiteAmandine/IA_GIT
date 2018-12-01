%Programa para calcular la ruta optima entre dos estaciones del metro
%de la Ciudad de Mexico aplicando el algoritmo de busqueda A*.
%Autores: Amanda Velasco CU: 154415 Email: am_tuti@hotmail.com
%         Octavio Ordaz  CU: 158525 Email: octavio.ordaz13@gmail.com
%Fecha: 4 de diciembre de 2018

%-----------------------------Predicados Dinamicos--------------------------------
/*
Los siguientes predicados de la base de conocimientos seran modificados durante
tiempo de ejecucion para cargar datos y para A*:
*/
:-dynamic estacion/1.
:-dynamic estacion/6.
:-dynamic via/3.
:-dynamic f/2.
:-dynamic papa/2.
:-dynamic visitados/1.
%---------------------------------------------------------------------------------

%----------------------------Funcionalidad Auxiliar-------------------------------
%Incluye archivo de funciones comunes
:-['Auxiliares.pl'].

% Carga los datos de nombre, latitud, longitud y demás a la base de
% conocimiento para cada una de las estaciones.
/*
Lee datos de dos archivos csv, uno que contiene a las estaciones y
otro que contiene a las vias, los convierte a listas y los agrega a la
base de conocimientos.
*/
cargaDatosA:-
    retractall(estacion(_)),
    retractall(estacion(_,_,_,_,_,_)),
    retractall(via(_,_,_)),
    ArchivoE = 'C:/Users/super/Documents/Documentos Escolares/ITAM/Séptimo Semestre/Inteligencia Artificial/IA_GIT/Proyecto3/estaciones.csv',
    get_rows_data(ArchivoE,Estaciones),
    escribeEstaciones(Estaciones),
    ArchivoV = 'C:/Users/super/Documents/Documentos Escolares/ITAM/Séptimo Semestre/Inteligencia Artificial/IA_GIT/Proyecto3/vias.csv',
    get_rows_data(ArchivoV,Vias),
    escribeVias(Vias).
% -----------------------------------------------------------------------------------

%-------------------------------Estaciones/Nodos------------------------------------
/*
Una estacion se define de dos maneras.
-Por su nombre:
  estacion(nombre)
-Por su nombre, posicion geografica, distancia en vias que se ha
recorrido desde un origen dado hasta dicha estacion (g), el costo
total (f), tanto en vias como en distancia sobre el globo terraqueo, en
que se ha incurrido para llegar desde un origen dado hasta dicha
estacion, y el sector al que pertenece la estacion:
estacion(nombre,latitud,longitud,distAcum,costoTot,sector)

El costo total de una estacion (f) se encuentra mapeado a la estacion de la
siguiente manera:
f(estacion, costo)
*/

/*
El predicado papa con la siguiente estructura:
papa(est1,est2)
indica que A* encontro un camino que llega a est1 pasando por est2
*/

%Obtiene en Res el valor de f asocidado a la estacion E
obtieneF(E,Res):-
    findall(Val,f(E,Val),[Res|_]).

%Obtiene una lista en XH con los datos de la estacion E
%de la forma XH = [latitud, longitud, distancia_acumulada, costo_total]
obtieneDatosEst(E,XH):-
    findall([La,Lo,D,C,S],estacion(E,La,Lo,D,C,S),[XH|_]).

%Obtiene en X la latitud de la estacion E
getLatitud(E,X):-
    obtieneDatosEst(E,[X|_]).

%Obtiene en X la longitud de la estacion E
getLongitud(E,X):-
    obtieneDatosEst(E,[_|[X|_]]).

%Obtiene en X la distancia acumulada (g) de una estacion E
getDistanciaAcum(E,X):-
    obtieneDatosEst(E,[_|[_|[X|_]]]).

%Obtiene en X el costo total (f) de una estacion E
getCostoTotal(E,X):-
    obtieneDatosEst(E,[_|[_|[_|[X|_]]]]).

%Obtiene en X el sector al que pertenece una estacion E
getSector(E,X):-
    obtieneDatosEst(E,[_|[_|[_|[_|[X|_]]]]]).

%Agrega las estaciones de una lista a la base de conocimientos
/*
Los datos leidos del archivo csv se encuentran en listas con la estructura:
[nombre, latitud, longitud, distancia_acumulada, costo_total]
Esta funcion realiza asserts para agregar a la base de conocimientos las dos
definiciones de estacion asi como el costo total f el cual es inicializado
en +infinito.
*/
escribeEstaciones([]):-!.
escribeEstaciones([[Nombre|[Latitud|[Longitud|[DistAcum|[CostoTot|[Sector|_]]]]]]|ListsT]):-
    assert(estacion(Nombre)),
    assert(estacion(Nombre,Latitud,Longitud,DistAcum,CostoTot,Sector)),
    assert(f(Nombre,inf)),
    escribeEstaciones(ListsT).
%---------------------------------------------------------------------------------
%
% ------------------------------Vias/Aristas--------------------------------------
/*
Una via se define de la siguiente manera:
via(origen,destino,distancia)
donde origen y destino son los nombres de dos estaciones y distancia es
la distancia (en vias) entre origen y destino.
*/

%Obtiene en XH la distancia entre dos estaciones E1 y E2
getDistancia(E1,E2,XH):-
    findall(P,via(E1,E2,P),[XH|_]).

% Para una via subsecuente, obtiene la estacion que es hija de la actual.
getEstD([ViaH|_],ViaH):-!.

%Agrega las vias de una lista a la base de conocimientos
/*
Los datos leidos del archivo csv se encuentran en listas con la estructura:
[estacion1, estacion2, distancia_en_vias].

Esta funcion realiza asserts para agregar a la base de conocimientos dos
instancias de la via con el mismo peso (puesto que es no dirigida), una
con estacion1 como origen y otra con estacion2 como origen.
*/
escribeVias([]):-!.
escribeVias([[E1|[E2|[D|_]]]|ListsT]):-
  assert(via(E1,E2,D)),
  assert(via(E2,E1,D)),
  escribeVias(ListsT).
%---------------------------------------------------------------------------------

% -------------------------------Metro/Grafo--------------------------------------
/*
El predicado visitados de la forma
visitados(estacion)
indica que una estacion ya fue visitada en el recorrido actual del metro
*/

%Entrega en X una lista de las conexiones de la estacion Ori
/*
Busca todas las vias que tengan a Ori como origen y entrega en X los
nombres de las estaciones destino y los pesos de las vias. La estructura
de X es X = [estacion1,peso1,...,estacionN,pesoN].
*/
conexiones(Ori,X):-
    findall([Dest,P],via(Ori,Dest,P),X).

%Obtiene la estacion con menor costo total
/*
Dada una lista de estaciones obtiene para cada una su costo total, y de manera
secuencial compara si el valor obtenido es menor al valor menor. En caso de ser
cierto, actualiza el menor valor y avanza sobre los demas valores. Se detiene
cuando no quedan mas estaciones por analizar.
*/
menorLista([HijosH|HijosT],Estacion):-
    menorLista([HijosH|HijosT],inf,HijosH,Estacion).
menorLista([],_,X,X):-!.
menorLista([HijosH|HijosT],Menor,Actual,Estacion):-
    getCostoTotal(HijosH,CostoAct),
    CostoAct < Menor -> menorLista(HijosT,CostoAct,HijosH,Estacion);
    menorLista(HijosT,Menor,Actual,Estacion).

%----------------------------------A*---------------------------------------------
%Revisa si una estacion (nodo) ya fue visitada
/*
Utilizando la funcion findall propia de SWI-Prolog, busca todas las ocurrencias
del elemento Estacion dentro de la lista de visitados y los almacena en una lista,
comprueba, usando la funcion member propia de SWI-Prolog que la estacion se encuentra
en esa lista respuesta. Devuelve true si lo encontró o false en caso contrario.
*/
visitado(Estacion):-
    findall(Est,visitados(Estacion),Res),
    member(Est,Res).

%Obtiene el camino por recorrer desde una estacion origen a una destino
/*
Dadas dos estaciones, y una lista de nodos recorridos, busca con la funcion
findall de SWI-Prolog todas las ocurrencias de la estación actual dentro de
la base de conocimiento y devuelve en la cabeza de una lista el padre del actual.
Realiza backtracking para encontrar el padre de cada estacion.
*/
obtieneCamino(Origen,Origen,[]):-!.
obtieneCamino(Origen,Destino,[CaminoH|CaminoT]):-
    findall(Padre,papa(Destino,Padre),[CaminoH|_]),
    obtieneCamino(Origen,CaminoH,CaminoT).

%Calcula y actualiza el valor del costo total para cada estacion candidata
/*
Dada una lista de hijos de una estacion actual, para cada hijo que no se ha visitado,
calcula la distancia haversine (distancia sobre la superficie de la
Tierra) desde el hijo hasta el destino, la distancia acumulada en metros
sobre las vias desde el origen hasta el hijo actual, y verifica si es
menor al valor guardado. En este caso, actualiza su valor, y añade la
estacion a la lista de candidatos.
*/
trataSubsecuentes(_,_,[],Candidatos,Candidatos,_):-!.
trataSubsecuentes(Actual,Destino,[SubsecuentesH|SubsecuentesT],OpenList,Candidatos,Sec):-
    getEstD(SubsecuentesH,EstD),
    not(visitado(EstD)),
    distHaversine(EstD,Destino,H),
    getDistancia(Actual,EstD,GInc),
    getDistanciaAcum(Actual,GAcu),
    G is GAcu + GInc,
    F is G + H,
    obtieneF(EstD,Val),
    F < Val -> (retract(f(EstD,_)),
                assert(f(EstD,F)),
                getLatitud(EstD,Lat),
                getLongitud(EstD,Long),
                retract(estacion(EstD,_,_,_,_,_)),
                assert(estacion(EstD,Lat,Long,G,F,Sec)),
                assert(papa(EstD,Actual)),
                append(OpenList,[EstD],Nueva),
                trataSubsecuentes(Actual,Destino,SubsecuentesT,Nueva,Candidatos,Sec));
    trataSubsecuentes(Actual,Destino,SubsecuentesT,OpenList,Candidatos,Sec).


%Prepara para A*
/*
Reestablece los valores de la base de conocimiento para los predicados de estacion, via,
papa, visitados, y f. Utilizando la funcion auxiliar cargaDatos, agrega a la base de
conocimiento las estaciones, sus coordenadas geograficas, el valor inicial para su distancia
acumulada y el costo total. Agrega la estacion origen a la lista abierta que contiene las
estaciones por explorar y actualiza su costo total. Manda a llamar el metodo que implementa A*,
el cual devuelve el camino por recorrer e imprime el resultado utilizando la funcion auxiliar
imprimeCamino.
*/
aEstrellaGeo(Origen,Destino,CaminoFinal):-
    retractall(estacion(_)),
    retractall(estacion(_,_,_,_,_,_)),
    retractall(f(_,_)),
    retractall(visitados(_)),
    retractall(papa(_,_)),
    retractall(via(_,_,_)),
    cargaDatosA,
    findall(Est,estacion(Origen),XH),
    member(Est,XH),
    findall(Est,estacion(Destino),YH),
    member(Est,YH),
    getCostoTotal(Origen,CT),
    retract(f(Origen,_)),
    assert(f(Origen,CT)),
    OpenList = [Origen],
    getSector(Origen,Sec),
    aEstrellaGeo(Origen,Destino,OpenList,Camino,Sec),
    invierte(Camino,Aux),
    append(Aux,[Destino],CaminoFinal).

%Implementa A*
/*
Para la lista abierta (OpenList) obtiene la estacion que menor costo total tenga, y a esa
estacion le asigna el nombre de actual. Verifica si no ha visitado la estacion actual, de no
haberla visitado la agrega a visitados y comprueba si es o no la estacion destino. De ser la
estacion destino termina la ejecucion y devuelve el camino final. En caso de que no sea el
destino, la elimina de la lista abierta, obtiene todos sus hijos y para cada uno de ellos
calcula su costo total para elegir la opcion de menor costo en terminos de la heuristica;
ademas, vuelve a llamar al metodo para ejecutarlo sobre la nueva lista de candidatos. Todo
esto se repite hasta que no queda ningun candidato (i.e., no tiene solucion) o llego al destino.
*/
aEstrellaGeo(_,_,[],[],_):-!.
aEstrellaGeo(Origen,Destino,OpenList,Camino,Sec):-
    menorLista(OpenList,Actual),
    not(visitado(Actual)),
    assert(visitados(Actual)),
    Actual \== Destino -> (delete(OpenList,Actual,OpenListN),
                           conexiones(Actual,Subsecuentes),
                           trataSubsecuentes(Actual,Destino,Subsecuentes,OpenListN,Candidatos,Sec),
                           aEstrellaGeo(Origen,Destino,Candidatos,Camino,Sec));
    obtieneCamino(Origen,Destino,Camino).
%---------------------------------------------------------------------------------
%---------------------------------------------------------------------------------






