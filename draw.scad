
include <math.scad>;

Cphi = (1+sqrt(5)) / 2;

icosa_cart = [
	[0, +1, +Cphi],	// 0
	[0, +1, -Cphi],	// 1
	[0, -1, -Cphi],	// 2
	[0, -1, +Cphi],	// 3

	[+Cphi, 0, +1],	// 4
	[+Cphi, 0, -1],	// 5
	[-Cphi, 0, -1],	// 6
	[-Cphi, 0, +1],	// 7

	[+1, +Cphi, 0],	// 8
	[+1, -Cphi, 0],	// 9
	[-1, -Cphi, 0],	// 10
	[-1, +Cphi, 0]	// 11
	];

icosa_faces = [ 
	[3,0,4],
	[3,4,9],
	[3,9,10],
	[3,10,7],
	[3,7,0],
	[0,8,4],
	[0,7,11],
	[0,11,8],
	[4,8,5],
	[4,5,9],
	[7,10,6],
	[7,6,11],
	[9,5,2],
	[9,2,10],
	[2,6,10],
	[1,5,8],
	[1,8,11],
	[1,11,6],
	[5,1,2],
	[2,1,6]
	];

module triakis(r, f = 1.5)
{
	p0 = [1,0,-1/sqrt(2)] * r / 2;
	p1 = [-1,0,-1/sqrt(2)] * r / 2;
	p2 = [0,1,1/sqrt(2)] * r / 2;
	p3 = [0,-1,1/sqrt(2)] * r / 2;
	p012 = f*(p0+p1+p2)/3;
	p123 = f*(p3+p1+p2)/3;
	p013 = f*(p0+p1+p3)/3;
	p023 = f*(p0+p3+p2)/3;
	polyhedron([p0,p1,p2,p3,p012,p123,p013,p023],
		[[0,1,4],[4,1,2],[0,4,2],
		[1,2,5],[5,2,3],[1,5,3],
		[7,3,0],[2,7,0],[2,3,7],
		[6,0,1],[3,6,1],[3,0,6]]);
}

module tetraeder(r)
{
	p0 = [1,0,-1/sqrt(2)] * r / 2;
	p1 = [-1,0,-1/sqrt(2)] * r / 2;
	p2 = [0,1,1/sqrt(2)] * r / 2;
	p3 = [0,-1,1/sqrt(2)] * r / 2;
	polyhedron([p0,p1,p2,p3],[[0,1,2],[1,2,3],[2,3,0],[3,0,1]]);
}

module dodecahedron(height) 
{
        scale([height,height,height]) //scale by height parameter
        {
                intersection(){
                        //make a cube
                        cube([2,2,1], center = true); 
                        intersection_for(i=[0:4]) //loop i from 0 to 4, and intersect results
                        { 
                                //make a cube, rotate it 116.565 degrees around the X axis,
                                //then 72*i around the Z axis
                                rotate([0,0,72*i])
                                        rotate([116.565,0,0])
                                        cube([2,2,1], center = true); 
                        }
                }
        }
}

module octaeder(r)
{
	p0 = [1,0,0] * r / 2;
	p1 = [-1,0,0] * r / 2;
	p2 = [0,1,0] * r / 2;
	p3 = [0,-1,0] * r / 2;
	p4 = [0,0,1] * r / 2;
	p5 = [0,0,-1] * r / 2;
	polyhedron([p0,p1,p2,p3,p4,p5],[
		[0,2,4],[0,4,3],[0,5,2],[0,3,5],
		[1,3,4],[1,4,2],[1,5,3],[1,2,5]
	]);
}

module tetraederHull(r)
{
	hull() {
		tetraederCorners(r);
	}
}

module tetraederCorners(r)
{
    p0 = [1,0,-1/sqrt(2)] * r / 2;
    p1 = [-1,0,-1/sqrt(2)] * r / 2;
    p2 = [0,1,1/sqrt(2)] * r / 2;
    p3 = [0,-1,1/sqrt(2)] * r / 2;
    translate(p0) children();
    translate(p1) children();
    translate(p2) children();
    translate(p3) children();
}

