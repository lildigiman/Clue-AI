/*
 * internal.pl - holds all internal rules and prediactes
 * 
 */

/*
 * Set a card in the hand of a player
 */
setHand(Player, Status, Card) :-
	me(Me),
	((Player == Me)
		->	write('I tried to set my own hand'), write(Player), nl
		;	write(Player), write('\t'), write(Status), write('\t'), write(Card), nl,
			((hand(Player, X, Y), Y == Card)
				->	write('Retract: '), write(Player), write(' '), write(X), write(' '), write(Y), nl,
					retract(hand(Player, _, Card)), asserta(hand(Player, Status, Card))
				;	asserta(hand(Player, Status, Card))
			)
	).

setMyHand(Card1, Card2, Card3) :-
	me(Me),
	forall(player(X),
		(setHand(X, hasnot, Card1), setHand(X, hasnot, Card2), setHand(X, hasnot, Card3))),
	forall(card(Type, CardOut), asserta(hand(Me, hasnot, CardOut))),
	asserta(hand(Me, has, Card1)),
	asserta(hand(Me, has, Card2)),
	asserta(hand(Me, has, Card3)).

/*
 * Store each question in full
 * TODO: If no one responds, then what?
 */
storeQuestion(Asker, Card1, Card2, Card3, Refuter) :-
	write(Asker), write(' suspects '), write(Card1), write(' '), write(Card2), write(' '), write(Card3), nl, write(Refuter), write(' responded'), nl,
	asserta(question(Asker, Card1, Card2, Card3, Refuter)).

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
 * TODO:	Find maybe cards furthest from me
 *			this may require reworking the suspect/2 and ai_suspects/2
 */
suspect(Type, CardOut) :-
	card(Type, CardOut),
	hand(_, maybe, CardOut).

/*
 * Elliminate any repeat cards in questions where possible
 *
 * Mrs.White suggests :
 *
 * Mustard with Knife in the Kitchen.
 * 	and Mrs. Peacock says she has no card.
 * But previously, Miss Scarlet suggested
 * 	Mustard with the rope in the kitchen.
 *	So Mrs. Peacock must have the rope.
 * TODO: create discover function to reduce repeat code
 */

% Green, Plum, Revolver, Hall, Mustard
% Green, Green, Revolver, Hall, Plum 
eliminateExcess(Card1, Card2, Card3) :-
	write('Here'),
	me(Me),	
	(player(X),
	X \== envelope, X \== Me,
	hand(X, hasnot, Card1),
	hand(X, hasnot, Card2),
	question(_, Card1, Card2, HotCard, X)
		->	write('We did this'),
			forall((player(Players), Players \== Me, Players \== envelope),
				setHand(Players, hasnot, HotCard)),
			setHand(X, has, HotCard)
		;	write('No Question fits'), nl
	),
	(player(Y),
	Y \== envelope, Y \== Me,
	hand(Y, hasnot, Card1),
	hand(Y, hasnot, Card3),
	question(_, Card1, HotCard, Card3, Y)
		->	write('We did this'),
			forall((player(Players), Players \== Me, Players \== envelope),
				setHand(Players, hasnot, HotCard)),
			setHand(X, has, HotCard)
		;	write('No Question fits'), nl
	),
	(player(Z),
	Z \== envelope, Z \== Me,
	hand(Z, hasnot, Card2),
	hand(Z, hasnot, Card3),
	question(_, HotCard, Card2, Card3, Z)
		->	write('We did this'),
			forall((player(Players), Players \== Me, Players \== envelope),
				setHand(Players, hasnot, HotCard)),
			setHand(X, has, HotCard)
		;	write('No Question fits'), nl
	),

	/* If all players don't have a card, then the envelope has it */
	((allHaveNot(Card1), \+ hand(envelope, has, Card1))
		->	retract(hand(envelope, _, Card1)),
			asserta(hand(envelope, has, Card1))
		;	write(Card1), write(' Not Enough Evidence'), nl),	
	((allHaveNot(Card2), \+ hand(envelope, has, Card2))
		->	retract(hand(envelope, _, Card2)),
			asserta(hand(envelope, has, Card2))
		;	write(Card2), write(' Not Enough Evidence'), nl),	
	((allHaveNot(Card3), \+ hand(envelope, has, Card3))
		->	retract(hand(envelope, _, Card3)),
			asserta(hand(envelope, has, Card3))
		;	write(Card3), write(' Not Enough Evidence'), nl).

/*
 * Returns true when all players don't have a card
 */
allHaveNot(Card) :-
	hand(green, hasnot, Card),
	hand(plum, hasnot, Card),
	hand(mustard, hasnot, Card),
	hand(peacock, hasnot, Card),
	hand(scarlet, hasnot, Card),
	hand(white, hasnot, Card).

/*
 * forall rule which is not predefined in GNU prolog
 */
forall(Condition, Action) :-
	\+ (call(Condition), \+ call(Action)).

/*
 * Printout
 */
printout :-
	forall(player(X), forall(hand(X, Y, Z), (write(X), write(' '), write(Y), write(' '), write(Z), nl))).
