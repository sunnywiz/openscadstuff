/* 1. Rewrite this piece here to bring in your model and transform it so that it is centered
 *    around 0,0,0 */

module ThingToSlice() { 
   rotate([0,0,-35]) translate([0,0,-3]) import("yoda_small_first_go.stl"); 
}

/* 2.  Set up the corners of where the core is going to be and thus where 
	    its going to slice */

top=1;  // z
bottom=-1;  // -z
front=-1;  // -y
back=2;  // +y
left=-1;  // x
right=1; // -x



/* 3.  Set this up to run ShowMe instead of SliceMe and inspect where the slices would
 *     happen at.  Also turn on axes and inspect where the center is */ 

// ShowMe();  // with F5

/* 4.  If you want, you can see what all the slices look like by commenting out 
 *     the ShowMe() above, and instead running SliceEverything() 
 *     Set spacer to control how far apart things should be.  */

spacer = max(top-bottom,front-back,right-left)*2;
SliceEverything();     // with F6.  Could be really slow. 

// or one at a time: 
// SliceCore(); 


/* ============== Stuff below this line is what makes it work ================= */


module ShowMe() { 
   ThingToSlice(); 
	// +X
	color([1,0,0,.2]) rightSlicer();
	// -X
	color([0.5,0,0,.2]) leftSlicer(); 
	// +Y
	color([0,1,0,.2]) backSlicer();
	// -Y
	color([0,0.5,0,.2]) frontSlicer(); 
	// it is assumzed that given the above, it should be obvious where top and bottom are
}

module SliceEverything() { 

	SliceCore(); 

	// +X
	translate([spacer,0,0])
   	rotate([0,-90,0])
		translate([-right,0,0]) 
		intersection() { 
			ThingToSlice(); 
		   rightSlicer();
	   }

	// -X
	translate([-spacer,0,0])
   rotate([0,90,0])
	translate([-left,0,0]) 
	intersection() { 
		ThingToSlice(); 
	   leftSlicer();
	   }

	// +Y 
   translate([0,spacer,0])
 	rotate([90,0,0])
	translate([0,-back,0])
	intersection() { 
		ThingToSlice();
		backSlicer(); 
	}
 	
	// -Y 
	translate([0,-spacer,0])
	rotate([-90,0,0])
	translate([0,-front,0])
	intersection() { 
		ThingToSlice(); 
		frontSlicer(); 
	} 

	// +Z
	translate([-spacer,+spacer,0])
 	translate([0,0,-top])
	intersection() { 
		ThingToSlice(); 
		topSlicer(); 
	}

	// -Z
	translate([+spacer,+spacer,0])
	rotate([180,0,0])
	translate([0,0,-bottom])
	intersection() { 
		ThingToSlice(); 
		bottomSlicer(); 
	}
}

module SliceCore() { 
	// Core
	translate ([0,0,-bottom]) 
		intersection() { 
			ThingToSlice();
			box(left,right,front,back,bottom,top);
		}; 
}

module box(left,right,front,back,bottom,top)
{
		translate([(right+left)/2,(front+back)/2,(top+bottom)/2] ) 
			scale( [right-left,back-front,top-bottom]) 
				cube(1,center=true);
}

// unfortunately, i did these backwards: specify them in counter clockwise from origin
// if pointing at the direction

module rightSlicer() { 
	projectedSlicer( 
			[right,front,   top],
			[right, back,   top], 
			[right, back,bottom],
			[right,front,bottom] );
}

module leftSlicer() {
	projectedSlicer( 
			[left,front,   top],
			[left,front,bottom],
			[left, back,bottom],
			[left, back,   top] ); 
}

module backSlicer() { 
	projectedSlicer(
			[right,  back,   top],
			[left, back,   top],
	      [left, back,bottom], 
			[right,  back,bottom]
			); 
}

module frontSlicer() { 
	projectedSlicer(
			[left, front,   top],
			[right,front,   top],
	      [right,front,bottom], 
			[left, front,bottom]
			); 
}

module topSlicer() { 
	projectedSlicer(
		[right, front, top], 
      [left, front, top], 
      [left, back, top], 
      [right, back, top]
		); 
}

module bottomSlicer() { 
	projectedSlicer(
		[right, front, bottom], 
		[right, back, bottom], 
		[left, back, bottom], 
		[left, front, bottom]
	); 
}

module projectedSlicer(v1,v2,v3,v4) { 
	polyhedron(
		points=[v1,v2,v3,v4, v1*10,v2*10,v3*10,v4*10],
		faces=[
			[3,2,1,0],
		   [5,4,0,1],
		   [2,6,5,1], 
		   [7,6,2,3],
		   [7,3,0,4],
		   [4,5,6,7]
		]
	); 
}

/* 

	color([1,0,0,.2]) box(left*100,right*100,front,back,bottom,top);
	color([0,1,0,.2]) box(left,right,front*100,back*100,bottom,top);
	color([0,0,1,.2]) box(left,right,front,back,bottom*100,top*100);
}

module box(left,right,front,back,bottom,top)
{
		translate([(right+left)/2,(front+back)/2,(top+bottom)/2] ) 
			scale( [right-left,back-front,top-bottom]) 
				cube(1,center=true);
}


module faceThing() { 
polyhedron ( 
  points=[
		[1,1,1],[1,1,-1],[1,-1,-1],[1,-1,1],
		[2,2,2],[2,2,-2],[2,-2,-2],[2,-2,2]
	],
  faces=[
	[3,2,1,0],
   [5,4,0,1],
   [2,6,5,1], 
   [7,6,2,3],
   [7,3,0,4],
   [4,5,6,7]
  ]
);


*/


/*
module dufus() { 
s=50;
color([.5,.5,.5]) cube([2,2,2],center=true);
color([ 1, 0, 0]) gar(); 
color([ 0, 1, 0]) rotate([0,  0, 90]) { gar(); };
color([.5, 0, 0]) rotate([0,  0,180]) { gar(); };
color([ 0,.5, 0]) rotate([0,  0,-90]) { gar(); };
color([ 0, 0, 1]) rotate([0,-90,  0]) { gar(); };
color([ 0, 0,.5]) rotate([0, 90,  0]) { gar(); };
}
*/

/* 
xc=40;
yc=40;
zc=5; 

intersection() { 
  SliceMe(); 
  scale(25) cube([2,2,2],center=true);
}

translate([xc,0,0]) intersection() { 
  SliceMe(); 
  scale(25) faceThing(); 
} 

translate([0,yc,0]) intersection() { 
  SliceMe(); 
  scale(25) rotate([0,  0, 90]) faceThing(); 
} 
 */ 