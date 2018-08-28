/* Este es un comentario */
% Éste tambien es un comentario

% El predicado de hombre tiene un argumento cuyo valor es el nombre de
% un hombre
hombre(jose).
hombre(juan).
mujer(maria).
% El primer argumento del predicado "papa" debe der el nombre de un
% papá, el segundo argumento es el nombre de su hije.
papa(juan,jose).
papa(juan,maria).
valioso(dinero).
dificilDeObtener(dinero).
le_da(pedro,libro,antonio).

hermana(X,Y):-
    papa(Z,X),
    mujer(X),
    papa(Z,Y),
    X\==Y.
hijo(X,Y):-
    papa(Y,X),
    hombre(X).
humano(X):-
    hombre(X);
    mujer(X).
/* Una forma de establecer reglas
humano(X):-
    mujer(X).
humano(X):-
    hombre(X).
*/

