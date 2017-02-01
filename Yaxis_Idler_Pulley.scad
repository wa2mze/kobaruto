bearing_screw_dia = 6; //5mm screw, oversized
bearing_width = 15;
bearing_length = 29;
bearing_height = 22;
bearing_opening = 13;
bearing_insert = 25;
slide_length = 35;
slit_dia = 5;
slit_offset = 35;
slit_length=20;
nut_thick = 3.5;
nut_width = 6.5;
nut_insert = 16;
nut_offset = 58;

slide_width = 9;


rotate([90,0,0]) {
difference(){
difference() {
    cube(size=[bearing_length,bearing_width,bearing_height]);
    translate([12,bearing_width/2,-1]){
        cylinder(h=24,d=bearing_screw_dia,center=false,$fn=100);
    }
    translate([12,bearing_width/2,-1]){   
       cylinder(h=4,d=9.5,$fn=6); 
    }

    translate([-1,-1,-1]){
        cube(size=[5,bearing_height,25]);
    }
}
translate([-1,-1,4.5])
    cube(size=[bearing_insert,bearing_height,bearing_opening]);
}

difference(){
translate([bearing_length,0,(bearing_height-slide_width)/2])
    cube(size=[slide_length,bearing_width,slide_width]);

translate([slit_offset,(bearing_width/2)-(slit_dia/2),0])
    cube(size=[slit_length,slit_dia,22]);

translate([30+25,bearing_width/2,11]) rotate([0,90,0])
    cylinder(h=10,d=3,$fn=100,center=false);
    
//nut opening
translate([nut_offset,(bearing_width/2)-(nut_width/2),-1.3])
    cube(size=[nut_thick,nut_width,nut_insert]);
}
}