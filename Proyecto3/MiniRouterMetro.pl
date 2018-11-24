%Declaracion de hechos dinamicos
:-dynamic sector/1.
:-dynamic subsector/2.
:-dynamic conexion/5.
:-dynamic caso/5.

%Incluye archivo de A*
:-['grafoMetro_Final.pl'].

%sector(nombre).
%subsector(nombre, secPapa).
%conexion(sector1, sector2, estacion1, estacion2, secInter).
%caso(estOri, sector1, estDest, sector2, camino).

rows_to_lists(Rows, Lists):-
  maplist(row_to_list, Rows, Lists).
row_to_list(Row, List):-
  Row =..[row|List].
get_rows_data(Archivo,Lists):-
    csv_read_file(Archivo, Rows, []),
    rows_to_lists(Rows, Lists).

cargaDatos:-
    ArchivoC = 'C:/Users/velasam/Documents/ITAM/7mo Semestre/IA/Proyecto3/Prolog/conexiones_sector.csv',
    get_rows_data(ArchivoC,Conexiones),
    escribeConexiones(Conexiones),
    assert(sector('NO')),
    assert(sector('N')),
    assert(sector('NE')),
    assert(sector('SO')),
    assert(sector('SE')),
    assert(subsector('N1', 'N')),
    assert(subsector('N2', 'N')).

escribeConexiones([]):-!.
escribeConexiones([[Sector1|[Sector2|[Estacion1|[Estacion2|[SectorInt|_]]]]]|ListsT]):-
    assert(conexion(Sector1, Sector2, Estacion1, Estacion2, SectorInt)),
    assert(conexion(Sector2, Sector1, Estacion2, Estacion1, SectorInt)),
    escribeConexiones(ListsT).


%Obtiene los sectores intermedios por los que se debe pasar
getCamSectores(SecOri, SecDest, X):-
    findall(Val, conexion(SecOri, SecDest, 0, 0, Val), [Res|_]) -> X = [SecOri,Res,SecDest];
    X = [SecOri, SecDest].

eligeCamDes(SecOri, EstDest, SecDest, Z):-
    findall(Dest, conexion(SecOri, SecDest, Sig, Dest, _), [Res|_])
    %Encuentro Z (miembro de Res que tenga menor distancia haversine al destino)
    .

buscaCaso(EstOri, EstDest, X):-
    EstOri == EstDest -> X = [EstOri], !;
    findall(Camino, caso(EstOri,_,EstDest,_,Camino),[X|_]) -> !;
    findall(Camino, caso(EstDest,_,EstOri,_,Camino),[Aux|_]) -> invierte(Aux,X), !;
    %Debo crear un caso
    creaCaso(EstOri, EstDest, X).

creaCaso(EstOri, EstDest, X):-
    %Checo sectores de EstOri y EstDest
    getSector(EstOri,S1),
    getSector(EstDest,S2),
    S1 == S2 -> aEstrellaGeo(EstOri,EstDest,X);
    getCamSectores(S1,S2,CamSec)
    %Necesito recuperar las conexiones entre sectores que tiene CamSec
    %Para la lista, hago eligeCamDes y de ahi debe devolver la estacion en  mi sector que debo tomar para ir al otro
    %Verificar si hay un segundo nivel en la jerarquia
    %Checar si tengo un caso, si no hago A* hasta ese punto y lo guardo como caso (ver frecuencia)
    %Hacer lo mismo para el otro extremo, sea la conexion o un sector intermedio
    %Juntar ambos cachos y guardarlo como caso
    .
