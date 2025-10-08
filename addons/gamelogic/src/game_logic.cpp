#include "game_logic.h"

GameLogic *GameLogic::singleton = nullptr;

void GameLogic::enter_crash_zone() {
	// Executing the following code crashes the game
	print_line("Entering crash zone...");
	char *chr = (char *)1;
	print_line(chr);
}

void GameLogic::_bind_methods() {
	ClassDB::bind_method(D_METHOD("enter_crash_zone"), &GameLogic::enter_crash_zone);
}
