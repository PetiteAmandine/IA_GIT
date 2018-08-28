%El operador corte ("cut") ! su valor logico siempre es cierto. Elimina
% el mas reciente punto de retroceso
saludos:-
    prolog_pais(Pais1),
    write(Pais1),
    write(" saluda a:"),
    nl,
    !, %Elimina el punto de retroceso inicial
    prolog_pais(Pais2),
    Pais2\==Pais1,
    write(Pais2),
    nl,
    fail. %Hace que el programa regrese abajo del !, no hasta arriba
prolog_pais(japon).
prolog_pais(francia).
prolog_pais(hungria).
prolog_pais(buthan).
prolog_pais(kenya).
prolog_pais(suriname).

