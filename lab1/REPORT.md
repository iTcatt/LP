# Отчет по лабораторной работе №1
## Работа со списками и реляционным представлением данных
## по курсу "Логическое программирование"

### студент: Катаев Ю.И.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Все структурные объекты Пролога — это деревья. Списки не являются исключением из этого правила. Список в прологе отличается от списков в императивных языках. Во-первых, обработка списков осуществляется при помощи рекурсии, разделяя список на голову и хвост, в то время как в императивных языках, чтобы обратиться к какому-то элементу списка, можно использовать итераторы. Во-вторых, элементы списка в Прологе могут быть любого типа. В конце концов, не во всех императивных языках программирования реализованы списки. 

Списки Prolog напоминают массивы в других императивных языках. (В Python объявление списка выглядит так: "List = [1, 2, 3]", в Прологе - "List = [1, 2, 3].". Отличия только в точке у Prolog). Но все же к элементам массива мы имеем произвольный доступ, чего не скажешь о списках.
## Задание 1.0: Стандартные предикаты

`list_length(List, N)` - длина списка

Примеры использования:
```prolog
?- list_length([], N). 
N = 0.

?- list_length([1,2,3], N).
N = 3.
```

Реализация:
```prolog
list_length([], 0). 
list_length([_|Y], N) :- 
    length(Y, N1), 
    N is N1 + 1.
```

`list_member(X, List)` - нахождение элемента в списке

Примеры использования:
```prolog
?- list_member(2, [1,2,3,4]).
true .

?- list_member(5, [1,2,3]).
false.
```

Реализация:
```prolog
list_member(A, [A|_]).
list_member(A, [_|Z]) :- list_member(A, Z).
```

`list_append(List1, List2, Result)` - конкатенация двух списков

Примеры использования:
```prolog
?- list_append([1,2], [3,4,5], X).  
X = [1, 2, 3, 4, 5].

?- list_append([1,2], [], X).      
X = [1, 2].
```

Реализация:
```prolog
list_append([], X, X).
list_append([A|X], Y, [A|Z]) :- list_append(X, Y, Z).
```

`list_remove(X, List, Result)` - удаление элемента из списка

Примеры использования:
```prolog
?- list_remove(2, [1,2,3], Res).
Res = [1, 3] .

?- list_remove(3, [1,2,3], Res). 
Res = [1, 2] .
```

Реализация:
```prolog
list_remove(X, [X|T], T).
list_remove(X, [Y|T], [Y|T1]) :- list_remove(X, T, T1).
```

`mysublist(S, L)` - все подсписки списка

Примеры использования:
```prolog
?- mysublist(S, [a,b]).
S = [] ;
S = [a] ;
S = [a, b] ;
S = [] ;
S = [b] .
```

Реализация:
```prolog
mysublist(S, L) :-
    list_append(_, L1, L),
    list_append(S, _, L1).
```

`list_permute(List, Result)` - перестановки

Примеры использования:
```prolog
?- list_permute([a,b,c], X). 
X = [a, b, c] ;
X = [a, c, b] ;
X = [b, a, c] ;
X = [b, c, a] ;
X = [c, a, b] ;
X = [c, b, a] .
```

Реализация:
```prolog
list_permute([],[]).
list_permute(L, [X|T]):- 
    list_remove(X, L, R),
    list_permute(R, T).
```
## Задание 1.1: Предикат обработки списка
### Удаление N первых элементов
`del_n_first1(List, N, Result)` -  со стандартными предикатами

`del_n_first2(List, N, Result)` - без стандартных предикатов

Примеры использования:
```prolog
?- del_n_first1([1,2,3,4,5], 3, Result).
Result = [4, 5].
?- del_n_first2([1,2,3], 3, Result).
Result = [].
```

Реализация с использованием стандартных предикатов:
```prolog
del_n_first1(X, 0, X).
del_n_first1(List, N, Result) :- 
    list_append([_], Y, List),
    del_n_first1(Y, N1, Result),
    N is N1 + 1.
```

Первое условие очевидно. Если мне нужно удалить 0 первых элементов, то я должен вернуть сам список. С помощью list_append я нахожу хвост списка и передаю его в рекурсивный вызов. Так как я удалил голову, то мне остается удалить N-1 первых элементов. Поэтому в следующий рекурсивный вызов я передаю N1. 

Реализация без использования стандартных предикатов:
```prolog
del_n_first2(X, 0, X).
del_n_first2([_|Tail], N, Result) :-
    del_n_first2(Tail, N1, Result),
    N is N1 + 1.
```
Идея удаления та же. Но тут я убераю голову списка напрямую. 
## Задание 1.2: Предикат обработки числового списка
### Вычисление числа вхождения 1-го элемента
`first_counter1(List, N)` - без стандартных предикатов

`first_counter2(List, N)` - со стандартными предикатами

