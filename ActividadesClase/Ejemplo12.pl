%Checa si los elementos A,B aparecen consecutivos en alg�n punto de la
% lista
consecutivos(A,B,[A,B|_]):-!.
consecutivos(A,B,[_|R]):-
             consecutivos(A,B,R).

