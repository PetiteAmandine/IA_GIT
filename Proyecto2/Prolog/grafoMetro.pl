:-dynamic estacion/1.
:-dynamic estacion/5.
:-dynamic via/3.
:-dynamic f/2.
:-dynamic papa/2.
:-dynamic visitados/1.

%"Clase" Estacion
%EJEMPLO1
%estacion(nombre,latitud,longitud,distAcc,costoTot)
estacion(a).
estacion(b).
estacion(c).
estacion(d).
estacion(e).
estacion(e1).
estacion(e2).
estacion(e3).
estacion(e4).
estacion(e5).
estacion(e6).
estacion(e7).
estacion(e8).
estacion(a,0,0,0,0).
estacion(b,0,2,0,0).
estacion(c,0,4,0,0).
estacion(d,1,1,0,0).
estacion(e,1,3,0,0).
estacion(e1,0,0,0,0).
estacion(e2,-1,-1,0,0).
estacion(e3,-1,1,0,0).
estacion(e4,0,1,0,0).
estacion(e5,1,1,0,0).
estacion(e6,1,2,0,0).
estacion(e7,1,-1,0,0).
estacion(e8,2,0,0,0).
%via(origen,destino,peso)
via(a,b,20).
via(b,a,20).
via(a,d,23).
via(d,a,23).
via(b,d,2).
via(d,b,2).
via(b,c,20).
via(c,b,20).
via(c,e,15).
via(e,c,15).
via(e1,e2,10).
via(e2,e1,10).
via(e1,e3,15).
via(e3,e1,15).
via(e1,e7,13).
via(e7,e1,13).
via(e1,e5,20).
via(e5,e1,20).
via(e2,e7,19).
via(e7,e2,19).
via(e3,e4,7).
via(e4,e3,7).
via(e4,e5,10).
via(e5,e4,10).
via(e5,e7,12).
via(e7,e5,12).
via(e5,e6,15).
via(e6,e5,15).
via(e6,e8,13).
via(e8,e6,13).
via(e7,e8,6).
via(e8,e7,6).
via(e3,e6,11).
via(e6,e3,11).
%f(Est,Dist). mapea una estacion a un valor de f
f(a,inf).
f(b,inf).
f(c,inf).
f(d,inf).
f(e,inf).
f(e1,inf).
f(e2,inf).
f(e3,inf).
f(e4,inf).
f(e5,inf).
f(e6,inf).
f(e7,inf).
f(e8,inf).

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


%papa(E1,E2) indica que se llego a E1 por E2

%Obtiene F asocidada
obtieneF(E,Res):-
    findall(Val,f(E,Val),[Res|_]).
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
%------------------------------------------------------

%"Clase" via
%via(origen,destino,distancia)
%Obtiene distancia entre 2 estaciones
getDistancia(E1,E2,XH):-
    findall(P,via(E1,E2,P),[XH|_]).
getEstD([ViaH|_],ViaH):-!.
%-------------------------------------------------------

%"Clase grafo"
%conexiones(Origen,X) entrega X=[e1,p1,e2,p2,...,en,pn]
conexiones(Ori,X):-
    findall([Dest,P],via(Ori,Dest,P),X).
% visitados = [e1,e2,...,en]
%donde ei se agrega a la lista cuando se visita
%Define haversine
haversine(X,H):-
    H is sin(X/2)**2.
%Distancia harvesine
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
%Crea una lista de costos a partir de una de estaciones
encuentraCostos(OpenList,Costos):-
    encuentraCostos(OpenList,[],Costos).
encuentraCostos([],Aux,Aux):-!.
encuentraCostos([OpenListH|OpenListT],Aux,[CostosH|CostosT]):-
    getCostoTotal(OpenListH,CostosH),
    encuentraCostos(OpenListT,Aux,CostosT).
%Obtiene la estacion con menor costo total
menorLista([HijosH|HijosT],Estacion):-
    menorLista([HijosH|HijosT],inf,HijosH,Estacion).
menorLista([],_,X,X):-!.
menorLista([HijosH|HijosT],Menor,Actual,Estacion):-
    getCostoTotal(HijosH,CostoAct),
    CostoAct < Menor -> menorLista(HijosT,CostoAct,HijosH,Estacion);
    menorLista(HijosT,Menor,Actual,Estacion).

%A*
%invierte
invierte(X,Res):-
    invierte(X,[],Res).
invierte([],Y,Y):-!.
invierte([XH|XT],Y,Res):-
    invierte(XT,[XH|Y],Res).
%visitado(Estacion)
visitado(Estacion):-
    findall(Est,visitados(Estacion),Res),
    member(Est,Res).
%obtieneCamino(Actual,Destino,Camino)
%Disque backtrackea desde el destino hasta el origen
obtieneCamino(Origen,Origen,[]):-!.
obtieneCamino(Origen,Destino,[CaminoH|CaminoT]):-
    findall(Padre,papa(Destino,Padre),[CaminoH|_]),
    obtieneCamino(Origen,CaminoH,CaminoT).
% trataSubsecuentes(Actual,Destino,Subsecuentes,Visitados,OpenListT,Candidatos)
% Disque revisa si cada hijo de actual tiene menor F
trataSubsecuentes(_,_,[],Candidatos,Candidatos):-!.
trataSubsecuentes(Actual,Destino,[SubsecuentesH|SubsecuentesT],OpenList,Candidatos):-
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
                retract(estacion(EstD,_,_,_,_)),
                assert(estacion(EstD,Lat,Long,G,F)),
                assert(papa(EstD,Actual)),
                append(OpenList,[EstD],Nueva),
                trataSubsecuentes(Actual,Destino,SubsecuentesT,Nueva,Candidatos));
    trataSubsecuentes(Actual,Destino,SubsecuentesT,OpenList,Candidatos).
%Imprime camino
imprimeCamino([]):-!.
imprimeCamino([CaminoH|CaminoT]):-
    write(CaminoH),
    nl,
    imprimeCamino(CaminoT).
%aEstrellaGeo(Origen,Destino,OpenList,Camino)
aEstrellaGeo(Origen,Destino):-
    cargaDatos,
    getCostoTotal(Origen,CT),
    assert(f(Origen,CT)),
    OpenList = [Origen],
    aEstrellaGeo(Origen,Destino,OpenList,Camino),
    invierte(Camino,Aux),
    append(Aux,[Destino],CaminoFinal),
    imprimeCamino(CaminoFinal).
aEstrellaGeo(_,_,[],[]):-!.
aEstrellaGeo(Origen,Destino,OpenList,Camino):-
    menorLista(OpenList,Actual),
    not(visitado(Actual)),
    assert(visitados(Actual)),
    Actual \== Destino -> (delete(OpenList,Actual,OpenListN),
                           conexiones(Actual,Subsecuentes),
                           trataSubsecuentes(Actual,Destino,Subsecuentes,OpenListN,Candidatos),
                           aEstrellaGeo(Origen,Destino,Candidatos,Camino));
    obtieneCamino(Origen,Destino,Camino).


