:- dynamic(hand/3).

% has(Player, Status, Card).

/*
STATUS:
has
hasnot
maybe
*/

%hear(Asker, Card1, Card2, Card3, Responder) :-


%No one answers here
%hear(Asker, Card1, Card2, Card3) :-
	

infer(Player, Card) :-
	asserta(Player, maybe, Card).


%When a player shows you a card
see(Presenter, Card1, Card2, Card3, CardShown) :-
	forall(between(me(Me), Presenter, X), 
		asserta(hand(X, hasnot, Card1)),
		asserta(hand(X, hasnot, Card2)),
		asserta(hand(X, hasnot, Card3))),
	forall(player(X), asserta(hand(X, hasnot, CardShown))),
	asserta(hand(Presenter, has, CardShown)).
	

between(Beginer, Presenter, X) :-
	nextPlayer(Beginer, Y),
	Y \== Presenter ->
		between(Y, Presenter, X). 

forall(Condition, Action) :-
    \+ (call(Condition), \+ call(Action)).

isBetween(Player, Begin, End) :-
	numPlayersBetween(Begin, End, Y),
	numPlayersBetween(Begin, Player, Z),
	write(Z),
	write('\n'),
	write(Y),
	write('\n'),
	Z < Y.

playersBetween(Begin, End, Player) :-
	player(Player),
	isBetween(Player, Begin, End).

numPlayersBetween(Begining, End, X) :-
        numPlayersBetween(Begining, End, X, 0).
 
numPlayersBetween(Begining, End, X, Count) :-
        (Begining == End ->
                X is (Count - 1);
        nextPlayer(Begining, Y),
        numPlayersBetween(Y, End, X, Count + 1)).








	

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
