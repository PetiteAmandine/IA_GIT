%Programa Para manejar polinomios de una sola variable y sus distintas
% operaciones
%Autores: Amanda Velasco y Octavio Ordaz

%Definicion de un polinomio
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
%Invierte la lista de polinomios
invierte(X,Res):-
    invierte(X,[],Res).
invierte([],Y,Y):-!.
invierte([XH|XT],Y,Res):-
    invierte(XT,[XH|Y],Res).
%---------------------------------------------------------

%Creacion de un polinomio
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

%Composición de dos polinomios P1(P2(x))
comp(_,[],[]):-!.
comp([],_,[]):-!.
comp([P1H|P1T],P2,Res):-
    comp(P1T,P2,Temp),
    poly(P1H,0,P),
    mult(P2,Temp,M),
    suma(P,M,Res).

%Evaluacion de un polinomio P en un valor x
evalua([],_,0):-!.
evalua([PH|PT],X,Res):-
        evalua(PT,X,Resul),
        Res is PH+X*Resul.

%Derivada de un polinomio
deriv(P,Res):-
    grado(P,G),
    invierte(P,Pp),
    deriv(Pp,G,Temp),
    invierte(Temp,Res).
deriv([],_,[]):-!.
deriv(_,0,[]):-!.
deriv([PH|PT],G,[ResH|ResT]):-
    ResH is PH*G,
    Gnvo is G-1,
    deriv(PT,Gnvo,ResT).
/*
deriva([PH|PT],[ResH|ResT]):-
    deriva([PH|PT],0,[ResH|ResT]).
deriva([],_,[]):-!.
deriva([PH|PT],G,[ResH|ResT]):-
    ResH is PH*G,
    Grado is G+1,
    deriva(PT,Grado,ResT).
*/

%Imprime el polinomio
verificaCC(C):-
    C == 0 -> write(""); !.
verificaCP(C,G,Fijo):-
    G == Fijo -> write(C); G == 0 -> !; C > 1 -> write("+"),write(C); !.
verificaCN(C):-
    C == -1 -> write("-"); C < -1 -> write(C); !.
verificaG(C,G):-
    C == 0 -> !; G == 0 -> write("+"),write(C); C == 1 -> write("+"); G == 1 -> write("x"); write("x^"),write(G).
imprime(P):-
    invierte(P,Pp),
    grado(P,G),
    imprime(Pp,G,G).
imprime([],_,_):-!.
imprime([PH|PT],G,Fijo):-
    verificaCC(PH),
    verificaCP(PH,G,Fijo),
    verificaCN(PH),
    verificaG(PH,G),
    Gnvo is G-1,
    imprime(PT,Gnvo,Fijo).

%---------------------------------------------------------
main:-
    %Definimos el primer polinomio
    poly(4,3,A), poly(3,2,B),
    suma(A,B,C), poly(2,1,D),
    suma(C,D,E), poly(1,0,F),
    suma(E,F,P),
    %Definimos el segundo polinomio
    poly(3,2,G), poly(5,0,H),
    suma(G,H,Q),

    %Cero
    ceros(0,1,Zero),
    %Suma de P(x)+Q(x)
    suma(P,Q,Suma),
    %Multiplicacion de P(x)*Q(x)
    mult(P,Q,Multi),
    %Composicion de P(Q(x)))
    comp(P,Q,Compo),
    %Cambio de signo
    escalar(P,-1,Minus),
    %Evaluar en P(x) con x=3
    evalua(P,3,Eval),
    %Primera derivada de P(x) con respecto a x
    deriv(P,D1),
    %Segunda derivada de P(x) con respecto a x
    deriv(D1,D2),

    %Impresiones
    write("zero(x)     = "),imprime(Zero), nl,
    write("p(x)        = "),imprime(P),    nl,
    write("q(x)        = "),imprime(Q),    nl,
    write("p(x) + q(x) = "),imprime(Suma), nl,
    write("p(x) * q(x) = "),imprime(Multi),nl,
    write("p(q(x))     = "),imprime(Compo),nl,
    write("0 - p(x)    = "),imprime(Minus),nl,
    write("p(3)        = "),write(Eval),   nl,
    write("p'(x)       = "),imprime(D1),   nl,
    write("p''(x)      = "),imprime(D2).









