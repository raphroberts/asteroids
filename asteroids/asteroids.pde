/* 
    _   ___ _____ ___ ___  ___ ___ ___  ___ 
   /_\ / __|_   _| __| _ \/ _ \_ _|   \/ __|
  / _ \\__ \ | | | _||   / (_) | || |) \__ \
 /_/ \_\___/ |_| |___|_|_\\___/___|___/|___/
 
 An Asteroids game clone made with processing 3.5.4
 Overview of the game: https://youtu.be/UPa-HIOGEtU
 
 DEV NOTES:
 - Globals are stored under the large (ASCII art) headings they relate to
 - Requires minim library for sounds and music
 - Minim can be installed directly via Sketch > Imporant Library 
 - (This library approved for assignment)
 
 AUTHORS:
   Raph Roberts
   Steven Buchanan
   
 FEATURES:
   Game features: Ship upgrades, boss fights, level system, parralax starfields
   Graphics made in Blender & Illustrator. All sounds are royalty free.

*/

// Debug switch to assist testing (currently this reduces asteroid count)
boolean debug = false;

// FUNCTIONS AND GLOBALS THAT RELATE TO GAME SETUP AND THE GAME LOOP

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
  
  // General
  frameRate(60);  
  rectMode(CENTER); 
  imageMode(CENTER);
  textSize(26);
  
  // Ship setup
  shipAcceleration = new PVector(0, 0);
  shipAcceleration.limit(0.1);
  shipVelocity = new PVector(0, 0);
  shipLocation = new PVector(width/2, height/2);
  
  // Image arrays setup..
  
  // Ship with weapons
  populateImageArray(shipGraphic, "images/ship/ship_main_", 2);
  
  // Ship thruster
  populateImageArray(thrusterGraphic, "images/ship/thruster_", 2); 
  
  // Ship shield
  populateImageArray(shieldGraphic, "images/ship/ship_shield", 2); 
  
  // Asteroids
  populateImageArray(enemyGraphics, "images/asteroids/asteroid_", 5); 
  
  // Boss main
  populateImageArray(bossGraphic, "images/boss/boss_main", 3); 
  
  // Boss blade
  populateImageArray(bossBladeGraphic, "images/boss/boss_blade", 1);
  
  // Icons for game and upgrade screen UI
  populateImageArray(iconsUI, "images/icons/icon_", 10); 
  
  // Game status graphics
  populateImageArray(levelStatusImage, "images/level_status/status_", 2);
  
  // upgrade screen UI
  populateImageArray(upgradeScreenImage, "images/upgradeUI/upgrade_screen_", 2);
  
  // background images
  populateImageArray(backgroundImage, "images/backgrounds/background_", 2); 
  
  // title screen ship
  populateImageArray(titleShip, "images/titleScreenUI/title_", 1); 
 
  // Preload assets async
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
  screenHandler(); 

}
