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
		draw_sprite(background, 0, 0, 0);
		surface_reset_target();
	}
}

/*
	kawase_dual_filter_begin does the initial copying and downsampling between the contents and
	filter surfaces
*/
kawase_dual_filter_begin(stack, spread);
/*
	kawase_dual_filter_process does the blur, going from the downscale process through the upscale process
*/
kawase_dual_filter_process(stack, spread);
/*
	kawase_dual_filter_render draws the final blurred surface
*/
kawase_dual_filter_render(stack, 0, 0);

/*
	draw the sprite for comparison
*/
draw_sprite_part(background, 0, mouse_x, 0, room_width - mouse_x, room_height, mouse_x, 0);