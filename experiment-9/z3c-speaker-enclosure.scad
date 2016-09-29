corner_radius=7;
box_radius=9;
hole_radius=10;
wall=2;
phone_width=65;
phone_length=127.25;
phone_depth=8.75;
phone_lengthwise_margin=13.25;
viewport_width=phone_length-phone_lengthwise_margin*2;
viewport_height=56.5;
box_width=phone_length+5+5; 
box_height=140;
lip_length=20;
foot_length=sqrt(2*(box_height*box_height))/2;
speaker_length=147;

rotate([0,0,45]) {
// rotate([0,0,0]) {
    //#translate([phone_depth+wall,phone_width+75,0]) rotate([90,0,0]) rotate([0,-90,0]) #phone();
    %left_upright();
    %left_speaker_foot();
    //translate([30, 45, 0]) foot_beam();
    translate([-10,0,0]) {
        right_upright();
        right_speaker_foot();
    }

}
//#speaker();

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
module left_speaker_foot() {
    dia=phone_depth+wall*2;
    depth=phone_lengthwise_margin+wall;
    r=0.5*phone_depth+wall;

    difference() {
        translate([dia,0,0])  {
            hull() {
                translate([-dia/2,r,0]) cylinder(h=depth, r=r/2);
                translate([-dia/2+20,r,0]) cylinder(h=depth, r=r/2);
            }
            hull() {
                translate([-dia/2+20,r,0]) cylinder(h=depth, r=r/2);
                translate([30+r/2,depth/2+r+r/2,0]) cylinder(r=r/2, h=depth);
            }
            translate([0, 0.5, 0]) hull() {
                translate([30+r/2,depth/2+r+r/2,0]) cylinder(r=r/2, h=depth);
                translate([20,depth/2+r,0]) cube([15, 25, depth*2]);
                translate([28.5+r+1.5,depth/2+15,0]) cylinder(r=r, h=depth);
            }
        }
        // make concavity for radiused speaker body
        translate([dia,0,wall]) left_speaker_end(33, 6);
    }
}
module left_speaker_end(r, trunc) {
    difference() {
        hull() {
            translate([0,r,r]) sphere(r=r);
            translate([0,r,r+50]) sphere(r=r);
        }
        union() {
            translate([-r,0,0]) cube([r,r*2,r*2+50]);
            translate([r-trunc,0,0]) cube([r,r*2,r*2+50]);
        }
    }
}
module right_speaker_foot() {
    dia=phone_depth+wall*2;
    r=33;
    difference() {
        mirror([1,0,0]) left_speaker_foot();
        translate([-dia,0, wall]) mirror([1,0,0]) left_speaker_end(33,0);
    }
}    

module speaker() {
    translate([phone_depth+wall+wall,phone_depth/2+wall+33,0]) 
    rotate([0,0,90]) 
    union() {
        difference() {
            cylinder(r=33, h=speaker_length);
            union() {
                translate([-33,0,0]) cube([66, 33, speaker_length]);
                translate([-33,-25-10,0]) cube([66, 10, speaker_length]);
            }
        }
        translate([-(66-34.5)/2,-25-5,speaker_length-40]) cube([34.5,29.5,40]);
    }
}

module speaker_plate() {
    side_margin=phone_lengthwise_margin+wall;
    r=12;
    
    translate([0,0,10]) {
    difference() {
        cylinder(r=r+wall*4, h=wall, center=true);
        #cylinder(r=r+wall*2, h=wall, center=true);
    }
    difference() {
        cylinder(r=r+wall*2, h=wall, center=true);
        #cylinder(r=r, h=wall, center=true);
    }
    }

    difference() {
        union() {    
            translate([side_margin, 0, 0]) cube([speaker_length, phone_width, wall]);
            // top lip
            translate([side_margin+22, 0, 0]) cube([speaker_length-22*2, wall, phone_depth+wall]);
            // cutout/marker for left speaker faceplate attach point
            #translate([side_margin,phone_width/2,0]) cylinder(r=12, h=wall+0.5);
            #translate([speaker_length+side_margin,phone_width/2,0]) cylinder(r=12, h=wall+0.5);
        }
        union() {
            translate([side_margin+r,phone_width/2-r,0]) #cube([speaker_length-r*2, r*2, wall]);
            translate([side_margin,phone_width/2-r,wall]) #cube([speaker_length, r*2, wall]);
        }
    }
}
module phone_outline() {
    cube([phone_length, phone_width, phone_depth]);
}

