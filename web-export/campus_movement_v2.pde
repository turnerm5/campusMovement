//Copyright 2014 - Marshall Turner
//schacht aslani architects
//All rights reserved.

import de.bezier.data.*;

import java.util.Iterator;

int[] scheduleArray = new int[24];
String cell;

ArrayList<Student> students;
XlsReader reader;

ParkingLots lots;
Buildings buildings;

PImage background; 

int frameInterval;
int periodDisplay;
int studentCount;

void setup() {
  size(720, 830);
  frameRate = 60;
  students = new ArrayList<Student>();
  studentCount = 0;

  lots = new ParkingLots();
  buildings = new Buildings();

  background(85);
  background = loadImage("campusmap.png");
  tint(255, 255, 255, 85);
  image(background, 0, 0);

  //get our Excel data
  reader = new XlsReader(this, "studentdata.xls");
  reader.firstRow();
  while (reader.hasMoreRows ()) {

    //read all of our excel data, fill in the periods and parking spot
    reader.nextRow();
    for (int i = 0; i < 24; i++) {
      scheduleArray[i] = reader.getInt();
      reader.nextCell();
    }

    //initialize our students. This should really be done with an array.

    //Class times
    students.add(new Student(
    scheduleArray[0], 
    scheduleArray[1], 
    scheduleArray[4], 
    scheduleArray[5], 
    scheduleArray[8], 
    scheduleArray[9], 
    scheduleArray[12], 
    scheduleArray[13], 
    scheduleArray[16], 
    scheduleArray[17], 
    scheduleArray[20], 
    scheduleArray[21], 


    //Their class locations
    new PVector (scheduleArray[2], scheduleArray[3]), 
    new PVector (scheduleArray[6], scheduleArray[7]), 
    new PVector (scheduleArray[10], scheduleArray[11]), 
    new PVector (scheduleArray[14], scheduleArray[15]), 
    new PVector (scheduleArray[18], scheduleArray[19]), 
    new PVector (scheduleArray[22], scheduleArray[23]), 

    //Student speed
    random(2, 3)
      )
      );
  }
  studentGraphSetup();
}

void draw() {

  //can't use background(), since we'd erase the cool graph at the bottom
  fill(85);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, width, 730);

  //our campus map
  image(background, 0, 0);

  manageStudents();
  timeClock();


  lots.display();
  buildings.display();
  studentGraph();
  //turn this on when rendering it.
  //saveFrame("/frames/frame-#######.tif");

  if (mousePressed && (mouseButton == LEFT)) {
    Iterator<Student> it = students.iterator();
    while (it.hasNext ()) {
      Student s = it.next();    
      //s.follow(flow);
      s.explode(new PVector(mouseX, mouseY));
    }
  }
}

void manageStudents() {
  Iterator<Student> it = students.iterator();
  while (it.hasNext ()) {
    Student s = it.next();    
    //s.follow(flow);
    s.run();

    if (s.hasLeft) {
      it.remove();
    }
  }
}


void timeClock() {
  fill(85);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, 100, 35); 
  textSize(9);

  //convert frames to total seconds.

  int totalSeconds = (frameCount * 10 + 20000);
  int hours = int(totalSeconds / 3600);
  int minutes = int(totalSeconds / 60) % 60;
  String minString = "";
  if (minutes < 10) {
    minString = "0" + minutes;
  } 
  else {
    minString =  "" + minutes;
  }
  textAlign(LEFT);
  fill(255);
  text("Monday, Fall Quarter", 10, 16);
  text("Time: " + hours + ":" + minString, 10, 32);
  text("Students on Campus: " + studentCount, 10, 48);
}

void studentGraphSetup() {
  for (int i=0; i < 18; i++) {
    int xCoor = i * 43 + 27;
    stroke(230, 50);
    line(xCoor, height, xCoor, height-100);

    int hours = i+6;

    textAlign(RIGHT);
    textSize(8);
    fill(255);
    text(hours + ":00", xCoor-4, height-93);
  }
}

void studentGraph() {
  int x = int(map(frameCount, 0, 6600, 5, 800));
  int y = int(map(studentCount, 0, 5000, height-1, height-90));
  stroke(230, 50);
  line(x+2, height, x+2, y);
}

void keyPressed() {
  if (keyCode == UP) {
    frameCount = 0;
    setup();
  }
}
//Copyright 2014 - Marshall Turner
//schacht aslani architects
//All rights reserved.


