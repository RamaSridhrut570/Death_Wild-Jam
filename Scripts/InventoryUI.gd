extends HBoxContainer

var selected_slot_index: int = 0
var default_color: Color = Color(0.1, 0.1, 0.1, 0.8)
var selected_color: Color = Color(0.8, 0.8, 0.1, 0.8)

var items: Array[ItemData] = [null, null, null, null, null]

@onready var slots = [
	$Slot1,
	$Slot2,
	$Slot3,
	$Slot4,
	$Slot5
]

func _ready() -> void:
	_update_slot_visuals()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inv_1"):
		_select_slot(0)
	elif Input.is_action_just_pressed("inv_2"):
		_select_slot(1)
	elif Input.is_action_just_pressed("inv_3"):
		_select_slot(2)
	elif Input.is_action_just_pressed("inv_4"):
		_select_slot(3)
	elif Input.is_action_just_pressed("inv_5"):
		_select_slot(4)

func _select_slot(index: int) -> void:
	if selected_slot_index == index:
		return
	
	selected_slot_index = index
	_update_slot_visuals()
	
	var item = items[index]
	if item:
		print("Selected inventory slot: ", index + 1, " (", item.item_name, ")")
	else:
		print("Selected inventory slot: ", index + 1, " (Empty)")

func add_item(item: ItemData) -> bool:
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item
			_update_slot_visuals()
			print("Picked up: ", item.item_name)
			
			# Auto-select the slot if it's the only item
			if _get_item_count() == 1:
				_select_slot(i)
				
			return true
	print("Inventory is full!")
	return false

func _get_item_count() -> int:
	var count = 0
	for item in items:
		if item != null:
			count += 1
	return count

func get_selected_item_name() -> String:
	var item = items[selected_slot_index]
	if item:
		return item.item_name
	return ""

func _update_slot_visuals() -> void:
	for i in range(slots.size()):
		if i == selected_slot_index:
			slots[i].color = selected_color
		else:
			slots[i].color = default_color
		
		var icon_rect = slots[i].get_node("Icon")
		if items[i] != null and items[i].icon != null:
			icon_rect.texture = items[i].icon
		else:
			icon_rect.texture = null
