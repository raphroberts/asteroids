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

  initialiseSprites(); // set/reset sprites
  
  shipGraphic[0] = requestImage("images/ship/ship_main_triple.png");
  shipGraphic[1] = requestImage("images/ship/ship_main_single.png");
  shipGraphic[2] = requestImage("images/ship/ship_main_enforcer.png");
  
  // Thruster setup
  thrusterGraphic[0] = requestImage("images/ship/thruster_1.png");
  thrusterGraphic[1] = requestImage("images/ship/thruster_2.png");
  thrusterGraphic[2] = requestImage("images/ship/thruster_3.png");
  
  // Shield setup
  shieldGraphic[0] = requestImage("images/ship/ship_shield1.png");
  shieldGraphic[1] = requestImage("images/ship/ship_shield2.png");
  shieldGraphic[2] = requestImage("images/ship/ship_shield3.png");

  //Bullet setup
  bulletLocation = new PVector(230, 230);
  
  //Asteroid setup
  enemyGraphics[0] = requestImage("images/asteroid_lg_1.png");
  enemyGraphics[1] = requestImage("images/asteroid_lg_2.png");
  enemyGraphics[2] = requestImage("images/asteroid_lg_3.png");
  enemyGraphics[3] = requestImage("images/asteroid_sm_1.png");
  enemyGraphics[4] = requestImage("images/asteroid_sm_2.png");
  enemyGraphics[5] = requestImage("images/asteroid_sm_3.png");
  
  // Boss setup
  bossGraphic[0] = requestImage("images/boss/boss_main.png");
  bossGraphic[1] = requestImage("images/boss/boss_main2.png");
  bossBladeGraphic[0] = requestImage("images/boss/boss_blade.png");
  bossBladeGraphic[1] = requestImage("images/boss/boss_blade2.png");
  
  // Weapon icons
  iconsUI[0] = requestImage("images/icons/icon_triple.png");
  iconsUI[1] = requestImage("images/icons/icon_single.png");
  iconsUI[2] = requestImage("images/icons/icon_enforcer.png");
  
  // Shield icons
  iconsUI[3] = requestImage("images/icons/icon_shield1.png");
  iconsUI[4] = requestImage("images/icons/icon_shield2.png");
  iconsUI[5] = requestImage("images/icons/icon_shield3.png");
  
  // Thrust icons
  iconsUI[6] = requestImage("images/icons/icon_thrust1.png");
  iconsUI[7] = requestImage("images/icons/icon_thrust2.png");
  iconsUI[8] = requestImage("images/icons/icon_thrust3.png");
  
  // Level status graphics
  levelStatusImage[0] = requestImage("images/level_status/status_1.png");
  levelStatusImage[1] = requestImage("images/level_status/status_2.png");
  levelStatusImage[2] = requestImage("images/level_status/status_3.png");
 
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

  // Main game font
  gameFont = createFont("data/Rajdhani-Medium.ttf", gameTextSizeMain);
  textFont(gameFont); 
  
}


// GAME LOOP

void draw() {

  // handle game screen to display 
  // (located in ReusableFunctions.PDE)
  
  screenHandler(); 

}
