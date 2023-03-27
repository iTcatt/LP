# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Катаев Юрий Игоревич

## Результат проверки

Вариант задания:

 - [ ] стандартный, без NLP (на 3)
 - [x] стандартный, с NLP (на 3-4)
 - [ ] продвинутый (на 3-5)
 
| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Введение

После выполнения курсового проекта я получу знания и навыки составления родословного дерева, опыт работы с форматом GEDCOM, навыки написания парсера на языке Python, навыки работы с естественным языком и поиском связей на языке пролог.

## Задание

1, 4 и 5 задания у всех одинаковые.
2) Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog с использованием предикатов `parent(родитель, ребенок)`, `sex(человек, m/f)`.
3) Реализовать предикат проверки/поиска деверя (брат мужа).

## Получение родословного дерева

Я получил родословное дерево в формате GEDCOM с помощью сайта MyHeritage.com. Там я нашел дерево последней английской правящеё династии Виндзоров, которое я и решил взять. В дереве представлено 47 человек, что позволит протестировать мою программу на правильность выполнения.

## Конвертация родословного дерева

Для парсинга файла с форматом GEDCOM выбрал Python, потому что хорошо знаю этот язык. Python часто применяется в такого рода задачах. К тому же для Python есть модуль gedcom, что существенно облегчает парсинг файлов формата GEDCOM.

С помощью модуля gedcom получаем всех членов королевской семьи. Получаем имена индивидов с помощью метода get_name объекта element класса Parser. Для этого я написал функцию grab_name, чтобы не повторять код для родителей.

```python
def grab_name(element):
    (first, last) = element.get_name()
    if last == '':
        return first
    else:
        return first + " " + last
```
Далее узнаем пол индивида с помощью метода get_gender и составляем предикат `sex`.

```python
name = grab_name(element)
gender = element.get_gender()
sex.append(f"sex('{name}', '{gender}').\n")
```
Если у индивида есть родители, то получаем их и формируем предикат child.

```python
if element.is_child():
    for parent in gedcom_parser.get_parents(element, "ALL"):
        name_parent = grab_name(parent)
        children.append(f"child('{name}', '{name_parent}').\n")
```


## Предикат поиска родственника

Деверь это брат мужа. Сначала я реализовал стандартные предикаты для поиска мужа, ребенка, брата. Затем я по определению ищу мужа жены, а затем его брата.


```prolog
male(X) :- sex(X, 'M').
female(Y) :- sex(Y, 'F').

husband(W, H) :- child(X, W), child(X, H), !, male(H), female(W).
brother(X, Y) :- child(X, Z), child(Y, Z), male(X), X \= Y.

dever(X, Y) :- husband(X, H), brother(Y, H).
```
Пример работы:
```prolog
?- dever('Catherine, Duchess of Cambridge', X).
X = 'Prince Henry, Duke of Sussex' .

dever('Meghan', X).                          
X = 'Prince William, Duke of Cambridge' .

?- dever(X, Y).
X = 'Diana, Princess of Wales',   
Y = 'Prince Andrew, Duke of York' ;
X = 'Diana, Princess of Wales',   
Y = 'Prince Andrew, Duke of York' ;
X = 'Diana, Princess of Wales',
Y = 'Prince Edward, Earl of Wessex' ;
X = 'Diana, Princess of Wales',
Y = 'Prince Edward, Earl of Wessex' ;
X = 'Catherine, Duchess of Cambridge',
Y = 'Prince Henry, Duke of Sussex' ;
X = 'Catherine, Duchess of Cambridge',
Y = 'Prince Henry, Duke of Sussex' ;
X = 'Catherine, Duchess of Cambridge',
Y = 'Prince Henry, Duke of Sussex' ;
X = 'Catherine, Duchess of Cambridge',
Y = 'Prince Henry, Duke of Sussex' ;
X = 'Catherine, Duchess of Cambridge',
Y = 'Prince Henry, Duke of Sussex' ;
X = 'Catherine, Duchess of Cambridge',
Y = 'Prince Henry, Duke of Sussex' ;
X = 'Elizabeth Bowes-Lyon',
Y = 'Edward VIII' ;
X = 'Elizabeth Bowes-Lyon',
Y = 'Edward VIII' ;
X = 'Elizabeth Bowes-Lyon',
Y = 'George, Duke of Kent' ;
X = 'Elizabeth Bowes-Lyon',
Y = 'George, Duke of Kent' ;
X = 'Elizabeth Bowes-Lyon',
Y = 'Henry, Duke of Gloucester' ;
X = 'Elizabeth Bowes-Lyon',
Y = 'Henry, Duke of Gloucester' ;
X = 'Elizabeth Bowes-Lyon',
Y = 'John' ;
X = 'Elizabeth Bowes-Lyon',
Y = 'John' .
```
## Определение степени родства

