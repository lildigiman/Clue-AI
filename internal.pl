/*
 * internal.pl - holds all internal rules and prediactes
 * 
 */

/*
 * Set a card in the hand of a player
 */
setHand(Player, Status, Card) :-
	write('Enter sethand'),
	me(Me),
	(Player == Me
		->	write('I tried to set my own hand')
		;	(write(Player), write('\t'), write(Status), write('\t'), write(Card), nl,
			asserta(hand(Player, Status, Card)))
	),
	write('Exit setHand').

setMyHand(Card1, Card2, Card3) :-
	me(Me),
	forall(card(Type, CardOut), asserta(hand(Me, hasnot, CardOut))),
	asserta(hand(Me, has, Card1)),
	asserta(hand(Me, has, Card2)),
	asserta(hand(Me, has, Card3)).

/*
 * Store each question in full
 * TODO: If no one responds, then what?
 */
storeQuestion(Asker, Card1, Card2, Card3, Refuter) :-
	write(Asker), write(' suspects '), write(Card1), write(' '), write(Card2), write(' '), write(Card3), nl, write(Refuter), write(' respond'), nl,
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
 *	So Mrs. Peacock must have the rope.
 * TODO: create discover function to reduce repeat code
 */

% Green, Plum, Revolver, Hall, Mustard
% Green, Green, Revolver, Hall, Plum 
eliminateExcess(Card1, Card2, Card3) :-
	write('Enter elliminateExcess'), nl,
	(player(X),
	X \== envelope,
	hand(X, hasnot, Card1),
	hand(X, hasnot, Card2),
	question(_, Card1, Card2, HotCard, X)
		->	player(Players),
			forall(Players, setHand(Players, hasnot, HotCard)),
			setHand(X, has, HotCard)
		;	write('No Question fits')
	),
	(player(Y),
	Y \== envelope,
	hand(Y, hasnot, Card1),
	hand(Y, hasnot, Card3),
	question(_, Card1, HotCard, Card3, Y)
		->	player(Players),
			forall(Players, setHand(Players, hasnot, HotCard)),
			setHand(Y, has, HotCard)
		;	write('No Question fits')
	),
	(player(Z),
	Z \== envelope,
	hand(Z, hasnot, Card2),
	hand(Z, hasnot, Card3),
	question(_, HotCard, Card2, Card3, Z)
		->	player(Players),
			forall(Players, setHand(Players, hasnot, HotCard)),
			setHand(Z, has, HotCard)
		;	write('No Question fits')
	),
	write('Exit elliminateExcess'), nl.

/*
 * forall rule which is not predefined in GNU prolog
 */
forall(Condition, Action) :-
	\+ (call(Condition), \+ call(Action)).

/*
 * Union
 */
union([A|B], C, D) :- member(A,C), !, union(B,C,D).
union([A|B], C, [A|D]) :- union(B,C,D).
union([],Z,Z).


/*
 * Printout
 */
printout :-
	forall(player(X), forall(hand(X, Y, Z), (write(X), write(' '), write(Y), write(' '), write(Z), nl))).
