#include "game_logic.h"

GameLogic *GameLogic::singleton = nullptr;

void GameLogic::enter_crash_zone() {
	// Executing the following code crashes the game
	print_line("Entering crash zone...");
	volatile int *ptr = nullptr;
	*ptr = 0;
}

void GameLogic::_bind_methods() {
	ClassDB::bind_method(D_METHOD("enter_crash_zone"), &GameLogic::enter_crash_zone);
}
