// UNALLOCATED - allocate somewhere as seen fit
ArrayList<int[]> enemyObject = new ArrayList<int[]>(); 
//index 0 = object ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = HP (>=0 if relevant, else -1), 7 = points given upon destruction
/*
object ID as follows. This must match the enemyGraphics ID:
0 = large asteroid ID 1
1 = large asteroid ID 2
2 = large asteroid ID 3
3 = small asteroid ID 1
4 = small asteroid ID 2
5 = small asteroid ID 3
*/

PImage[] enemyGraphics = new PImage[6]; //index should correspond to enemyObject ID

//END UNALLOCATED - Allocate everything here in a nicer location

void steveSetupTemp() {
  enemyGraphics[0] = loadImage("images/asteroid_lg_1.png");
  enemyGraphics[1] = loadImage("images/asteroid_lg_2.png");
  enemyGraphics[2] = loadImage("images/asteroid_lg_3.png");
  enemyGraphics[3] = loadImage("images/asteroid_sm_1.png");
  enemyGraphics[4] = loadImage("images/asteroid_sm_2.png");
  enemyGraphics[5] = loadImage("images/asteroid_sm_3.png");
  
  createAsteroid(250, 150, "large");
  createAsteroid(150, 150, "large");
  createAsteroid(150, 150, "large");
}

void steveDrawTemp() {
  if (currentScreen == "game") {
    drawAndMoveEnemies();
    asteroidHandlerTemp();
  }
}




//Add to Sprites?
void createAsteroid(int x, int y, String size) {
  //create an asteroid at the given x, y coords, with size = "large" or "small"
  
  switch (size) {
    case "large":
      //pick random asteroid from ID 0-2
      int ID = randomInt(0, 2);
      PVector initialVelocity = new PVector(randomInt(-4, 4), randomInt(-4,4));
      
      //index 0 = object ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = HP (>=0 if relevant, else -1), 7 = 10 (points given)
      enemyObject.add(new int[] {ID, x, y, enemyGraphics[ID].width, (int)initialVelocity.x, (int)initialVelocity.y, 1, 10}); 
  }
}

void drawAndMoveEnemies() {
  //iterate through all enemyObjects and draw them, also move them
  for (int i = 0; i < enemyObject.size(); i++) {
    int[] obj = enemyObject.get(i);
    PVector objCoords = new PVector(obj[1], obj[2]);
    PVector objVelocity = new PVector(obj[4], obj[5]);
    
    //draw
    image(enemyGraphics[i], objCoords.x, objCoords.y);
    
    //move
    obj[1] = obj[1] + (int)objVelocity.x; //move in x direction given the object velocity
    obj[2] = obj[2] + (int)objVelocity.y; //move in y direction given the object velocity 
    
    //Screen overlap check
    if (obj[1] > width){
      obj[1] = 0;
    }
    if (obj[2] > height){
      obj[2] = 0;
    }
    if (obj[1] < 0){
      obj[1] = width;
    }
    if (obj[2] < 0){
      obj[2] = height;
    }
    
  }
        
}

boolean checkBulletCollisions(PVector location, int hitboxSize) {
  //This function returns True if a bullet exists within the given location and hitboxSize, otherwise False
  //this is an ineffective O(n^2) implementation, but the alternative I can think of (doing grid based checks), would be a gigantic undertaking, I think.
  //I believe the number of enemyObjects will be small enough that this ineffecient implementation will be unnoticeable, but stress testing required to find out
  for (int i = 0; i < bulletLocations.length; i++) {
    //bulletLocations[i]
  }
  return false; //temp
}


//Add to asteroid handler?
void asteroidHandlerTemp() {
  
}

void damageShip(int amount) {
  //Whenever the ship receives some damage "amount", it is handled via this function
}

//Add to ReusableFunctions?
int randomInt(int low, int high) {
  return (int)round(random(0, 2));
}
