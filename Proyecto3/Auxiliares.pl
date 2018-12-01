%Programa que incluye funcionalidad auxiliar a la resolucion del mini
% router que implemente casos y busqueda A* entre dos estaciones del
% metro de la Ciudad de Mexico.
% Autores: Amanda Velasco CU: 154415 Email: am_tuti@hotmail.com
%          Octavio Ordaz  CU: 158525 Email: octavio.ordaz13@gmail.com
% Fecha: 4 de diciembre de 2018
%
%----------------------------Funcionalidad Auxiliar-------------------------------

%Lee datos del csv y los transforma a filas
/*
Son tres funciones que trabajan en conjunto:
-get_rows_data: Utiliza una función propia de SWI Prolog que le permite
acceder a la ruta del archivo y poner cada fila separada en una
estructura llamada Rows, los corchetes vacíos indican que las opciones
son las que vienen por defecto.
-rows_to_list: Para cada una de las Rows que genero la funcion
anterior, las convierte en un mapa donde crea un conjunto de listas que
contienen los datos de cada estacion.
-row_to_list: Para el conjunto de listas que devolvió la
funcion anterior, crea una lista diferente de Prolog para cada estacion
que esta en el csv.
*/
rows_to_lists(Rows, Lists):-
  maplist(row_to_list, Rows, Lists).
row_to_list(Row, List):-
  Row =..[row|List].
get_rows_data(Archivo,Lists):-
    csv_read_file(Archivo, Rows, []),
    rows_to_lists(Rows, Lists).

%Invierte el contenido de una lista X en otra lista Res
/*
Toma la cabeza de una lista y guarda el elemento, una vez que la lista
queda vacia añade en orden inverso (los pone en la cola) dentro de una
lista que sirve como resultado.
*/
invierte(X,Res):-
    invierte(X,[],Res).
invierte([],Y,Y):-!.
invierte([XH|XT],Y,Res):-
    invierte(XT,[XH|Y],Res).

%split_at
split_at(N,Xs,Take,Rest) :-
    split_at_(Xs,N,Take,Rest).

split_at_(Rest, 0, [], Rest) :- !. % optimization
split_at_([], N, [], []) :-
    % cannot optimize here because (+, -, -, -) would be wrong,
    % which could possibly be a useful generator.
    N > 0.
split_at_([X|Xs], N, [X|Take], Rest) :-
    N > 0,
    succ(N0, N),
    split_at_(Xs, N0, Take, Rest).


%Elimina el ultimo elemento de la lista
eliminaUltimo([XH|XT], Y) :-
  eliminaUltimo(XT, Y, XH).
eliminaUltimo([], [], _).
eliminaUltimo([XH|XT], [YH|YT], YH) :-
   eliminaUltimo(XT, YT, XH).

%Devuelve el ultimo elemento de la lista
devuelveUltimo(X,Elem):-
  length(X,Pos),
  Pos == 0 -> !;
  length(X,Pos),
  NewPos is Pos - 1,
  split_at(NewPos,X,_,[Elem|_]).

%Define la funcion haversine y entrega el valor en H
haversine(X,H):-
    H is sin(X/2)**2.

% Calcula en Har la distancia entre dos estaciones usando la formula del
% haversine
/*
Funcion utilizada para calcular el valor heuristico h donde
h es la distancia sobre el globo terraqueo entre una estacion actual
arbitraria y la estacion destino a la que se quiere buscar una solucion.
Dadas dos estaciones Actual y Destino accede a sus componentes de
longitud y latitud para aplicar la formula del haversine y entregar el
resultado en Har.
*/
distHaversine(Actual,Destino,Har):-
    getLongitud(Actual,LongA),
    getLongitud(Destino,LongD),
    getLatitud(Actual,X),
    LatA is X*pi/180,
    getLatitud(Destino,Y),
    LatD is Y*pi/180,
    DifLon is (LongD-LongA)*pi/180,
    DifLat is LatD-LatA,
    haversine(DifLat,H1),
    haversine(DifLon,H2),
    C1 is cos(LatA),
    C2 is cos(LatD),
    A is H1+C1*C2*H2,
    R1 is sqrt(A),
    R2 is sqrt(1-A),
    C is atan2(R1,R2)*2,
    D is 6371*C,
    Har is D*1000.

%Imprime camino
/*
Dada una lista de estaciones que representan el camino final desde el origen hasta
el destino, imprime una a una las estaciones.
*/
imprimeCamino([]):-!.
imprimeCamino([CaminoH|CaminoT]):-
    write(CaminoH),
    nl,
    imprimeCamino(CaminoT).

%Imprime estadistica
imprimeEst:-
  statistics(predicates,B),
  statistics(functors,C),
  statistics(stack,D),
  write('predicates: '),write(B),
  write('functors: '),write(C),
  write('stack: '),write(D).




%-----------------------------------------------------------------------------------
