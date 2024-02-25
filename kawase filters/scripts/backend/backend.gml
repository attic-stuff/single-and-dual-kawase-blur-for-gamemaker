/*

	- single filter kawase blur instructions

		create ping surface and pong surface at half the size of your
		content, whether that is a surface or a sprite
		
		turn on tex filter
		
		draw content to ping surface using the shader and kernel index 0
		
		draw ping surface to pong surface
		draw pong surf


*/
enum kawase_single_filter_stack { contents, ping, pong };

function kawase_single_filter_copy(stack, kernel) {
	static kerneluniform = shader_get_uniform(kawasesinglefilter, "kernel");
	static texeluniform = shader_get_uniform(kawasesinglefilter, "texelsize");
	var contents = stack[kawase_single_filter_stack.contents];

	var width = surface_get_width(contents) * 0.5;
	var height = surface_get_height(contents) * 0.5;
	if (surface_exists(stack[kawase_single_filter_stack.ping]) == false) {
		stack[kawase_single_filter_stack.ping] = surface_create(width, height);	
	}
	surface_set_target(stack[kawase_single_filter_stack.ping]) {
		draw_clear_alpha(#000000, 0);
		shader_set(kawasesinglefilter) {
			shader_set_uniform_f(kerneluniform, kernel[0]);
			shader_set_uniform_f(texeluniform, 1 / width, 1 / height);
			gpu_set_tex_filter(true);
			draw_surface_ext(contents, 0, 0, 0.5, 0.5, 0, #ffffff, 1);
			gpu_set_tex_filter(false);
			shader_reset();	
		}
		surface_reset_target();
	}
}

function kawase_single_filter_process(stack, kernel) {
	static kerneluniform = shader_get_uniform(kawasesinglefilter, "kernel");
	static texeluniform = shader_get_uniform(kawasesinglefilter, "texelsize");
	var contents = stack[kawase_single_filter_stack.contents];
	var width = surface_get_width(contents) * 0.5;
	var height = surface_get_height(contents) * 0.5;
	if (surface_exists(stack[kawase_single_filter_stack.ping]) == false) {
		stack[kawase_single_filter_stack.ping] = surface_create(width, height);	
	}
	if (surface_exists(stack[kawase_single_filter_stack.pong]) == false) {
		stack[kawase_single_filter_stack.pong] = surface_create(width, height);	
	}
	gpu_set_tex_filter(true);
	for (var iteration = 1, repeats = array_length(kernel); iteration < repeats; iteration += 2) {
		surface_set_target(stack[kawase_single_filter_stack.pong]) {
			draw_clear_alpha(#000000, 0);
			shader_set(kawasesinglefilter) {
				shader_set_uniform_f(kerneluniform, kernel[iteration]);
				shader_set_uniform_f(texeluniform, 1 / width, 1 / height);
				draw_surface(stack[kawase_single_filter_stack.ping], 0, 0);
				shader_reset();	
			}
			surface_reset_target();
		}
		surface_set_target(stack[kawase_single_filter_stack.ping]) {
			draw_clear_alpha(#000000, 0);
			shader_set(kawasesinglefilter) {
				shader_set_uniform_f(kerneluniform, kernel[iteration + 1]);
				shader_set_uniform_f(texeluniform, 1 / width, 1 / height);
				draw_surface(stack[kawase_single_filter_stack.pong], 0, 0);
				shader_reset();	
			}
			surface_reset_target();
		}
	}
	gpu_set_tex_filter(false);
}

function kawase_single_filter_render(stack, x, y) {
	var contents = stack[kawase_single_filter_stack.contents];
	var width = surface_get_width(contents);
	var height = surface_get_height(contents);
	gpu_set_tex_filter(true);
	draw_surface_stretched(stack[kawase_single_filter_stack.pong], x, y, width, height);
	gpu_set_tex_filter(false);
}

function kawase_single_filter_clean(stack) {
	if (surface_exists(stack[0]) == true) {
		surface_free(stack[0]);	
	}
	if (surface_exists(stack[1]) == true) {
		surface_free(stack[1]);	
	}
	if (surface_exists(stack[2]) == true) {
		surface_free(stack[2]);	
	}
}