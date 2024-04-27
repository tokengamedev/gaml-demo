@tool
extends EditorPlugin

var export_plugin : AndroidPermissionPlugin

func _enter_tree():
	export_plugin = AndroidPermissionPlugin.new()
	add_export_plugin(export_plugin)


func _exit_tree():
	remove_export_plugin(export_plugin)
	export_plugin = null


class AndroidPermissionPlugin extends EditorExportPlugin:
	## TODO Step 3: Update the PLUGIN_NAME and PLUGIN_FILE_NAME here
	const PLUGIN_NAME = "AndroidPermission"
	const PLUGIN_FILE_NAME = "AndroidPermission.2.0.0.release.aar"

	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false

	func _get_android_libraries(platform, debug):
		return PackedStringArray([PLUGIN_NAME.path_join(PLUGIN_FILE_NAME)])


	func _get_android_dependencies(platform, debug):
		return PackedStringArray([])

	func _get_name():
		return PLUGIN_NAME
