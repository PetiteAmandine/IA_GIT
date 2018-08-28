grande(bisonte).
grande(oso).
grande(elefante).
chico(gato).
cafe(bisonte).
cafe(oso).
negro(gato).
gris(elefante).
oscuro(Z):-
    cafe(Z).
oscuro(Z):-
    negro(Z).

%?-oscuro(X),grande(X),wirte(X),nl,fail.
