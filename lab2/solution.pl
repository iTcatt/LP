fathers([alexey-ivanovich, fedor-semenovich, valentin-petrovich, grigorii-arkadivich]).

solve :-
    Solve = [family(lyonya, FatherL), family(andrey, FatherA), family(tima, FatherT), family(kolya, FatherK)],
    Ride = [ride(lyonya, FatherT), ride(andrey, FatherK), ride(tima, FatherA), ride(kolya, FatherL)],
    fathers(Fathers),
    
    permutation(Fathers, [FatherL, FatherA, FatherT, FatherK]),
    
    member(family(SonAI, alexey-ivanovich), Solve),
    member(ride(SonAI, valentin-petrovich), Ride),
    
    member(ride(lyonya, alexey-ivanovich), Ride),

    member(family(SonVP, valentin-petrovich), Solve),
    member(ride(SonVP, fedor-semenovich), Ride),

    write(FatherL), write(' | lyonya'), nl,
    write(FatherA), write(' | andrey'), nl,
    write(FatherT), write(' | tima'), nl,
    write(FatherK), write(' | kolya'), nl,

    nl, 
    write('lyonya ride with '), member(ride(lyonya, X), Ride), write(X), nl,
    write('andrey ride with '), member(ride(andrey, Y), Ride), write(Y), nl,
    write('tima ride with '), member(ride(tima, Z), Ride), write(Z), nl,
    write('kolya ride with '), member(ride(kolya, W), Ride), write(W), nl.
