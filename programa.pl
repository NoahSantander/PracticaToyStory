dueno(andy, woody, 8).
dueno(andy, buzz, 8).
dueno(sam, jessie, 3).

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(senorCaraDePapa, caraDePapa([original(pieIzquierdo), original(pieDerecho)], repuesto(nariz))).

esRaro(deAccion(stacyMalibu, 1, [sombrero])).

esColeccionista(sam).

% 1.a
% conocerTematica/2 Relaciona la forma de un juguete con su tematica
conocerTematica(deTrapo(Tematica), Tematica).
conocerTematica(deAccion(Tematica, _), Tematica).
conocerTematica(miniFiguras(Tematica, _), Tematica).

% tematica/2 Relaciona a un juguete con su temática
tematica(Juguete, caraDePapa):-
    juguete(Juguete, caraDePapa(_)).

tematica(Juguete, Tematica):-
    juguete(Juguete, Forma),
    conocerTematica(Forma, Tematica).

% 1.b
% esDePlastico/1 Saber si un juguete es de plastico
esDePlastico(Juguete):-
    juguete(Juguete, miniFiguras(_, _)).
esDePlastico(Juguete):-
    tematica(Juguete, caraDePapa).

% 1.c
% esDeColeccion/1 Saber si un juguete es de coleccion
esDeColeccion(Juguete):-
    juguete(Juguete, deTrapo(_)).

esDeColeccion(Juguete):-
    esRaro(deAccion(Juguete, _, _)).

esDeColeccion(Juguete):-
    esRaro(caraDePapa(Juguete, _, _)).

% 2
tieneHaceMenosTiempo(Dueno, Juguete1, Juguete2):-
    dueno(Dueno, Juguete1, Year1),
    dueno(Dueno, Juguete2, Year2),
    Year1 > Year2.

esDetrapo(Juguete):-
    juguete(Juguete, deTrapo(_)).

% amigoFiel/2 Relaciona a un dueño con el nombre del juguete que no sea de plástico que tiene hace más tiempo
amigoFiel(Dueno, Juguete):-
    dueno(Dueno, Juguete, _),
    forall(esDetrapo(Juguete), not(tieneHaceMenosTiempo(Dueno, _, Juguete))).

% 3
% esPiezaOriginal Saber si una pieza es original
esPiezaOriginal(caraDePapa(Piezas)):-
    member(original(_), Piezas).

esPiezaOriginal(deAccion(_, Piezas)):-
    member(original(_), Piezas).

% tienePiezasOriginales/1 Saber si un juguete tiene todas sus piezas originales
tienePiezasOriginales(Juguete):-
    forall(juguete(Juguete, Forma), esPiezaOriginal(Forma)).

% superValioso/1 Saber los juguetes de colección que tengan todas sus piezas originales, y que no estén en posesión de un coleccionista
superValioso(Juguete):-
    esDeColeccion(Juguete),
    esColeccionista(Coleccionista),
    not(dueno(Coleccionista, Juguete, _)),
    tienePiezasOriginales(Juguete).

% 4
% hacenBuenaPareja/2 Relaciona dos juguetes de la misma tematica
hacenBuenaPareja(woody, buzz).
hacenBuenaPareja(Juguete1, Juguete2):-
    Juguete1 \= Juguete2,
    tematica(Juguete1, Tematica),
    tematica(Juguete2, Tematica).

% duoDinamico/3 Relaciona un dueño y a dos nombres de juguetes que le pertenezcan que hagan buena pareja
duoDinamico(Dueno, Juguete1, Juguete2):-
    dueno(Dueno, Juguete1, _),
    dueno(Dueno, Juguete2, _),
    hacenBuenaPareja(Juguete1, Juguete2).

% 5
calcularFelicidad(_, Juguete, Felicidad):-
    juguete(Juguete, miniFiguras(_, CantFiguras)),
    Felicidad is CantFiguras*20.

calcularFelicidad(_, Juguete, 100):-
    juguete(Juguete, deTrapo(_)).

calcularFelicidad(_, Juguete, Felicidad):-
    juguete(Juguete, caraDePapa(Piezas)),
    findall(PiezaOriginal, member(original(_), Piezas), ListaOriginales),
    findall(PiezaRepuesto, member(repuesto(_), Piezas), ListaRepuestos),
    length(ListaOriginales, CantOriginales),
    length(ListaRepuestos, CantRepuestos),
    Felicidad is (CantOriginales*5) + (CantRepuestos*8).

calcularFelicidadJuguetes(Dueno, [], 0).

calcularFelicidadJuguetes(Dueno, [Juguete], Felicidad):-
    calcularFelicidad(Dueno, Juguete, Felicidad).

calcularFelicidadJuguetes(Dueno, [Juguete|JuguetesSiguientes], FelicidadTotal):-
    calcularFelicidad(Dueno, Juguete, FelicidadActual),
    calcularFelicidadJuguetes(Dueno, JuguetesSiguientes, FelicidadSiguiente),
    FelicidadTotal is FelicidadActual + FelicidadSiguiente.

% felicidad/2 Relaciona un dueño con la cantidad de felicidad que le otorgan todos sus juguetes
felicidad(Dueno, FelicidadTotal):-
    findall(Jueguete, dueno(Dueno, Jueguete, _), ListaJuguete),
    calcularFelicidadJuguetes(Dueno, ListaJuguete, FelicidadTotal).
    
% 6
cantJuguetesDueno(Dueno, CantJuguetes):-
    findall(Jueguete, dueno(Dueno, Jueguete, _), ListaJuguete),
    length(ListaJuguete, CantJuguetes).

amigoQuePresta(Jugador, Amigo):-
    Jugador \= Amigo,
    cantJuguetesDueno(Jugador, CantJugador),
    cantJuguetesDueno(Amigo, CantAmigo),
    CantAmigo > CantJugador.

% puedeJugarCon/2 Relaciona a alguien con un nombre de juguete cuando puede jugar con él
puedeJugarCon(Jugador, Juguete):-
    dueno(Jugador, Juguete, _).

puedeJugarCon(Jugador, Juguete):-
    not(dueno(Jugador, Juguete, _)),
    dueno(Amigo, _, _),
    amigoQuePresta(Jugador, Amigo).
    puedeJugarCon(Amigo, Juguete).

% 7

% 8
% El polimorfismo se aprovecho en piezaOriginal