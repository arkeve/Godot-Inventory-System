extends Node2D

const SlotClass = preload("res://Slot.gd")
onready var hotbar_slots = $HotbarSlots
onready var slots = hotbar_slots.get_children()

func _ready():
#	for i in range(slots.size()):
#		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
#		slots[i].slot_index = i
	for i in range(slots.size()):
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].slotType = SlotClass.SlotType.HOTBAR
		slots[i].slot_index = i
	initialize_hotbar()

func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
