/*
	follow basic gml conventions for handling surfaces: do not
	make them in create events, do not initialize them to integers
	and if the surface needs to be updated each frame then always
	check for existence first.
	
	here we draw something on the content surface
*/
if (surface_exists(stack[0]) == false) {
	stack[0] = surface_create(room_width, room_height);
	surface_set_target(stack[0]) {
		draw_sprite(background, 0, 0 ,0);
		surface_reset_target();
	}
}

/*
	kawase_single_filter_begin is used here to initialize the blur.
	this function creates the ping and pong surfaces, downsamples
	the contents surface, and begins the blur
*/
kawase_single_filter_begin(stack);

/*
	kawase_single_filter_process flips and flops between ping and pong
	to do the goodtimes
*/
kawase_single_filter_process(stack, distances);

/*
	kawase_single_filter_render draws the final contents, but you can also
	use index 0 of the stack in other places to draw it yourself or use as
	a texture in a shader or whatevs.
*/
kawase_single_filter_render(stack, 0, 0);

/*
	draw the sprite for comparison
*/
draw_sprite_part(background, 0, mouse_x, 0, room_width - mouse_x, room_height, mouse_x, 0);