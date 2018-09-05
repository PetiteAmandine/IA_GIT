%Definición de un polinomio
%poly(coef,exp).

%-----------------Funciones auxiliares--------------------
%Combina 2 listas
combina([],Y,Y):-!.
combina([X|Resto],Y,[X|Nueva]):-
    combina(Resto,Y,Nueva).
%Crea una lista de N ceros
ceros(_,0,[]).
ceros(0,N1,[0|L]):-
    N1 > 0,
    N is N1-1,
    ceros(0,N,L).
%---------------------------------------------------------

%Creación de un polinomio
poly(C,E,P):-
    ceros(0,E,Z),
    combina(Z,[C],P).

%Grado de un polinomio
%grado(P,G):-

%Suma de dos polinomios
suma(P1T,[],P1T):-!.
suma([],P2T,P2T):-!.
suma([P1H|P1T], [P2H|P2T], [ResH|ResT]):-
   ResH is P1H+P2H,
   suma(P1T, P2T, ResT).

%Resta de dos polinomios
resta(P1T,[],P1T):-!.
resta([],P2T,P2T):-!.
resta([P1H,P1T],[P2H,P2T],[ResH,ResT]):-
    ResH is P1H-P2H,
    resta(P1T,P2T,ResT).


