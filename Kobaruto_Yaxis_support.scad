//part width and height.  Width must allow for size of tube
boxd = 25;
boxh = 23;
boxl = 38;



//dimensions for the square tube and how far into the part it sits
tube_od = 20;

//solid rod diameter and clearance from tube and edge of part
rod = 9.1;
rodr = rod/2;
rody = tube_od +((boxl-tube_od)/2);

//screw size
screwd = 4.5;
screwr = screwd/2;

difference(){
	cube(size=[boxd,boxl,boxh],center=false);
	translate([(boxd-tube_od)/2,0,-1])
		cube(size=[tube_od,tube_od,boxh+2],center=false);

	translate([-1,tube_od/2,boxh/2])
		rotate([270,0,270])
			cylinder(h=boxd+2,r=screwr,$fn=100);

	translate([-1,tube_od + ((boxl-tube_od)/2)  ,boxh/2])
		rotate([270,0,270])
	 		cylinder(h=boxd+2,r=rodr,$fn=100);
}


