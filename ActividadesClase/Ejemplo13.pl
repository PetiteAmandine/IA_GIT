repite.
repite:-
    repite.
%repite es no determin�stico entonces provoca un punto de retroceso

lee_valores:-
    repite,%repite funciona como un punto de retroceso (simula un while)
    read(X),
    write(X),
    nl,
    X==ya. %cuando el dato le�do sea "ya" se detiene (salida del while)
