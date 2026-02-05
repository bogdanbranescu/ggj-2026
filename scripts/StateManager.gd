extends Node


@onready var state_chart := $StateChart as StateChart


func send_event(event: String) -> void:
	state_chart.send_event(event)


func _ready() -> void:
	state_chart.get_node("Mode/Main").state_entered.connect(_on_main_entered)
	state_chart.get_node("Mode/Outro").state_entered.connect(_on_outro_entered)


func _on_main_entered() -> void:
	# TODO handle music, player movement, masks
	EventBus.player_movement_disabled.emit()
	await get_tree().create_timer(0.7).timeout

	EventBus.player_movement_enabled.emit()
	get_node("../AnnouncerFIGHT").play()


func _on_outro_entered() -> void:
	print("GAME OVER")
	# TODO handle music, player movement, masks, win panel
	
	get_node("../BGM").stop()
	get_node("../VictoryJingle").play()
	
	var sfx = get_node("../AnnouncerKNOCKOUT")
	sfx.play()
	await sfx.finished
	
	# sfx = get_node("../AnnouncerWIN")
	# sfx.play()
	# await sfx.finished
	
	await get_tree().create_timer(1.5).timeout
	
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
