import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import de.bezier.data.*; 
import java.util.Iterator; 
import java.util.Collections; 
import java.util.Iterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class campus_movement_v2 extends PApplet {

//Copyright 2014 - Marshall Turner
//schacht aslani architects
//All rights reserved.





int[] scheduleArray = new int[24];
String cell;

ArrayList<Student> students;
XlsReader reader;

ParkingLots lots;
Buildings buildings;

PImage backgroundImg; 

int frameInterval;
int periodDisplay;
int studentCount;
int studentMovingCount;

public void setup() {
  size(740, 830);
  frameRate = 120;
  students = new ArrayList<Student>();
  studentCount = 0;
  studentMovingCount = 0;
  lots = new ParkingLots();
  buildings = new Buildings();

  background(85);
  backgroundImg = loadImage("campusmap.jpg");
  // tint(255, 255, 255, 150);
  // image(background, 0, 0);

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

public void draw() {

  //can't use background(), since we'd erase the cool graph at the bottom
  noStroke();
  rectMode(CORNER);
  

  //our campus map
  //crop it nicely
  copy(backgroundImg,200,0,527,720,200,0,527,720);
  fill(85,150);
  rect(200, 0, width, 730);

  //get those students running around
  manageStudents();
  countMovingStudents();
  timeClock();

  //this should really be done with different image buffers, to layer things nicely

  lots.display();
  buildings.display();
  studentGraph();


  //run away!!!
  if (mousePressed && (mouseButton == LEFT)) {
    Iterator<Student> it = students.iterator();
    while (it.hasNext ()) {
      Student s = it.next();    
      //s.follow(flow);
      s.explode(new PVector(mouseX, mouseY));
    }
  }
}


//Run through our ArrayList of students
public void manageStudents() {
  Iterator<Student> it = students.iterator();
  while (it.hasNext ()) {
    Student s = it.next();    
    s.run();
    if (s.hasLeft) {
      it.remove();
    }
  }
}

public void countMovingStudents() {
  studentMovingCount = 0;
  Iterator<Student> it = students.iterator();
  while (it.hasNext ()) {
    Student s = it.next();    
    if (s.isMoving()) {
      studentMovingCount++;
    }
  }
}

public void timeClock() {
  fill(85);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, 200, 80); 
  textSize(12);

  //convert frames to total seconds.

  int totalSeconds = (frameCount * 10 + 20000);
  int hours = PApplet.parseInt(totalSeconds / 3600);
  int minutes = PApplet.parseInt(totalSeconds / 60) % 60;
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


//Draw some nice lines and times
public void studentGraphSetup() {
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


//Map the number of students on campus, from 0 to 5000.
public void studentGraph() {
  int x = PApplet.parseInt(map(frameCount, 0, 6600, 5, 800));
  int y = PApplet.parseInt(map(studentCount, 0, 5000, height-1, height-90));
  int y2 = PApplet.parseInt(map(studentMovingCount, 0, 5000, height-1, height-90));
  stroke(230, 50);
  line(x+2, height, x+2, y);
  stroke(0,0,100, 50);
  line(x+2, height, x+2, y2);
}

public void keyPressed() {
  if (keyCode == UP) {
    saveFrame("screenshot.tif" );
  }
}
//Copyright 2014 - Marshall Turner
//schacht aslani architects
//All rights reserved.


class Buildings {

  PVector[] building;
  String[] names; 
  int[] capacity;
  
  int[] currentOccupancy;
  int xoffset, yoffset, matchingIndex;

  Buildings() {

    building = new PVector[16];
    currentOccupancy = new int[16]; 
    names = new String[16];
    capacity = new int[16];
    
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
    
    capacity[0] = 1000;
    capacity[1] = 1000;
    capacity[2] = 1000;
    capacity[3] = 1000;
    capacity[4] = 1000;
    capacity[5] = 1000;
    capacity[6] = 1000;
    capacity[7] = 1000;
    capacity[8] = 2000;
    capacity[9] = 1000;
    capacity[10] = 1000;
    capacity[11] = 1000;
    capacity[12] = 1000;
    capacity[13] = 1000;
    capacity[14] = 1000;
    capacity[15] = 1000;
    
    for (int i=0; i<16; i++) {
      currentOccupancy[i] = 0;
    }
  }

  public void enterBuilding(PVector target) {
    

    //I don't remember why I set it up this way...
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

  public void leaveBuilding(PVector target) {

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

  public void display() {
    for (int i=0; i<16; i++) {

      //draw circles on the buildings, representing the building occupancy.
      //change the map function below to alter the circle size.

      noStroke();
      strokeWeight(1);

      fill(255, 100);

      ellipseMode(CENTER);
      
      //I really like the map() function...
      ellipse(building[i].x, building[i].y, map(currentOccupancy[i], 0, 400, 28, 70), map(currentOccupancy[i], 0, 400, 28, 70));

      noStroke();
      textSize(12);
      textAlign(CENTER);
      fill(240);

      text(names[i], building[i].x, building[i].y+4);

      //I'll leave this in for now. It'd be nice to graph the building utilization, like we do for the parking lots.

      // float utilization = float(currentOccupancy[i]) / float(capacity[i]);
      // utilization *= 100;
      // String utilizationString = nf(utilization,3,2);

      // text(utilizationString, building[i].x, building[i].y+14);

      // fill(255);
      // textSize(12);
      // textAlign(LEFT);

      
      //text("Building " + i + ": " + utilizationString + "%", 10, 500 + (10 * i));

      //text(names[i], xoffset, yoffset + (80*i));
    }
  }
}
//Copyright 2014 - Marshall Turner
//schacht aslani architects
//All rights reserved.

class ParkingLots {

  ArrayList<Integer> shortlist;
  ArrayList<PVector> lot;
  ArrayList<String> name;
  ArrayList<Integer> capacity;
  ArrayList<Integer> currentCapacity;

  PVector building;

  float randomNumber;

  float shortestDistance = 100000;
  float distance;

  int busGraphColor;

  ParkingLots() {

    lot = new ArrayList<PVector>();
    capacity = new ArrayList<Integer>();     
    currentCapacity = new ArrayList<Integer>();
    shortlist = new ArrayList<Integer>();
    name = new ArrayList<String>();

    //This should be optimized to have a table, instead of hard-coded values
    lot.add(0, new PVector(298, 380));
    lot.add(1, new PVector(415, 378));
    lot.add(2, new PVector(429, 314));
    lot.add(3, new PVector(499, 250));
    lot.add(4, new PVector(497, 420));
    lot.add(5, new PVector(465, 428));
    lot.add(6, new PVector(460, 572));
    lot.add(7, new PVector(495, 565));
    lot.add(8, new PVector(495, 650));
    lot.add(9, new PVector(410, 629));
    lot.add(10, new PVector(317, 647));
    lot.add(11, new PVector(293, 576));
    lot.add(12, new PVector(327, 27));
    lot.add(13, new PVector(571, 52));
    lot.add(14, new PVector(341, 96));
    lot.add(15, new PVector(298, 611));

    lot.add(16, new PVector(447, 510));
    lot.add(17, new PVector(580, 327));
    lot.add(18, new PVector(668, 28));
    lot.add(19, new PVector(515, 28));

    name.add(0, "A");
    name.add(1, "B");
    name.add(2, "C");
    name.add(3, "D");
    name.add(4, "E");
    name.add(5, "F");
    name.add(6, "G");
    name.add(7, "H");
    name.add(8, "J");
    name.add(9, "N M L K");
    name.add(10, "P");
    name.add(11, "Q");
    name.add(12, "Maltby");
    name.add(13, "Ice Arena");
    name.add(14, "Olympic");
    name.add(15, "");

    //edmonds lots
    capacity.add(0, 163);
    capacity.add(1, 130);
    capacity.add(2, 139);
    capacity.add(3, 285);
    capacity.add(4, 228);
    capacity.add(5, 21);
    capacity.add(6, 66);
    capacity.add(7, 67);
    capacity.add(8, 47);
    capacity.add(9, 159);
    capacity.add(10, 301);
    capacity.add(11, 132);
    capacity.add(12, 69);
    capacity.add(13, 120);
    capacity.add(14, 52);
    capacity.add(15, 0);
    
    //bus drop off
    capacity.add(16, 99999);
    capacity.add(17, 99999);
    capacity.add(18, 99999);
    capacity.add(19, 99999);



    //initialize our lots
    for (int i=0; i<20; i++) {
      currentCapacity.add(i, capacity.get(i));
    }
  }

  public PVector lookup(PVector building) {
    
    // where is the closest lot?
    shortestDistance = 100000;
    shortlist.clear();
    shortlist.add(0);
    int tempIndex = 0;

    //check the distance between my first building and all of the lots
    
    ArrayList<PVector> shuffledLot = new ArrayList<PVector>(lot.size());
    for (PVector lotItem : lot){
      shuffledLot.add(lotItem);
    }
    Collections.shuffle(shuffledLot);

    Iterator<PVector> lotIt = shuffledLot.listIterator();
    while (lotIt.hasNext ()) {
      distance = abs(building.dist(lotIt.next()));
      if (distance < shortestDistance) {
        shortestDistance = distance;
        shortlist.add(0, tempIndex);
      }
      tempIndex++;  
    }


    //is the lot full? If so, remove it from our list of candidates.
    Iterator<Integer> it = shortlist.listIterator();    
    while (it.hasNext ()) {
      int testLot = it.next();
      if (currentCapacity.get(testLot) < 1) {
        it.remove();
      }
    }

    //some people take the bus
    randomNumber = random(0, 1);

    //if there are lots available, and I'm not taking the bus, return the lot I should pick
    if (shortlist.size() > 0 && randomNumber < .70f) { //this should be confirmed with a survey of how many people take the bus
      //choose one of the lots off my possible list
      int randomLot = PApplet.parseInt(random(0, shortlist.size()));
      return lot.get(shortlist.get(randomLot));
    } 
    else {
      //use a random bus stop
      float random = random(0, 1);
      if (random < .5f) {
        return lot.get(16);
      } 
      else if (random < .75f) {
        return lot.get(17);
      } 
      else if (random < .85f) {
        return lot.get(18);
      } 
      else if (random < 1) {
        return lot.get(19);
      } else {
        return lot.get(16); 
      }
    }
  }

  public int indexLookup(PVector building) {

    if (shortlist.size() > 0 && randomNumber < .70f) {
      return shortlist.get(0);
    } 
    else {
      float random = random(0, 1);
      if (random < .5f) {
        return 16;
      } 
      else if (random < .7f) {
        return 17;
      } 
      else if (random < .8f) {
        return 18;
      } 
      else if (random < 1) {
        return 19;
      } else {
        return 16; 
      }
    }
  }


  public void removeParking(int lot) {
    currentCapacity.set(lot, currentCapacity.get(lot) - 1);
  }

  public void addParking(int lot) {
    currentCapacity.set(lot, currentCapacity.get(lot) + 1);
  }

  public void display() {
    fill(85);
    noStroke();
    rectMode(CORNER);
    rect(0, 80, 65, 630);

    fill(255);
    textSize(12);
    textAlign(LEFT);
    text("Parking Lot Use", 10, 75);

    int totalCapacity = 0;

    for (int i=0; i<15; i++) {
      fill(255);
      textSize(10);
      int offset = 72 + (38*(i+1));
      
      text(name.get(i), lot.get(i).x, lot.get(i).y);

      int x = PApplet.parseInt(map(frameCount, 0, 6600, 0, 135)) + 65;
      int y = offset - PApplet.parseInt(map(currentCapacity.get(i), 0, capacity.get(i), 25, 0));
      
      totalCapacity += currentCapacity.get(i);

      if (currentCapacity.get(i) < 1){
        stroke(120, 0, 0, 50);
      } else {
        stroke(230, 50);
      }
      
      line(x, offset, x, y);
      text(name.get(i), 10, offset);      
    }

    int offset = 72 + (38*(15+1));
    int x = PApplet.parseInt(map(frameCount, 0, 6600, 0, 135)) + 65;
    int busRiders = (99999 - currentCapacity.get(16)) + (99999 - currentCapacity.get(17)) + (99999 - currentCapacity.get(18)) + (99999 - currentCapacity.get(19));
    int y = offset - PApplet.parseInt(map(busRiders, 0, 2000, 0, 25));
    
    if (totalCapacity < 300) {
      busGraphColor = color(120, 0, 0, 50);
    } else {
      busGraphColor = color(230, 50);
    }

    stroke(busGraphColor);
    line(x, offset, x, y);
    text("Bus", 10, offset); 
  }
}

//Copyright 2014 - Marshall Turner
//schacht aslani architects
//All rights reserved.




class Student {
  PVector location;
  PVector velocity;
  PVector acceleration;

  boolean hasLeft, hasArrived, visible, leaving, getsLunch;

  int arrival, departure, lunchTime;

  int parkingXOffset, parkingYOffset;

  boolean moving;

  float topspeed;
  float maxforce;

  int travelBuffer = PApplet.parseInt(random(100, 200));
  int breaks[];

  //They know when their periods start and end, and where they parked.
  int p1s, p1e, p2s, p2e, p3s, p3e, p4s, p4e, p5s, p5e, p6s, p6e, parkingSpotIndex;
  
  //They know where their buildings are.
  PVector p1b, p2b, p3b, p4b, p5b, p6b, parkingSpot, target;  

  //There has to be a better way to initialize this, right?
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
    moving = false;

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

    arrival = p1s - PApplet.parseInt((travelBuffer * 1.5f));

    // set up some variation in when they leave class, to give it a sense of organic-ness

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

    //they start from a spot a random distance away from the center of the parking lot
    parkingXOffset = PApplet.parseInt(sqrt(random(0, 1)) * cos(random(0, 2 * PI)) * 30);
    parkingYOffset = PApplet.parseInt(sqrt(random(0, 1)) * sin(random(0, 2 * PI)) * 30);
    parkingSpot = new PVector(0, 0);
    location = new PVector(0, 0);
    target = new PVector(0, 0);

    velocity = new PVector();
    acceleration = new PVector();   
    topspeed = topspeed_;
    maxforce = 0.15f;

    checkLunch();
  }


  //main functions
  public void applyForce(PVector force) {
    acceleration.add(force);
  }

  public void update() {
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
    acceleration.mult(0);
  } 

  public void getParking(ParkingLots lots) {
    parkingSpot = lots.lookup(p1b).get();  //give the parking lot object our first class. it'll tell us the location of where to park
    parkingSpotIndex = lots.indexLookup(p1b); //And what number the lot is
    parkingSpot.x += parkingXOffset;
    parkingSpot.y += parkingYOffset;
  }


  public void checkOnCampus() {

    if (frameCount == arrival) {
      hasArrived = true;
      getParking(lots); //check the lots for a parking spot

      location = parkingSpot.get(); //where should I park?
      lots.removeParking(parkingSpotIndex);  //remove that parking spot from the list of available spots
      target = p1b.get(); //where is my first building?
      buildings.enterBuilding(target); //go into the building
      applyForce(new PVector(random(-.5f, .5f), random(-.5f, .5f))); //apply a small force to give it a little sense of playfulness
      visible = true; //we can see the student!
      studentCount += 1; //add it to the list of total students on campus
    }

    if (frameCount == departure) {
      hasLeft = true;
      studentCount -= 1;
      visible = false;
      lots.addParking(parkingSpotIndex); //add that parking spot to the list of available spots
    }
  }


  //This may be a clunky way to do this. If they have a long break, and it's between 11:00 and 1:00 pm, consider
  //that student to get lunch. 
  public void checkLunch() {
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


  public void goToClass() {

    //there has to be a better way to do this...

    if (frameCount == p1e) { 
      buildings.leaveBuilding(target); //leave my current target
      if (p2s != 0) {  //if I have a class next in my schedule
        target = p2b.get(); //get my new target
        buildings.enterBuilding(target); //go to my new target
      } 
      else {
        leaving = true; 
        target = parkingSpot.get();
      }
      applyForce(new PVector(random(-.5f, .5f), random(-.5f, .5f)));
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
      }
      applyForce(new PVector(random(-.5f, .5f), random(-.5f, .5f)));
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
      }
      applyForce(new PVector(random(-.5f, .5f), random(-.5f, .5f)));
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
      }
      applyForce(new PVector(random(-.5f, .5f), random(-.5f, .5f)));
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
      }
      applyForce(new PVector(random(-.5f, .5f), random(-.5f, .5f)));
    }

    if (frameCount == p6e) { 
      buildings.leaveBuilding(target);
      leaving = true;
      target = parkingSpot.get();
      applyForce(new PVector(random(-.5f, .5f), random(-.5f, .5f)));
    }
  }

  public void getLunch() {
    if (getsLunch) { //if I get lunch
      float test = random(0, 1); //where should I get lunch?
      if (test < .7f) {
        if (frameCount == lunchTime) {
          target = new PVector(435, 465); //cafeteria 1
          buildings.enterBuilding(target);
        }
      } 
      else if (test < .85f) {
        if (frameCount == lunchTime) {  
          target = new PVector(348, 468); //cafeteria 2
          buildings.enterBuilding(target);
        }
      } 
      else if (test < 1) {
        if (frameCount == lunchTime) {  
          target = new PVector(348, 600); //cafeteria 3
          buildings.enterBuilding(target);
        }
      }
    }
  }  


  //seek the building
  public void seek(PVector target_) {
    PVector desired = PVector.sub(target_, location); //get the vector between my current location and my target
    float d = desired.mag(); //what is the current distance away?
    desired.normalize();

    if (d <30) {  //if I'm close
      //arrive slowly
      float m = map(d, 0, 50, .25f, topspeed);
      desired.mult(m);
    } 
    else { //if I'm not close
      desired.mult(topspeed); //go fast! 
    }

    PVector steer = PVector.sub(desired, velocity); //get the steering force to apply

    //how quickly do our students steer?
    steer.limit(maxforce);
    applyForce(steer);
  }



  public void drawStudent() {
    if (visible) {
      rectMode(CENTER);
      colorMode(RGB);

      noStroke(); //if I'm leaving, make me lighter
      if (leaving) {
        fill(255, 200, 20, 60);
      }
      else {
        fill(255, 255, 20, 180);
      }
      rect(location.x, location.y, 4, 4);
    }
  }

  public boolean isMoving() {  //count me if i'm moving
    if (velocity.mag() > .75f) {
      return true;
    } else {
      return false;
    }
  };

  public void run() {
    checkOnCampus(); //Is the student on campus yet?
    goToClass(); 
    getLunch(); 
    seek(target);
    update();
    drawStudent();
  }

  public void explode(PVector gunpowder) {

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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "campus_movement_v2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