Примеры использования:
```prolog
?- first_counter1([1,2,3,4,5], N).
N = 1 .

?- first_counter2([1,1,1,1,1,5,1], N).
N = 6 .
```

Реализация без использования стандартных предикатов:
```prolog
first_counter1([Head|Tail], N) :-
    counter1([Head|Tail], Head, N).

counter1([], _ , 0).
counter1([Head|Tail], Head, N) :-
    counter1(Tail, Head, N1),
    N is N1 + 1.
counter1([X|Tail], Head, N) :-
    X \= Head,
    counter1(Tail, Head, N).
```
Для реализации этого предиката был создан предикат counter1, т.к. нужна еще одна переменная для хранения первого элемента. Это рекурсивная функция. Если список закончился, возвращаем 0. Дальше идет две ветки counter1. Если голова текущего списка совпадает со значением первого элемента, то вызываем эту же фунцию от хвоста и увеличиваем счёчик. А если голова не равна, то передаем хвост, а счётчик не изменяем.

Реализация c использованием стандартных предикатов:
```prolog
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
```
Для реализации этого предиката был создан предикат appender. Если в списке встречается элемент, который равен первому элементу в списке, то он добавляет его в список New. Задача этой функции - сформировать New. 

В first_counter2 вызывается предикат appender, а потом находится длина полученного списка. 
## Задание 2: Реляционное представление данных

В настоящее время наиболее популярны реляционные базы данных, в которых данные представляются в виде совокупности таблиц. Термин «реляционный» означает, что теория основана на математическом понятии отношение (relation). Поэтому реляционное представление показывает отношения между объектами. Результат запроса к таким данным - это неименованное производное отношение, удовлетворяющее внутренней структуре программы. Модель таких данных определена заранее, является строго типизированной. Задача состоит в том, чтобы реализовать такую структуру, обеспечивающую правильность и полноту ответов. Достоинством реляционного представления является простота разработки, так как программа разбивается на отдельные компоненты, которые реализуются независимо друг от друга. Кроме того, устойчивость, гибкость, масштабируемость, производительность и совместимость предполагают доминирующее положение в сфере управления данными. К недостаткам можно отнести то, что реляционные БД хорошо масштабируются только в том случае, если располагаются на единственном сервере. На сегодняшний день разнообразие приложений растет, они работают в условиях высокой нагрузки, поэтому их требования к масштабируемости возрастают. А когда ресурсы одного сервера закончатся, необходимо будет добавить больше машин и распределить нагрузку между ними. Если увеличить количество серверов не до нескольких штук, а до сотни или тысячи, то сложность возрастет на порядок, и характеристики, которые делают реляционные БД такими привлекательными, стремительно снижают к нулю шансы использовать их в качестве платформы для больших распределенных систем.

Мой вариант представления данных можно охарактеризовать как списки групп и журнал успеваемости по предметам. Трудность такого представления состоит в том, что все факты об оценках находятся внутри предиката subject, который состоит из списка функторов. Как итог, когда нужно получить информацию об оценках, не всегда удобно обращаться со списками. Нет разделения оценок по группам, они находятся в общем списке. Для работы с реляционной базой данных в прологе обычно используют стандартные предикаты asseta, assertz, retractall, consult, save и другие, но в данная лабораторная работа не предполагает модификации исходных данных, поэтому использовать их нет необходимости. Преимуществом такого представления можно отметить легкий доступ к данным, содержащим отношения "предмет-оценка", соответственно отношения "группа-предмет" создавали некоторые трудности. Если бы информация о группе находилась в функторе grade, было бы намного удобнее реализовывать некоторые предикаты. Для своего представления данных я выполнил 3 вариант.

1. Для каждого студента, найти средний балл, и сдал ли он экзамены или нет.

`student(Student, Average_mark, Result)` - для каждого студента нахождение среднего балла и сдал ли он.

Вспомогательные предикаты:

`sum_list(List, N)` - сумма списка

`average_mark(List, Avg)` - среднний балл списка

`passed(List, Result)` - сдал ли студент или нет

Примеры использования:
```prolog
?- student(Student, Avg, Res).
Student = 'Петровский',
Avg = 3.6666666666666665,
Res = 'Не сдал' ;
Student = 'Сидоров',
Avg = 3.6666666666666665,
Res = 'Не сдал' ;
Student = 'Мышин',
Avg = 4.5,
Res = 'Cдал' ;
Student = 'Безумников',
Avg = 3.6666666666666665,
Res = 'Не сдал' .
```

Реализация:
```prolog
student(Student, Average_mark, Result) :-
    group(_, Names),
    member(Student, Names),
    findall(Mark, (subject(_, Grades), member(grade(Student, Mark), Grades)), List), % нашел cписок оценок студента
    passed(List, Result),
    average_mark(List, Average_mark).
```
Первый шаг - получение списка имен для каждой группы. Далее для каждого студента из списка Names я с помощью findall формирую cписок List, в котором находятся оценки студента по всем предметам. Предикат passed на основе переданого списка говорит о том, сдал ли студент. Эту информацию он помещает в Result (реализация дальше). В конце вычисляется средний балл по списку. 

