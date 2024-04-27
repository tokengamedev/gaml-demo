extends Control

#@onready var toast_message: ToastMessage = $ToastMessage


func _ready():
	ReviewManager.review_completed.connect(_on_review_completed)
	ReviewManager.review_launch_failed.connect(_on_review_launch_failed)


func _on_review_completed():
	print("Review Completed")
	#toast_message.show_info("Review completed")


func _on_review_launch_failed(message: String):
	print("Review launch failed due to %s" % message)
	#toast_message.show_warning("Review launch failed due to %s" % message)


func _on_in_app_review_button_pressed() -> void:
	ReviewManager.launch_in_app_review()


func _on_in_store_review_button_pressed() -> void:
	ReviewManager.launch_in_store_review()
