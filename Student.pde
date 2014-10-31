
//Copyright 2014 - Marshall Turner
//schacht aslani architects
//All rights reserved.


import java.util.Iterator;

class Student {
  PVector location;
  PVector velocity;
  PVector acceleration;

  boolean hasLeft, hasArrived, visible, leaving, getsLunch;

  int arrival, departure, lunchTime;

  float topspeed;
  float maxforce;

  int travelBuffer = int(random(100, 200));
  int breaks[];

  int p1s, p1e, p2s, p2e, p3s, p3e, p4s, p4e, p5s, p5e, p6s, p6e, parkingSpotIndex;
  PVector p1b, p2b, p3b, p4b, p5b, p6b, parkingSpot, target;  

  Student(
  int p1s_, 
  int p1e_, 
  int p2s_, 
  int p2e_, 
  int p3s_, 
  int p3e_, 
  int p4s_, 
  int p4e_, 
  int p5s_, 
  int p5e_, 
  int p6s_, 
  int p6e_, 

  PVector p1b_, 
  PVector p2b_, 
  PVector p3b_, 
  PVector p4b_, 
  PVector p5b_, 
  PVector p6b_, 

  float topspeed_ )

  {

    hasLeft = false;
    hasArrived = false;
    leaving = false;
    visible = false;
    getsLunch = false;

    breaks = new int[5];

    p1s = p1s_;
    p1e = p1e_;
    p2s = p2s_;
    p2e = p2e_;
    p3s = p3s_;
    p3e = p3e_;
    p4s = p4s_;
    p4e = p4e_;
    p5s = p5s_;
    p5e = p5e_;
    p6s = p6s_;
    p6e = p6e_;

    lunchTime = 0;

    p1b = p1b_;
    p2b = p2b_;
    p3b = p3b_;
    p4b = p4b_;
    p5b = p5b_;
    p6b = p6b_;

    breaks[0] = p2s - p1e;
    breaks[1] = p3s - p2e;
    breaks[2] = p4s - p3e;
    breaks[3] = p5s - p4e;
    breaks[4] = p6s - p5e;

    arrival = p1s - int((travelBuffer * 1.5));

    if (p6e != 0) {
      departure = p6e + travelBuffer;
    } 
    else if (p5e != 0) {
      departure = p5e + travelBuffer;
    } 
    else if (p4e != 0) {
      departure = p4e + travelBuffer;
    } 
    else if (p3e != 0) {
      departure = p3e + travelBuffer;
    } 
    else if (p2e != 0) {
      departure = p2e + travelBuffer;
    } 
    else if (p1e != 0) {
      departure = p1e + travelBuffer;
    }

    parkingSpot = new PVector(0, 0);
    location = new PVector(0, 0);
    target = new PVector(0, 0);

    velocity = new PVector();
    acceleration = new PVector();   
    topspeed = topspeed_;
    maxforce = 0.15;
  }


