extends Node

signal active_item_updated

const SlotTypes = preload("res://scripts/slot-type-enum.gd")
const Common = preload("res://scenes/slot/slot.gd")
const NUM__inventoryGrid = 20
const NUM_HOTBAR_SLOTS = 8

var active_item_slot = 0

var inventory = {
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

# TODO: First try to add to hotbar
func add_item(itemName, amount):
	var slot_indices: Array = inventory.keys()
	slot_indices.sort()
	for item in slot_indices:
		if inventory[item][0] == itemName:
			var stack_size = int(JsonData.item_data[itemName]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= amount:
				inventory[item][1] += amount
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				amount = amount - able_to_add
	
	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM__inventoryGrid):
		if inventory.has(i) == false:
			inventory[i] = [itemName, amount]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return

# TODO: Make compatible with hotbar as well
func update_slot_visual(slotIndex, itemName, amount):
	var slot = get_tree().root.get_node("/root/World/UserInterface/Inventory/GridContainer/Slot" + str(slotIndex + 1))
	if slot.GetItemReference() != null:
		slot.GetItemReference().set_item(itemName, amount)
	else:
		slot.initialize_item(itemName, amount)

func remove_item(slot: Slot):
	match slot.GetSlotType():
		SlotTypes.HOTBAR:
			hotbar.erase(slot.GetSlotIndex())
		SlotTypes.INVENTORY:
			inventory.erase(slot.GetSlotIndex())
		_:
			equips.erase(slot.GetSlotIndex())

func add_item_to_empty_slot(item: Item, slot: Slot):
	match slot.GetSlotType():
		SlotTypes.HOTBAR:
			hotbar[slot.GetSlotIndex()] = [item.GetItemName(), item.GetItemCount()]
		SlotTypes.INVENTORY:
			inventory[slot.GetSlotIndex()] = [item.GetItemName(), item.GetItemCount()]
		_:
			equips[slot.GetSlotIndex()] = [item.GetItemName(), item.GetItemCount()]

func add_item_quantity(slot: Slot, amount: int):
	match slot.GetSlotType():
		SlotTypes.HOTBAR:
			hotbar[slot.GetSlotIndex()][1] += amount
		SlotTypes.INVENTORY:
			inventory[slot.GetSlotIndex()][1] += amount
		_:
			equips[slot.GetSlotIndex()][1] += amount

###
### Hotbar Related Functions
func active_item_scroll_up() -> void:
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")

func active_item_scroll_down() -> void:
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")





