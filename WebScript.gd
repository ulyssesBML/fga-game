extends Node

const Player = preload("res://Player/Player.tscn")
var player_id = null
var players_list = [] 
var ws = null

func _ready():
	self.connect("walk",Player,"_setNewPos")
	ws = WebSocketClient.new()
	ws.connect("connection_established", self, "_connection_established")
	ws.connect("connection_closed", self, "_connection_closed")
	ws.connect("connection_error", self, "_connection_error")
	
	#var url = "ws://localhost:3000"
	var url = "ws://fgagame.herokuapp.com"
	
	print("Connecting to " + url)
	ws.connect_to_url(url)
	
func _connection_established(protocol):
	print("Connection Established With Protocol: ", protocol)
	
func _connection_closed():
	print("Connection Closed")

func _connection_error():
	var rng = RandomNumberGenerator.new()
	var instance= Player.instance()
	instance.id = str(rng.randi())
	instance.name = str(rng.randi())
	instance.enable = true
	self.add_child(instance)
	print("Connection Error")
	

func _process(delta):
	if ws.get_connection_status() == ws.CONNECTION_CONNECTING || ws.get_connection_status() == ws.CONNECTION_CONNECTED:
		ws.poll()
	
	if ws.get_peer(1).is_connected_to_host():
		#if Input.is_action_just_released("ui_up"):
		var buffer = StreamPeerBuffer.new()
		var player_obj = _getActualPlayer()
		if player_obj:
			var info_play = player_obj.passPlayerInformationToServer()
			buffer.put_string(info_play)
		else:
			buffer.put_string('{}')
		_sendPacket(buffer.get_data_array())
			
		if ws.get_peer(1).get_available_packet_count() > 0 :
			var packet = ws.get_peer(1).get_packet()
			buffer = StreamPeerBuffer.new()
			buffer.set_data_array(packet)
			var type = buffer.get_u16()
			match type:
				1:
					player_id = buffer.get_string()
					print("My id is %s !" % player_id)
					var instance= Player.instance()
					instance.id = player_id
					instance.name = player_id
					instance.enable = true
					self.add_child(instance)
				2:
					#print('Recieve %s' % buffer.get_string())
					var all_players = JSON.parse(buffer.get_string()).result
					
					if all_players:		
						remove_deactivated_nodes(all_players)
					
					for wp in all_players:
						if wp.id in players_list and wp.id != player_id:
							for p in self.get_children():
								if p.id == wp.id:
									p.processOtherPlayersInfo(wp)
								
						elif not wp.id in players_list and wp.id != player_id:
							var instance = Player.instance()
							instance.id = wp.id
							instance.name = wp.id
							instance.position.x = wp.pos_x
							instance.position.y = wp.pos_y
							self.add_child(instance) 
							players_list.append(wp.id)

func _sendPacket(data):
	ws.get_peer(1).put_packet(data)

func _getActualPlayer():
	for p in self.get_children():
		if p.id == player_id:
			return p
	return null
	
func remove_deactivated_nodes(all_players):
	for p in self.get_children():
		var in_game = false
		for wp in all_players:
			if p.id == wp.id:
				in_game = true
		if not in_game and p.id!=player_id:
			p.queue_free()
