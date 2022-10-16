% Task 2: Relational Data

% The line below imports the data
:- ['four.pl'].

% 1. Для каждого студента, найти средний балл, и сдал ли он экзамены или нет

% сумма переданного списка
sum_list([], 0).
sum_list([Head|Tail], N) :-
    sum_list(Tail, N1),
    N is N1 + Head.

% средней балл
average_mark(List, Avg) :-
    sum_list(List, Sum),
    length(List, Len),
    Avg is Sum / Len.

% на основе списка говорит сдал ли студент
passed(List, Result) :-
    (member(2, List), Result = 'Не сдал');
    (not(member(2, List)), Result = 'Cдал').

% Для каждого студента, нахождение средниго балла, и сдал ли он экзамены или нет
student(Student, Average_mark, Result) :-
    group(_, Names),
    member(Student, Names),
    findall(Mark, (subject(_, Grades), member(grade(Student, Mark), Grades)), List), % нашел cписок оценок студента
    passed(List, Result),
    average_mark(List, Average_mark).

% 2. Для каждого предмета, найти количество не сдавших студентов

%считает количество не сдавших студентов для одного предмета
counter([], 0).
counter([grade(_, 2)|T], N) :- 
    counter(T, N1),
    N is N1 + 1.
counter([grade(_, X)|T], N) :-
    X \= 2,
    counter(T, N).

% количество не сдавших студентов для каждого предмета
grade2(Subject, Result) :-  
    subject(Subject, Grades),
    counter(Grades, Result).

% 3. Для каждой группы, найти студента (студентов) с максимальным средним баллом

% максимум из двух чисел
mymax(X, Y, Res) :-
    (X >= Y, Res = X);
    (X < Y, Res = Y).

% нахождение максимального среднего балла
search_max([], 0).
search_max([Head|Tail], Max) :- 
    search_max(Tail, Max1),
    mymax(Head, Max1, Max).
    
% нахождение студентов с максимальным средним баллом
max_average(Group, Student, Max) :-
    group(Group, Names),
    findall(Average_mark, (member(X, Names), student(X, Average_mark, _)), List),
    search_max(List, Max),
    member(Student, Names),
    student(Student, Avg, _),
    Avg == Max.