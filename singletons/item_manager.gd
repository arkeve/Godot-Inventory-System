extends Node
onready var _itemScene = preload("res://scenes/item/item.tscn")
var _itemInTransition : Item

func CreateItem():
	var item = _itemScene.instance()
	return item
	
func ItemInTransition(item):
	_itemInTransition = item
