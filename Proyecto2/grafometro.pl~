%"Clase" Estacion
:-dynamic estacion/1.
:-dynamic estacion/5.
:-dynamic via/3.
:-dynamic f/2.
:-dynamic papa/2.

%estacion(nombre,latitud,longitud,distAcc,costoTot,id)

estacion(a).
estacion(b).
estacion(c).
estacion(d).
estacion(e).
estacion(a,0,0,0,0).
estacion(b,0,2,0,0).
estacion(c,0,4,0,0).
estacion(d,1,1,0,0).
estacion(e,1,3,0,0).
%f(Est,Dist). mapea una estacion a un valor de f
f(a,inf).
f(b,inf).
f(c,inf).
f(d,inf).
f(e,inf).
%papa(E1,E2) indica que se llego a E1 por E2


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
%Obtiene distancia entre 2 estaciones
getDistancia(E1,E2,XH):-
    findall(P,via(E1,E2,P),[XH|_]).
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
costoMenor([CostosH|CostosT],[OpenListH|OpenListT],Menor,MEst):-
    menor(CostosT,CostosH,OpenListT,OpenListH,Menor,MEst).
menor([],Menor,[],MEst,Menor,MEst):-!.
menor([CostosH|CostosT],Menor0,[OpenListH|OpenListT],OpenListH,Menor,MEst):-
    Menor1 is min(CostosH,Menor0),
    (Menor0 \== Menor1) -> Est1 is OpenListH,
    menor(CostosT,Menor1,OpenListT,Est1,Menor,MEst).
%A*
aEstrella(Origen,Destino,Camino):-
    getCostoTotal(Origen,CT),
    assert(f(Origen,CT)),
    OpenList = [Origen],
    aEstrella(Origen,Destino,Camino,OpenList).
aEstrella(_,_,_,[]):-!.
aEstrella(Destino,Destino,_,_):-!.
aEstrella(Origen,Destino,Camino,OpenList):-.

