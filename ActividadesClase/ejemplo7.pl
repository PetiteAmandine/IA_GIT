gusta(jorge,X):-
    carne(X).
gusta(beatriz,X):-not(X==higado),carne(X).

carne(higado).
carne(filete).
carne(pancita).
