extends Node

signal permission_request_completed(permission: PERMISSIONS, status: STATUS )

enum PERMISSIONS {
	READ_CALENDAR = -1,
	READ_EXTERNAL_STORAGE = 3,
	READ_CONTACTS = 4,
	POST_NOTIFICATIONS = 20,
}

enum STATUS {
	UNKNOWN = -1,
	GRANTED = 0,
	DENIED = 1,
	DENIED_WITH_RATIONALE = 2,
}

const CUSTOM_PERMISSIONS := {
	PERMISSIONS.READ_CALENDAR : "android.permission.READ_CALENDAR"
}

var permission_plugin

func is_service_available(): return permission_plugin != null

func _ready():
	# Check if the plugin is available
	if Engine.has_singleton("AndroidPermission"):
		print("Android Permission Service is available.")
		# Get a reference to the singleton
		permission_plugin = Engine.get_singleton("AndroidPermission")

		permission_plugin.connect(
			"permission_request_completed",
			_on_permission_request_completed)
	else:
		print("Android Permission Service not available.")


func check_permission(permission: PERMISSIONS):

	if not permission_plugin:
		return STATUS.UNKNOWN

	match(permission):
		PERMISSIONS.READ_EXTERNAL_STORAGE, \
		PERMISSIONS.READ_CONTACTS, \
		PERMISSIONS.POST_NOTIFICATIONS:
			return permission_plugin.checkPermission(permission)
		_:
			return permission_plugin.checkPermissionString(CUSTOM_PERMISSIONS[permission])


func request_permission(permission: PERMISSIONS):

	if not permission_plugin:
		return

	prints("requested permission:",PERMISSIONS.find_key(permission))

	match(permission):
		PERMISSIONS.READ_EXTERNAL_STORAGE, \
		PERMISSIONS.READ_CONTACTS, \
		PERMISSIONS.POST_NOTIFICATIONS:
			permission_plugin.requestPermission(permission)
		_:
			permission_plugin.requestPermissionString(CUSTOM_PERMISSIONS[permission])


func _on_permission_request_completed(permission_code, permission_string, status):
	if permission_code > 0:
		permission_request_completed.emit(permission_code as PERMISSIONS, status as STATUS)
	else:
		permission_code = CUSTOM_PERMISSIONS.find_key(permission_string)
		permission_request_completed.emit(permission_code as PERMISSIONS, status as STATUS)

