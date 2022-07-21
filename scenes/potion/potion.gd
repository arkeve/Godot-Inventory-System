extends Item

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
var item_name

var _player = null
var _isAnimatingPickup = false

func _ready():
	item_name = "Slime Potion"
	
func PickupItem(body):
	if !body.is_in_group("Player"):
		return
	$Sprite/Label.visible = false
	_player = body
	InventoryManager.AddItem(item_name, 1)

func _on_PickupArea2D_body_entered(body):
	if body.is_in_group("Player"):
		$Sprite/Label.visible = true

func _on_PickupArea2D_body_exited(body):
	if body.is_in_group("Player"):
		$Sprite/Label.visible = false
