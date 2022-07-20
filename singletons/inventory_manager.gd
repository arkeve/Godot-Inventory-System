extends Node2D

const SlotTypes = preload("res://scripts/slot-type-enum.gd")
onready var _inventoryScene = preload("res://scenes/inventory/inventory.tscn")
var _listOfInventories = []
var _activeInventory
var _activeItemSlot = 0

var _inventory = {
	0: ["Iron Sword", 1],  #--> slot_index: [item_name, item_quantity]
	1: ["Iron Sword", 1],  #--> slot_index: [item_name, item_quantity]
	2: ["Slime Potion", 98],
	6: ["Slime Potion", 45],
}

var hotbar = {
	0: ["Iron Sword", 1],  #--> slot_index: [item_name, item_quantity]
	3: ["Slime Potion", 45],
}

var equips = {
	0: ["Brown Shirt", 1],  #--> slot_index: [item_name, item_quantity]
	1: ["Blue Jeans", 1],  #--> slot_index: [item_name, item_quantity]
	2: ["Brown Boots", 1],	
}

func _start():
	InitSignals()

func InitSignals():
	Signals.connect("HoldItem", self, "HoldItem")

func SetActiveInventory(inv):
	_activeInventory = inv
	
func CreateInventory():
	return _inventoryScene.instance()
	#_listOfInventories.append(inventory)
	#GameManager.GetUserInterface().AddInventory(inventory)
	#return inventory
	
func UserRightClicked():
	if GetHeldItemReference() != null:
		GetActiveInventory().AddItem(TakeHeldItem())

func GetActiveInventory():
	return _activeInventory

func GetHeldItemReference():
	return GameManager.GetUserInterface().GetHeldItemReference()

func TakeHeldItem():
	return GameManager.GetUserInterface().TakeHeldItem()
		
func HoldItem(item):
	GameManager.GetUserInterface().AddItemForTransfer(item)

func UpdateSlotVisual(slotIndex, itemName, amount):
	var slot = get_tree().root.get_node("/root/World/UserInterface/Inventory/GridContainer/Slot" + str(slotIndex + 1))
	if slot.GetItemReference() != null:
		slot.GetItemReference().set_item(itemName, amount)
	else:
		slot.initialize_item(itemName, amount)
	
func AddItem(itemName, amount):
	var slot_indices: Array = _inventory.keys()
	slot_indices.sort()
	for item in slot_indices:
		if _inventory[item][0] == itemName:
			var stack_size = int(JsonData.item_data[itemName]["StackSize"])
			var able_to_add = stack_size - _inventory[item][1]
			if able_to_add >= amount:
				_inventory[item][1] += amount
				UpdateSlotVisual(item, _inventory[item][0], _inventory[item][1])
				return
			else:
				_inventory[item][1] += able_to_add
				UpdateSlotVisual(item, _inventory[item][0], _inventory[item][1])
				amount = amount - able_to_add
				
	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(_activeInventory.GetSlotCount()):
		if _inventory.has(i) == false:
			_inventory[i] = [itemName, amount]
			UpdateSlotVisual(i, _inventory[i][0], _inventory[i][1])
			return

func RemoveItem(slot: Slot):
	match slot.GetSlotType():
		SlotTypes.HOTBAR:
			hotbar.erase(slot.GetSlotIndex())
		SlotTypes.INVENTORY:
			_inventory.erase(slot.GetSlotIndex())
		_:
			equips.erase(slot.GetSlotIndex())
			
