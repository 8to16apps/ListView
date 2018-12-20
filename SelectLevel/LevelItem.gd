extends Control

"""
	IMPORTAN NOTE:
		The elements inside the LevelItem has the flag IGNORE in the mouse filter property
		and the top control has the flag PASS in the mouse filter property
"""

signal levelSelected(index)

var LevelIndex = 0;
var unlocked = false;

func _ready():
	$"ItemRect/Label".text = str(LevelIndex);
	unlocked = (LevelIndex == 1);
	$"ItemRect/Unlock".visible = unlocked;

func _gui_input(event):
	if unlocked and (event is InputEventMouseButton) and (event.button_index == BUTTON_LEFT) and event.is_pressed():
		emit_signal("levelSelected", LevelIndex);
