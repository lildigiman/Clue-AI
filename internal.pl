/*
 * internal.pl - holds all internal rules and prediactes
 * 
 */

/*
 * Set a card in the hand of a player
 */
setHand(Player, Status, Card) :-
	me(Me),
	((Player == Me, Player == envelope)
		->	write('I tried to set my own hand or Envelope'), write(Player), nl
		;	(write(Player), write('\t'), write(Status), write('\t'), write(Card), nl,
			((hand(Player, X, Y), Y == Card)
				->	retract(hand(Player, _, Card)), asserta(hand(Player, Status, Card))
				;	asserta(hand(Player, Status, Card)))
			)
	).

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
	me(Me),	
	(player(X),
	X \== envelope, X \== Me,
	hand(X, hasnot, Card1),
	hand(X, hasnot, Card2),
	question(_, Card1, Card2, HotCard, X)
		->	player(Players), Players \== Me, Players \== envelope,
			forall(Players, setHand(Players, hasnot, HotCard)),
			setHand(X, has, HotCard)
		;	write('No Question fits'), nl
	),
	(player(Y),
	Y \== envelope, Y \== Me,
	hand(Y, hasnot, Card1),
	hand(Y, hasnot, Card3),
	question(_, Card1, HotCard, Card3, Y)
		->	player(Players), Players \== Me, Players \== envelope,
			forall(Players, setHand(Players, hasnot, HotCard)),
			setHand(Y, has, HotCard)
		;	write('No Question fits'), nl
	),
	(player(Z),
	Z \== envelope, Z \== Me,
	hand(Z, hasnot, Card2),
	hand(Z, hasnot, Card3),
	question(_, HotCard, Card2, Card3, Z)
		->	player(Players), Players \== Me, Players \== envelope,
			forall(Players, setHand(Players, hasnot, HotCard)),
			setHand(Z, has, HotCard)
		;	write('No Question fits'), nl
	),
	(allHaveNot(Card1) -> asserta(hand(envelope, has, Card1)),	
	(allHaveNot(Card2) -> asserta(hand(envelope, has, Card2)),	
	(allHaveNot(Card3) -> asserta(hand(envelope, has, Card3)).


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
