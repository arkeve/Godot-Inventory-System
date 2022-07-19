extends Node
onready var _itemScene = preload("res://scenes/item/item.tscn")
var _itemInTransition : Item

func CreateItem(itemName, itemCount):
	var item = _itemScene.instance()
	item.ConfigureItem(itemName, itemCount)
	return item

func ItemInTransition(item):
	_itemInTransition = item
