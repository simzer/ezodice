
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
    (ps[0]+ps[1]+ps[2]+ps[3]+ps[4])/5;

sidecenter = center(side);

function toSphere(p) = (30/2) * p / norm(p);

function invOnCenter(i,f) = 
    toSphere(sidecenter-f*(side[i%5]-sidecenter));

function midpoint(i,j) = 
    toSphere((side[i%5] + side[j%5])/2);

f = 0.365033;
f2 = 1.0219;
    
module vertex(p) {
    translate(p)
        sphere(0.001, $fn=1);
}

module pentagon(ps,j) {
    echo(area(ps));
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
    pentagon([
        toSphere(side[i]),
        f2*midpoint(i,i+1),
        invOnCenter(i+3,f),
        invOnCenter(i+2,f),
        f2*midpoint(i,i+4)], j + 12*(i+1));
}
pentagon([
    invOnCenter(0,f),
    invOnCenter(1,f),
    invOnCenter(2,f),
    invOnCenter(3,f),
    invOnCenter(4,f)],j);
}

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
    orient(center(ps), ps[4]-ps[1])
    translate([0,0,.02])
    rotate([0,180,180])
//        caption((i==6 ? "6." : i==9 ? "9." : str(i)));    
        caption(s[i%36]);    
}

module caption(i, height = .5, textsize = 3.5)
{
    linear_extrude(height) {
		text(text = i, size = textsize, 
			font = "DejaVu Sans:style=Condensed Bold",
			valign = "center", halign="center");    
	}
}
