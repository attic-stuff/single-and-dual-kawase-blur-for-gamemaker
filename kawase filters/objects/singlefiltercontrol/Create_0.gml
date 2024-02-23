window_set_size(512, 512);
window_center();

ping = -1;
pong = -1;

uoffset = shader_get_uniform(kawasesinglefilter, "offset");

kernels = [ 0, 1, 1, 2, 3 ];
stack = array_create(5, -1);

var texel = 1 / 256;

for (var i = 0; i < 5; i++) {
	kernels[i] = (0.5 + kernels[i]) * texel;
}

