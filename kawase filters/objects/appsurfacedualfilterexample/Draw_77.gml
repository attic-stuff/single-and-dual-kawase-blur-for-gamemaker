/*
	here we use the app surface as the content surface
*/
stack[0] = application_surface;

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
	hold space to stop rendering the blur
*/
if (keyboard_check(vk_space) == false) {
	kawase_dual_filter_render(stack, 0, 0);	
} else {
	draw_surface(application_surface, 0, 0);
}