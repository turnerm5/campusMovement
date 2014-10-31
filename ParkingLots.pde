//Copyright 2014 - Marshall Turner
//schacht aslani architects
//All rights reserved.

class ParkingLots {

  PVector[] lot;
  ArrayList<Integer> shortlist;

  PVector building;

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


    //This should be optimized to have a table, instead of hard-coded values
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


    //edmonds lots
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
    for (int i=0; i<16; i++) {
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
    if (shortlist.size() > 0 && randomNumber < .65) { //this should be confirmed with a survey of how many people take the bus
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

    if (shortlist.size() > 0 && randomNumber < .65) {
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
    textSize(12);
    textAlign(LEFT);
    text("Parking Lot Capacity", 10, 75);

    for (int i=0; i<16; i++) {
      fill(255);
      textSize(12);
      textAlign(LEFT);
      text("Lot " + (i+1) + ": " + currentCapacity[i], 10, 75 + (16*(i+1)));
      
    }
      text("Not Driving: " + ((99999 - currentCapacity[16]) + (99999 - currentCapacity[17]) + (99999 - currentCapacity[18]) + (99999 - currentCapacity[19])), 10, 350);
  }
}