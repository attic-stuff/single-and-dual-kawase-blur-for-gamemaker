if (surface_exists(stack[0]) == false) {
	stack[0] = surface_create(room_width, room_height);
	surface_set_target(stack[0]) {
		draw_sprite(background, 0, 0 ,0);
		surface_reset_target();
	}
}

kawase_single_filter_copy(stack, kernels);
kawase_single_filter_process(stack, kernels);
kawase_single_filter_render(stack, 0, 0);