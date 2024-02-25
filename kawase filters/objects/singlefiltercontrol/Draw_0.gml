for (var i = 0; i < 5; i++) {
	if (surface_exists(stack[i]) == false) {
		stack[i] = surface_create(room_width * 0.5, room_height * 0.5);
	}
}

gpu_set_tex_filter(true);

surface_set_target(stack[0]) {
	shader_set(kawasesinglefilter) {
		shader_set_uniform_f(uoffset, kernels[0]);
		image_xscale = 0.5;
		image_yscale = 0.5;
		draw_self();
		image_xscale = 1;
		image_yscale = 1;
		shader_reset();
	}
	surface_reset_target();
}


for (var i = 1; i < 5; i++) {
	surface_set_target(stack[i]) {
		shader_set(kawasesinglefilter) {
			shader_set_uniform_f(uoffset, kernels[i]);
			draw_surface(stack[i - 1], 0, 0);
			shader_reset();
		}
		surface_reset_target();
	}	
}

gpu_set_tex_filter(false);

draw_self();
//draw_surface_part(stack[4], mouse_x, 0, room_width - mouse_x, room_width, mouse_x, 0);
draw_surface_stretched(stack[4], 0, 0, room_width, room_height)
//draw_line_width_color(mouse_x, -1, mouse_x, room_width, 2, #000000, #000000)