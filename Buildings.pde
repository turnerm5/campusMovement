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

  void enterBuilding(PVector target) {
    

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

      //draw circles on the buildings, representing the building occupancy.
      //change the map function below to alter the circle size.

      noStroke();
      strokeWeight(1);

      fill(255, 50);

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