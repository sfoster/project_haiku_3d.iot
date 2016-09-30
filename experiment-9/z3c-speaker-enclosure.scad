corner_radius=7;
box_radius=9;
hole_radius=10;
wall=2;
phone_width=65;
phone_length=127.25;
phone_depth=8.75;
phone_lengthwise_margin=13.25;
viewport_width=101;
viewport_height=56.5;
box_width=phone_length+5+5; 
box_height=140;
lip_length=20;
foot_length=sqrt(2*(box_height*box_height))/2;
speaker_length=148.5;

//rotate([0,0,45]) {
rotate([0,0,0]) {
    //#translate([phone_depth+wall,phone_width+75,0]) rotate([90,0,0]) rotate([0,-90,0]) #phone();
    *left_upright();
    *left_speaker_foot();
    //translate([30, 45, 0]) foot_beam();
    *translate([-10,0,0]) {
        right_upright();
        right_speaker_foot();
    }
    translate([-box_width/2,-100,0]) speaker_plate();
    //speaker();
}

module phone() {
    cube([phone_width, phone_length, phone_depth]);
}
module left_upright() {
    r=0.5*phone_depth+wall;
    dia=phone_depth+wall*2;
    length=phone_width+75;
    depth=phone_lengthwise_margin+wall;

    difference() {
        channel(r, dia, length, depth);
        union() {
            // cutout for left phone speaker
            translate([0, 75+phone_width/2, 3+phone_lengthwise_margin]) rotate([0,90,0]) cylinder(r=12, h=wall);
            // cutout/marker for left speaker faceplate attach point
            translate([0, 75-phone_width+phone_width/2, 3+phone_lengthwise_margin]) rotate([0,90,0]) cylinder(r=12, h=0.5);
        }
    }
    // the horizontal beam
    *translate([dia,0,depth])  {
        foot_beam();
    }
}

module foot_beam() {
    dia=phone_depth+wall*2;
    r=0.5*phone_depth+wall;
    depth=phone_lengthwise_margin+wall;
    #hull() {
        translate([-dia/2,0,0]) cylinder(h=depth, r=r);
        translate([28.5+r+1.5,depth/2+15,0]) cylinder(r=r, h=depth);
    }
}
module right_upright() {
    mirror([1,0,0]) left_upright();
}
module channel(r, dia, length, depth) {
    difference() {
        hull() {
            cube([phone_depth+wall*2, length-wall, depth]);
            translate([r,length-wall,0]) cylinder(h=depth, r=r);
            translate([r,0,0]) cylinder(h=depth, r=r);
        }
        hull() {
            translate([wall, 10, wall]) cube([phone_depth, length-10-wall, phone_lengthwise_margin]);
            translate([r,length-wall,wall]) scale([1,0.5,1]) cylinder(h=phone_lengthwise_margin, r=r-wall);
        }
    }
    
    // bottom ledge for phone
    translate([wall,length-phone_width-wall,0]) cube([phone_depth, wall, 6.5+wall]);
    // receiver for faceplate attach screw
    hull() {
        translate([wall/2, 75-phone_width+phone_width/2, depth/2]) rotate([0,90,0]) cylinder(r=3.5, h=phone_depth+wall);
        translate([wall/2, 75-phone_width+phone_width/2-3.5, 0]) cube([phone_depth+wall, 7, depth/2]);
    }
}

module _speaker_foot() {
    dia=phone_depth+wall*2;
    depth=phone_lengthwise_margin+wall;
    upright_length=phone_width+75;
    unit=upright_length/4;
    r=0.5*phone_depth+wall;
    echo("r: ", r);
    upright_offset=11.5;
    translate([dia,upright_offset-7.5,0])  {
        translate([-dia/2,-7.5,0]) {
            hull() {
                translate([0,0,0]) cylinder(h=depth, r=r/2);
                translate([0,upright_offset,0]) cylinder(r=r/2, h=depth);
                #translate([15,upright_offset,0]) cylinder(r=r/2, h=depth);
            }
            hull() {
                translate([0,0,0]) cylinder(h=depth, r=r/2);
                translate([4*(unit*3/5),3*(unit*3/5),0]) cylinder(r=r/2, h=depth);
            }
            hull() {
                translate([4*(unit*3/12),3*(unit*3/12),0]) cylinder(r=r/2, depth*2);
                translate([4*(unit*3/12),20+3*(unit*3/12),0]) cylinder(r=r/2, depth*2);
                translate([4*(unit*3/8),3*(unit*3/8),0]) cylinder(r=r/2, depth*2);
            }
        }
    }
}
module left_speaker_foot() {
    difference() {
        _speaker_foot();
        // make concavity for radiused speaker body
        speaker();
    }
}

