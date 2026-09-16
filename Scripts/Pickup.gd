extends Area3D

@export var item_data: ItemData

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "PlayerBody":
		var inventory = body.get_parent().get_node("UI/InventoryUI")
		if inventory and item_data:
			if inventory.add_item(item_data):
				queue_free()
