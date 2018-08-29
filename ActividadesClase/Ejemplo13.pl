repite.
repite:-
    repite.
%repite es no determinístico entonces provoca un punto de retroceso

lee_valores:-
    repite,%repite funciona como un punto de retroceso (simula un while)
    read(X),
    write(X),
    nl,
    X==ya. %cuando el dato leído sea "ya" se detiene (salida del while)
