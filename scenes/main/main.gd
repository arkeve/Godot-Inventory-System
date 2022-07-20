extends Node2D
onready var _itemScene = preload("res://scenes/item/item.tscn")
onready var _interactiveInventoryScene = preload("res://scenes/interactives/inventory/interactive-inventory.tscn")
func _ready():
	randomize()
	GameManager.SetMain(self)
	AddInteractiveInventory("Chest", 6, 3)

func AddInteractiveInventory(inventoryType, slotSize, columnSize):
	var interactiveInventory = _interactiveInventoryScene.instance()
	$Interactives.add_child(interactiveInventory)
	interactiveInventory.position = Vector2(300, 199)
	interactiveInventory.Configure(inventoryType, slotSize, columnSize)
	
func get_input():
	if Input.is_action_pressed('right_click'):
		InventoryManager.UserRightClicked()
	
func AddSlot():
	InventoryManager.GetActiveInventory().AddSlot()

func RemoveSlot():
	InventoryManager.GetActiveInventory().RemoveSlot()

func AddColumn():
	InventoryManager.GetActiveInventory().AddColumn()

func RemoveColumn():
	InventoryManager.GetActiveInventory().RemoveColumn()
	
func _on_AddSlotButton_pressed():
	AddSlot()

func _on_RemoveSlotButton_pressed():
	RemoveSlot()

func _on_AddColumnButton_pressed():
	AddColumn()

func _on_RemoveColumnButton_pressed():
	RemoveColumn()
