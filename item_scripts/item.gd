extends Area2D

class_name  Item
# ЭТО УНИВЕРСАЛЬНЫЙ КОМПОНЕНТ - ПРЕДМЕТ


@export_enum("food", "key", "empty") var Item_type: String
@export var Power = 1
func _on_body_entered(body):
	if Item_type == "food":	#	Если еда
		body.segment_spawn(Power) # выполняем функцию в змейке для создания нового сегмента
		body.get_parent().spawn_food(1) # выполняем функцию в родительской ноде world для создания новой еды
		get_parent().queue_free() # Нас съедают
	else:	#	Если не еда
		body.take_item(self)
	
