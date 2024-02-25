window_set_size(room_width, room_height);
window_center();
ping = -1;
pong = -1;

kerneluniform = shader_get_uniform(kawasesinglefilter, "kernel");

kernels = [ 0, 1, 1, 2, 3 ];
stack = array_create(5, -1);

var texel = 1 / 256;

for (var i = 0; i < 5; i++) {
	kernels[i] = (0.5 + kernels[i]) * texel;
}

show_debug_overlay(true)