  //main functions
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
    acceleration.mult(0);
  } 

  void getParking(ParkingLots lots) {
    parkingSpot = lots.lookup(p1b).get();
    parkingSpotIndex = lots.indexLookup(p1b);
  }


  void checkOnCampus() {

    if (frameCount == arrival) {
      hasArrived = true;
      getParking(lots);

      location = parkingSpot.get();
      location.x += int(random(-20, 20));
      location.y += int(random(-20, 20));
      lots.removeParking(parkingSpotIndex);
      target = p1b.get();
      buildings.enterBuilding(target);
      applyForce(new PVector(random(-.5, .5), random(-.5, .5)));
      visible = true;
      studentCount += 1;
    }

    if (frameCount == departure) {
      hasLeft = true;
      studentCount -= 1;
      visible = false;
      lots.addParking(parkingSpotIndex);
    }
  }

  void checkLunch() {
    if (breaks[0] > 180 && p1e > 2140 && p1e < 2860) {
      getsLunch = true;
      lunchTime = p1e;
    }
    if (breaks[1] > 180 && p2e > 2140 && p2e < 2860) {
      getsLunch = true;
      lunchTime = p2e;
    } 
    if (breaks[2] > 180 && p3e > 2140 && p3e < 2860) {
      getsLunch = true;
      lunchTime = p3e;
    } 
    if (breaks[3] > 180 && p4e > 2140 && p4e < 2860) {
      getsLunch = true;
      lunchTime = p4e;
    } 
    if (breaks[4] > 180 && p5e > 2140 && p5e < 2860) {
      getsLunch = true;
      lunchTime = p5e;
    }
  }


  void goToClass() {

    if (frameCount == p1e) { 
      buildings.leaveBuilding(target);
      if (p2s != 0) {  
        target = p2b.get();
        buildings.enterBuilding(target);
      } 
      else {
        leaving = true;
        target = parkingSpot.get();
        target.x += int(random(-20, 20));
        target.y += int(random(-20, 20));
      }
      applyForce(new PVector(random(-.5, .5), random(-.5, .5)));
    }

    if (frameCount == p2e) { 
      buildings.leaveBuilding(target);
      if (p3s != 0) {  
        target = p3b.get();
        buildings.enterBuilding(target);
      } 
      else {
        leaving = true;
        target = parkingSpot.get();
        target.x += int(random(-20, 20));
        target.y += int(random(-20, 20));
      }
      applyForce(new PVector(random(-.5, .5), random(-.5, .5)));
    }

    if (frameCount == p3e) { 
      buildings.leaveBuilding(target);
      if (p4s != 0) {  
        target = p4b.get();
        buildings.enterBuilding(target);
      } 
      else {
        leaving = true;
        target = parkingSpot.get();
        target.x += int(random(-20, 20));
        target.y += int(random(-20, 20));
      }
      applyForce(new PVector(random(-.5, .5), random(-.5, .5)));
    }

    if (frameCount == p4e) { 
      buildings.leaveBuilding(target);
      if (p5s != 0) {  
        target = p5b.get();
        buildings.enterBuilding(target);
      } 
      else {
        leaving = true;
        target = parkingSpot.get();
        target.x += int(random(-20, 20));
        target.y += int(random(-20, 20));
      }
      applyForce(new PVector(random(-.5, .5), random(-.5, .5)));
    }

    if (frameCount == p5e) { 
      buildings.leaveBuilding(target);
      if (p6s != 0) {  
        target = p6b.get();
        buildings.enterBuilding(target);
      } 
      else {
        leaving = true;
        target = parkingSpot.get();
        target.x += int(random(-20, 20));
        target.y += int(random(-20, 20));
      }
      applyForce(new PVector(random(-.5, .5), random(-.5, .5)));
    }

    if (frameCount == p6e) { 
      buildings.leaveBuilding(target);
      leaving = true;
      target = parkingSpot.get();
      target.x += int(random(-20, 20));
      target.y += int(random(-20, 20));
      applyForce(new PVector(random(-.5, .5), random(-.5, .5)));
    }
  }

  void getLunch() {
    if (getsLunch) {
      float test = random(0, 1);
      if (test < .7) {
        if (frameCount == lunchTime) {
          target = new PVector(435, 465);
          buildings.enterBuilding(target);
        }
      } 
      else if (test < .85) {
        if (frameCount == lunchTime) {  
          target = new PVector(348, 468);
          buildings.enterBuilding(target);
        }
      } 
      else if (test < 1) {
        if (frameCount == lunchTime) {  
          target = new PVector(348, 600);
          buildings.enterBuilding(target);
        }
      }
    }
  }  

  //seek the building
  void seek(PVector target_) {
    PVector desired = PVector.sub(target_, location);
    float d = desired.mag();
    desired.normalize();

    if (d <30) {
      //arrive slowly
      float m = map(d, 0, 50, .25, topspeed);
      desired.mult(m);
    } 
    else {
      desired.mult(topspeed);
    }

    PVector steer = PVector.sub(desired, velocity);

    //how quickly do our students steer?
    steer.limit(maxforce);
    applyForce(steer);
  }



  void drawStudent() {
    if (visible) {
      rectMode(CENTER);
      colorMode(RGB);

      noStroke();
      if (leaving) {
        fill(255, 200, 20, 60);
      }
      else {
        fill(255, 255, 20, 180);
      }
      rect(location.x, location.y, 4, 4);
    }
  }

  void run() {
    checkOnCampus();
    checkLunch();
    goToClass(); 
    getLunch(); 
    seek(target);
    update();
    drawStudent();
  }

  void explode(PVector gunpowder) {

    //the vector now goes between the mouse and the superPixel
    gunpowder.sub(location);

    //check the distance between the two
    float distance = gunpowder.mag();

    //if it's far away, no need to affect it (save CPU!)
    if (distance < 60) {
      gunpowder.normalize();
      float amount = -1 * random(30, 60);
      gunpowder.mult(amount/distance);
      acceleration.add(gunpowder);
    }
  }
}