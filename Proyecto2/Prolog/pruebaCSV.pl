:-dynamic estacion/1.
:-dynamic estacion/5.

rows_to_lists(Rows, Lists):-
  maplist(row_to_list, Rows, Lists).
row_to_list(Row, List):-
  Row =..[row|List].
get_rows_data(Lists):-
    Archivo = 'C:/Users/super/Documents/Documentos Escolares/ITAM/Séptimo Semestre/Inteligencia Artificial/IA_GIT/Proyecto2/Prolog/estaciones.csv',
    csv_read_file(Archivo, Rows, []),
    rows_to_lists(Rows, Lists).

escribeEstaciones([]):-!.
escribeEstaciones([[Nombre|[Latitud|[Longitud|[DistAcum|[CostoTot|_]]]]]|ListsT]):-
    assert(estacion(Nombre)),
    assert(estacion(Nombre,Latitud,Longitud,DistAcum,CostoTot)),
    escribeEstaciones(ListsT).

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


