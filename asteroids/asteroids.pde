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
 
*/

// Debug switch (renders var information when enabled)
boolean debug = true; //print stats to console for debugging purposes

// SETTINGS

void settings() {
  size(800, 500);
}

// SETUP
  
void setup() {
  
  // Audio setup
  minim = new Minim(this);
     
  // Title screen setup
  titleSetup();
  
  //General
  frameRate(60);  
  rectMode(CENTER); 
  imageMode(CENTER);
  textSize(26);
  
  //Ship setup
  shipAcceleration = new PVector(0, 0);
  shipAcceleration.limit(0.1);
  shipVelocity = new PVector(0, 0);
  shipLocation = new PVector(width/2, height/2);
  
  // Image arrays setup
  populateImageArray(shipGraphic, "images/ship/ship_main_", 2); // Ship with weapons
  populateImageArray(thrusterGraphic, "images/ship/thruster_", 2); // Ship thruster
  populateImageArray(shieldGraphic, "images/ship/ship_shield", 2); // Ship shield
  populateImageArray(enemyGraphics, "images/asteroids/asteroid_", 5); // Asteroids
  populateImageArray(bossGraphic, "images/boss/boss_main", 3); // Boss main
  populateImageArray(bossBladeGraphic, "images/boss/boss_blade", 1); // Boss blade
  populateImageArray(iconsUI, "images/icons/icon_", 10); // Icons for game and upgrade screen UI
  populateImageArray(levelStatusImage, "images/level_status/status_", 2); // Game status graphics
  populateImageArray(upgradeScreenImage, "images/upgradeUI/upgrade_screen_", 2); // upgrade screen UI
  populateImageArray(backgroundImage, "images/backgrounds/background_", 2); // background images
  populateImageArray(titleShip, "images/titleScreenUI/title_", 1); // title screen ship
 
  //preload assets async
  thread("preloading");
  
  // generate smoke animation image array
  generateSmoke();

  // Main game font
  gameFont = createFont("data/Rajdhani-Medium.ttf", gameTextSizeMain);
  textFont(gameFont); 
  
  // Custom mouse cursor (upgrade screen)
  cursor = loadImage("images/cursor.png");
  
  // Set up initial sprite properties
  initialiseSprites();
}

// GAME LOOP

void draw() {

  // handle game screen to display 
  // (located in ReusableFunctions.PDE)
  
  screenHandler(); 

}
