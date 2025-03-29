@tool
extends Area2D

var can_hover = true
var hovering = false:
	set(new_val):
		hovering = new_val
		
		if can_hover:
			if hovering:
				var tween = get_tree().create_tween()
				tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.4).set_trans(Tween.TRANS_SINE)
			else:
				var tween = get_tree().create_tween()
				tween.tween_property(self, "scale", Vector2(1, 1), 0.4).set_trans(Tween.TRANS_SINE)

@export var card : Card:
	set(new_card):
		card = new_card
		
		if $Display:
			$Display.texture = card.cover
			$MouseDetection.shape.size = card.back.get_size()

@export var size: float = 1.0:
	set(new_val):
		size = new_val
		
		if $Display:
			$Display.scale = Vector2(size, size)
			$MouseDetection.scale = Vector2(size, size)

func _on_mouse_entered():
	hovering = true

func _on_mouse_exited():
	hovering = false

func _on_input_event(viewport, event, shape_idx):
	#if Input.is_action_just_pressed("inspect") and hovering:
		#inspect_card()
	if Input.is_action_just_pressed("action"):
		var id = get_parent().get_card_viewer_index(self)
		if GameManager.play_card(card, id):
			
			var screen_size = get_viewport_rect().size
			reparent(get_tree().current_scene.ui)
			self.z_index = 10000
			can_hover = false
			
			# animate it enlargening in middle of screen and then disappearing
			var tween = get_tree().create_tween().set_parallel()
			tween.tween_property(self, "position", Vector2(screen_size.x/2,screen_size.y/2), 0.5).set_trans(Tween.TRANS_SINE)
			tween.tween_property(self, "scale", Vector2(4,4), 1).set_trans(Tween.TRANS_SINE)
			
			await get_tree().create_timer(1).timeout
			$AnimationPlayer.play("play_card")
			
			await get_tree().create_timer(1).timeout
			queue_free()
#
#func inspect_card():
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "scale", Vector2(2, 2), 0.5).set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self, "global_position", Vector2(get_viewport().size/2), 0.5).set_trans(Tween.TRANS_SINE)
