extends CanvasLayer
var holding_item = null

onready var _transferItemContainer = $TransferItemContainer

func _ready():
	InitSignals()
	GameManager.SetUserInterface(self)
	
func InitSignals():
	pass

# So the item automatically floats above all else
func AddItemForTransfer(item):
	_transferItemContainer.add_child(item)

func GetHeldItemReference():
	if _transferItemContainer.get_child_count() == 0:
		return null
	return _transferItemContainer.get_child(0)

func TakeHeldItem():
	if _transferItemContainer.get_child_count() == 0:
		return null
	var heldItem = _transferItemContainer.get_child(0)
	_transferItemContainer.remove_child(heldItem)
	return heldItem
	
func _input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
	
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()
