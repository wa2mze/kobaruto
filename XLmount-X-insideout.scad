// Y-belt retainer/tensioner
// May 2012 John Newman

// This parameter deterimes how far the belt is held above the deck
dRise = 0;			// Added to the depth to make the belt run horizontal

// Belt dimensions - These are for T2.5, see below for T5
//tBase = 1.25;		// Thickness of belt base
//tFull = 2.0;			// Thickness of Belt at teeth
//wTooth = 1.4;		// Width of tooth (not actual, req)
//wSpace = 1.1;		// Width of space
//wBelt = 6.2;		// Width of belt

// Belt dimensions - These are for T5
tBase = 1.5;		// Thickness of belt base
tFull = 2.7;			// Thickness of Belt at teeth
wTooth = 2.6;		// Width of tooth (not actual, req)
wSpace = 2.4;		// Width of space
wBelt = 10;		// Width of belt


// Misc params
wHex = 6.9;		// Width of trap for hex nut
dHex	= 2.5;			// Depth of trap for hex nut
rM3 = 1.7;			// Radius of M3 bolt hole
sDrop = wHex/2-0.5; //2.8;		// Driver screw drop from base of slider
Adjust = 0.5;		// Spacing for things to fit inside other things!
pWidth = 9;			// Screw platform width
pHeight = 5;		// Screw platform height

// Base parameters
bwExt = 20;		// Widest part of base
bwInt = 15;			// inside width, where slider goes
blExt = 30;			// Overall length of base
blHed = 6;			// Head of base whch takes the strain !
bdExt = 12.5;		// This included a minimum floor thickness of 2mm (?)
bRoof = 2.8;		// The thickness of the roof which holds the slider in
bFloor = 1;			// The thickness of the floor under the slider (minimum)
bdSoc = bdExt-(bRoof+bFloor);		// 'Socket' depth for slider to go in

// Slider parameters
swMax = bwInt - Adjust;	// Wide part of slider
sdMax = bdSoc-Adjust;		// Height of slider

lBelt = blExt*2;		// Length of a bit of belt!
rMsk = blExt/3 ;		// Radius of part of mount masking...

module sliderpart() {
	difference() {
		cube([blExt-blHed,swMax,sdMax],center=true);
		// Make a hole for the bolt end
	//	translate([(blExt-blHed)/2-2,0,(sdMax/2)-sDrop]) rotate([30,0,0]) rotate([0,90,0]) cylinder(10,rM3+0.5,rM3+0.5,$fn=6);
		// Make a fracture to cause fill
		translate([(blExt-blHed)/2-4.2,0,(sdMax-tFull)/2+1]) cube([0.05,swMax-4.4,sdMax],center=true) ;
		// Finally indent for belt
		translate([-lBelt/2,-wBelt/2,-sdMax/2-0.1]) belt();
	}
}

// Note this is positioned so that the slider is centered on the XY plane
module basepart() {
	union() {
		difference() {
			translate([0,0,-dRise/2]) cube([blExt,bwExt,bdExt+dRise],center=true);
			// Remove the space for the slider
			translate([-blHed,0,(bFloor-bRoof)/2]) cube([blExt,bwInt,bdSoc],center=true);
			// Remove a hole for the bolt
			translate([(blExt/2-9),0,bFloor+sDrop-bdExt/2]) rotate([30,0,0]) rotate([0,90,0]) cylinder(15,rM3,rM3);
			// An indentation for the bolt head
			translate([(blExt/2)-(blHed+5-dHex),0,bFloor+sDrop-bdExt/2]) rotate([30,0,0]) rotate([0,90,0]) cylinder(5,wHex/2,wHex/2,$fn=6);
			// A slot for the belt to come through
			translate([blExt/2-blHed,0,(bdExt-tFull-0.61)/2-bRoof]) cube([15,wBelt+2,tFull+0.6],center=true);
		}
		translate([0,bwExt/2 + (pWidth/2-0.01),-bdExt/2+pHeight/2]) screwmount() ;
		translate([0,-(bwExt/2 + (pWidth/2-0.01)),-bdExt/2+pHeight/2]) screwmount() ;
	}
}

