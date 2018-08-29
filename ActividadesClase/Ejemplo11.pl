%Imprime combinaciones (con orden) de una lista
combina([X|Lista1],Lista2,[X|Lista3]):-
    combina(Lista1,Lista2,Lista3).
combina([],Lista,Lista):-!.
