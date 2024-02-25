if (keyboard_check(vk_space) == false) {
	for (var i = 0; i < array_length(stack); i++) {
		if (surface_exists(stack[i]) == false) {
			stack[i] = surface_create(room_width, room_height);
		}
	}

	gpu_set_tex_filter(true);

	var texture = surface_get_texture(stack[0]);
	var texelwidth = texture_get_texel_width(texture) * 0.5;
	var texelheight = texture_get_texel_height(texture) * 0.5;

	var dhalftexel = shader_get_uniform(kawasedualfilterdown, "halftexel");
	var uhalftexel = shader_get_uniform(kawasedualfilterup, "halftexel");
	var doffset = shader_get_uniform(kawasedualfilterdown, "offset");
	var uoffset = shader_get_uniform(kawasedualfilterup, "offset");
	var offset = 3;

	surface_set_target(stack[0]) {
		shader_set(kawasedualfilterdown) {
			shader_set_uniform_f(dhalftexel, texelwidth, texelheight);
			shader_set_uniform_f(doffset, offset)
			draw_self();
			shader_reset();
		}
		surface_reset_target();
	}

	for (var i = 1; i < array_length(stack); i++) {
		if (i >= floor(array_length(stack) * 0.5)) {		
			surface_set_target(stack[i]) {
				shader_set(kawasedualfilterup) {
					shader_set_uniform_f(uhalftexel, texelwidth, texelheight);
					shader_set_uniform_f(uoffset, offset)
					draw_surface(stack[i - 1], 0, 0);
					shader_reset();
				}
				surface_reset_target();		
			}			
		} else {
			surface_set_target(stack[i]) {
				shader_set(kawasedualfilterdown) {
					shader_set_uniform_f(dhalftexel, texelwidth, texelheight);
					shader_set_uniform_f(doffset, offset)
					draw_surface(stack[i - 1], 0, 0);
					shader_reset();
				}
				surface_reset_target();		
			}
		}
	}

	gpu_set_tex_filter(false);

	draw_self();
	draw_surface_part(stack[array_length(stack) - 1], mouse_x, 0, room_width - mouse_x, room_width, mouse_x, 0);
	draw_line_width_color(mouse_x, -1, mouse_x, room_width, 2, #000000, #000000);
} else {
	draw_self();
}