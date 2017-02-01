module triangle(x,y,z){
	scale([x,y,z]){
		linear_extrude(height=1,center=false,convexity=10,twist=0)
			polygon(points=[[0,0],[0,1],[1,0],[0,0]]);
	}
}


//part width and height.  Width must allow for size of tube
boxd = 25;
boxh = 23;
rod_separation_inches = 5; 
rod_sepmm = rod_separation_inches * 25.4;

//dimensions for the square tube and how far into the part it sits
tube_id = 16;
tube_od = 20;
tube_insert = 19;

//solid rod diameter and clearance from tube and edge of part
rod = 10.1;
rodr = rod/2;
rod_space = 10;
rod_clear = 2;

//screw size
screwd = 4.5;
screwr = screwd/2;

//dimenisions based on part specifications
core_shift = (boxd*0.5)-(tube_od*0.5);
rod_shift = core_shift+tube_od+rod_space+rodr;
boxl = core_shift+tube_od+rod_space+rod+rod_clear;



motor_mount_plate = 60; //square sides for motor mount, made taller by boxh
mmp_thick = 8; //motor mount thickness as required
motor_thick = 4.5;  //thickness of motor top plate
//surplus motor
motor_pulley_offset = 27;  //top of pulley to motor top
//MPJ $8 special
//motor_pulley_offset = 21;  //top of pulley to motor top

motor_height = 50;
motor_hole = 39;
motor_screw = 5;
bed_offset = 46;
bed_pulley_offset = 8;

//top of motor plate at bed
mmp_reference = (boxl - mmp_thick - bed_offset);
motor_offset = bed_pulley_offset + motor_pulley_offset;
mmp_offset = mmp_reference + motor_offset;

//bottom of tube is 44.5mm from printer base
//boxl-coreshift is bottom of square tubing
//boxl is core_shift lower to printer base than tubing

body_extension_offset = boxl + (44.5-core_shift); 
body_extension = (44.5-core_shift);
module core(outer,inner,h)
{
	difference(){
		cube(size=[outer,outer,h],center=false);
		translate([(outer-inner)*0.5,(outer-inner)*0.5,0])
			cube(size=[inner,inner,h+1],center=false);
	}
}
module Yend(){
rotate([0,180,0]) {
 translate([boxd/2,boxl/2,0]){
 rotate([0,0,180]){
  translate([(boxd/2),-(boxl/2),-(boxh)]){
	difference(){
		cube(size=[boxd,boxl,boxh],center=false);
		translate([core_shift,core_shift,boxh-tube_insert])
			core(tube_od,tube_id,tube_insert+1);

		translate([boxd/2,rod_shift,4])
			cylinder(h=20,r=rodr,$fn=100);

		translate([boxd-core_shift,core_shift+(tube_od/2),boxh-tube_insert+(tube_insert/2)]){
			rotate([270,0,270])
				cylinder(h=4,r=screwr,$fn=100);
		}

		translate([0,core_shift+(tube_od/2),boxh-tube_insert+(tube_insert/2)]){
			rotate([270,0,270])
				cylinder(h=4,r=screwr,$fn=100);
		}
	 }
   }
  }
 }
}
}

