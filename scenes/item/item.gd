extends Node2D
class_name Item
var _itemName = ""
var _itemCount = 0
var _maxStackSize = 1
var _splittable = false

func _ready():
	pass
		
func ConfigureItem(itemName, itemCount):
	_itemName = itemName
	_itemCount = itemCount
	$TextureRect.texture = load("res://item_icons/" + _itemName + ".png")
	
	_maxStackSize = int(JsonData.item_data[_itemName]["MaxStackSize"])
	if _maxStackSize > 1:
		_splittable = bool(JsonData.item_data[_itemName]["Splittable"])
	RefreshItemCountLabel()
	
func RefreshItemCountLabel():
	print("RefreshItemCountLabel:" + str(_itemCount))
	if _itemCount == 1:
		$Label.visible = false
	else:
		if _itemCount > _maxStackSize:
			_itemCount = _maxStackSize
			print("Yo, itemCount can't be larger than our item definitions maxStackSize. Change one.")
			
		$Label.visible = true
	$Label.text = String(_itemCount)
		
func AddToStack(amount):
	_itemCount += amount
	RefreshItemCountLabel()
	
func RemoveFromStack(amount):
	_itemCount -= amount
	RefreshItemCountLabel()

func SetItemCount(amount):
	_itemCount = amount
	RefreshItemCountLabel()
	
func GetItemName():
	return _itemName
	
func GetItemCount():
	return _itemCount

func GetMaxStackSize():
	return _maxStackSize
