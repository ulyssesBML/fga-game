extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Jogar_pressed():
	get_tree().change_scene("res://World.tscn")


func _on_Creditos_pressed():
	get_tree().change_scene("res://Creditos.tscn")
	
