extends Control


# Declare member variables here. Examples:
onready var maleButton = $Male
onready var femaleButton = $Female
onready var lineEdit = $LineEdit


func _ready():
	pass # Replace with function body.




func _on_LineEdit_text_changed(new_text):
	if lineEdit.text == "":
		maleButton.disabled = true
		femaleButton.disabled = true
	else:
		maleButton.disabled = false
		femaleButton.disabled = false


func _on_Female_pressed():
	Global.player_name = lineEdit.text
	Global.player_character = "female"
	get_tree().change_scene("res://World.tscn")


func _on_Male_pressed():
	Global.player_name = lineEdit.text
	Global.player_character = "male"
	get_tree().change_scene("res://World.tscn")
