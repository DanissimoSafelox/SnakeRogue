extends Node2D

var food = preload("res://Items/apple.tscn")


func _ready():
	Global.js_show_ad()
	$TextureRect.size.x = 2000
	$TextureRect.size.y = 2000
	$TextureRect.position.x = 0
	$TextureRect.position.y = 0
	spawn_food(10)
	randomize()
	


func spawn_food(count):
	for i in count:
		var new_food = food.instantiate() # в переменной содержится экземпляр
		new_food.position.x = randi_range(50, 1950)
		new_food.position.y = randi_range(50, 1950)
		#owner.add_child.call_deferred(new_food)
		add_child.call_deferred(new_food)
