class_name ToastMessage extends MarginContainer

enum ICON { NONE, INFO, WARNING, ERROR }
enum POSITION {TOP, MIDDLE, BOTTOM }

const icon_textures := {
	ICON.INFO: preload("./assets/info.svg"),
	ICON.WARNING: preload("./assets/warning.svg"),
	ICON.ERROR: preload("./assets/error.svg")	}

const colors := {
	ICON.INFO: Color("#3679e2"), # blue
	ICON.WARNING: Color("#ffbc2d"), # yellow/orange
	ICON.ERROR: Color("#e85c5c"), # red
}

@export var icon: ICON: set = set_icon
@export var message: String: set = set_message
@export var dialog_position := POSITION.MIDDLE: set = set_dialog_position
@export var timeout: int = 4 # (int, 2, 10, 1)

@export var fg_color: Color = Color("#e9e9e9")

@onready var timer = $Timer
@onready var label = $Panel/Margin/Container/Label
@onready var image = $Panel/Margin/Container/Icon

var animation_time := 0.8 # seconds

func _ready():
	timer.wait_time = float(timeout)


func set_message(_message):
	message = _message
	# set the text
	label.text = message


func set_dialog_position(_dialog_position):
	dialog_position = _dialog_position
	match(_dialog_position):
		POSITION.MIDDLE:
			anchor_top = 0.5
			anchor_bottom = 0.5
		POSITION.TOP:
			anchor_top = 0.15
			anchor_bottom = 0.15
		POSITION.BOTTOM:
			anchor_top = 0.9
			anchor_bottom = 0.9


func set_icon(_icon):
	icon = _icon
	# Set the Icon
	label.label_settings.font_color = fg_color
	if icon == ICON.NONE:
		image.visible = false
		label.label_settings.font_color = fg_color
	else:
		image.texture = icon_textures[icon]
		image.modulate = colors[icon]
		image.visible = true
		label.label_settings.font_color = (colors[icon] as Color).lightened(0.25)


func show_error(text: String, dlg_position = POSITION.BOTTOM):
	_show_message(text, ICON.ERROR, dlg_position )

func show_warning(text: String, dlg_position = POSITION.BOTTOM):
	_show_message(text, ICON.WARNING, dlg_position )

func show_info(text: String, dlg_position = POSITION.BOTTOM):
	_show_message(text, ICON.INFO, dlg_position )

func show_message(text: String, dlg_position = POSITION.BOTTOM):
	_show_message(text, ICON.NONE, dlg_position )

func _show_message(text: String, icon: ICON, dlg_position = POSITION.BOTTOM):
	set_message(text)
	set_icon(icon)
	set_dialog_position(dlg_position)
	animation_time = 0.8

	modulate.a = 0.0
	visible = true
	await get_tree().process_frame

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, animation_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	timer.start()


func _on_CloseButton_pressed():
	animation_time = 0.4
	hide_message()


func hide_message():
	if not timer.is_stopped():
		timer.stop()

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, animation_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)


func _on_Timer_timeout():
	hide_message()

