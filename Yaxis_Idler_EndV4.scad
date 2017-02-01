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
tube_id = 15.9; //subtract 0.1mm for clearance
tube_od = 20.1; //add 0.1mm for clearance
tube_insert = 19;

//solid rod diameter and clearance from tube and edge of part
rod_adjust = 0.1;
rod = 10+rod_adjust;
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

//motor_mount_plate = 65; //square sides for motor mount, made taller by boxh
//mmp_thick = 5; //motor mount thickness as required
//motor_thick = 4.5;  //thickness of motor top plate
//pulley_offset = 33 - motor_thick;  //top of pulley to motor top
//motor_height = 50;
//motor_hole = 39;
//motor_screw = 5;
//offset from bottom of mmp in Y direction == pulley offset
//mmp_offset = pulley_offset - mmp_thick;

middle = (boxd/2)+(rod_sepmm/2);



module core(outer,inner,h)
{
	difference(){
		cube(size=[outer,outer,h],center=false);
		translate([(outer-inner)*0.5,(outer-inner)*0.5,0])
			cube(size=[inner,inner,h+1],center=false);
	}
}
module Yend(){
translate([boxd/2,boxl/2,0]){
 rotate([0,0,180]){
  translate([-(boxd/2),-(boxl/2),0]){
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

//the body
difference(){
	//pair rod/extrusion mounts
    union(){
		Yend();
		translate([rod_sepmm,0,0]) Yend();
        //fill in gap between body and mmp    
//   		translate([boxd,mmp_offset,0])
//			cube(size=[rod_sepmm-boxd,mmp_offset-mmp_thick,boxh],center=false);

		//solid between rod and square extrusion mounts
//		translate([0,boxl,0])
//			cube(size=[boxd+rod_sepmm,motor_height,boxh],center=false);
    }

    //cut out in middle, remove excess material
//	translate([(boxd/2)+(rod_sepmm/2),motor_height+boxd,0]){
//		cylinder(h=boxh+2,r=(motor_height*0.6),center=false,$fn=100);
//    }

   //holes for 1/4" rod in center of tube
    translate([boxd/2,rod_space+rod+rod_clear+(tube_od/2),-.5])
    cylinder(d=6.5,h=boxh+12,$fn=100);

// -- hex head relief, not used ---
//    translate([boxd/2,rod_space+rod+rod_clear+(tube_od/2),-1])
//        cylinder(d=14,h=4.0,$fn=6);
    
    translate([(boxd/2)+(rod_sepmm),rod_space+rod+rod_clear+(tube_od/2),-.5])
    cylinder(d=6.5,h=boxh+12,$fn=100);
    
// -- hex head relief, not used ---
//    translate([(boxd/2)+(rod_sepmm),rod_space+rod+rod_clear+(tube_od/2),-1])
//        cylinder(d=14,h=4.0,$fn=6);


}




bar_width = 30;
bar_center = bar_width*0.6;
opening_position = bar_center;

difference(){
union(){
//The pulley bar holder (this gets re-translated into place)
translate([0,7,0]){  //re-translate into place
translate([0,bar_center,0]) rotate([90,0,0]){   //bar center = 10
    difference(){

        //joiner bar
        translate([boxd,0,0])
            cube(size=[rod_sepmm-boxd,12,bar_width]);  //bar width=20

        //rectangular hole
        translate([middle-(17/2),-2,opening_position-(11/2)]) 
            cube(size=[17,15,11]);
        //screw hole
        translate([middle,6,-10]) rotate([0,0,0])
            cylinder(d=4,h=55,$fn=100);
        //nut recess
        //nut_width = 8.2;  //larger 6-32 nut
        //nut_thick = 3.2;
        nut_width = 7.2;    //smaller 6-32 nut
        nut_thick = 3;
        screw_head = 3;     //height of screw head
        translate([middle-(nut_width/2),-1,5])
            cube(size=[nut_width,12,nut_thick]);
        //screw head recess
        translate([middle,6,bar_width-screw_head]) 
            cylinder(d=8,h=8,$fn=100);
        
    }

}}
translate([boxd,bar_width-7,0])
cube(size=[rod_sepmm-boxd,boxl-(bar_width-7),boxh]);
}

translate([middle,boxl*1.35,-1])
scale([2.7,1,1])cylinder(d=50,h=boxh+10,$fn=100);

//translate([(4*boxd)+9,-5,0])cube([45,5,boxh]);

//translate([boxd-2,-5,0])cube([35,5,boxh]);

translate([middle+21.5,-5,2])cube([7,25,11]);

}
difference(){
    translate([middle+17,-5,12])cube([16,28,11]);
    translate([middle+21.5,-5,12])cube([7,28,11]);
    translate([90,0,0]){
        translate([0,0,16])
            rotate([0,90,0])
                cylinder(d=3,h=20,$fn=100);
    } 
    translate([90,10,0]){
        translate([0,0,16])
            rotate([0,90,0])
                cylinder(d=3,h=20,$fn=100);
    }
}

