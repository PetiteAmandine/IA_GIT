gusta(jorge,X):-
    carne(X).
gusta(beatriz,X):-
    X==higado,!,fail. %Utilizamos el corte y fail para excluir fallos
gusta(beatriz,X):-
    carne(X).

carne(higado).
carne(filete).
carne(pancita).
