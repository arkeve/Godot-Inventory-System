extends Node2D

onready var _slider = $VSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetStepValue(value):
	_slider.step = value
	
func SetMinValue(value):
	_slider.min_value = value

func SetMaxValue(value):
	_slider.max_value = value

func SetValue(value):
	_slider.value = value

func GetValue():
	return _slider.value

func SetLabelPosition(value):
	$Spliiter.position.y = value

func SetLabelText(value):
	$Spliiter/SplitAmountLabel.text = str(value)
