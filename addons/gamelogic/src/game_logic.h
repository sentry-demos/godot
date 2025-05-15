#pragma once

#include "gamelogic_defines.h"

#include <godot_cpp/classes/object.hpp>

class GameLogic : public Object {
	GDCLASS(GameLogic, Object);

public:
	static GameLogic *singleton;

	static GameLogic *get_singleton() { return singleton; }
	static void create_singleton() { singleton = memnew(GameLogic); }
	static void destroy_signleton() {
		memdelete(singleton);
		singleton = nullptr;
	}

protected:
	static void _bind_methods();

public:
	void enter_crash_zone();
};
