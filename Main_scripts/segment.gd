extends CharacterBody2D

var look = 0
var current_item: String
@onready var key_sprite = $Item_sprite_key
var head: CharacterBody2D

func change_current_item(new_item: String):
	current_item = new_item
	if new_item == "key":
		key_sprite.visible = true
	if new_item == "empty":
		key_sprite.visible = false

func _ready():
	change_current_item("empty")
	head.resort_inventory()
	
func _physics_process(delta):
	$Sprite2D.rotation = look
	move_and_slide()
	