class Buildings {

  PVector[] building;
  String[] names; 

  int[] currentOccupancy;
  int xoffset, yoffset, matchingIndex;

  Buildings() {

    building = new PVector[16];
    currentOccupancy = new int[16]; 
    names = new String[16];

    //our building arrays. this could be done by importing an Excel. Next time!

    building[0] = new PVector(342, 545);
    building[1] = new PVector(407, 535);
    building[2] = new PVector(424, 577);
    building[3] = new PVector(348, 600);
    building[4] = new PVector(295, 514);
    building[5] = new PVector(238, 472);
    building[6] = new PVector(288, 456);
    building[7] = new PVector(348, 468);
    building[8] = new PVector(435, 465);
    building[9] = new PVector(419, 400);
    building[10] = new PVector(343, 317);
    building[11] = new PVector(386, 195);
    building[12] = new PVector(358, 77);
    building[13] = new PVector(352, 47);
    building[14] = new PVector(626, 107);
    building[15] = new PVector(672, 67);

    names[0] = "LYN";
    names[1] = "ALD";
    names[2] = "SNH";
    names[3] = "MUK";
    names[4] = "WWY";
    names[5] = "MIC";
    names[6] = "MDL";
    names[7] = "MLT";
    names[8] = "BRI";
    names[9] = "SQL";
    names[10] = "SEA";
    names[11] = "FIR";
    names[12] = "OLY";
    names[13] = "MAB";
    names[14] = "GWY";
    names[15] = "MON";

    for (int i=0; i<16; i++) {
      currentOccupancy[i] = 0;
    }
  }



  void enterBuilding(PVector target) {
    matchingIndex = 999;

    //if the target building matches one on our list, add one to the occupancy.
    for (int i=0; i<16; i++) {
      if (building[i].x == target.x && building[i].y == target.y) {
        matchingIndex = i;
      }
    }
    if (matchingIndex != 999) {
      currentOccupancy[matchingIndex]++;
    } 
    else {
      println("No matching building found. Target was:" + target.x + "," + target.y);
    }
  }

  void leaveBuilding(PVector target) {
    matchingIndex = 999;

    //if the target building matches one on our list, subtract one from the occupancy.
    for (int i=0; i<16; i++) {
      if (building[i].x == target.x && building[i].y == target.y) {
        matchingIndex = i;
      }
    }
    if (matchingIndex != 999) {
      currentOccupancy[matchingIndex]--;
    } 
    else {
      println("No matching building found. Target was:" + target.x + "," + target.y);
    }
  }

  void display() {
    for (int i=0; i<16; i++) {

      if (i < 8) {
        xoffset = 1000;
        yoffset = 150;
      } 
      else {
        xoffset = 1200;
        yoffset = -492;
      }

      //draw circles on the buildings, representing the building occupancy.
      //change the map function below to alter the circle size.

      stroke(255);
      strokeWeight(1);

      fill(255, 100);

      ellipseMode(CENTER);
      ellipse(building[i].x, building[i].y, map(currentOccupancy[i], 0, 400, 28, 70), map(currentOccupancy[i], 0, 400, 28, 70));

      //ellipse(xoffset, yoffset - 6 + (80*i), map(currentOccupancy[i], 0, 400, 30, 100), map(currentOccupancy[i], 0, 400, 30, 100));

      noStroke();
      textSize(10);
      textAlign(CENTER);
      fill(30);


      text(names[i], building[i].x, building[i].y+4);



      //text(names[i], xoffset, yoffset + (80*i));
    }
  }
}
//Copyright 2014 - Marshall Turner
//schacht aslani architects
//All rights reserved.

class ParkingLots {

  PVector[] lot;
  ArrayList<Integer> shortlist;

  PVector building;

  int[] capacity;
  int[] currentCapacity;



  float shortestDistance = 100000;
  float distance;

