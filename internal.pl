/*
 * internal.pl - holds all internal rules and prediactes
 * 
 */

/*
 * Set a card in the hand of a player
 */
setHand(Player, Status, Card) :-
	write(Player), write('\t'), write(Status), write('\t'), write(Card), nl,
	asserta(hand(Player, Status, Card)).

/*
 * Store each question in full
 * TODO: If no one responds, then what?
 */
storeQuestion(Asker, Card1, Card2, Card3, Responder) :-
	write(Asker), write(' suspects '), write(Card1), write(Card2), write(Card3), nl, write(Responder), write(' respond'), nl.
	asserta(question(Asker, Card1, Card2, Card3, Responder)).

/*
 * Helper which returns the number of players between Begin player and End player
 */
numPlayersBetween(Begining, End, X, Count) :-
	(Begining == End ->
		X is (Count - 1);
		nextPlayer(Begining, Y),
		numPlayersBetween(Y, End, X, Count + 1)).

/*
 * forall rule which is not predefined in GNU prolog
 */
forall(Condition, Action) :-
	\+ (call(Condition), \+ call(Action)).
