extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if randi() % 3 == 0:
		$TextureRect.texture = load("res://Iron Sword.png")
	else:
		$TextureRect.texture = load("res://Tree Branch.png")