Сначала определим предикаты для определения родства индивидов. Я задал достаточно много отношений родства.
```prolog
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
```
Перемещаться по дереву я буду с помощью следующих 4 предикатов move. Они позволят мне перемещаться вертикально (от родителя к сыну и наоборот) и горизонтально (между братьями и сестрами). 
```prolog
move(A, B) :- child(A, B).
move(A, B) :- child(B, A).
move(A, B) :- sister(A, B).
move(A, B) :- brother(A, B).
```
Чтобы определить степень родства двух произвольных индивидуумов в дереве, я решил воспользоваться поиском с итерационным заглублением. Если нашлась связь между людьми, то мы, выходя из рекурсии, получаем список отношений между людьми, которые были на пути. Если же связь не нашлась, то мы делаем следующий шаг, и рекурсивно ищем относительно нового человека.
```prolog
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
```
Далее опишу предикат `relative(Res, A, B)`, который получает список, представляющий "путь родства" в дереве, и двух его индивидуумов соответственно. Он определяет все возможные степени родства (если Res переменная), с помощью поиска с итеративным заглублением. Предикат `printer(S)` печатает путь S. 

```prolog
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
```

Примеры работы предиката:
```prolog
?- relative(['parent'], X, 'Prince William, Duke of Cambridge').
Prince Charles, Prince of Wales parent of Prince William, Duke of Cambridge
X = 'Prince Charles, Prince of Wales' ;
Diana, Princess of Wales parent of Prince William, Duke of Cambridge
X = 'Diana, Princess of Wales' ;
false.

?- relative(X, 'Prince Charles, Prince of Wales', 'Princess Charlotte').
Prince Charles, Prince of Wales grandfather of Princess Charlotte
X = [grandfather] ;
Prince Charles, Prince of Wales grandparent of Princess Charlotte
X = [grandparent] ;
Prince Charles, Prince of Wales father of Princess Charlotte
X = [father, father] ;
Prince Charles, Prince of Wales parent of father of Princess Charlotte
X = [parent, father] ;
Prince Charles, Prince of Wales father of parent of Princess Charlotte
X = [father, parent] ;
Prince Charles, Prince of Wales parent of Princess Charlotte
X = [parent, parent] ;
Prince Charles, Prince of Wales son of father of grandfather of Princess Charlotte
X = [son, father, grandfather] .
```

## Естественно-языковый интерфейс
Моя программа способна интерпретировать несколько основных типов вопросов:

1. Who is A to B?, где A и B - это некие люди. Этот вопро вызывает стандартный предикат поиска родственников.
```prolog
question(['Who', 'is', R1, 'to', R2,'?'], Ans) :-
    relation(R1, R2, Ans).
```
Пример работы:
```prolog
?- question(['Who','is','dever','to','Meghan','?'], Ans).  
Ans = 'Prince William, Duke of Cambridge' ;
```
2. How many T does A have?, где Т - это одно из ключевых слов (siblings, ancestors, children, descendants, zolovka), а А - человек, количество соответствующих родственников которого и находится при помощи нахождения количества ответов к следующему вопросу.
```prolog
question(['How', 'many', T, 'does', R1, 'have', '?'], Ans) :-
    (T = 'siblings', findall(R2, sibling(R1, R2), A), length(A, Ans));
    (T = 'children', findall(R2, parent(R1, R2), A), length(A, Ans));
    (T = 'parents', findall(R2, child(R1, R2), A), length(A, Ans));
    (T = 'grandparents', findall(R2, grandchild(R1, R2), A), length(A, Ans));
    (T = 'devers', findall(R2, dever(R1, R2), A), length(A, Ans));
    (T = 'grandchildren', findall(R2, grandparent(R1, R2), A), length(A, Ans)).
```
Пример работы:
```prolog
?- question(['How', 'many', 'children', 'does', 'Prince William, Duke of Cambridge', 'have', '?'], Ans). 
Ans = 3 ;
false.
```

3. Who are T of A?, где Т - это одно из все тех же ключевых слов, а А - человек, соответствующих родственников которого находит предикат.
```prolog
question(['Who', 'are', T, 'of', R2,'?'], Ans) :-
    (T = 'siblings', sibling(R2, Ans));
    (T = 'children', parent(R2, Ans));
    (T = 'parents', child(R2, Ans));
    (T = 'grandparents', grandchild(R2, Ans));
    (T = 'devers', dever(R2, Ans));
    (T = 'grandchildren', grandparent(R2, Ans)).
```
Пример работы:
```prolog
?- question(['Who', 'are', 'grandchildren', 'of', 'Prince Charles, Prince of Wales','?'], Ans). 
Ans = 'Prince George' ;
Ans = 'Princess Charlotte' ;
Ans = 'Prince Louis' ;
Ans = 'Archie'.
```

## Выводы

Я поработал с GEDCOM файлами и научился парсить их на ЯП Python.
Я научился работать с естественно-языковым интерфейсом на Prolog. Я смог приметить знания и навыки, полученные в ходе выполнения лабораторных работ, например, поискс итеративным погружением. Я ещё раз смог поработать с базой данных на языке пролог. 
Курсовой проект научил меня использовать Prolog в более обширных проектах, требующих скоординированного взаимодействия нескольких программ, написанных на разных языках.
