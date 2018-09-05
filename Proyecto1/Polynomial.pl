%Programa para manejar polinomios de una sola variable y sus distintas
% operaciones
% Autores: Amanda Velasco y Octavio Ordaz

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
grado([],-1):-!.
grado([_|Resto],G):-
    grado(Resto,Grad),
    G is Grad+1.

%Multiplicacion por un escalar
escalar([],_,[]):-!.
escalar([P1H|P1T],Esca,[ResH|ResT]):-
    ResH is P1H*Esca,
    escalar(P1T,Esca,ResT).

%Suma de dos polinomios
suma(P1T,[],P1T):-!.
suma([],P2T,P2T):-!.
suma([P1H|P1T], [P2H|P2T],[ResH|ResT]):-
   ResH is P1H+P2H,
   suma(P1T, P2T, ResT).

%Resta de dos polinomios
resta(P1T,[],P1T):-!.
resta([],P2T,Res):-
    escalar(P2T,-1,Res).
resta(P1,P2,Res):-
    escalar(P2,-1,Aux),
    suma(P1,Aux,Res).

%Multiplicacion de polinomios
mult(_,[],[]):-!.
mult([],_,[]):-!.
mult([P1H|P1T],P2,Res):-
    mult(P1T,P2,Temp),
    escalar(P2,P1H,Aux),
    suma([0|Temp],Aux,Res).

%Evaluación de un polinomio P en un valor x
evalua([],_,0):-!.
evalua([PH|PT],X,Res):-
        evalua(PT,X,Resul),
        Res is PH+X*Resul.

%Derivada de un polinomio
deriv(P,Res):-
    grado(P,G),
    deriv(P,G,Res).
deriv([],_,[]):-!.
deriv(_,0,0):-!.
deriv([PH|PT],G,[ResH|ResT]):-
    deriv(PT,GN,ResT),
    ResH is G*PH,
    GN is G-1.




