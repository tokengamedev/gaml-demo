@tool
extends EditorPlugin

var export_plugin : GooglePlayReviewPlugin

func _enter_tree():
	export_plugin = GooglePlayReviewPlugin.new()
	add_export_plugin(export_plugin)


func _exit_tree():
	remove_export_plugin(export_plugin)
	export_plugin = null


class GooglePlayReviewPlugin extends EditorExportPlugin:
	const PLUGIN_NAME = "GooglePlayReview"
	const PLUGIN_FILE_NAME = "GooglePlayReview.2.0.0.release.aar"

	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false

	func _get_android_libraries(platform, debug):
		return PackedStringArray([PLUGIN_NAME.path_join(PLUGIN_FILE_NAME)])


	func _get_android_dependencies(platform, debug):
		return PackedStringArray(["com.google.android.play:review:2.0.1"])

	func _get_name():
		return PLUGIN_NAME
