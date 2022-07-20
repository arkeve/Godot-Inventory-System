extends Node2D

signal ToggleDragState
const SlotTypes = preload("res://scripts/slot-type-enum.gd")

onready var _slotScene = preload("res://scenes/slot/slot.tscn")
onready var _inventoryGrid = $BackgroundNinePatchRect/InventoryGrid
onready var _equipmentGrid = $BackgroundNinePatchRect/EquipmentGrid
onready var _background = $BackgroundNinePatchRect

var _slotCount : float = 20.0
var _columnCount : float = 5.0
var _originalGrabPosition : Vector2
var _originalDialogPosition : Vector2
var _draggingInventory = false

func _ready():
	InitSignals()
	InventoryManager.SetInventory(self)
	CreateInventoryGrid()
	InitEquipment()
	PopulateInventory()
	PopulateEquipment()

func InitSignals():
	Signals.connect("SlotClicked", self, "SlotClicked")
	connect("ToggleDragState", self, "ToggleDragState")
	
func AddSlot():
	_slotCount += 1.0
	# slots start at 0
	CreateSlot(_slotCount - 1)
	RefreshInventory()

func RemoveSlot():
	_slotCount -= 1.0
	if _slotCount < 0.0:
		_slotCount = 0.0
	
	var slot = _inventoryGrid.get_child(_inventoryGrid.get_child_count() - 1)
	_inventoryGrid.remove_child(slot)
	RefreshInventory()

func AddColumn():
	_columnCount += 1.0
	RefreshInventory()

func RemoveColumn():
	_columnCount -= 1.0
	if _columnCount < 1.0:
		_columnCount = 1.0
	RefreshInventory()
	
func ClearGrid():
	for child in _inventoryGrid.get_children():
		_inventoryGrid.remove_child(child)
		child.queue_free()

func RefreshInventory():
	if _columnCount <= 0.0:
		_columnCount = 1.0
	AdjustBackgroundSize()
	AdjustGridSize()
	var leftMargin = _inventoryGrid.get_constant("hseparation")
	var rightMargin = 8
	var topMargin = 8
	var slotSize = 18
	_equipmentGrid.rect_position = Vector2(leftMargin, topMargin)
	_inventoryGrid.rect_position = Vector2(leftMargin + slotSize + rightMargin, topMargin)
		
func CreateInventoryGrid():
	if _columnCount <= 0.0:
		_columnCount = 1.0
	AdjustBackgroundSize()
	AdjustGridSize()
	CreateInventorySlots()
	var leftMargin = _inventoryGrid.get_constant("hseparation")
	var rightMargin = 8
	var topMargin = 8
	var slotSize = 18
	_equipmentGrid.rect_position = Vector2(leftMargin, topMargin)
	_inventoryGrid.rect_position = Vector2(leftMargin + slotSize + rightMargin, topMargin)

func AdjustGridSize():
	_inventoryGrid.columns = _columnCount
	
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
	
func CreateInventorySlots():
	for i in _slotCount:
		CreateSlot(i)

func CreateSlot(slotIndex):
	var slot = _slotScene.instance()
	slot.SetSlotIndex(slotIndex)
	slot.SetSlotName("Slot" + str(slotIndex + 1)) # Slot1 - n
	slot.SetSlotType(SlotTypes.INVENTORY)
	slot.AddIndexText(str(slotIndex))
	_inventoryGrid.add_child(slot)
			
func InitEquipment():
	var equipmentSlots = _equipmentGrid.get_children()
	for i in range(equipmentSlots.size()):
		equipmentSlots[i].SetSlotIndex(i)
	equipmentSlots[0].SetSlotType(SlotTypes.SHIRT)
	equipmentSlots[1].SetSlotType(SlotTypes.PANTS)
	equipmentSlots[2].SetSlotType(SlotTypes.SHOES)

# Looks at a static list of items
func PopulateInventory():
	var listOfSlots = _inventoryGrid.get_children()
	for i in range(listOfSlots.size()):
		if PlayerInventory.inventory.has(i):
			var item = ItemManager.CreateItem(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
			listOfSlots[i].AddItem(item)

func PopulateEquipment():
	var equipmentSlots = _equipmentGrid.get_children()
	for i in range(equipmentSlots.size()):
		if PlayerInventory.equips.has(i):
			var item = ItemManager.CreateItem(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])
			equipmentSlots[i].AddItem(item)			
	
#			add_child(_item)
#			refresh_style()
	
func SlotClicked(slot: Slot):
	var slotItem = slot.GetItemReference()
	var heldItemRef = InventoryManager.GetHeldItemReference()
	if heldItemRef != null && is_instance_valid(heldItemRef):
		# I'm holding something
		if slotItem != null && is_instance_valid(slotItem):
			# The slot I'm dropping on has something already
			if heldItemRef.GetItemName() == slot.GetItemReference().GetItemName():
				# items types are the same. Try to stack
				StackItems(slot)
			else:
				# item types are different. Swap them
				SwapItems(slot)
				
#			if !slot.GetItemReference():
#				left_click_empty_slot(slot)
#			else:
#				if find_parent("UserInterface").holding_item.GetItemName() != slot.GetItemReference().GetItemName():
					
#				else:
					
		else:
			var heldItem = InventoryManager.TakeHeldItem()
			slot.AddItem(heldItem)
	elif slot.GetItemReference():
		var item = slot.TakeItem()
		InventoryManager.HoldItem(item)
		UpdateHeldItemPosition()

func UpdateHeldItemPosition():
	var heldItem = InventoryManager.GetHeldItemReference()
	if heldItem != null && is_instance_valid(heldItem) && heldItem.is_inside_tree():
		InventoryManager.GetHeldItemReference().global_position = get_global_mouse_position()
			
func _input(__event):
	UpdateHeldItemPosition()

func IsItemTypeAllowedInSlot(slot: Slot):
	var heldItem = InventoryManager.GetHeldItemReference()
	var heldItemCategory = JsonData.item_data[heldItem.GetItemName()]["ItemCategory"]
	
	if slot.GetSlotType() == SlotTypes.SHIRT:
		if heldItemCategory != "Shirt":
			return false
	elif slot.GetSlotType() == SlotTypes.PANTS:
		if heldItemCategory != "Pants":
			return false
	elif slot.GetSlotType() == SlotTypes.SHOES:
		if heldItemCategory != "Shoes":
			return false

	return true
	
func SwapItems(slot: Slot):
	if IsItemTypeAllowedInSlot(slot):
		var slotItem = slot.TakeItem()
		var heldItem = InventoryManager.TakeHeldItem()
		slot.AddItem(heldItem)
		InventoryManager.HoldItem(slotItem)
		UpdateHeldItemPosition()

func StackItems(slot: Slot):
	if IsItemTypeAllowedInSlot(slot):
		var existingItem = slot.GetItemReference()
		var existingItemCount = existingItem.GetItemCount()
		var heldItem = InventoryManager.GetHeldItemReference()
		var amountWeCanAdd = heldItem.GetMaxStackSize() - existingItemCount
		if heldItem.GetItemCount() > amountWeCanAdd:
			existingItem.AddToStack(amountWeCanAdd)
			heldItem.RemoveFromStack(amountWeCanAdd)
		else:
			existingItem.AddToStack(heldItem.GetItemCount())
			heldItem = InventoryManager.TakeHeldItem()
			heldItem.queue_free()

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
