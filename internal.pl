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
 * Extension of ai_suspects. This is where the AI grabs what it wants to find
 * more information on
 * This is an important part of the AI that is essentially the BRAIN!
 */
suspect(Type, CardOut) :-
	card(Type, CardOut),
	\+ hand(CardOut, has, _),
	\+ hand(CardOut, hasnot, _).

/*
 * Elliminate any repeat cards in questions where possible
 *
 * Mrs.White suggests :
 *
 * Mustard with Knife in the Kitchen.
 * 	and Mrs. Peacock says she has no card.
 * But previously, Miss Scarlet suggested
 * 	Mustard with the rope in the kitchen.
 */
eliminateExcess(Asker, Card1, Card2, Card3, Responder) :-
	question(_, Card1, Y, Z, Responder),
	(Y \== Card2, Z \== Card3)
		->	setHand(Responder, has, Card1)
		;	write('No Knowledge gained from '), write(Card1), nl
	),
	question(_, _, Card2, _, Responder),
	(X \== Card1, Z \== Card3)
		->	setHand(Responder, has, Card2)
		;	write('No Knowledge gained from '), write(Card2), nl
	question(_, _, _, Card3, Responder),
	(X \== Card1, Y \== Card2)
		->	setHand(Responder, has, Card3)
		;	write('No Knowledge gained from '), write(Card3), nl
	).

/*
 * forall rule which is not predefined in GNU prolog
 */
forall(Condition, Action) :-
	\+ (call(Condition), \+ call(Action)).