module right_speaker_foot() {
    overhang=(speaker_length-131)/2;
    difference() {
        mirror([1,0,0]) _speaker_foot();
        translate([0,0,speaker_length-overhang-overhang]) rotate(a=180, v=[0,1,0]) speaker();
    }
}    


module speaker() {
    r=33;
    upright_r=0.5*phone_depth+wall;
    upright_offset=11.5;
    trunc=6;
    overhang=(speaker_length-131)/2;
    echo("overhang", overhang);
    translate([phone_depth+wall+wall,upright_offset,-overhang]) 
    rotate([0,0,0]) 
    union() {
        difference() {
            union() {
                difference() {
                    translate([0,(r+r-38)/2,speaker_length-r]) rotate([0,90,90]) cylinder(r=r, h=38);
                    translate([-r,(r-38)/2,speaker_length-r-r]) cube([r,r+r,r+r]);
                }
                hull() {
                    difference() {
                        hull() {
                            translate([0,r,r]) sphere(r=r);
                            translate([0,r,speaker_length-r]) sphere(r=r);
                        }
                        union() {
                            translate([-r,0,0]) cube([r,r*2,speaker_length]);
                            translate([29,(r*2-38)/2,0]) cube([r,38,speaker_length-r]);
                        }
                    }
                    translate([-3,(r*2-38)/2,38]) cube([3,38,speaker_length-38-38]);
                }
            }
        }
    }
}

module speaker_plate() {
    side_margin=phone_lengthwise_margin+wall;
    r=12;
    
    plate_width=viewport_width;
    plate_height=phone_width;
    cell=plate_width/16;
    holes_x_count=plate_width/cell;
    holes_y_count=plate_height/6;
    echo("holes_x_count:", holes_x_count);

    difference() {
        union() {    
            translate([r,0,0]) {
                resize([0,phone_width,0], auto=[false,true,false])
                cube([plate_width, plate_height, wall]);
                //honeycomb(holes_x_count, holes_y_count, 6, wall, 60);
            }
            // top lip
            translate([r, 0, 0]) cube([plate_width, wall, phone_depth+wall]);
            // cutout/marker for left speaker faceplate attach point
            #translate([r,plate_height/2,0]) cylinder(r=12, h=wall+0.5);
            #translate([r+plate_width,plate_height/2,0]) cylinder(r=12, h=wall+0.5);
        }
        union() {
            translate([r*2,plate_height/2-r,0]) cube([plate_width-r*2, r*2, wall]);
            translate([r,plate_height/2-r,wall]) cube([plate_width, r*2, wall]);
        }
    }
}
module phone_outline() {
    cube([phone_length, phone_width, phone_depth]);
}

module honeycomb(x, y, cell, h, fill)  {
    sqrt3=sqrt(3);      
    w=cell*fill/100;            // calculate wall thickness
    echo("wall:", w);           // display (walls won't get printed when too thin)

  difference()  {
    cube([(1.5*x+0.5)*cell+w, cell*sqrt3*y+1.5*w-w/2, h]);  // rectangular plate

    translate([w-cell*2, w, wall])
    linear_extrude(wall)  {       // punch with matrix of hexagonal prisms
      for (a=[0:x/2+1], b=[0:y], c=[0:1/2:1/2])
      translate([(a+c)*3*cell-w/2, (b+c)*sqrt3*cell-w/2])
      circle(cell-w, $fn=6);
    }
  }
}
