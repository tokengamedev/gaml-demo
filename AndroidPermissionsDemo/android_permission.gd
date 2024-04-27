@tool
extends Control

const STATUS = PermissionManager.STATUS
const PERMISSIONS = PermissionManager.PERMISSIONS

const STATUS_TEXTURE := {
	STATUS.DENIED: 		preload("res://assets/denied.svg"),
	STATUS.UNKNOWN:		preload("res://assets/default.png"),
	STATUS.GRANTED:		preload("res://assets/granted.svg"),
	STATUS.DENIED_WITH_RATIONALE:	preload("res://assets/denied__with.svg")
}
@onready var toast_message = $ToastMessage

@onready var permissions := {
	PERMISSIONS.READ_EXTERNAL_STORAGE:
		{
			"option" : $Body/MarginContainer/VBoxContainer/ReadExternalStorage/CheckBox,
			"status" : $Body/MarginContainer/VBoxContainer/ReadExternalStorage/Status,
			"result" : PermissionManager.STATUS.UNKNOWN
		},
	PERMISSIONS.READ_CONTACTS:
		{
			"option" : $Body/MarginContainer/VBoxContainer/ReadContacts/CheckBox,
			"status" : $Body/MarginContainer/VBoxContainer/ReadContacts/Status,
			"result" : PermissionManager.STATUS.UNKNOWN
		},
	PERMISSIONS.POST_NOTIFICATIONS:
		{
			"option" : $Body/MarginContainer/VBoxContainer/PostNotification/CheckBox,
			"status" : $Body/MarginContainer/VBoxContainer/PostNotification/Status,
			"result" : PermissionManager.STATUS.UNKNOWN
		},
	PERMISSIONS.READ_CALENDAR:
		{
			"option" : $Body/MarginContainer/VBoxContainer/ReadCalendar/CheckBox,
			"status" : $Body/MarginContainer/VBoxContainer/ReadCalendar/Status,
			"result" : PermissionManager.STATUS.UNKNOWN
		}
}

@onready var request_permission_button = $Body/Actions/RequestPermissionButton

func _ready():

	if not PermissionManager.is_service_available():
		toast_message.show_error("Permission service not available")
	# Wait for 1 sec
	await get_tree().create_timer(1).timeout

	for permission in permissions:
		permissions[permission].option.connect("toggled", _on_option_toggled.bind(permission))

	request_permission_button.disabled = true
	for permission in permissions:
		update_permission_status(
			permission,
			PermissionManager.check_permission(permission))

	PermissionManager.connect("permission_request_completed", _on_request_completed)


func update_permission_status(permission: PERMISSIONS, status: STATUS):

	print("result=", STATUS.find_key(status))
	permissions[permission].result = status
	permissions[permission].status.texture = STATUS_TEXTURE[status]


func _on_option_toggled(pressed: bool, permission):

	if pressed:
		print(permission)
		if ( permissions[permission].result != STATUS.GRANTED):
			request_permission_button.disabled = false
		else:
			request_permission_button.disabled = true


func _on_RequestPermissionButton_pressed():
	for permission in permissions:
		if permissions[permission].option.pressed:
			print("requesting for permission ", permission			)
			PermissionManager.request_permission(permission)
			break


func _on_request_completed(code,  status):
	display_result("Permission for " + PERMISSIONS.find_key(code), status )
	update_permission_status(code, status)

func display_result(message: String, status: int):
	prints(message, ":", STATUS.find_key(status))
	match(status):
		PermissionManager.STATUS.DENIED:
			toast_message.show_warning(message + " : DENIED")
		PermissionManager.STATUS.DENIED_WITH_RATIONALE:
			toast_message.show_warning(message + " : DENIED (Needs Rationale)")
		PermissionManager.STATUS.GRANTED:
			toast_message.show_info(message + " : GRANTED")
