#№ Отчет по лабораторной работе №2
## по курсу "Логическое программирование"

## Решение логических задач

### студент: Катаев Ю.И.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Будучи логическим языком, Prolog, является отличным средством для поиска решения логических задач. Факты, соответствующие условию задачи, могут быть легко записаны в виде утверждений логики предикатов. После этого написать программу, которая будет искать решение данной задачи, не составит труда(в силу её предикатного описания). 

Существует несколько общих техник для составления программ решения различных задач. Наиболее широкой является перебор всех вариантов с последующим отсеиванием неподходящих.

Для того, чтобы выбрать только те факты, которые справедливы по условию задачи, необходимо их перечислить. Это можно сделать в виде отдельных предикатов, каждый из которых отвечает за один факт, с помощью предиката member или sublist, чтобы выполнялось условие принадлежности некоторому множеству.

Задача поиска решения для всевозможных задач одним универсальным алгоритмом алгоритмически не выполнима, т.к. не существует(пока) алгоритма, который мог бы решить любую задачу. Для каждой существуют некоторые особенности, в чем я убедился на собственном опыте.

## Задание

Вариант №23. Четверо друзей: Алексей Иванович, Федор Семенович, Валентин Петрович и Григорий Аркадьевич  были как-то со своими детьми в парке культуры и отдыха. Они катались на "колесе обозрения". В кабинах колеса оказались вместе: Леня с Алексеем Ивановичем, Андрей с отцом Коли, Тима с отцом Андрея, Федор Семенович с сыном Валентина Петровича, а Валентин Петрович с сыном Алексея Ивановича. Назовите, кто чей сын, и кто с кем катался, если известно, что ни один из мальчиков не катался со своим отцом.

## Принцип решения

```prolog
Solve = [family(lyonya, FatherL), family(andrey, FatherA), family(tima, FatherT), family(kolya, FatherK)],
Ride = [ride(lyonya, FatherT), ride(andrey, FatherK), ride(tima, FatherA), ride(kolya, FatherL)],
```
Список `Solve` содержит информацию о отцах и сыновьях. 

Список `Ride` содержит инфомацию, кто оказался на колесе обозрения в одной кабине. Факты про Андрея и Тиму уже учтены. Но сделав анализ, можно утверждать, что Коля катался с отцом Лёни, а Лёня катался с отцом Тимы. Это следует из того, что Лёня не может кататься со своим отцом.

Я перебирал только отцов, чтобы уменьшить перебор. Их набор описан в списке `fathers`.
```prolog
fathers([alexey-ivanovich, fedor-semenovich, valentin-petrovich, grigorii-arkadivich]).
```

Сам перебор был сделал с помощью `permutation`.
```prolog
fathers(Fathers),
permutation(Fathers, [FatherL, FatherA, FatherT, FatherK]),
```

Далее я пишу все факты, которые даны в условии:
```prolog
member(family(SonAI, alexey-ivanovich), Solve),
member(family(SonVP, valentin-petrovich), Solve),

member(ride(lyonya, alexey-ivanovich), Ride),
member(ride(SonAI, valentin-petrovich), Ride),
member(ride(SonVP, fedor-semenovich), Ride),
```

## Решение

```prolog
fathers([alexey-ivanovich, fedor-semenovich, valentin-petrovich, grigorii-arkadivich]).

solve :-
    Solve = [family(lyonya, FatherL), family(andrey, FatherA), family(tima, FatherT), family(kolya, FatherK)],
    Ride = [ride(lyonya, FatherT), ride(andrey, FatherK), ride(tima, FatherA), ride(kolya, FatherL)],
    fathers(Fathers),
    
    permutation(Fathers, [FatherL, FatherA, FatherT, FatherK]),
    
    member(family(SonAI, alexey-ivanovich), Solve),
    member(family(SonVP, valentin-petrovich), Solve),

    member(ride(lyonya, alexey-ivanovich), Ride),
    member(ride(SonAI, valentin-petrovich), Ride),
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
```

Ответ, который выводит программа:

```prolog
?- solve.
grigorii-arkadivich | lyonya
valentin-petrovich | andrey
alexey-ivanovich | tima
fedor-semenovich | kolya

lyonya ride with alexey-ivanovich
andrey ride with fedor-semenovich
tima ride with valentin-petrovich
kolya ride with grigorii-arkadivich
```
## Выводы

В данной лаборатоной работе я убедился, что пролог удобен для решения логических задач. Описав ряд условий, мы отсекаем неподходящие варианты и находим нужное решение. Это намного проще, чем решать вручную, если бы мы проверяли все возможные решения. 

Если такая задача одна и там немного входных данных, то проще решить ее на бумаге. На больших данных, со множеством условий, разумнее написать программу. 

Лаборатоная работа заставила меня задуматься над эффективностью программ. В первоначальном варианте решения, я перебирал не только отцов, но и сыновей. Когда я понял, что программа делает слишком много перебора, я решил переписать программу. 





