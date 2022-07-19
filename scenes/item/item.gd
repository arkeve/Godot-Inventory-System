extends Node2D
class_name Item
var _itemName = ""
var _itemCount = 0
var _maxStackSize = 1
var _splittable = false

func _ready():
#	var rand_val = randi() % 3
#	if rand_val == 0:
#		_itemName = "Iron Sword"
#	elif rand_val == 1:
#		_itemName = "Tree Branch"
#	else:
#		_itemName = "Slime Potion"
#		_splittable = true
#
#	$TextureRect.texture = load("res://item_icons/" + _itemName + ".png")
#	_itemCount = int(JsonData.item_data[_itemName]["MaxStackSize"])
#	_itemCount = randi() % _itemCount + 1
#
#	if _itemCount == 1:
#		$Label.visible = false
#	else:
#		$Label.text = String(_itemCount)
	pass
	
func ConfigureItem(itemName, itemCount):
	_itemName = itemName
	_itemCount = itemCount
	$TextureRect.texture = load("res://item_icons/" + _itemName + ".png")
	
	_maxStackSize = int(JsonData.item_data[_itemName]["MaxStackSize"])
	if _maxStackSize > 1:
		_splittable = bool(JsonData.item_data[_itemName]["Splittable"])
	
	if _itemCount == 1:
		$Label.visible = false
	else:
		if _itemCount > _maxStackSize:
			_itemCount = _maxStackSize
			print("Yo, itemCount can't be larger than our item definitions maxStackSize. Change one.")
			
		$Label.visible = true
		$Label.text = String(_itemCount)
		
func add_item_quantity(amount):
	_itemCount += amount
	$Label.text = String(_itemCount)
	
func decrease_item_quantity(amount):
	_itemCount -= amount
	$Label.text = String(_itemCount)

func GetItemName():
	return _itemName
	
func GetItemCount():
	return _itemCount
