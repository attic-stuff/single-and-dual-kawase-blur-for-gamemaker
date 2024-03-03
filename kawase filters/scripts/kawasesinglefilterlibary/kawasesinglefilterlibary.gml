enum kawase_single_filter_stack { contents, ping, pong };

/**
 * helper function to make a stack for the single filter kawase blur
 */
function kawase_single_filter_create_stack() {
	return array_create(3, -1);	
}

/**
 * begins the single filter kawase blur process
 * @param {array} stack the stack of surfaces
 */
function kawase_single_filter_begin(stack) {
	static distancesuniform = shader_get_uniform(kawasesinglefiltershader, "distances");
	static texeluniform = shader_get_uniform(kawasesinglefiltershader, "texelsize");
	var contents = stack[kawase_single_filter_stack.contents];
	var width = surface_get_width(contents) div 2;
	var height = surface_get_height(contents) div 2;
	if (surface_exists(stack[kawase_single_filter_stack.ping]) == false) {
		stack[kawase_single_filter_stack.ping] = surface_create(width, height);	
	}
	surface_set_target(stack[kawase_single_filter_stack.ping]) {
		draw_clear_alpha(#000000, 0);
		shader_set(kawasesinglefiltershader) {
			shader_set_uniform_f(distancesuniform, 0);
			shader_set_uniform_f(texeluniform, 1 / width, 1 / height);
			gpu_set_tex_filter(true);
			draw_surface_stretched(contents, 0, 0, width, height);
			gpu_set_tex_filter(false);
			shader_reset();	
		}
		surface_reset_target();
	}
}
/**
 * does the kawase blur series
 * @param {array<Id.Surface>} stack the stack of surfaces
 * @param {array<Real>} distances the array of distances for each pass
 */
function kawase_single_filter_process(stack, distances) {
	static distancesuniform = shader_get_uniform(kawasesinglefiltershader, "distances");
	static texeluniform = shader_get_uniform(kawasesinglefiltershader, "texelsize");
	var contents = stack[kawase_single_filter_stack.contents];
	var width = surface_get_width(contents) div 2;
	var height = surface_get_height(contents) div 2;
	if (surface_exists(stack[kawase_single_filter_stack.ping]) == false) {
		stack[kawase_single_filter_stack.ping] = surface_create(width, height);	
	}
	if (surface_exists(stack[kawase_single_filter_stack.pong]) == false) {
		stack[kawase_single_filter_stack.pong] = surface_create(width, height);	
	}
	gpu_set_tex_filter(true);
	for (var iteration = 0, repeats = array_length(distances); iteration < repeats; iteration += 2) {
		surface_set_target(stack[kawase_single_filter_stack.pong]) {
			draw_clear_alpha(#000000, 0);
			shader_set(kawasesinglefiltershader) {
				shader_set_uniform_f(distancesuniform, distances[iteration]);
				shader_set_uniform_f(texeluniform, 1 / width, 1 / height);
				draw_surface(stack[kawase_single_filter_stack.ping], 0, 0);
				shader_reset();	
			}
			surface_reset_target();
		}
		surface_set_target(stack[kawase_single_filter_stack.ping]) {
			draw_clear_alpha(#000000, 0);
			shader_set(kawasesinglefiltershader) {
				shader_set_uniform_f(distancesuniform, distances[iteration + 1]);
				shader_set_uniform_f(texeluniform, 1 / width, 1 / height);
				draw_surface(stack[kawase_single_filter_stack.pong], 0, 0);
				shader_reset();	
			}
			surface_reset_target();
		}
	}
	gpu_set_tex_filter(false);
}

/**
 * draws the final contents with the fancy new blur stuff
 * @param {array<Id.Surface>} stack the stack of surfaces uses for all this
 * @param {real} x the x position to draw the final contents
 * @param {real} y the y position to draw the final contents
 */
function kawase_single_filter_render(stack, x, y) {
	var contents = stack[kawase_single_filter_stack.contents];
	var width = surface_get_width(contents);
	var height = surface_get_height(contents);
	gpu_set_tex_filter(true);
	draw_surface_stretched(stack[kawase_single_filter_stack.pong], x, y, width, height);
	gpu_set_tex_filter(false);
}

/**
 * cleans the array stack from vram
 * @param {array<Id.Surface>} stack the stack of surfaces uses for all this
 */
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