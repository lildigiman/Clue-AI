% :- dynamic(hand/3).

% has(Player, Status, Card).

/*
STATUS:
has
hasnot
maybe
*/


observe(Asker, Card1, Card2, Card3, Responder) :-
	forall(playersBetween(Asker, Responder, X), 	
		(setHand(X, hasnot, Card1), setHand(X, hasnot, Card2), setHand(X, hasnot, Card3))),
	%The Responder possibly has one of the three cards:
	%On the other hand, if ANY player has the card, we know he doesn't
	((hand(Responder, has, Card1) ; hand(Responder, hasnot, Card1))
		-> write('Responder has card') %TODO: Make this a null operator after debug
		; setHand(Responder, maybe, Card1)
	).


% observe(Asker, Card1, Card2, Card3) :-
	

infer(Player, Card) :-
	asserta(Player, maybe, Card).


%When a player shows you a card
see(Presenter, Card1, Card2, Card3, CardShown) :-
	me(Me),
	forall(playersBetween(Me, Presenter, X), 	
		(setHand(X, hasnot, Card1), setHand(X, hasnot, Card2), setHand(X, hasnot, Card3))),
	forall(player(X), asserta(hand(X, hasnot, CardShown))),
	asserta(hand(Presenter, has, CardShown)).
	
/*
between(Beginer, Presenter, X) :-
	nextPlayer(Beginer, Y),
	Y \== Presenter ->
		between(Y, Presenter, X). 
*/

isBetween(Player, Begin, End) :-
	numPlayersBetween(Begin, End, Y),
	numPlayersBetween(Begin, Player, Z),
	Z < Y,
	Begin \== Player.

playersBetween(Begin, End, Player) :-
	player(Player),
	Player \== envelope,
	isBetween(Player, Begin, End).

numPlayersBetween(Begining, End, X) :-
		numPlayersBetween(Begining, End, X, 0).

% engine
ask(Person, Weapon) :-
	suspect(Person, player),
	suspect(Weapon, weapon).

go_to(Room) :-
	suspect(Room, room).


suspect(Card, Type) :-
	card(Type, Card),
	\+ has(_, card(Type, Card)),
	\+ may_have(_, card(Type, Card)).
