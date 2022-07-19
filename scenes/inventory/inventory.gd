extends Node2D

signal ToggleDragState
const SlotTypes = preload("res://scripts/slot-type-enum.gd")

onready var _slotScene = preload("res://scenes/slot/slot.tscn")
onready var _inventoryGrid = $BackgroundNinePatchRect/InventoryGrid
onready var _equipmentGrid = $BackgroundNinePatchRect/EquipmentGrid
onready var _background = $BackgroundNinePatchRect

var _slotCount : float = 12.0
var _columnCount : float = 3.0
var _originalGrabPosition : Vector2
var _originalDialogPosition : Vector2
var _draggingInventory = false

func _ready():
	InitSignals()
	InventoryManager.SetInventory(self)
	CreateInventory()
	InitEquipment()
	PopulateInventory()
	PopulateEquipment()

func InitSignals():
	connect("ToggleDragState", self, "ToggleDragState")

func AddSlot():
	_slotCount += 1.0
	ClearGrid()
	CreateInventory()

func RemoveSlot():
	_slotCount -= 1.0
	if _slotCount < 0.0:
		_slotCount = 0.0
	ClearGrid()
	CreateInventory()

func AddColumn():
	_columnCount += 1.0
	ClearGrid()
	CreateInventory()

func RemoveColumn():
	_columnCount -= 1.0
	if _columnCount < 1.0:
		_columnCount = 1.0
	ClearGrid()
	CreateInventory()
	
func ClearGrid():
	for child in _inventoryGrid.get_children():
		_inventoryGrid.remove_child(child)
		child.queue_free()
		
func CreateInventory():
	if _columnCount <= 0.0:
		_columnCount = 1.0
	AdjustBackgroundSize()
	CreateSlots()
	InitSlots()
	var leftMargin = _inventoryGrid.get_constant("hseparation")
	var rightMargin = 8
	var topMargin = 8
	var slotSize = 18
	_equipmentGrid.rect_position = Vector2(leftMargin, topMargin)
	_inventoryGrid.rect_position = Vector2(leftMargin + slotSize + rightMargin, topMargin)
	
func AdjustBackgroundSize():
	var slotSize = 18
	var leftMargin = _inventoryGrid.get_constant("hseparation")
	var rightMargin = 8
	var topMargin = 8
	var equipmentVSeparation = _equipmentGrid.get_constant("vseparation")
	var equipmentSlotsWidth = slotSize
	var totalEquipmentWidth = leftMargin + equipmentSlotsWidth + rightMargin
	var equipmentSlotCount = 3
	var minHeight = topMargin + (equipmentSlotCount * slotSize) + (equipmentSlotCount * equipmentVSeparation)
	var backgroundWidth = totalEquipmentWidth + (_columnCount * slotSize) + (_inventoryGrid.get_constant("hseparation") * (_columnCount))
	var calculatedRowCount = ceil(_slotCount / _columnCount) # 15 rounds up to 16
	var backgroundHeight = topMargin + (calculatedRowCount * slotSize) + (_inventoryGrid.get_constant("vseparation") * calculatedRowCount)
	if backgroundHeight < minHeight:
		backgroundHeight = minHeight
	_background.rect_size = Vector2(backgroundWidth, backgroundHeight)
	
func CreateSlots():
	_inventoryGrid.columns = _columnCount
	for i in _slotCount:
		var slot = _slotScene.instance()
		slot.name = "Slot" + str(i + 1) # Slot1 - n
		_inventoryGrid.add_child(slot)
	
func InitSlots():
	var slots = _inventoryGrid.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slotType = 1

func InitEquipment():
	var equipmentSlots = _equipmentGrid.get_children()
	for i in range(equipmentSlots.size()):
		equipmentSlots[i].connect("gui_input", self, "slot_gui_input", [equipmentSlots[i]])
		equipmentSlots[i].slot_index = i
	equipmentSlots[0].slotType = SlotTypes.SHIRT
	equipmentSlots[1].slotType = SlotTypes.PANTS
	equipmentSlots[2].slotType = SlotTypes.SHOES
	
func PopulateInventory():
	var slots = _inventoryGrid.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func PopulateEquipment():
	var equipmentSlots = _equipmentGrid.get_children()
	for i in range(equipmentSlots.size()):
		if PlayerInventory.equips.has(i):
			equipmentSlots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])

func slot_gui_input(event: InputEvent, slot: Slot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UserInterface").holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if find_parent("UserInterface").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)
				
func _input(__event):
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
		
		
func able_to_put_into_slot(slot: Slot):
	var holding_item = find_parent("UserInterface").holding_item
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	
	if slot.slotType == SlotTypes.SHIRT:
		return holding_item_category == "Shirt"
	elif slot.slotType == SlotTypes.PANTS:
		return holding_item_category == "Pants"
	elif slot.slotType == SlotTypes.SHOES:
		return holding_item_category == "Shoes"
	return true
		
func left_click_empty_slot(slot: Slot):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = null
	
func left_click_different_item(event: InputEvent, slot: Slot):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = temp_item

func left_click_same_item(slot: Slot):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity)
			slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
			find_parent("UserInterface").holding_item.queue_free()
			find_parent("UserInterface").holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot: Slot):
	PlayerInventory.remove_item(slot)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()

func _process(_delta):
	if _draggingInventory:
		var mousePosition = get_viewport().get_mouse_position()
		if _originalGrabPosition == Vector2(0, 0):
			_originalGrabPosition = mousePosition
			_originalDialogPosition = self.position
		self.position = _originalDialogPosition + (mousePosition - _originalGrabPosition)
	else:
		_originalGrabPosition = Vector2(0, 0)
		
func ToggleDragState():
	_draggingInventory =! _draggingInventory

func _on_BackgroundNinePatchRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("ToggleDragState")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("ToggleDragState")