module belt() {
	cube([lBelt,wBelt,tBase]) ;
	for (inc = [0:(wTooth+wSpace):lBelt-wTooth]) translate([inc,0,tBase-0.01]) cube([wTooth,wBelt,(tFull-tBase)]) ;
}

module screwmount() {
	difference() {
		cube([blExt,pWidth,pHeight],center=true);
		// Bolt holes
		translate([(blExt-pWidth)/2,0,-(pHeight/2+1)]) rotate([0,0,30]) cylinder(pHeight+2,rM3,rM3,$fn=6);
		translate([-(blExt-pWidth)/2,0,-(pHeight/2+1)]) rotate([0,0,30]) cylinder(pHeight+2,rM3,rM3,$fn=6);
		// Nut traps
		translate([(blExt-pWidth)/2,0,pHeight/2-dHex-0.01]) rotate([0,0,30]) cylinder(5,wHex/2,wHex/2,$fn=6);
		translate([-(blExt-pWidth)/2,0,pHeight/2-dHex-0.01]) rotate([0,0,30]) cylinder(5,wHex/2,wHex/2,$fn=6);
	}
}



// ---- this is the only thing I've done, just using the belt shape for 
// ---- my purposes here, misan.


/*
translate([0,0,14]) rotate([-90,0,0])  {
//	union() {
	translate([0,10,0]) cube([25,4,15.4]);
	translate([0,0,12.4]) cube([25,14,3]);
}
*/



translate([0,0,14]) rotate([-90,0,0]) difference() {
	union() {
        translate([0,10,0]) cube([25,4,17.4]);
        translate([0,0,11.4])
        //move teeth to back wall
        difference(){
            cube([25,14,6]);
            translate([0,0,-1.5]) belt();
        }    
        cube([25,14,10]);
	}

	translate([6,25,4]) rotate([90,0,0]) cylinder(d=4.2, h=30,$fn=50);
	translate([6,14.5,4]) rotate([90,0,0]) rotate([0,0,0]) cylinder(r=6.5 / cos(180 / 6) / 2 + 0.05, h=4,$fn=6);
     
	translate([19,25,4]) rotate([90,0,0]) cylinder(d=4.2, h=30,$fn=50);
	translate([19,14.5,4]) rotate([90,0,0]) rotate([0,0,0]) cylinder(r=6.5 / cos(180 / 6) / 2 + 0.05, h=4,$fn=6);
 
}






/*
translate([40,0,14]) rotate([-90,0,0]) difference() {
	union() {
	translate([0,10,0]) cube([25,4,15.4]);
	translate([0,0,11.4]) cube([25,14,4]);
		difference() {
			cube([25,14,11]);
			translate([0,10,12]) 			rotate([180,0,0])  belt();
		}
	}

	translate([6,25,4]) rotate([90,0,0]) cylinder(d=4.2, h=30,$fn=16);
	translate([6,2,4]) rotate([90,0,0]) rotate([0,0,0]) cylinder(r=7 / cos(180 / 6) / 2 + 0.05, h=4,$fn=6);
     
	translate([19,25,4]) rotate([90,0,0]) cylinder(d=4.2, h=30,$fn=16);
	translate([19,2,4]) rotate([90,0,0]) rotate([0,0,0]) cylinder(r=7 / cos(180 / 6) / 2 + 0.05, h=4,$fn=6);

 
    
//	translate([-1,7,4]) rotate([0,90,0]) cylinder(r=4.2/2, h=27,$fn=16);
//	translate([-1,7,4]) rotate([0,90,0]) rotate([0,0,0]) cylinder(r=7 / cos(180 / 6) / 2 + 0.05, h=4,$fn=6);
}
*/