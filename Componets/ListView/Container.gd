extends Control

signal item_selected(index)

export(NodePath) var item_container; # Control to insert elements
export(NodePath) var drag_control; # Control to move with mouse or touch
export var threshold = 10.0; # Minimun movement to star drag control
export(bool) var vertical_scroll = true; # Allow vertical movement
export(bool) var horizontal_scroll = true; # Allow horizontal movement

# Internal variables
var drag_control_node
var last_selected_item_index = -1

# Mouse drag initial state
var initial_mouse_position
var initial_container_position
var is_mouse_pressed = false
var is_mouse_dragging = false

func _ready():
	drag_control_node = get_node(drag_control);

# Insert element and connect signal to know whitch is under the mouse
func insert_item(item):
	item.connect("levelSelected", self, "set_last_selected_item_index");
	get_node(item_container).add_child(item);

func set_last_selected_item_index(index):
	last_selected_item_index = index;

# The CORE CODE
func _gui_input(event):
	# Check if mouse (touch) is pressed and keep the initial data
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		is_mouse_pressed = true;
		initial_container_position = drag_control_node.rect_position;
		initial_mouse_position = get_local_mouse_position();
	
	#Process mouse (touch) release
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
		is_mouse_pressed = false;
		
		#If not dragging then emit the signal of item selected
		if not is_mouse_dragging and last_selected_item_index > -1:
			emit_signal("item_selected", last_selected_item_index);
			last_selected_item_index = -1;
		# Reset gragging flag
		is_mouse_dragging = false;
	
	# If mouse not pressed no process the remain code
	if not is_mouse_pressed:
		return
	
	# If the mouse (touch) is moving
	if event is InputEventMouseMotion:
		var current_mouse_postion = get_local_mouse_position();
		var diff_mouse_position = current_mouse_postion - initial_mouse_position;
		
		# Check if the movement is greater the threshold to allow drag
		if diff_mouse_position.length() > threshold:
			is_mouse_dragging = true;
			last_selected_item_index = -1;
	
	# If mouse (touch) dragging the move the control position
	if is_mouse_dragging:
		var current_mouse_postion = get_local_mouse_position();
		var diff_mouse_position = current_mouse_postion - initial_mouse_position;
		
		# Calculate the new position
		var x_move = diff_mouse_position.x if horizontal_scroll else 0;
		var y_move = diff_mouse_position.y if vertical_scroll else 0;
		var new_position = initial_container_position + Vector2(x_move, y_move);
		
		# Apply the limits of the control size
		if new_position.x > 0:
			new_position.x = 0;
		if new_position.x < (rect_size.x - drag_control_node.rect_size.x):
			new_position.x = (rect_size.x - drag_control_node.rect_size.x)
			
		if new_position.y > 0:
			new_position.y = 0;
		if new_position.y < (rect_size.y - drag_control_node.rect_size.y):
			new_position.y = (rect_size.y - drag_control_node.rect_size.y)
		
		# Set the new position
		drag_control_node.rect_position = new_position;