//the body
difference(){
	//pair rod/extrusion mounts
	translate([0,0,0]){
		//solid between rod and square extrusion mounts
		translate([0,boxl,0])
			cube(size=[boxd+rod_sepmm,22,boxh],center=false);
		Yend();
		translate([rod_sepmm,0,0]) Yend();
        //fill in gap between body and mmp    
   		translate([boxd,mmp_offset,0])
			cube(size=[rod_sepmm-boxd,boxl-mmp_offset,boxh],center=false);
	}
    //cut out in middle, remove excess material
    translate([(boxd/2)+(rod_sepmm/2),boxl+20,-1]){ //Surplus
//    translate([(boxd/2)+(rod_sepmm/2),boxl+14,-1]){ //MPJ
		cylinder(h=boxh+2,d=motor_hole+15,center=false,$fn=100);
    }
    
    translate([rod_sepmm+boxd,boxl+22,-1])rotate([0,0,180])triangle(boxl/2,boxl/2,boxh+2);
    
    translate([0,boxl+22,-1])rotate([0,0,270])triangle(boxl/2,boxl/2,boxh+2);

    //large cutout, only extend "legs"
//    translate([boxd,boxl+19,0])
//    cube(size=[rod_sepmm-boxd,body_extension ,boxh]);
  
//    translate([0,boxl,(boxh*.5)])
//    cube(size=[boxd*1.25,boxl*1.2,boxh]);

//    translate([rod_sepmm-(boxd*.25),boxl,(boxh*.5)])
//    cube(size=[boxd*1.25,boxl*1.2,boxh]);

//    translate([(rod_sepmm/2)+(boxd/2),motor_hole*1.3,boxh*.75])
//    cube(size=[motor_hole+13,motor_hole+4,(boxh/2)+.1],center=true);
  
//     translate([boxl,0,0])
//      cube(rod_sepmm+boxd,motor_mount_plate/2,boxh);

    //holes for 1/4" rod in center of tube
    translate([boxd/2,rod_space+rod+rod_clear+(tube_od/2),-1])
    cylinder(d=6.5,h=boxh+2,$fn=100);

    translate([(boxd/2)+(rod_sepmm),rod_space+rod+rod_clear+(tube_od/2),-1])
    cylinder(d=6.5,h=boxh+2,$fn=100);

    translate([-1,44.5,boxh/2])cube([boxd+(boxd/2),boxl/2,boxh]);
    translate([rod_sepmm-(boxd/2),44.5,boxh/2])cube([boxd+(boxd/2),boxl/2,boxh]);
  
}


//the motor mouting plate attached to the body
translate([0,mmp_offset,0]){ //move assembled unit on Y axis into position
    //motor mount plate
    difference(){
    //plate
	translate([((boxd+rod_sepmm)/2)-(motor_mount_plate/2)-5,0,0]){
		cube(size=[motor_mount_plate+10,mmp_thick,motor_mount_plate+boxh],center=false);
	}

    //motor hole
	translate([(boxd/2)+(rod_sepmm/2),mmp_thick+2,(motor_mount_plate/2)+boxh]){
		rotate([90,0,0])
			cylinder(h=mmp_thick+4,r=motor_hole/2,$fn=100);
	}
    
    //motor mount screws #1
    translate([((boxd/2)+(rod_sepmm/2))-23.5,mmp_thick+2,(motor_mount_plate/2)-23.5+boxh])
        rotate([90,0,0])
            cylinder(h=mmp_thick+4,d=motor_screw,$fn=100);
    //#2
    translate([((boxd/2)+(rod_sepmm/2))+23.5,mmp_thick+2,(motor_mount_plate/2)+23.5+boxh])
        rotate([90,0,0])
            cylinder(h=mmp_thick+4,d=motor_screw,$fn=100);
    //#3
    translate([((boxd/2)+(rod_sepmm/2))+23.5,mmp_thick+2,(motor_mount_plate/2)-23.5+boxh])
        rotate([90,0,0])
            cylinder(h=mmp_thick+4,d=motor_screw,$fn=100);
    //#4
    translate([((boxd/2)+(rod_sepmm/2))-23.5,mmp_thick+2,(motor_mount_plate/2)+23.5+boxh])
        rotate([90,0,0])
            cylinder(h=mmp_thick+4,d=motor_screw,$fn=100);
    }
}

//braces
translate([(rod_sepmm/2)+(boxd/2)-(motor_mount_plate/2),mmp_offset+mmp_thick,boxh])
rotate([0,270,0])
triangle(motor_mount_plate,motor_mount_plate/2,5);

translate([(boxd/2)+(rod_sepmm/2)+(motor_mount_plate/2)+5,mmp_offset+mmp_thick,boxh])
rotate([0,270,0])
triangle(motor_mount_plate,motor_mount_plate/2,5);

//translate([rod_sepmm-(boxd/2),44.5,-boxh/2])cube([boxd+(boxd/2),boxl/2,boxh]);



 

 