extends Area2D

var items_in_range = {}

func _on_PickupZone_body_entered(body):
	if body.is_in_group("Player"):
		return
	items_in_range[body] = body

func _on_PickupZone_body_exited(body):
	if body.is_in_group("Player"):
		return
	if items_in_range.has(body):
		items_in_range.erase(body)
