
include <math.scad>
include <transform.scad>
include <draw.scad>

phi = (1+sqrt(5)) / 2;

points = [
[1,1,1],[1,1,-1],[1,-1,1],[1,-1,-1],
[-1,1,1],[-1,1,-1],[-1,-1,1],[-1,-1,-1],
[0,1/phi,phi],[0,-1/phi,phi],[0,1/phi,-phi],[0,-1/phi,-phi],
[1/phi,phi,0],[-1/phi,phi,0],[1/phi,-phi,0],[-1/phi,-phi,0],
[phi,0,1/phi],[-phi,0,1/phi],[phi,0,-1/phi],[-phi,0,-1/phi],  
];

side = [
 points[8],points[9],points[6],points[17],points[4]
];

function center(ps) = 
    (ps[0]+ps[1]+ps[2]+ps[3])/4;

sidecenter = (side[0]+side[1]+side[2]+side[3]+side[4])/5;

function toSphere(p) = (30/2) * p / norm(p);

function invOnCenter(i,f) = 
    toSphere(sidecenter-f*(side[i%5]-sidecenter));

function midpoint(i,j) = 
    toSphere((side[i%5] + side[j%5])/2);

f = 0.365033;
f2 = 1.005;
    
module vertex(p) {
    translate(p)
        sphere(0.001, $fn=1);
}

module romboid(ps,j) {
    difference() {
        hull() {
            for (p = ps) vertex(p);
            vertex([0,0,0]);
        }
        sideCaption(ps,j);
    }
}

function area(ps) =
    ((norm(ps[2]-ps[3]) + norm(ps[1]-ps[4])) / 2)
    * norm((ps[2]+ps[3])/2-(ps[1]+ps[4])/2)
    + (norm(ps[1]-ps[4]) * norm(ps[0]-(ps[1]+ps[4])/2))/2;


module part(j = 0)
{
    for (i = [0:4])
    {
        romboid([
            toSphere(side[i]),
            f2*midpoint(i,i+1),
            toSphere(sidecenter),
            f2*midpoint(i,i+4)], j + 12*i);
    }
}
//scale(11)
//import("d60.stl");
part(1);
rotate([0,180,0]) part(12);
rotate([0,0,180]) part(5);
rotate([0,180,180]) part(8);
rotate([90,90,0]) part(7);
rotate([90,-90,0]) part(4);
rotate([-90,90,0]) part(9);
rotate([-90,-90,0]) part(6);
rotate([90,0,90]) part(10);
rotate([-90,0,90]) part(11);
rotate([90,0,-90]) part(3);
rotate([-90,0,-90]) part(2);

module sideCaption(ps,i)
{
    s = ["2","3","4","5","6.","7","8","9.","10","11",
         "12","3","4","5","6.","7","8","9.","10","11",
         "4","5","6.","7","8","9.","10","5","6.","7",
         "8","9.","6.","7","8","7"];
    translate(center(ps))
    orient(vcross(ps[2]-ps[0],ps[1]-ps[3]), ps[3]-ps[1])
    translate([0,0,.02])
    rotate([0,180,180])
        caption((i==6 ? "6." : i==9 ? "9." : str(i)));    
//        caption(s[i%36]);    
}

module caption(i, height = .5, textsize = 3.4)
{
    linear_extrude(height) {
		text(text = i, size = textsize, 
			font = "DejaVu Sans:style=Condensed Bold",
			valign = "center", halign="center");    
	}
}
