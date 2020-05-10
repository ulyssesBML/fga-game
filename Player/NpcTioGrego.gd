extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var init_pos = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer
onready var animationTree =$AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	init_pos = position


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	#input_vector.x =+ 50
	var actual_pos = position-init_pos
	
	var height_square = 30
	var width_square = 50
	
	if actual_pos.x < width_square and actual_pos.y <= 0:
		input_vector.x =+ 50
	elif actual_pos.y < height_square and actual_pos.x > 0:
		input_vector.y =+ 50
	elif actual_pos.x > 0:
		input_vector.x =- 50
	elif actual_pos.y > 0:
		input_vector.y =- 50
	

	animationTree.set("parameters/Andar/blend_position", input_vector.normalized())
	animationState.travel("Andar")
	
	move_and_slide(input_vector)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
