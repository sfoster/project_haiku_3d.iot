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
    translate([0,0,0]) {
        left_upright();
        left_speaker_foot();
    }
    translate([-10,0,0]) {
        right_upright();
        right_speaker_foot();
    }
    translate([-box_width/2,-80,0]) speaker_plate();
    translate([-box_width/2,-130,0]) base_strap();

    // ---------------------------
    // debug 
    // 
    *speaker();
    // translate([phone_depth+wall,phone_width+75,0])
    // rotate([90,0,0]) rotate([0,-90,0]) #phone();
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
            translate([0, 77.5+phone_width/2, 3+phone_lengthwise_margin]) rotate([0,90,0]) cylinder(r=12, h=wall);
            // cutout/marker for left speaker faceplate attach point
            translate([0, 77.5-phone_width+phone_width/2, 3+phone_lengthwise_margin]) rotate([0,90,0]) cylinder(r=12, h=0.5);
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
module divot() {
    translate([0.75, 0, 0.5]) rotate([0, 180, 0]) cylinder(r1=0.75, r2=0, height=1.5);
}
module right_upright() {
    mirror([1,0,0]) left_upright();
}
module channel(r, dia, length, depth) {
    d=phone_depth+wall;
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
    translate([wall,length-phone_width-wall,0]) cube([phone_depth, wall, 4.5+wall]);
    // receiver for faceplate attach screw
    translate([wall/2, 82.5-phone_width+phone_width/2-12, 0]) #cube([phone_depth+wall, 14, 14]);
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
        union() {
            // make concavity for radiused speaker body
            translate([0,0,-5]) speaker();
            // receiver for the base strap
            #translate([70, 49, 16]) rotate([0,90,-54]) cylinder(r=12.5, h=1.5);
        }
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
                    translate([0,r,r]) rotate([0,90,0]) cylinder(r=r/2, h=r-3);
                    translate([0,r,r/2]) rotate([0,90,0]) cylinder(r=r/2, h=r-3);
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
    inner_r=r-0.25;
    
    plate_width=viewport_width;
    plate_height=phone_width;
    
    difference() {
        union() {    
            translate([r,0,0]) {
                cube([plate_width, plate_height, wall]);
            }
            // top lip
            translate([r+5, 0, 0]) cube([plate_width-5*2, wall, wall*2]);
            // bottom lip
            translate([r, plate_height-wall, 0]) cube([plate_width, wall, phone_depth+wall]);
            // faceplate attach point lugs
            translate([r+1.5,plate_height/2,0]) cylinder(r=inner_r, h=wall+0.5);
            translate([r+plate_width-1.5,plate_height/2,0]) cylinder(r=inner_r, h=wall+0.5);
            
            *translate([r,plate_height/2-0.5,wall]) #cube([plate_width, 1, wall]);
        }
        union() {
            // hole markers for lugs
            translate([r+1.5-6.5,plate_height/2,wall]) #divot();
            translate([r+plate_width-1.5+6.5,plate_height/2,wall]) #divot();
            
            #hull() {
                translate([r*2+r*0.25,plate_height/2,0]) cylinder(r=inner_r, h=wall+0.5);
                translate([plate_width-r*0.25,plate_height/2,0]) cylinder(r=inner_r, h=wall+0.5);
            }
            // translate([r*2,plate_height/2-r,0]) cube([plate_width-r*2, r*2, wall]);
            // the holes grid
            translate([r+1,1.5,0]) honeycomb(plate_width, plate_height/2-r, 3, 6);
            translate([r+1,plate_height/2+r,0]) honeycomb(plate_width, plate_height/2-r, 3, 6);
        }
    }
}
module base_strap() {
    side_margin=phone_lengthwise_margin+wall;
    r=12;
    inner_r=r-0.25;
    
    plate_width=viewport_width;
    plate_height=phone_width;
    difference() {
        hull() {
            // lugs
            translate([r+1.5,plate_height/2,0]) cylinder(r=inner_r, h=wall+0.5);
            translate([r+plate_width-1.5,plate_height/2,0]) cylinder(r=inner_r, h=wall+0.5);
        }
        union() {
            // hole markers for lugs
            translate([r+1.5-6.5,plate_height/2,wall]) #divot();
            translate([r+plate_width-1.5+6.5,plate_height/2,wall]) #divot();
        }
    }

    }
module phone_outline() {
    cube([phone_length, phone_width, phone_depth]);
}

module honeycomb(width, height, inner_d, spacing)  {
    unit_w=inner_d+spacing;
    cols=-1+floor((width-unit_w)/unit_w);
    rows=-1+floor(height/(unit_w*0.66));
    col=0;
    row=0;
    x=0;
    indent_x = 0;
    translate([unit_w/2,unit_w/2,0]) #union() {
        for (row=[0:rows]) {
            for (col=[0:cols]) {
                x = (row%2==0) ? unit_w/2+col*unit_w : col*unit_w;
                translate([x, 0.66*row*unit_w, 0]) cylinder(r=inner_d/2, h=wall);
                if (row%2 > 0)
                    translate([x+unit_w, 0.66*row*unit_w, 0]) cylinder(r=inner_d/2, h=wall);
            }
        }
    }
}
