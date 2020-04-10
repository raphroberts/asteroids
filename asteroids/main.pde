//Global variables
PVector location;
PVector velocity;
PVector acceleration;

float rotation = 0; //radians
float maxSpeed = 4;
float accelerationThrust = 0.1;

boolean[] keyDown = new boolean[4];

public void settings() {
  size(800, 800);
}

void setup() {
  acceleration = new PVector(0, 0);
  acceleration.limit(0.1);
  velocity = new PVector(0, 0);
  location = new PVector(30, 30);
  
  //for rect transforms, set the point of origin within the middle instead of the top left
  rectMode(CENTER); 
}

void draw() {
  background(30);
  
  IPlayerShipController(); //ship movement
  IFireWeapon();
}


//Global function
void keyPressed() {
  //IplayerShipController dependency section
  if (key == 'a') {
    keyDown[0] = true;
  }
  if (key == 'd') {
    keyDown[1] = true;
  }
  if (key == 'w') {
    keyDown[2] = true;
  }
  if (key == 's') {
    keyDown[3] = true;
  }
  //End IPlayerShipController dependency section
}

//Global function
void keyReleased() {
  //IplayerShipController dependency section
  if (key == 'a') {
    keyDown[0] = false;
  }
  if (key == 'd') {
    keyDown[1] = false;
  }
  if (key == 'w') {
    keyDown[2] = false;
  }
  if (key == 's') {
    keyDown[3] = false;
  }
  //End IPlayerShipController dependency section
}
