/*
	handle the window and turn off automatic application surface drawing
*/
window_set_size(1280, 720);
surface_resize(application_surface, 1280, 720);
display_set_gui_size(640, 360);
application_surface_draw_enable(false);

/*
	start a dual filter with a stack, which is an array sized 2 + N passes;
	index 0 is the contents that will be blurred, everything else is used for filter
*/
passes = 4;
stack = kawase_dual_filter_create_stack(passes);

/*
	determine how far you want the blur to spread, but a spread of 1 is usually fine	
*/
spread = 1;
