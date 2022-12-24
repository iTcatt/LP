prefix(X, Y, OP, Ans) :- 
    append(X, Y, R),
    append(OP, R, Ans).

calculate([N], [N]).
calculate(Seq, Ans) :- append(A, ['-'|B], Seq), calculate(A, X), calculate(B, Y), !, prefix(X, Y, ['-'], Ans).
calculate(Seq, Ans) :- append(A, ['+'|B], Seq), calculate(A, X), calculate(B, Y), !, prefix(X, Y, ['+'], Ans).
calculate(Seq, Ans) :- append(A, ['*'|B], Seq), calculate(A, X), calculate(B, Y), !, prefix(X, Y, ['*'], Ans).
calculate(Seq, Ans) :- append(A, ['/'|B], Seq), calculate(A, X), calculate(B, Y), !, prefix(X, Y, ['/'], Ans).
calculate(Seq, Ans) :- append(A, ['^'|B], Seq), calculate(A, X), calculate(B, Y), !, prefix(X, Y, ['^'], Ans).
%calculate([5, '+', 2,'*', 3], X).
