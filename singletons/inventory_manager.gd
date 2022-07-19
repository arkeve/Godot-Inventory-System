extends Node2D

var _inventory

func _start():
	InitSignals()

func InitSignals():
	Signals.connect("HoldItem", self, "HoldItem")
	
func SetInventory(inventory):
	_inventory = inventory

func GetInventory():
	return _inventory

func GetHeldItemReference():
	return GameManager.GetUserInterface().GetHeldItemReference()

func TakeHeldItem():
	return GameManager.GetUserInterface().TakeHeldItem()
		
func HoldItem(item):
	GameManager.GetUserInterface().AddItemForTransfer(item)
