/*
 * internal.pl - holds all internal rules and prediactes
 * 
 */

setHand(Player, Status, Card) :-
	write(Player), write('\t'), write(Status), write('\t'), write(Card), write('\n'),
	asserta(hand(Player, Status, Card)).

storeQuestion(Asker, Card1, Card2, Card3, Responder) :-
	write(Asker), write(' suspects '), write(Card1), write(Card2), write(Card3), write('\n'), write(Responder), write(' responds\n').
	asserta(question(Asker, Card1, Card2, Card3, Responder)).

numPlayersBetween(Begining, End, X, Count) :-
	(Begining == End ->
		X is (Count - 1);
		nextPlayer(Begining, Y),
		numPlayersBetween(Y, End, X, Count + 1)).

forall(Condition, Action) :-
	\+ (call(Condition), \+ call(Action)).
