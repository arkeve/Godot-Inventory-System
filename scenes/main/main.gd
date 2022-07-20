extends Node2D

func _ready():
	randomize()
	GameManager.SetMain(self)

func get_input():
	if Input.is_action_pressed('right_click'):
		InventoryManager.UserRightClicked()
	
func AddSlot():
	InventoryManager.GetInventory().AddSlot()

func RemoveSlot():
	InventoryManager.GetInventory().RemoveSlot()

func AddColumn():
	InventoryManager.GetInventory().AddColumn()

func RemoveColumn():
	InventoryManager.GetInventory().RemoveColumn()
	
func _on_AddSlotButton_pressed():
	AddSlot()

func _on_RemoveSlotButton_pressed():
	RemoveSlot()

func _on_AddColumnButton_pressed():
	AddColumn()

func _on_RemoveColumnButton_pressed():
	RemoveColumn()
