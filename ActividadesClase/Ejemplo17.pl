:-dynamic antes_de/2. %el 2 indica que antes_de lleva dos argumentos

antes_de(ayer,hoy).
antes_de(hoy,maniana).

% uno: revisa que antes_de(ayer,maniana) todavía no está en la base de
% conocimientos
% dos: agrega la regla antes_de(X,Y) para verificar
% antes_de(ayer,maniana)
% tres: agrega antes_de(ayer,maniana) a la base de conocimientos
main:-
    not(antes_de(ayer,maniana)),write("uno"),nl,
    assert((antes_de(X,Y):-antes_de(X,Z),antes_de(Z,Y))), %con este assert agregamos una regla
    write("dos"),nl,
    antes_de(ayer,maniana),write("tres"),nl,!.



