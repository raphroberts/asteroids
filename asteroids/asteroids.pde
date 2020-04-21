// FUNCTIONS AND GLOBALS THAT RELATE TO GAME SETUP AND THE GAME LOOP

/* 
    _   ___ _____ ___ ___  ___ ___ ___  ___ 
   /_\ / __|_   _| __| _ \/ _ \_ _|   \/ __|
  / _ \\__ \ | | | _||   / (_) | || |) \__ \
 /_/ \_\___/ |_| |___|_|_\\___/___|___/|___/
 
 An implementation of the traditional Asteroids game
 Note: Requires processing sound library to be installed
 
 DEV NOTES:
 - Globals/Functions are stored inside the file representing the screen they relate to
 - Globals/Functions that are used across screens sit in "ReusableFunctions.PDE"
 - Globals are stored under the large (ASCII art) headings they relate to
 - minim library used for sounds, found here: http://code.compartmental.net/tools/minim/ 
 - Can be installed directly via Sketch > Imporant Library > Add Library > Minim
 - This library approved for assignment according to COSC 101 stack Unit Coordinator
 
 KNOWN ISSUES:
 Ship fires when game screen loads
 
*/

// Debug switch (renders var information when enabled)
boolean debug = true; //print stats to console for debugging purposes

// SETTINGS

void settings() {
  size(800, 500);
}

// SETUP

void setup() {
  
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  
  // loadFile will look in all the same places as loadImage does.
  // this means you can find files that are in the data folder and the 
  // sketch folder. you can also pass an absolute path, or a URL.
     
  // Title screen setup
  titleSetup();
  
  //General
  frameRate(60);  
  rectMode(CENTER); 
  imageMode(CENTER); 
  
  //Ship setup
  shipAcceleration = new PVector(0, 0);
  shipAcceleration.limit(0.1);
  shipVelocity = new PVector(0, 0);
  shipLocation = new PVector(width/2, height/2);

  initialiseShip(); // set/reset ship properties
  shipGraphic[0] = requestImage("images/ship_float.png");
  shipGraphic[1] = requestImage("images/ship_thrust.png");
  shipGraphic[2] = requestImage("images/ship_shield.png");

  //Bullet setup
  bulletLocation = new PVector(230, 230);
  
  //Asteroid setup
  enemyGraphics[0] = requestImage("images/asteroid_lg_1.png");
  enemyGraphics[1] = requestImage("images/asteroid_lg_2.png");
  enemyGraphics[2] = requestImage("images/asteroid_lg_3.png");
  enemyGraphics[3] = requestImage("images/asteroid_sm_1.png");
  enemyGraphics[4] = requestImage("images/asteroid_sm_2.png");
  enemyGraphics[5] = requestImage("images/asteroid_sm_3.png");
  
  iconsUI[0] = requestImage("images/dummygun.png");
 
  //preload assets async
  thread("preloading");
  
  //Screen setup
  backgroundImage[0] = loadImage("images/title_screen.png");
  backgroundImage[1] = requestImage("images/game_screen.png");
  backgroundImage[2] = requestImage("images/upgrade_screen.png");
  
  // Font and text defaults
  textSize(26);
  
  // generate smoke animation image array
  generateSmoke();
  
  // Initialize stats
  changeWeapon(1);

  //temp
  //createAsteroid(450, 450, "large");
  //createAsteroid(750, 350, "large");
  //createAsteroid(750, 350, "small");
  
}

void generateSmoke(){
    // Generates smokeAnimFrames array used for smoke animation
       
    for (int i = 0; i < numSmokeFrames; i++){
      smokeAnimFrameArray[i] = loadImage("images/smoke_frames/smoke_" + i + ".png");
    }
}


// GAME LOOP

void draw() {

  // handle game screen to display 
  // (located in ReusableFunctions.PDE)
  
  screenHandler(); 

}
