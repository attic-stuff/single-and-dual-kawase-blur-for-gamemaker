enum kawase_dual_filter_stack { contents, first };

/**
 * helper function to make a stack for the dual filter kawase blur
 * @param {real} passes how many passes the blur will use
 */
function kawase_dual_filter_create_stack(passes = 4) {
	return array_create(2 + passes, -1);	
}

/**
 * begins the dual filter kawase blur process
 * @param {array} stack the stack of surfaces
 * @param {real} spread how far to spread the blur
 */
function kawase_dual_filter_begin(stack, spread = 1) {
	static texelsizeuniform = shader_get_uniform(kawasedualfilterdown, "texelsize");
	static spreaduniform = shader_get_uniform(kawasedualfilterdown," spread");
	var contents = stack[kawase_dual_filter_stack.contents];
	var width = surface_get_width(contents);
	var height = surface_get_height(contents);	
	var divisor = 2;
	var passes = array_length(stack) - 1;	
	for (var iteration = 1; iteration < passes; iteration++) {
		if (surface_exists(stack[iteration]) == false) {
			stack[iteration] = surface_create(width div divisor, height div divisor);	
		}
		divisor = divisor * 2;
	}
	if (surface_exists(stack[passes]) == false) {
		var lastsurface = stack[passes - 1];
		width = surface_get_width(lastsurface);
		height = surface_get_height(lastsurface);
		stack[passes] = surface_create(width, height);
	}
	gpu_set_tex_filter(true);
	surface_set_target(stack[kawase_dual_filter_stack.first]) {
		shader_set(kawasedualfilterdown) {
			width = surface_get_width(stack[kawase_dual_filter_stack.first]);
			height = surface_get_height(stack[kawase_dual_filter_stack.first]);
			shader_set_uniform_f(texelsizeuniform, 1 / width, 1 / height);
			shader_set_uniform_f(spreaduniform, spread);
			draw_surface_stretched(stack[0], 0, 0, width, height);
			shader_reset();	
		}
		surface_reset_target();
	}
	gpu_set_tex_filter(false);
}

/**
 * does the kawase blur series, downscale and upscale
 * @param {array} stack the stack of surfaces
 * @param {real} spread how far to spread the blur
 */
function kawase_dual_filter_process(stack, spread = 1) {
	static downtexelsizeuniform = shader_get_uniform(kawasedualfilterdown, "texelsize");
	static uptexelsizeuniform = shader_get_uniform(kawasedualfilterup, "texelsize");
	static downspreaduniform = shader_get_uniform(kawasedualfilterdown,"spread");
	static upspreaduniform = shader_get_uniform(kawasedualfilterup, "spread");
	gpu_set_tex_filter(true);
	var passes = array_length(stack) - 1
	for (var iteration = 2; iteration < passes; iteration++) {
		var width = surface_get_width(stack[iteration]);
		var height = surface_get_height(stack[iteration]);
		surface_set_target(stack[iteration]) {
			shader_set(kawasedualfilterdown) {
				shader_set_uniform_f(downtexelsizeuniform, 1 / width, 1 / height);
				shader_set_uniform_f(downspreaduniform, spread);
				draw_surface_stretched(stack[iteration - 1], 0, 0, width, height);
				shader_reset();	
			}
			surface_reset_target();
		}
	}
	surface_set_target(stack[passes]) {
		draw_surface(stack[passes - 1], 0, 0);
		surface_reset_target();
	}
	for (var iteration = passes - 1; iteration > 0; iteration--) {
		var width = surface_get_width(stack[iteration]);
		var height = surface_get_height(stack[iteration]);
		surface_set_target(stack[iteration]) {
			shader_set(kawasedualfilterup) {
				shader_set_uniform_f(uptexelsizeuniform, 1 / width, 1 / height);
				shader_set_uniform_f(upspreaduniform, spread);
				draw_surface_stretched(stack[iteration + 1], 0, 0, width, height);
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
function kawase_dual_filter_render(stack, x, y) {
	var contents = stack[kawase_dual_filter_stack.contents];
	var width = surface_get_width(contents);
	var height = surface_get_height(contents);
	gpu_set_tex_filter(true);
	draw_surface_stretched(stack[kawase_dual_filter_stack.first], x, y, width, height);
	gpu_set_tex_filter(false);
}

/**
 * cleans the array stack from vram
 * @param {array<Id.Surface>} stack the stack of surfaces uses for all this
 */
function kawase_dual_filter_clean(stack) {
	for (var iteration = 0, stacksize = array_length(stack); iteration < stacksize; iteration++) {
		if (surface_exists(stack[iteration]) == true) {
			surface_free(stack[iteration]);	
		}
	}
}