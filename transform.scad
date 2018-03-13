
module orient(a, b) {
	multmatrix(v2trans(a, b))
		children();
}

module deorient(a, b) {
	multmatrix(v2invtrans(a, b))
		children();
}

module dirscale(p, s) {
	a = atan2(p[1],p[0]);
	b = atan2(p[2],sqrt(p[0]*p[0]+p[1]*p[1]));
	rotate([0,0,a])
	rotate([0,-b,0])
	scale(s)
	rotate([0,b,0])
	rotate([0,0,-a])
		children();
}