  ParkingLots() {

    lot = new PVector[20];
    capacity = new int[20];     
    currentCapacity = new int[20];
    shortlist = new ArrayList<Integer>();

    lot[0] = new PVector(327, 27);
    lot[1] = new PVector(571, 52);
    lot[2] = new PVector(341, 96);
    lot[3] = new PVector(499, 250);
    lot[4] = new PVector(497, 398);
    lot[5] = new PVector(429, 314);
    lot[6] = new PVector(491, 453);
    lot[7] = new PVector(456, 378);
    lot[9] = new PVector(495, 554);
    lot[8] = new PVector(502, 603);
    lot[10] = new PVector(317, 647);
    lot[12] = new PVector(460, 572);
    lot[11] = new PVector(410, 629);
    lot[13] = new PVector(301, 380);
    lot[14] = new PVector(293, 576);
    lot[15] = new PVector(298, 611);

    lot[16] = new PVector(447, 510);
    lot[17] = new PVector(580, 327);
    lot[18] = new PVector(668, 28);
    lot[19] = new PVector(515, 28);


    capacity[0] = 75;
    capacity[1] = 75;
    capacity[2] = 50;
    capacity[3] = 250;
    capacity[4] = 200;
    capacity[5] = 200;
    capacity[6] = 200;
    capacity[7] = 75;
    capacity[9] = 150;
    capacity[8] = 250;
    capacity[10] = 250;
    capacity[12] = 140;
    capacity[11] = 200;
    capacity[13] = 150;
    capacity[14] = 175;
    capacity[15] = 175;
    capacity[16] = 99999;
    capacity[17] = 99999;
    capacity[18] = 99999;
    capacity[19] = 99999;

    for (int i=0; i<20; i++) {
      currentCapacity[i] = capacity[i];
    }
  }

  PVector lookup(PVector building) {
    shortestDistance = 100000;
    shortlist.clear();
    shortlist.add(0);

    for (int i=0; i<16; i++) {
      distance = abs(building.dist(lot[i]));
      if (distance < shortestDistance) {
        shortestDistance = distance;
        shortlist.add(0, i);
      }
    }

    Iterator<Integer> it = shortlist.listIterator();    
    while (it.hasNext ()) {
      int testLot = it.next();
      if (currentCapacity[testLot] < 1) {
        it.remove();
      }
    }

    if (shortlist.size() > 0) {
      return lot[shortlist.get(0)];
    } 
    else {
      float random = random(0, 1);
      if (random < .5) {
        return lot[16];
      } 
      else if (random < .75) {
        return lot[17];
      } 
      else if (random < .85) {
        return lot[18];
      } 
      else if (random < 1) {
        return lot[19];
      } else {
        return lot[16]; 
      }
    }
  }

  int indexLookup(PVector building) {

    if (shortlist.size() > 0) {
      return shortlist.get(0);
    } 
    else {
      float random = random(0, 1);
      if (random < .5) {
        return 16;
      } 
      else if (random < .7) {
        return 17;
      } 
      else if (random < .8) {
        return 18;
      } 
      else if (random < 1) {
        return 19;
      } else {
        return 16; 
      }
    }
  }


  void removeParking(int lot) {
    currentCapacity[lot]--;
  }

  void addParking(int lot) {
    currentCapacity[lot]++;
  }

  void display() {
    fill(85);
    noStroke();
    rectMode(CORNER);
    rect(0, 50, 120, 300); 


    fill(255);
    textSize(9);
    textAlign(LEFT);
    text("Parking Lot Capacity", 10, 75);

    for (int i=0; i<16; i++) {
      fill(255);
      textSize(9);
      textAlign(LEFT);
      text("Lot " + (i+1) + ": " + currentCapacity[i], 10, 75 + (16*(i+1)));
      
    }
      text("Not Driving: " + ((99999 - currentCapacity[16]) + (99999 - currentCapacity[17]) + (99999 - currentCapacity[18]) + (99999 - currentCapacity[19])), 10, 350);
  }
}

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

    float r;
    float wandertheta;

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
        target.x += int(random(-10, 10));
        target.y += int(random(-10, 10));
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
        target.x += int(random(-10, 10));
        target.y += int(random(-10, 10));
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
        target.x += int(random(-10, 10));
        target.y += int(random(-10, 10));
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
        target.x += int(random(-10, 10));
        target.y += int(random(-10, 10));
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
        target.x += int(random(-10, 10));
        target.y += int(random(-10, 10));
      }
      applyForce(new PVector(random(-.5, .5), random(-.5, .5)));
    }

    if (frameCount == p6e) { 
      buildings.leaveBuilding(target);
      leaving = true;
      target = parkingSpot.get();
      target.x += int(random(-10, 10));
      target.y += int(random(-10, 10));
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
        fill(255, 255, 20, 120);
      }
      rect(location.x, location.y, 2, 2);
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

