//Copyright 2014 - Marshall Turner
//schacht aslani architects
//All rights reserved.

class ParkingLots {

  PVector[] lot;
  ArrayList<Integer> shortlist;

  PVector building;

  String[] name;

  int[] capacity;
  int[] currentCapacity;

  float randomNumber;

  float shortestDistance = 100000;
  float distance;

  ParkingLots() {

    lot = new PVector[20];
    capacity = new int[20];     
    currentCapacity = new int[20];
    shortlist = new ArrayList<Integer>();
    name = new String[20];

    //This should be optimized to have a table, instead of hard-coded values
    lot[0] = new PVector(301, 380);
    lot[1] = new PVector(420, 378);
    lot[2] = new PVector(429, 314);
    lot[3] = new PVector(499, 250);
    lot[4] = new PVector(497, 425);
    lot[5] = new PVector(465, 428);
    lot[6] = new PVector(460, 572);
    lot[7] = new PVector(502, 560);
    lot[8] = new PVector(495, 650);
    lot[9] = new PVector(410, 629);
    lot[10] = new PVector(317, 647);
    lot[11] = new PVector(293, 576);
    lot[12] = new PVector(327, 27);
    lot[13] = new PVector(571, 52);
    lot[14] = new PVector(341, 96);
    lot[15] = new PVector(298, 611);

    lot[16] = new PVector(447, 510);
    lot[17] = new PVector(580, 327);
    lot[18] = new PVector(668, 28);
    lot[19] = new PVector(515, 28);

    name[0] = "A";
    name[1] = "B";
    name[2] = "C";
    name[3] = "D";
    name[4] = "E";
    name[5] = "F";
    name[6] = "G";
    name[7] = "H";
    name[8] = "J";
    name[9] = "N M L K";
    name[10] = "P";
    name[11] = "Q";
    name[12] = "Maltby";
    name[13] = "Ice Arena";
    name[14] = "Olympic";
    name[15] = "";

    //edmonds lots
    capacity[0] = 163;
    capacity[1] = 130;
    capacity[2] = 139;
    capacity[3] = 285;
    capacity[4] = 228;
    capacity[5] = 21;
    capacity[6] = 66;
    capacity[7] = 67;
    capacity[8] = 47;
    capacity[9] = 159;
    capacity[10] = 301;
    capacity[11] = 132;
    capacity[12] = 69;
    capacity[13] = 120;
    capacity[14] = 52;
    capacity[15] = 0;
    
    //bus drop off
    capacity[16] = 99999;
    capacity[17] = 99999;
    capacity[18] = 99999;
    capacity[19] = 99999;



    //initialize our lots
    for (int i=0; i<20; i++) {
      currentCapacity[i] = capacity[i];
    }
  }

  PVector lookup(PVector building) {
    
    // where is the closest lot?
    shortestDistance = 100000;
    shortlist.clear();
    shortlist.add(0);

    //check the distance between my first building and all of the lots
    for (int i=0; i<15; i++) {
      distance = abs(building.dist(lot[i]));
      if (distance < shortestDistance) {
        shortestDistance = distance;
        shortlist.add(0, i);
      }
    }

    //is the lot full? If so, remove it from our list of candidates.
    Iterator<Integer> it = shortlist.listIterator();    
    while (it.hasNext ()) {
      int testLot = it.next();
      if (currentCapacity[testLot] < 1) {
        it.remove();
      }
    }

    //some people take the bus
    randomNumber = random(0, 1);

    //if there are lots available, and I'm not taking the bus, return the lot I should pick
    if (shortlist.size() > 0 && randomNumber < .85) { //this should be confirmed with a survey of how many people take the bus
      
      //choose one of the lots off my possible list
      int randomLot = int(random(0, shortlist.size()));
      println("randomLot: "+randomLot);
      return lot[shortlist.get(randomLot)];
    } 
    else {
      
      //use a random bus stop
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

    if (shortlist.size() > 0 && randomNumber < .85) {
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
    rect(0, 80, 65, 630);

    fill(255);
    textSize(12);
    textAlign(LEFT);
    text("Parking Lot Use", 10, 75);

    for (int i=0; i<15; i++) {
      fill(255);
      textSize(10);
      int offset = 72 + (38*(i+1));
      
      text(name[i], lot[i].x, lot[i].y);

      int x = int(map(frameCount, 0, 6600, 0, 135)) + 65;
      int y = offset - int(map(currentCapacity[i], 0, capacity[i], 25, 0));
      
      if (currentCapacity[i] < 1){
        stroke(120, 0, 0, 50);
      } else {
        stroke(230, 50);
      }
      
      line(x, offset, x, y);
      text(name[i], 10, offset);      
    }

    int offset = 72 + (38*(15+1));
    int x = int(map(frameCount, 0, 6600, 0, 135)) + 65;
    int busRiders = (99999 - currentCapacity[16]) + (99999 - currentCapacity[17]) + (99999 - currentCapacity[18]) + (99999 - currentCapacity[19]);
    int y = offset - int(map(busRiders, 0, 2000, 0, 25));
    stroke(230, 50);
    line(x, offset, x, y);
    text("Bus", 10, offset); 
  }
}