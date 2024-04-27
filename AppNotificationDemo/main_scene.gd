extends Control

@onready var cancel_after: Button = %CancelAfter
@onready var timer: Timer = $Timer
@onready var toast_message: ToastMessage = %ToastMessage

func _ready() -> void:
	cancel_after.disabled = true
	if not NotificationManager.is_service_available():
		toast_message.show_error("Notification service not available.")


func _exit_tree() -> void:
	if not timer.is_stopped():
		timer.stop()

#region Basic Notifications

func _on_send_now_button_pressed() -> void:
	toast_message.show_info("Notification sent.")
	NotificationManager.send_notification(
		"GAML Message",
		"You have succeeded in showing notification.")


func _on_send_after_pressed() -> void:
	toast_message.show_info("Notification scheduled.")
	timer.wait_time = 9 # 1 seconds less then actual wait time
	NotificationManager.send_notification_after(
		"Gaml delayed message",
		"Message is shown after 10 secs (approx)",
		10)
	timer.start()
	cancel_after.disabled = false


func _on_timer_timeout() -> void:
	cancel_after.disabled = true


func _on_cancel_after_pressed() -> void:
	toast_message.show_info("Scheduled notification canceled.")
	NotificationManager.cancel_delayed_notification()
	cancel_after.disabled = true
	timer.stop()


func _on_send_recurring_toggled(toggled_on: bool) -> void:
	if toggled_on:
		toast_message.show_info("Recurring notification set.")
		NotificationManager.setup_notification_recurring(
			"Gaml recurring message",
			"Message shown at regular intervals",
			10, # first message will be shown after 10 seconds
			30, # recurring message will be shown after 30 seconds
			)
	else:
		toast_message.show_info("Recurring notification canceled.")
		NotificationManager.cancel_recurring_notification()

#endregion

#region Advanced Notifications

func _on_is_grouped_toggled(toggled_on: bool) -> void:
	if toggled_on:
		toast_message.show_info("You have enbaled grouping of message.")
	else:
		toast_message.show_info("You have disabled grouping of message.")
	NotificationManager.set_grouped(toggled_on)


func _on_send_custom_pressed() -> void:
	NotificationManager.send_custom_notification(
		NotificationManager.NOTIFY_CUSTOM,
		"Gaml Custom Message",
		"Notification is much better with customization")


func _on_send_tagged_pressed() -> void:
	var current_tag = (randi() % 4) + 1
	toast_message.show_info("Sent message with tag %s" % current_tag)
	NotificationManager.send_tagged_notification(
		str(current_tag),
		"Gaml Tagged Message",
		"Message can be subgrouped by tags")


func _on_send_big_image_pressed() -> void:
	NotificationManager.send_custom_notification(
		NotificationManager.NOTIFY_CUSTOM_BIG_PICTURE,
		"Gaml Image Message",
		"A picture is worth thousand words")


func _on_send_big_text_pressed() -> void:
	NotificationManager.send_custom_notification(
		NotificationManager.NOTIFY_CUSTOM_BIG_TEXT,
		"Gaml Long Text Message",
		"A long text begins with one word. This is a very long text which will wrap into two lines."	)
#endregion
