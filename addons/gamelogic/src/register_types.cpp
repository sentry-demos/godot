#include "register_types.h"

#include <godot_cpp/classes/engine.hpp>

#include "game_logic.h"

inline void add_godot_singleton(const StringName &p_singleton_name,
		Object *p_object) {
	Engine::get_singleton()->register_singleton(p_singleton_name, p_object);
}

inline void remove_godot_singleton(const StringName &p_singleton_name) {
	Engine::get_singleton()->unregister_singleton(p_singleton_name);
}

void initialize_gamelogic_module(ModuleInitializationLevel p_level) {
	// Note: Classes MUST be registered in inheritance order.
	if (p_level == MODULE_INITIALIZATION_LEVEL_SCENE) {
		// Register node classes here.
		// You can add singletons using add_godot_singleton().
		GDREGISTER_CLASS(GameLogic);
		GameLogic::create_singleton();
		add_godot_singleton("GameLogic", GameLogic::get_singleton());
	}
}

void uninitialize_gamelogic_module(ModuleInitializationLevel p_level) {
	if (p_level == MODULE_INITIALIZATION_LEVEL_SCENE) {
		// Perform cleanup here.
		// You can remove singletons using remove_godot_singleton().
		remove_godot_singleton("GameLogic");
		GameLogic::destroy_signleton();
	}
}
