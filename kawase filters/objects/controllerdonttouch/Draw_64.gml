if (instance_exists(kawasedualfilterexample) == true) {
	draw_text_ext(4, -2, $"dual filter mode\npress 1, 2, 3, 4, or 5 to change the number of passes made using this filter. hold shift and press 1, 2, 3, 4, or 5 to change the spread. press backspace to reset the blur, and press tab to switch to single filter mode.\n\npasses: {kawasedualfilterexample.passes}\nspread: {kawasedualfilterexample.spread}", 8,  128);	
}

if (instance_exists(kawasesinglefilterexample) == true) {
	draw_text_ext(4, -2, $"single filter mode\npress 1, 2, 3, 4, 5 to change the distances of each pass. press backspace to reset the blur, and press tab to switch to dual filter mode.\n\ndistances: {kawasesinglefilterexample.distances}", 8,  128);	
}