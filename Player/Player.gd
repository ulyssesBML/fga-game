extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_speed = 100

var acelleration = 100
var friction = 1000
var velocity = Vector2.ZERO
var at_animation = "Parado"

onready var sprite = $Sprite
onready var camera = $Camera2D
onready var lineedit = $LineEdit
onready var animationPlayer = $AnimationPlayer
onready var animationTree =$AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var timer = $Timer
onready var enviar = $Enviar
onready var speach = $Speach
onready var nome = $Nome
onready var music = $Music

var id = null
var input_vector = Vector2.ZERO
var enable = false
var new_pos = Vector2.ZERO
var speach_text = ""
var female_texture = load("res://assets/images/profem.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	if enable:
		nome.text = Global.player_name
		if Global.player_character == "female":
			sprite.texture = female_texture
		camera.current = true
	else:
		camera.current = false
		lineedit.visible = false
		enviar.visible = false
		$Button.visible = false
		music.playing = false
		music.queue_free()


func _physics_process(delta):
	speach.text = speach_text
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
	var astr = '{'
	astr = astr + '"id":"{0}",'
	astr = astr + '"pos_x":{1},'
	astr = astr + '"pos_y":{2},'
	astr = astr + '"at_animation":"{3}",'
	astr = astr + '"input_vector_x":"{4}",'
	astr = astr + '"input_vector_y":"{5}",'
	astr = astr + '"speach_text":"{6}",'
	astr = astr + '"player_name":"{7}",'
	astr = astr + '"player_character":"{8}"'
	astr = astr + '}'
	
	return astr.format([id,position.x, position.y,at_animation,input_vector.x,input_vector.y,speach_text,Global.player_name,Global.player_character]) 
	
func processOtherPlayersInfo(data):
	speach_text = data.speach_text
	var n_input_vector = Vector2(data.input_vector_x,data.input_vector_y)
	if n_input_vector != Vector2.ZERO:
		animationTree.set("parameters/Andando/blend_position", n_input_vector)
		animationTree.set("parameters/Parado/blend_position", n_input_vector)
		animationTree.set("parameters/Correndo/blend_position", n_input_vector)
	animationState.travel(data.at_animation)
	position.x=data.pos_x
	position.y=data.pos_y
	
	if data.player_character == 'female':
		sprite.texture = female_texture
		
	nome.text = data.player_name

func _on_Enviar_pressed():
	speach_text = lineedit.text
	timer.set_wait_time(2)
	timer.start()

func _on_Timer_timeout():
	speach_text = ""
	

func _input(ev):
	if Input.is_key_pressed(KEY_ENTER):
		speach_text = lineedit.text
		timer.set_wait_time(2)
		timer.start()
		lineedit.text = ""



func _on_Button_pressed():
	if enable:
		music.playing = not music.playing
