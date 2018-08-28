%combina(i,i,o). i->input/instantiated
%combina(i,i,i). o->output,open
%Si entregan una lista vacia y una lista, devolver la lista dada
%Condicion que dice que termina
combina([],Lista,Lista):-!.
% Combina la cabeza y cola de una lista con lista2, donde la cabeza de
% la tercera lista esta siendo concatenada al inicio
combina([X|Lista1],Lista2,[X|Lista3]):-
    combina(Lista1,Lista2,Lista3).