module tetraederWire(r)
{
    p0 = [1,0,-1/sqrt(2)] * r / 2;
    p1 = [-1,0,-1/sqrt(2)] * r / 2;
    p2 = [0,1,1/sqrt(2)] * r / 2;
    p3 = [0,-1,1/sqrt(2)] * r / 2;
    hull() {
        translate(p0) children();
        translate(p1) children();
    }
    hull() {
        translate(p0) children();
        translate(p2) children();
    }
    hull() {
        translate(p0) children();
        translate(p3) children();
    }
    hull() {
        translate(p1) children();
        translate(p2) children();
    }
    hull() {
        translate(p1) children();
        translate(p3) children();
    }
    hull() {
        translate(p2) children();
        translate(p3) children();
    }
}

module icosaederHull(r)
{
	hull() {
		icosaederCorners(r);
	}
}

module icosaederCorners(r)
{
	fi = (1+sqrt(5))/2 * r / 2;
	a = 1 * r / 2;
	translate([0,a,fi]) children();
	translate([0,-a,fi]) children();
	translate([0,a,-fi]) children();
	translate([0,-a,-fi]) children();
	translate([a,fi,0]) children();
	translate([-a,fi,0]) children();
	translate([a,-fi,0]) children();
	translate([-a,-fi,0]) children();
	translate([fi,0,a]) children();
	translate([fi,0,-a]) children();
	translate([-fi,0,a]) children();
	translate([-fi,0,-a]) children();
}

module icosaeder(r)
{
	a = 1 * r / 2;
	scale([a,a,a]) polyhedron(icosa_cart, icosa_faces);
}

module line(p0, p1, r, fn)
{
	translate(p0)
	orient(p1 - p0, [1,2,3.00001]/*todo:fixit*/)
    {
        cylinder(vabs(p1-p0), r, r, $fn = fn);
    }
	translate(p0)
        sphere(r, $fn=fn, center=true);
	translate(p1)
        sphere(r, $fn=fn, center=true);
}

module triangle(p0,p1,p2, r, fn)
{
	up = r * vnorm(vcross(p1-p0,p2-p0));
	polyhedron(points=[p0-up, p1-up, p2-up, p0+up, p1+up, p2+up], 
		faces=[[0,1,2], [5,4,3], [3,4,1,0], [4,5,2,1], [5,3,0,2]]);
	line(p0,p1,r,fn);
	line(p1,p2,r,fn);
	line(p2,p0,r,fn);
}

module quad(p0,p1,p2,p3, r, fn)
{
	triangle(p0,p1,p2, r, fn);
	triangle(p2,p3,p0, r, fn);
}

module pentagon(p, r, fn)
{
	triangle(p[0],p[1],p[2], r, fn);
	triangle(p[0],p[2],p[3], r, fn);
	triangle(p[0],p[3],p[4], r, fn);
}

module bezierLine(ps, r, fn, res = 20)
{
    di = 1 / res;
    for (i = [0:di:1])
    {
        t0 = i;
        t1 = i + di;
        hull()
        {
            translate(bezier(ps,i))
                sphere(r, $fn = resolution);
            translate(bezier(ps,i+di))
                sphere(r, $fn = resolution);
        }
    }
}

module bezierTriangle(p0,p1,p2, c, r, fn, res = 10)
{
    di = 1/res;
    dj = 1/res;

    for (j = [0:dj:1])
    {
        for (i = [0:di:1])
        {            
            
            p00 = bezierTriangle4ij(p0,p1,p2, c, i,j);
            p01 = bezierTriangle4ij(p0,p1,p2, c, i,j+dj);
            p10 = bezierTriangle4ij(p0,p1,p2, c, i+di,j);
            p11 = bezierTriangle4ij(p0,p1,p2, c, i+di,j+dj);
            hull()
            {
				if (fn > 0)
				{
					translate(p00) sphere(r, $fn = fn);
					translate(p01) sphere(r, $fn = fn);
					translate(p10) sphere(r, $fn = fn);
					translate(p11) sphere(r, $fn = fn);
				}
				else {
					translate(p00) tetraeder(r);
					translate(p01) tetraeder(r);
					translate(p10) tetraeder(r);
					translate(p11) tetraeder(r);
				}
            }
        }
    }
}
