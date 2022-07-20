extends Panel
class_name Slot

signal ToggleSplitStackState
const SlotTypes = preload("res://scripts/slot-type-enum.gd")

onready var _sliderScene = preload("res://scenes/slider/slider.tscn")
var default_tex = preload("res://item_slot_default_background.png")
var empty_tex = preload("res://item_slot_empty_background.png")
var selected_tex = preload("res://images/item_slot_selected_background.png")

onready var _itemContainer = $ItemContainer

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null
var slot_index
var _slotType = null
var _splittingStack = false
var _midY = 0
var _slider
var _waitingForMouseUp = false

func _ready():
	InitSignals()
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_tex
	RefreshStyle()

func InitSignals():
	connect("ToggleSplitStackState", self, "ToggleSplitStackState")
	
func AddItem(item):
	_itemContainer.add_child(item)
	item.position = Vector2(0, 0)
	RefreshStyle()
	
# "There can only be one"
func GetItemReference():
	if _itemContainer.get_child_count() == 0:
		return null
		
	return _itemContainer.get_child(0)

func TakeItem():
	var item = GetItemReference()
	_itemContainer.remove_child(item)
	RefreshStyle()
	return item
	
func SetSlotIndex(value):
	slot_index = value

func SetSlotName(value):
	name = value

func SetSlotType(value):
	_slotType = value

func GetSlotType():
	return _slotType
	
func GetSlotIndex():
	return slot_index

func AddIndexText(value):
	$IndexLabel.text = value
	
func ShowSplitStackSlider():
	if _slider == null || !is_instance_valid(_slider):
		_slider = _sliderScene.instance()
		_slider.position.x -= 3.5
		$SliderContainer.add_child(_slider)
		_slider.SetMaxValue(GetItemReference().GetItemCount())
		_slider.SetMinValue(0)
		_slider.SetValue(0)

func _process(_delta):
	var currentY = get_viewport().get_mouse_position().y
	if _splittingStack:
		var lowerRange = GetItemReference().GetItemCount() / 2
		var deltaY = _midY - currentY
		var newValue = deltaY * 0.05 * lowerRange
		if newValue < 0:
			newValue = 0
		_slider.SetValue(newValue)
		deltaY *= -1
		_slider.SetLabelPosition(deltaY)
		_slider.SetLabelText(str(_slider.GetValue()))


func RefreshStyle():
	if _slotType == SlotTypes.HOTBAR and PlayerInventory.active_item_slot == slot_index:
		set('custom_styles/panel', selected_style)
	elif GetItemReference() == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)

func SlideTimerFinished():
	if _waitingForMouseUp:
		_splittingStack = true
		set_process(true)
		ShowSplitStackSlider()

func SplitStack():
	if is_instance_valid(_slider) && _slider.GetValue() == 0:
		_slider.queue_free()
		return
	elif !is_instance_valid(_slider):
		return
		
	var itemInSlot = GetItemReference()
	var item = ItemManager.CreateItem(itemInSlot.GetItemName(), _slider.GetValue())
	InventoryManager.HoldItem(item)
	GetItemReference().SetItemCount(GetItemReference().GetItemCount() - _slider.GetValue())
	if GetItemReference().GetItemCount() <= 0:
		var emptyItem = TakeItem()
		emptyItem.queue_free()
	_slider.queue_free()
	_splittingStack = false
		
func _on_Slot_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			Signals.emit_signal("SlotClicked", self)
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			if GetItemReference() != null && is_instance_valid(GetItemReference()) && GetItemReference()._splittable:
				_waitingForMouseUp = true
				# Store this early because of our wait timer so mouse
				# movement doesn't impact offset.
				_midY = get_viewport().get_mouse_position().y
				print(str(_midY))
				$SlideTimer.start()
		elif event.button_index == BUTTON_RIGHT and !event.pressed:
			if _splittingStack:				
				set_process(false)
				SplitStack()
			else:
				# User fast right clicked
				$SlideTimer.stop()
				set_process(false)
				if _slider != null && is_instance_valid(_slider):
					_slider.queue_free()
				var slot = InventoryManager.GetInventory().GetFirstAvailableSlot()
				if is_instance_valid(slot):
					slot.AddItem(InventoryManager.TakeHeldItem())
				

func _on_SlideTimer_timeout():
	SlideTimerFinished()
