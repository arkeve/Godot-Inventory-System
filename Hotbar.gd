extends Node2D

onready var _slotScene = preload("res://scenes/slot/slot.tscn")
const SlotTypes = preload("res://scripts/slot-type-enum.gd")

onready var _actionBarGrid = $ActionBarGrid
onready var active_item_label = $ActiveItemLabel

func _ready():
	CreateActionBar(9)

func CreateActionBar(slotCount):
	for i in slotCount:
		var slot = _slotScene.instance()
		slot.SetSlotName("ActionSlot" + str(i + 1))
		slot.SetSlotType(SlotTypes.HOTBAR)
		slot.SetSlotIndex(i)
		_actionBarGrid.add_child(slot)

	initialize_hotbar()
	
func update_active_item_label():
	var slots = _actionBarGrid.get_children()
	if slots[PlayerInventory.active_item_slot].GetItemReference() != null:
		active_item_label.text = slots[PlayerInventory.active_item_slot].GetItemReference().GetItemName()
	else:
		active_item_label.text = ""

func initialize_hotbar():
	var slots = _actionBarGrid.get_children()
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			var item = ItemManager.CreateItem(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
			slots[i].AddItem(item)

func _input(__event):
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func slot_gui_input(event: InputEvent, slot: Slot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UserInterface").holding_item != null:
				if !slot.GetItemReference():
					left_click_empty_slot(slot)
				else:
					if find_parent("UserInterface").holding_item.GetItemName() != slot.GetItemReference().GetItemName():
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.GetItemReference():
				left_click_not_holding(slot)
			update_active_item_label()

func left_click_empty_slot(slot: Slot):
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null
	
func left_click_different_item(event: InputEvent, slot: Slot):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	var temp_item = slot.GetItemReference()
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = temp_item

func left_click_same_item(slot: Slot):
	var stack_size = int(JsonData.item_data[slot.GetItemReference().GetItemName()]["MaxStackSize"])
	var able_to_add = stack_size - slot.GetItemReference().GetItemCount()
	if able_to_add >= find_parent("UserInterface").holding_item.GetItemCount():
		PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.GetItemCount())
		slot.GetItemReference().add_item_quantity(find_parent("UserInterface").holding_item.GetItemCount())
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.GetItemReference().add_item_quantity(able_to_add)
		find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot: Slot):
	PlayerInventory.remove_item(slot)
	find_parent("UserInterface").holding_item = slot.GetItemReference()
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

