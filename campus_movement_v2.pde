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

PImage backgroundImg; 

int frameInterval;
int periodDisplay;
int studentCount;

void setup() {
  size(720, 830);
  frameRate = 120;
  students = new ArrayList<Student>();
  studentCount = 0;

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

void draw() {

  //can't use background(), since we'd erase the cool graph at the bottom
  noStroke();
  rectMode(CORNER);
  

  //our campus map
  // image(background, 0, 0);
  copy(backgroundImg,200,0,527,720,200,0,527,720);
  fill(85,150);
  rect(200, 0, width, 730);

  manageStudents();
  timeClock();


  lots.display();
  buildings.display();
  studentGraph();

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
  rect(0, 0, 200, 80); 
  textSize(12);

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
    saveFrame("screenshot.tif" );
  }
}
