extends Control

signal level_selected

var LevelItemPrefab = preload("res://SelectLevel/LevelItem.tscn");

func _ready():
	#Populate the list with 30 elements
	for i in range(1,31):
		var levelItem = LevelItemPrefab.instance();
		levelItem.LevelIndex = i;
		$ListView.insert_item(levelItem);

func _on_ListView_item_selected(index):
	print( "Level Selected " + str(index) );
	emit_signal("level_selected");
