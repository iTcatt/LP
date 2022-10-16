% М8О-210Б-21 Катаев Юрий

% Реализация стандартных предикатов
% Длина списка
list_length([], 0). 
list_length([_|Y], N) :- 
    length(Y, N1), 
    N is N1 + 1.

% Нахождение элемента в списке
list_member(A, [A|_]).
list_member(A, [_|Z]) :- list_member(A, Z).

% Конкатенация двух списков
list_append([], X, X).
list_append([A|X], Y, [A|Z]) :- list_append(X, Y, Z).

% Удаление элемента из списка
list_remove(X, [X|T], T).
list_remove(X, [Y|T], [Y|T1]) :- list_remove(X, T, T1).

%
mysublist(S, L) :-
    list_append(_, L1, L),
    list_append(S, _, L1).

% Перестановки
list_permute([],[]).
list_permute(L, [X|T]):- 
    list_remove(X, L, R),
    list_permute(R, T).

% Удаление N первых элементов со стандартными предикатами
del_n_first1(X, 0, X).
del_n_first1(List, N, Result) :- 
    list_append([_], Y, List),
    del_n_first1(Y, N1, Result),
    N is N1 + 1.

% Удаление первых элементов без стандартных предикатов
del_n_first2(X, 0, X).
del_n_first2([_|Tail], N, Result) :-
    del_n_first2(Tail, N1, Result),
    N is N1 + 1.

% Вычисление числа вхождения 1-го элемента без стандартных предикатов
first_counter1([Head|Tail], N) :-
    counter1([Head|Tail], Head, N).

counter1([], _ , 0).
counter1([Head|Tail], Head, N) :-
    counter1(Tail, Head, N1),
    N is N1 + 1.
counter1([X|Tail], Head, N) :-
    X \= Head,
    counter1(Tail, Head, N).

% Вычисление числа вхождения 1-го элемента со стандартными предикатами
first_counter2([Head|Tail], Res) :-
    appender([Head|Tail], Head, New),
    list_length(New, Res).

appender([], _, []).
appender([Head|Tail], Head, New) :-
    list_append([Head], New1, New),
    appender(Tail, Head, New1).
appender([X|Tail], Head, New) :-
    X \= Head,
    appender(Tail, Head, New).


    






    


