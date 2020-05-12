extends Node


onready var label = $Label
onready var timer = $Timer
onready var web_script = Global.web_script
# Called when the node enters the scene tree for the first time.
func _ready():
	web_script.connect("close_load_container",self,"dissmis")


func dissmis():
	self.queue_free()
