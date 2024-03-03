/*
	start a dual filter with a stack, which is an array sized 2 + N passes;
	index 0 is the contents that will be blurred, everything else is used for filter
*/
stack = kawase_dual_filter_create_stack(passes);
/*
	determine how far you want the blur to spread, but a spread of 1 is usually fine	
*/
spread = 1;