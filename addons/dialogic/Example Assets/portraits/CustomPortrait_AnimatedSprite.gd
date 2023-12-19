@tool
extends Node2D

# If the custom portrait accepts a change, then accept it here
func _update_portrait(passed_character:DialogicCharacter, passed_portrait:String) -> void:
	if passed_portrait == "":
		passed_portrait = passed_character['default_portrait']
	
	if $Sprite2D.sprite_frames.has_animation(passed_portrait):
		$Sprite2D.play(passed_portrait)

func _on_animated_sprite_2d_animation_finished():
	$Sprite2D.frame = randi()%$Sprite2D.sprite_frames.get_frame_count($Sprite2D.animation)
	$Sprite2D.play()


func _get_covered_rect() -> Rect2:
	return Rect2($Sprite2D.position, $Sprite2D.sprite_frames.get_frame_texture($Sprite2D.animation, 0).get_size()*$Sprite2D.scale)
