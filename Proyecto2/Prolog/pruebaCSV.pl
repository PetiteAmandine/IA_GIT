:-dynamic estacion/1.
:-dynamic estacion/5.
:-dynamic f/2.
:-dynamic via/3.

rows_to_lists(Rows, Lists):-
  maplist(row_to_list, Rows, Lists).
row_to_list(Row, List):-
  Row =..[row|List].
get_rows_data(Archivo,Lists):-
    csv_read_file(Archivo, Rows, []),
    rows_to_lists(Rows, Lists).

escribeEstaciones([]):-!.
escribeEstaciones([[Nombre|[Latitud|[Longitud|[DistAcum|[CostoTot|_]]]]]|ListsT]):-
    assert(estacion(Nombre)),
    assert(estacion(Nombre,Latitud,Longitud,DistAcum,CostoTot)),
    assert(f(Nombre,inf)),
    escribeEstaciones(ListsT).

escribeVias([]):-!.
escribeVias([[E1|[E2|[D|_]]]|ListsT]):-
  assert(via(E1,E2,D)),
  assert(via(E2,E1,D)),
  escribeVias(ListsT).

cargaDatos:-
    ArchivoE = 'C:/Users/super/Documents/Documentos Escolares/ITAM/S�ptimo Semestre/Inteligencia Artificial/IA_GIT/Proyecto2/Prolog/estaciones.csv',
    get_rows_data(ArchivoE,Estaciones),
    escribeEstaciones(Estaciones),
    ArchivoV = 'C:/Users/super/Documents/Documentos Escolares/ITAM/S�ptimo Semestre/Inteligencia Artificial/IA_GIT/Proyecto2/Prolog/vias.csv',
    get_rows_data(ArchivoV,Vias),
    escribeVias(Vias).

%Obtiene datos de estacion
obtieneDatosEst(E,XH):-
    findall([La,Lo,D,C],estacion(E,La,Lo,D,C),[XH|_]).
%Obtiene latitud
getLatitud(E,X):-
    obtieneDatosEst(E,[X|_]).
%Obtiene longitud
getLongitud(E,X):-
    obtieneDatosEst(E,[_|[X|_]]).
%Obtiene distancia acumulada (g)
getDistanciaAcum(E,X):-
    obtieneDatosEst(E,[_|[_|[X|_]]]).
%Obtiene costo total (f = g+h)
getCostoTotal(E,X):-
    obtieneDatosEst(E,[_|[_|[_|[X|_]]]]).
%Obtiene distancia entre 2 estaciones
getDistancia(E1,E2,XH):-
    findall(P,via(E1,E2,P),[XH|_]).
%Obtiene la estacion destino de una via
getEstD([ViaH|_],ViaH):-!.



