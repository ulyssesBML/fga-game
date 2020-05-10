extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_speed = 100

var acelleration = 100
var friction = 1000
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree =$AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Andando/blend_position", input_vector)
		animationTree.set("parameters/Parado/blend_position", input_vector)
		animationTree.set("parameters/Correndo/blend_position", input_vector)
		if(Input.is_key_pressed(KEY_SHIFT)):
			max_speed = 150
			animationState.travel("Correndo")		
		else:
			max_speed = 100
			animationState.travel("Andando")
		velocity = velocity.move_toward(input_vector * max_speed ,acelleration * delta)
	else:
		animationState.travel("Parado")
		velocity = velocity.move_toward(Vector2.ZERO,friction*delta)
		
	velocity = move_and_slide(velocity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
