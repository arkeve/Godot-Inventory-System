extends Node

signal active_item_updated

const SlotTypes = preload("res://scripts/slot-type-enum.gd")
const Common = preload("res://scenes/slot/slot.gd")

const NUM_HOTBAR_SLOTS = 8







# TODO: Make compatible with hotbar as well


#
#
#func add_item_to_empty_slot(item: Item, slot: Slot):
#	match slot.GetSlotType():
#		SlotTypes.HOTBAR:
#			hotbar[slot.GetSlotIndex()] = [item.GetItemName(), item.GetItemCount()]
#		SlotTypes.INVENTORY:
#			inventory[slot.GetSlotIndex()] = [item.GetItemName(), item.GetItemCount()]
#		_:
#			equips[slot.GetSlotIndex()] = [item.GetItemName(), item.GetItemCount()]
#
#func add_item_quantity(slot: Slot, amount: int):
#	match slot.GetSlotType():
#		SlotTypes.HOTBAR:
#			hotbar[slot.GetSlotIndex()][1] += amount
#		SlotTypes.INVENTORY:
#			inventory[slot.GetSlotIndex()][1] += amount
#		_:
#			equips[slot.GetSlotIndex()][1] += amount
#
####
#### Hotbar Related Functions
#func active_item_scroll_up() -> void:
#	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
#	emit_signal("active_item_updated")
#
#func active_item_scroll_down() -> void:
#	if active_item_slot == 0:
#		active_item_slot = NUM_HOTBAR_SLOTS - 1
#	else:
#		active_item_slot -= 1
#	emit_signal("active_item_updated")
#
#



