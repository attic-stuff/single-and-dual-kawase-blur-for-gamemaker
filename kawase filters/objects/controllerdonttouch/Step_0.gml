if (instance_exists(kawasedualfilterexample) == true) {
	for (var iteration = 1; iteration < 6; iteration++)  {
		if (keyboard_check_pressed(ord($"{iteration}")) ==  true) {
			if (keyboard_check(vk_shift) == false) {
				instance_destroy(kawasedualfilterexample);
				instance_create_depth(x, y, 0, kawasedualfilterexample, { passes :  iteration });
				break;
			} else {
				kawasedualfilterexample.spread = iteration;	
			}
		}
	}
	if (keyboard_check_pressed(vk_backspace) == true) {
		instance_destroy(kawasedualfilterexample);
		instance_create_depth(x, y, 0, kawasedualfilterexample);			
	}
	if (keyboard_check_pressed(vk_tab) == true) {
		instance_destroy(kawasedualfilterexample);
		instance_create_depth(x, y, 0,  kawasesinglefilterexample);
		exit;
	}
}


if (instance_exists(kawasesinglefilterexample) == true) {
	for (var iteration = 0, styles = array_length(kawasesinglefilterexample.distancelist); iteration < styles; iteration++)  {
		if (keyboard_check_pressed(ord($"{iteration + 1}")) ==  true) {
			kawasesinglefilterexample.distanceindex = iteration;
		}
	}	
	if (keyboard_check_pressed(vk_backspace) == true) {
		instance_destroy(kawasesinglefilterexample);
		instance_create_depth(x, y, 0, kawasesinglefilterexample);			
	}
	if (keyboard_check_pressed(vk_tab) == true) {
		instance_destroy(kawasesinglefilterexample);
		instance_create_depth(x, y, 0,  kawasedualfilterexample);
	}
}