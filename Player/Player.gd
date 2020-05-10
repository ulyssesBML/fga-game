extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_speed = 100

var acelleration = 100
var friction = 1000
var velocity = Vector2.ZERO
var at_animation = "Parado"

onready var camera = $Camera2D
onready var animationPlayer = $AnimationPlayer
onready var animationTree =$AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var id = null
var input_vector = Vector2.ZERO
var enable = false
var new_pos = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	if enable:
		camera.current = true
	else:
		camera.current = false		

func _physics_process(delta):
	if enable:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
	
		if input_vector != Vector2.ZERO:
			animationTree.set("parameters/Andando/blend_position", input_vector)
			animationTree.set("parameters/Parado/blend_position", input_vector)
			animationTree.set("parameters/Correndo/blend_position", input_vector)
			if(Input.is_key_pressed(KEY_SHIFT)):
				max_speed = 150
				at_animation = "Correndo"
			else:
				max_speed = 100
				at_animation = "Andando"
			velocity = velocity.move_toward(input_vector * max_speed ,acelleration * delta)
		else:
			at_animation = "Parado"
			velocity = velocity.move_toward(Vector2.ZERO,friction*delta)
		
		animationState.travel(at_animation)
		velocity = move_and_slide(velocity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func passPlayerInformationToServer(): #just work to enable Player
	return '{"id":"{0}","pos_x":{1},"pos_y":{2},"at_animation":"{3}","input_vector_x":"{4}","input_vector_y":"{5}"}'.format([id,position.x, position.y,at_animation,input_vector.x,input_vector.y]) 
	
func processOtherPlayersInfo(data):
	var n_input_vector = Vector2(data.input_vector_x,data.input_vector_y)
	if n_input_vector != Vector2.ZERO:
		animationTree.set("parameters/Andando/blend_position", n_input_vector)
		animationTree.set("parameters/Parado/blend_position", n_input_vector)
		animationTree.set("parameters/Correndo/blend_position", n_input_vector)
	animationState.travel(data.at_animation)
	position.x=data.pos_x
	position.y=data.pos_y
