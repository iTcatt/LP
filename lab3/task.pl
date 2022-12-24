% получение элемента списка
getElem([H|_], H, 0) :- !.
getElem([_|T], X, N) :-
    M is N - 1,
    getElem(T, X, M).

% свапнуть два элемента
swap(L, M, N, ResL) :-
    length(L, Len1),
    length(ResL, Len2),
    Len1 == Len2,
    append(MF, [MH|MT], L),
    append(MF, [NH|MT], Tmp),
    append(NF, [NH|NT], Tmp),
    append(NF, [MH|NT], ResL),

    length(MF, M),
    length(NF, N), !.

% элементы в правильном порядке
check_correct(L,N,M) :-
    getElem(L,X,N),
    getElem(L,Y,M),
    ((X == blue, Y == red);
    (X == blue, Y == white);
    (X == white, Y == red)), !.

% переход между состояниями
move([H|_], Res):-
    move(H, Res).

move(state(L), state(ResL)):-
    length(L, Len),
    Len1 is Len - 1,
    between(0, Len1, A),
    between(0, Len1, B),

    A < B,
    check_correct(L, A, B),
    swap(L, A, B, X),

    ResL = X.

prolong([X|T], [Y, X|T]) :-
    move(X, Y),
    not(member(Y, [X|T])).

reverse([]).
reverse([A|T]) :-
    reverse(T),
    write(A), nl.

int(1).
int(X) :-
    int(Y),
    X is Y + 1.

search_dfs(A,B) :-
    write('DFS START'), nl,
    get_time(DFS),
    dfs([A], B, L),
    reverse(L),
    get_time(DFS1),
    write('DFS END'), nl, nl,
    TIME is DFS1 - DFS,
    write('TIME IS '), 
    write(TIME), nl, nl.

dfs([X|T], X, [X|T]).
dfs(P, F, L):-
    prolong(P, P1),
    dfs(P1, F, L).

search_bfs(X, Y) :-
    write('BFS START'), nl,
    get_time(BFS),
    bfs([[X]], Y, L),
    reverse(L),
    get_time(BFS1),
    write('BFS END'), nl, nl,
    TIME is BFS1 - BFS,
    write('TIME IS '),
    write(TIME), nl, nl.

bfs([[X|T]|_], X, [X|T]).
bfs([P|QI], X, R):-
    findall(Z, prolong(P, Z), T),
    append(QI, T, Q0),
    bfs(Q0, X, R).

bfs([_|T], Y, L) :- bfs(T, Y, L).

% поиск с итерационным заглублением
search_id(Start, Finish) :-
    write('ITER START'), nl,
    get_time(ITER),
    int(DepthLimit),
    depth_id([Start], Finish, Res, DepthLimit),
    reverse(Res),
    get_time(ITER1),
    write('ITER END'), nl, nl,
    TIME is ITER1 - ITER,
    write('TIME IS '),
    write(TIME), nl, nl.

depth_id([Finish|T], Finish, [Finish|T], 0).
depth_id(Path, Finish, R, N):-
    N > 0,
    prolong(Path, NewPath),
    N1 is N - 1,
    depth_id(NewPath, Finish, R, N1).
