
goldenRatio = (1 + sqrt(5)) / 2;

function sqr(x) = x*x;

function vabs(v) = sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2]);

function vnorm(a) = a / vabs(a);

function vcross(a,b) = [
  a[1] * b[2] - b[1] * a[2],
  - a[0] * b[2] + b[0] * a[2],
  a[0] * b[1] - b[0] * a[1]
];

function vmul(a,b) = [a[0]*b[0],a[1]*b[1],a[2]*b[2]];
function vmul4(a,b) = [a[0]*b[0],a[1]*b[1],a[2]*b[2],a[3]*b[3]];

function vncross(a,b) = vnorm(vcross(a,b));

function mtrans(e0,e1,e2) = [
    [e2[0],e1[0],e0[0],0],
    [e2[1],e1[1],e0[1],0],
    [e2[2],e1[2],e0[2],0],
    [0,0,0,1]
];

function mtrans4(e0,e1,e2,e3) = [
    [e3[0],e2[0],e1[0],e0[0],0],
    [e3[1],e2[1],e1[1],e0[1],0],
    [e3[2],e2[2],e1[2],e0[2],0],
    [e3[3],e2[3],e1[3],e0[3],0],
    [0,0,0,1]
];

function det(e0,e1,e2) = 
	  e0[0]*e1[1]*e2[2] 
	+ e1[0]*e2[1]*e0[2]
	+ e2[0]*e0[1]*e1[2]
	- e0[0]*e2[1]*e1[2]
	- e1[0]*e0[1]*e2[2]
	- e2[0]*e1[1]*e0[2];

function minvert(e0,e1,e2) = [
    [e1[1]*e2[2]-e1[2]*e2[1],e0[1]*e2[2]-e0[2]*e2[1],e0[1]*e1[2]-e0[2]*e1[1],0],
    [e1[0]*e2[2]-e1[2]*e2[0],e0[0]*e2[2]-e0[2]*e2[0],e0[0]*e1[2]-e0[2]*e1[0],0],
    [e1[0]*e2[1]-e1[1]*e2[0],e0[0]*e2[1]-e0[1]*e2[0],e0[0]*e1[1]-e0[1]*e1[0],0],
    [0,0,0,1]
] / det(e0,e1,e2);

function v2Otrans(e0, e1) = mtrans(e0, e1, vncross(e0, e1));

function v2trans(a, b) = v2Otrans(vnorm(a), vncross(a, b));

function v2invtrans(a, b) = minvert(vnorm(a), vncross(a, b), vncross(a, vncross(a, b)));

function vlsh(v,i) = [v[(0+i)%3],v[(1+i)%3],v[(2+i)%3]];
function vlsh4(v,i) = [v[(0+i)%4],v[(1+i)%4],v[(2+i)%4],v[(3+i)%4]];

function vrsh(v,i) = [v[(3-i)%3],v[(4-i)%3],v[(5-i)%3]];
function vrsh4(v,i) = [v[(4-i)%4],v[(5-i)%4],v[(6-i)%4],v[(7-i)%4]];

vnull = [0,0,0];

function vconj(v, i) = [v[0] * ((i == 0) ? -1 : 1),
						v[1] * ((i == 1) ? -1 : 1),
						v[2] * ((i == 2) ? -1 : 1)];

function vrev(v) = [v[2], v[1], v[0]];

function vdot(a,b) = a[0]*b[0] + a[1]*b[1] + a[2]*b[2];

function angleOf2v(a,b) = acos(vdot(a,b) / (vabs(a)*vabs(b)));

function vintp(a,b,f) = a + f * (b - a);

function vmid(a,b) = (a + b) / 2;
function vmid3(a,b,c) = (a + b + c) / 3;

function bezier(ps,t) = 
	len(ps) == 3 ? bezier3(ps,t) :
	len(ps) == 4 ? bezier4(ps,t) :
				   bezier5(ps,t);

function bezier3(ps,t) = 
    (1-t) * (1-t) * ps[0]
    + 2*(1-t) * t * ps[1]
    + t * t * ps[2];

function bezier4(ps,t) = 
    (1-t) * (1-t) * (1-t) * ps[0]
    + 3 * (1-t) * (1-t) * t * ps[1]
    + 3 * (1-t) * t * t * ps[2]
    + t * t * t * ps[3];


function bezier5(ps,t) = 
    (1-t) * (1-t) * (1-t) * (1-t) * ps[0]
    + 4 * (1-t) * (1-t) * (1-t) * t * ps[1]
    + 6 * (1-t) * (1-t) * t * t * ps[2]
    + 4 * (1-t) * t * t * t *  ps[3]
    + t * t * t * t *  ps[4];

function bezierTangent4(ps,t) = 
	-3 *sqr(1 - t)  * ps[0]
	+ (9*t*t -12*t + 3) * ps[1] 
	+ 3*t*(2-3*t) * ps[2] 
	+ 3 * t*t * ps[3];

function bezier4Diff2(ps,t) = 
	- 6 * (1-t) * ps[0]
	+ (18*t-12) * ps[1] 
	+ (6-18*t) * ps[2] 
	+ 6 * t * ps[3];

function bezierNormal4(ps,t) = 
	bezier4Diff2(ps,t);

function bezierTriangle4ij(p0,p1,p2, c, i,j) = 
	bezierTriangle4(p0,p1,p2, c, i*(1-j), j, 1-i*(1-j)-j);

function bezierTriangle4(p0,p1,p2, c, s, t, u) = 
	s*s*s * p0[0]
	+ t*t*t * p1[0]
	+ u*u*u * p2[0]
	+ 6 * s*t*u * c
	+ 3 * s*s*u * p2[2]
	+ 3 * s*s*t * p0[1]
	+ 3 * t*t*s * p0[2]
	+ 3 * t*t*u * p1[1]
	+ 3 * u*u*s * p2[1]
	+ 3 * u*u*t * p1[2];

function vaxis4(i) = vrsh4([1,0,0,0],i);

function vnot4(x) = [
	x[0]?0:1,
	x[1]?0:1,
	x[2]?0:1,
	x[3]?0:1];

function vaxisproj4(x, i) = vmul4(x, vnot4(vaxis4(i)));
function vaxisdist4(x, i) = vmul4(x, vaxis4(i));

function vrot4(x, a0, a1, angle) = 
	vaxisproj4(vaxisproj4(x, a0), a1) 
	+ cos(angle)*(vaxisdist4(x,a0) + vaxisdist4(x,a1))
	+ sin(angle)*(vrsh4(vaxisdist4(x,a1),4+a0-a1) - vrsh4(vaxisdist4(x,a0),a1-a0));

function vabs4(v) = sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2]+v[3]*v[3]);
