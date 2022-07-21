extends Area2D

onready var _interactLabel = $InteractLabel
onready var _inventoryContainer = $InventoryContainer

func _ready():
	var inventory = InventoryManager.CreateInventory()
	_inventoryContainer.add_child(inventory)

func Configure(inventoryType, slotCount, columnCount):
	$Sprite.texture = load("res://assets/inventories/" + inventoryType + ".png")
	GetInventory().ConfigureInventory(6, 3)
	GetInventory().position = Vector2(-(GetInventory().GetWidth() / 2), -(GetInventory().GetHeight() + 16))
	
func Interact():
	if GetInventory().IsShowing():
		GetInventory().HideInventory()
	else:
		GetInventory().ShowInventory()

func HideInteractive():
	GetInventory().HideInventory()
	
func GetInventory():
	return _inventoryContainer.get_child(0)
		
func _on_Chest_body_entered(body):
	if body.is_in_group("Player"):
		body.SetInteractive(self)
		_interactLabel.visible = true

func _on_Chest_body_exited(body):
	if body.is_in_group("Player"):
		body.ClearInteractive()
		_interactLabel.visible = false
		HideInteractive()