Реализация вспомогательных предикатов:
```prolog
sum_list([], 0).
sum_list([Head|Tail], N) :-
    sum_list(Tail, N1),
    N is N1 + Head.

average_mark(List, Avg) :-
    sum_list(List, Sum),
    length(List, Len),
    Avg is Sum / Len.

passed(List, Result) :-
    (member(2, List), Result = 'Не сдал');
    (not(member(2, List)), Result = 'Cдал').
```
Предикат sum_list очень прост. Я отрезаю голову от списка, и предаю хвост дальше, а голову прибавляю к результату.

Предикат passed проверяет, есть ли двойка в списке оценок студента. 

Предикат average_mark вычисляет средний балл по списку. Сначала вычисляется сумма списка, потом длина списка. В результате возвращается среднее арифметическое.

2. Для каждого предмета, найти количество не сдавших студентов

`grade2(Subject, Result)` - количество не сдавших студентов для предмета Subject

Вспомогательный предикат:

`counter(List, N)` - подчитывает количество двоек в списке

Примеры использования:
```prolog
grade2(Subject, Result).
Subject = 'Логическое программирование',
Result = 3 ;
Subject = 'Математический анализ',
Result = 1 ;
Subject = 'Функциональное программирование',
Result = 0 ;
Subject = 'Информатика',
Result = 2 ;
Subject = 'Английский язык',
Result = 2 ;
Subject = 'Психология',
Result = 2 .
```

Реализация:
```prolog
grade2(Subject, Result) :-  
    subject(Subject, Grades),
    counter(Grades, Result).
```
Идея этой функции - получить список оценок и отправить её в counter, а он уже вернет результат.

Реализация вспомогательного предиката:
```prolog
counter([], 0).
counter([grade(_, 2)|T], N) :- 
    counter(T, N1),
    N is N1 + 1.
counter([grade(_, X)|T], N) :-
    X \= 2,
    counter(T, N).
```
Если в голове мы нашли оценку 2, то увеличиваем счётчик и запускаем предикат от хвоста. Если оценка не равна 2, то рекурсия запускается от хвоста, не меняя счётчик

3. Для каждой группы, найти студента (студентов) с максимальным средним баллом

`max_average(Group, Student, Max)` - нахождение студента с максимальным средним баллом среди группы.

Вспомогательные предикаты:

`mymax(X, Y, Res)` - нахождение максимума среди двух чисел

`search_max(List, Max)` - нахождение максимума в списке

Примеры использования:
```prolog
?- max_average(Group, Student, Max).
Group = 101,
Student = 'Мышин',
Max = 4.5 ;
Group = 102,
Student = 'Биткоинов',
Max = 4.5 ;
Group = 103,
Student = 'Текстописова',
Max = 4.666666666666667 ;
Group = 104,
Student = 'Запорожцев',
Max = 4 ;
Group = 104,
Student = 'Джаво',
Max = 4 ;
Group = 104,
Student = 'Фулл',
Max = 4 .
```

Реализация:
```prolog
max_average(Group, Student, Max) :-
    group(Group, Names),
    findall(Average_mark, (member(X, Names), student(X, Average_mark, _)), List),
    search_max(List, Max),
    member(Student, Names),
    student(Student, Avg, _),
    Avg == Max.
```
Здесь я использую функцию student, которая описана выше. Я формирую список List, в котором лежат средние баллы всех студентов группы Group. Далее в полученном списке я ищу максимальный средний балл. Затем снова прохожусь по всем студентам и вычисляю их средний балл. Если он совпадает с максимумом, то он будет вывыден на экран.

Реализация вспомогательных предикатов:
```prolog
mymax(X, Y, Res) :-
    (X >= Y, Res = X);
    (X < Y, Res = Y).

search_max([], 0).
search_max([Head|Tail], Max) :- 
    search_max(Tail, Max1),
    mymax(Head, Max1, Max).
```
Нахождение максимума тривиально.
Поиск максимума в списке тоже не сложный. Нахожу максимум среди головы и текущего максимума и запускаю рекурсию от хвоста. Если я дошел до конца списка, то в максимум унифицируется 0. 
## Выводы

В результате работы я познакомился с языком Prolog, изучил представление списков в нём, узнал какие есть стандартные предикаты для обработки списков и научился реализовывать их самостоятельно.

Также я узнал о реляционном способе представления данных и научился работать с таким представлением. Проанализировал его, составил предикаты для обработки информации, представленной в таком виде.

Из этой лабораторной работы я вынес для себя важную мысль - полезно разбивать функционал предикатов на несколько, чтобы в будущем повторно их использовать. К тому же, это значительно упрощает отладку программы. Также лабораторная работа помогла мне глубже понять рекурсию.

