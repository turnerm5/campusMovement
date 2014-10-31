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

  ParkingLots() {

    lot = new ArrayList<PVector>();
    capacity = new ArrayList<Integer>();     
    currentCapacity = new ArrayList<Integer>();
    shortlist = new ArrayList<Integer>();
    name = new ArrayList<String>();

    //This should be optimized to have a table, instead of hard-coded values
    lot.add(0, new PVector(301, 380));
    lot.add(1, new PVector(420, 378));
    lot.add(2, new PVector(429, 314));
    lot.add(3, new PVector(499, 250));
    lot.add(4, new PVector(497, 425));
    lot.add(5, new PVector(465, 428));
    lot.add(6, new PVector(460, 572));
    lot.add(7, new PVector(502, 560));
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

  PVector lookup(PVector building) {
    
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
    if (shortlist.size() > 0 && randomNumber < .75) { //this should be confirmed with a survey of how many people take the bus
      
      //choose one of the lots off my possible list
      int randomLot = int(random(0, shortlist.size()));
      return lot.get(shortlist.get(randomLot));
    } 
    else {
      
      //use a random bus stop
      float random = random(0, 1);
      if (random < .5) {
        return lot.get(16);
      } 
      else if (random < .75) {
        return lot.get(17);
      } 
      else if (random < .85) {
        return lot.get(18);
      } 
      else if (random < 1) {
        return lot.get(19);
      } else {
        return lot.get(16); 
      }
    }
  }

  int indexLookup(PVector building) {

    if (shortlist.size() > 0 && randomNumber < .75) {
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
    currentCapacity.set(lot, currentCapacity.get(lot) - 1);
  }

  void addParking(int lot) {
    currentCapacity.set(lot, currentCapacity.get(lot) + 1);
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
      
      text(name.get(i), lot.get(i).x, lot.get(i).y);

      int x = int(map(frameCount, 0, 6600, 0, 135)) + 65;
      int y = offset - int(map(currentCapacity.get(i), 0, capacity.get(i), 25, 0));
      
      if (currentCapacity.get(i) < 1){
        stroke(120, 0, 0, 50);
      } else {
        stroke(230, 50);
      }
      
      line(x, offset, x, y);
      text(name.get(i), 10, offset);      
    }

    int offset = 72 + (38*(15+1));
    int x = int(map(frameCount, 0, 6600, 0, 135)) + 65;
    int busRiders = (99999 - currentCapacity.get(16)) + (99999 - currentCapacity.get(17)) + (99999 - currentCapacity.get(18)) + (99999 - currentCapacity.get(19));
    int y = offset - int(map(busRiders, 0, 2000, 0, 25));
    stroke(230, 50);
    line(x, offset, x, y);
    text("Bus", 10, offset); 
  }
}