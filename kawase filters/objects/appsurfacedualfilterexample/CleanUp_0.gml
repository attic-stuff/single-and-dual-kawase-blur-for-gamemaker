/*
	and finally, we need to clean stuff up. dont clean the content surface cause thats the app surface lol
*/
for (var iteration = 1, stacksize = array_length(stack); iteration < stacksize; iteration++) {
	if (surface_exists(stack[iteration]) == true) {
		surface_free(stack[iteration]);	
	}
}