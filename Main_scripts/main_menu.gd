extends Control

@onready var Money_label = $MarginContainer/VBoxContainer/Panel/VBoxContainer/Label

func _process(delta):
	update_money()
	
func update_money():
	Money_label.text = "Монеты: %d" % [Global.coins]
	


func _on_button_start_game_pressed():
	get_tree().change_scene_to_file("res://Main_Scenes/world.tscn")


func _on_button_get_money_pressed():
	Global.js_show_rewarded_ad()
