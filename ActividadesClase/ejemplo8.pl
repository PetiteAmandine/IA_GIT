/*
 * Aridad: cantidad de argumentos que requiere un predicado.
 * Predicados de orden:
 *  CERO: sus argumentos son solo constantes
 *  UNO: variables entre sus argumentos
 *  DOS: hay otros predicados como entre sus argumentos
 * Un functor es un predicado que se usa como argumento de otro
 * predicado.
*/
evento(siglo15, "Portugueses y españoles exploran Africa, America y Asia").
evento(siglo16, "Leonardo da Vinci pinta la Mona Lisa").
evento(siglo17, "Construccion del Taj Mahal").
evento(siglo18, "Benjamin Franklin inventa los lentes").
evento(siglo19, "Independencia de Mexico").
evento(siglo20, "Invencion de Internet").
evento(siglo21, "11-S").

antes_de(evento(siglo15,_),evento(siglo16,_)).
antes_de(evento(siglo16,_),evento(siglo17,_)).
antes_de(evento(siglo17,_),evento(siglo18,_)).
antes_de(evento(siglo18,_),evento(siglo19,_)).
antes_de(evento(siglo19,_),evento(siglo20,_)).
antes_de(evento(siglo20,_),evento(siglo21,_)).
antes_de(X,Y):-
    antes_de(X,Z),
    antes_de(Z,Y).



