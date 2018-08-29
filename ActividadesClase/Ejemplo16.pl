:-dynamic pais/1.

pais(holanda).
pais(francia).

repite.
repite:-
    repite.

escribe_paises:-
    pais(X),
    %X\==ya,
    write(X),
    nl,
    fail.
escribe_paises.

main:-
    write("Dame los nombres de varios países y escribe ya para terminar"),
    nl,
    repite,
    read(Pais),
    assert(pais(Pais)),
    Pais==ya, %todo desde repetir se va a repetir mientras Pais no sea "ya"
    retract(pais(Pais)), %quita "ya" de la base
    escribe_paises. %escribe todos los países de la base de datos
