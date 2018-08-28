%El fallo fail su valor logico siempre es falso. Hace que el programa se
% regrese a su ultimo punto de retroceso (:-)
saludos:-
    prolog_pais(Pais),
    write("Hola "),
    write(Pais),
    nl,
    fail.
saludos.
%prolog_pais(o).
prolog_pais(japon).
prolog_pais(francia).
prolog_pais(hungria).
prolog_pais(bhutan).
prolog_pais(kenya).
prolog_pais(suriname).





