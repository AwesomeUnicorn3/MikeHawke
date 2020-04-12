extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Texture) var body_path
export (Texture) var shirt_path

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpriteTest.visible = false
	var Body = load(body_path.get_path())
	var Shirt = load(shirt_path.get_path())
	$Body.set_texture(Body)
	$Shirt.set_texture(Shirt)

