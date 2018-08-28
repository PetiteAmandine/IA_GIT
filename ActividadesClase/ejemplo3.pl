valor_max(X,Y,X):-
    X>Y.
valor_max(X,Y,Y):-
    X=<Y.
%Utilizando el operador "cut" (corte)
valor_max(X,Y,X):-
    X>Y,!.
valor_max(_,Y,Y).
