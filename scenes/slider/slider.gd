extends Node2D

onready var _slider = $VSlider

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
	$Splitter.position.y = value
	if $Splitter.position.y > 16:
		$Splitter.position.y = 16

func SetLabelText(value):
	$Splitter/SplitAmountLabel.text = str(value)
