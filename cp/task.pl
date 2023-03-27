:- consult('data.pl').

% Task 3 dever - brother of husband

male(X) :- sex(X, 'M').
female(Y) :- sex(Y, 'F').

husband(W, H) :- child(X, W), child(X, H), male(H), female(W).
wife(H, W) :- child(X, H), child(X, W), female(W), male(H).

parent(P, C) :- child(C, P).
father(P, C) :- child(C, P),!, male(P).
mother(P, C) :- child(C, P),!, female(P).

daughter(X, Y) :- female(X), child(X, Y).
son(X, Y) :- male(X), child(X, Y).

sister(X, Y) :- child(X, Z), child(Y, Z), female(X), X \= Y.
brother(X, Y) :- child(X, Z), child(Y, Z),male(X), X \= Y.
sibling(X, Y) :- child(X, Z), child(Y, Z), X \= Y.

granddaughter(X, Y) :- child(X, Z), child(Z, Y), female(X).
grandson(X, Y) :- child(X, Z), child(Z, Y), male(X).
grandchild(X, Y) :- child(X, Z), child(Z, Y).

grandmother(X, Y) :- child(Z, X), child(Y, Z), female(X).
grandfather(X, Y) :- child(Z, X), child(Y, Z), male(X).
grandparent(X, Y) :- child(Z, X), child(Y, Z).

dever(X, Y) :- husband(X, H), brother(Y, H).

% Task 4

relation('father', M, C) :- father(M, C).
relation('mother', F, C) :- mother(F, C).
relation('parent', P, C) :- parent(P, C).

relation('grandmother', GM, C) :- grandmother(GM, C).
relation('grandfather', GF, C) :- grandfather(GF, C).
relation('grandparent', GP, C) :- grandparent(GP, C).

relation('son', C, P) :- son(C, P).
relation('daughter', C, P) :- daughter(C, P).
relation('child', C, P) :- child(C, P).

relation('grandson', GC, P) :- grandson(GC, P).
relation('granddaughter', GC, P) :- granddaughter(GC, P).
relation('grandchild', GC, P) :- grandchild(GC, P).

relation('brother', A, B) :- brother(A, B).
relation('sister', A, B) :- sister(A, B).
relation('sibling', C, P) :- sibling(C, P).

relation('dever', A, B) :- dever(A, B).

move(A, B) :- child(A, B).
move(A, B) :- child(B, A).
move(A, B) :- sister(A, B).
move(A, B) :- brother(A, B).

int(A, B, C) :-
    A = B, A < C;
    B1 is B + 1,
    B1 < C,
    int(A, B1, C).

search_id(Path, A, B, N) :-
    N = 1,
    relation(Type, A, B),
    Path = [Type].

search_id(Path, A, B, N) :-
    N > 1,
    move(A, C),
    N1 is N - 1,
    search_id(Res, C, B, N1),
    relation(Type, A, C),
    append([Type], Res, Path).

    printer([]).
    printer([H|T]) :-
    write(H), write(' of '),
    delete([H|T], H, T1),
    printer(T1).

relative(Res, A, B) :-
    int(N, 1, 6),
    search_id(Res, A, B, N),
    B \= A, write(A), write(' '),
    printer(Res), write(B).

% Task 5
question(['Who', 'is', R1, 'to', R2,'?'], Ans) :-
    relation(R1, R2, Ans).

question(['How', 'many', T, 'does', R1, 'have', '?'], Ans) :-
    (T = 'siblings', findall(R2, sibling(R1, R2), A), length(A, Ans));
    (T = 'children', findall(R2, parent(R1, R2), A), length(A, Ans));
    (T = 'parents', findall(R2, child(R1, R2), A), length(A, Ans));
    (T = 'grandparents', findall(R2, grandchild(R1, R2), A), length(A, Ans));
    (T = 'devers', findall(R2, dever(R1, R2), A), length(A, Ans));
    (T = 'grandchildren', findall(R2, grandparent(R1, R2), A), length(A, Ans)).

question(['Who', 'are', T, 'of', R2, '?'], Ans) :-
    (T = 'siblings', sibling(R2, Ans));
    (T = 'children', parent(R2, Ans));
    (T = 'parents', child(R2, Ans));
    (T = 'grandparents', grandchild(R2, Ans));
    (T = 'devers', dever(R2, Ans));
    (T = 'grandchildren', grandparent(R2, Ans)).    