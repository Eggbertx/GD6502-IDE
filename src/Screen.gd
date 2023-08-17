extends Sprite2D

const palette = [
	Color("#000000"), Color("#ffffff"), Color("#880000"), Color("#aaffee"),
	Color("#cc44cc"), Color("#00cc55"), Color("#0000aa"), Color("#eeee77"),
	Color("#dd8855"), Color("#664400"), Color("#ff7777"), Color("#333333"),
	Color("#777777"), Color("#aaff66"), Color("#0088ff"), Color("#bbbbbb")
]

# 32x32, or 1024
const num_pixels = 0x400
var pixel: Rect2
var pixel_pos: Vector2
var pixels = []
var running = true

func _ready():
	pixel_pos = Vector2(0, 0)
	pixel = Rect2(pixel_pos,Vector2(1, 1))
	for _p in range(num_pixels):
		pixels.append(palette[0])

func _draw():
	var v = Vector2(0, 0)
	for _p in range(num_pixels):
		v.x = (_p % 32)
		v.y = (_p / 32)
		pixel.position = v
		draw_rect(pixel, pixels[_p])

func set_pixel_col(index:int, color:int):
	if pixels.size() > index:
		pixels[index] = palette[color]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if running:
		pass #update()
