// FUNCTIONS AND GLOBALS THAT ARE USED ACROSS SCREENS

// Game font globals
PFont gameFont;
final int gameTextSizeMain = 16;
final int mainFontColour = 255;

// Animated image initial sizes
float alertBanner = 250;
float LevelUpBanner = 780;
float levelUpStar = 100;
float titleBannerX = 530;
float titleBannerY = 80;

/*
  ___                    _                 _ _ _           
 / __| __ ___ ___ _ _   | |_  __ _ _ _  __| | (_)_ _  __ _ 
 \__ \/ _/ -_) -_) ' \  | ' \/ _` | ' \/ _` | | | ' \/ _` |
 |___/\__\___\___|_||_| |_||_\__,_|_||_\__,_|_|_|_||_\__, |
   
*/
 
String currentScreen = "title";

// The background images in the game
PImage[] backgroundImage = new PImage[4];

void stopAllSounds() {
  // Stops all current SFX and music
  
  for (int i = 0; i < soundArray.length; i++) {
    try {
      soundArray[i].pause();
    }
    catch (NullPointerException e) {}
  }
  for (int i = 0; i < musicArray.length; i++) {
    try {
      musicArray[i].pause();
    }
    catch (NullPointerException e) {}
  }
}

void screenHandler() {
  // Main function to change between screens of the game
  
  switch(currentScreen) {

  case "title": 
    // Display title screen
    titleScreen();
    break;

  case "game": 
    if (!gamePaused) {
      // Display game screen
      
      background(backgroundImage[1]);
  
      // Render the starfield
      renderStars();
      
      // If rapidFire enabled and standard gun selected, shoot a bullet
      if ( rapidFireUpgradeEnabled && frameCount % 5 > 3 && !levelComplete && weaponIndex == 1){
        createBullet();
      }
  
      // Update and draw the bullets
      drawAndMoveBullets();
      
      // Update and draw the ship
      moveShip();
      
      // Update and move enemies
      drawAndMoveEnemies();
      
      // Check for collisions
      checkCollision();
      rechargeShield();
      
      // Render explosion if an asteroid was hit
      renderExplosion();
      
      // Render the UI and overlays
      UIManager();

    }
    else{
      // Let player know that game is paused
      fill(0,100);
      rect(width/2, height/2, width/2,height/8);
      fill(255);
      text("Game paused, press P to continue",width/2,height/2);
    }
      
    break;

  case "level up": 
    // Display the upgrade screen
    
    // Shield replenishes between levels
    shieldHP = maxShieldHP;
    
    // Reset ship and sprite data
    initialiseSprites();
    
    // Continue to the next level if player is finished, otherwise display the upgrades
    if (continueLevel) {
      continueLevel = false;
      levelComplete = false;  
      gameLevel = gameLevel + 1;
      currentScreen = "game";
      thread("levelSequence");
    }
    else{
      upgradeScreen();
    }
    break;
  
  case "game over": 
    // Display the game over screen
    
    gameOverScreen();
    break;
  }
}

/*

  ___          _       __              _   _             
 | _ ) __ _ __(_)__   / _|_  _ _ _  __| |_(_)___ _ _  ___
 | _ \/ _` (_-< / _| |  _| || | ' \/ _|  _| / _ \ ' \(_-<
 |___/\__,_/__/_\__| |_|  \_,_|_||_\__|\__|_\___/_||_/__/
 
*/
    
// Current sizes and scaling status for "pulsing" graphic animations
// Note: Each animated graphic uses a unique index from these arrays
// 0, 1 = title screen banner, 2 = alert banner, 3 = level up banner, 4 = level up star, 5 = upgrade screen arrow, 6 = upgrade screen icon
float[] currentSize = { titleBannerX, titleBannerY, alertBanner, LevelUpBanner, levelUpStar, upgradeArrow, upgradeButtonIcon };
// Track whether images are pulsing up or down
boolean[] scaleDown = { true, true, true, true, true, true, true };

// Starfield data
ArrayList<int[]> starObject = new ArrayList<int[]>(); 
int numberOfStars = 120;


void populateImageArray(PImage[] arrayName, String prefix, int arrayLength){
  // Populates the provided PImage array with images (e.g images/ship1.png, images/ship2.png etc)
  // arrayName = name of the array to populate
  // prefix = url and file name
  // arrayLength = number of images in the array
  
  for (int i=0; i<=arrayLength; i++){
    arrayName[i] = loadImage(prefix + (i+1) + ".png");
  }
}

void generateStars() {
  // Create random starfield data

  for (int i = 1; i <= numberOfStars; i++) {
    //index 0 = x coord, 1 = y coord, 2 = size
    starObject.add(new int[] {randomInt(0, width + screenPadding * 2), randomInt(0, height + screenPadding * 2), randomInt(3, 4)});
  }
}

void renderStars() {
  // Render starfield to screen with parralax effect relative to ship location

  for (int i = 0; i < starObject.size(); i++) {
    //Retrieve the X,Y coordinates of the current star
    int[] obj = starObject.get(i);
    PVector starLocation = new PVector(obj[0], obj[1]); 
    strokeWeight(obj[2]);

    // Larger stars are brighter and move faster than others
    if (obj[2] < 4) {
      stroke(randomInt(70, 120));
      point(starLocation.x, starLocation.y - shipLocation.y);
      point(starLocation.x, starLocation.y - shipLocation.y - (height + (screenPadding*2)));
      point(starLocation.x, starLocation.y - shipLocation.y + (height + (screenPadding*2)));
    } else {
      stroke(randomInt(100, 190));
      if ((starLocation.y - shipLocation.y) < height / 2) {
        point(starLocation.x, (starLocation.y - shipLocation.y) * 2);
        point(starLocation.x, ((starLocation.y - shipLocation.y) * 2) - (height*2)+ (screenPadding*4));
        point(starLocation.x, ((starLocation.y - shipLocation.y) * 2) + (height*2)+ (screenPadding*4));
      }
    }
  }
}


int randomInt(int low, int high) {
  // Returns a random integer
  
  return (int)round(random(low, high));
}

void mouseReleased() { 
  // Generic function for all mouseReleased events
  
  mouseDown = false;
}

float pulseImage(int maxSize, int minSize, float speed, int scaleIndex, boolean noBounce) {
  // Calculate scale data for 'pulsing' image animations
  // maxSiz / minSize = max/min scale limits
  // Speed = animation speed
  // scaleIndex = index of currentSize[] and scaleUp[] arrays to fetch & set
  // noBounce = whether to loop the animation
  // Returns a scale factor

  // Determine scale direction for given scaleIndex
  if (currentSize[scaleIndex] >= maxSize) {
    if (noBounce){
      return currentSize[scaleIndex];
    }
    scaleDown[scaleIndex] = false;
  } else if (currentSize[scaleIndex] <= minSize) {
    if (noBounce){
      return currentSize[scaleIndex];
    }
    scaleDown[scaleIndex] = true;
  }  

  if (scaleDown[scaleIndex]) {
    currentSize[scaleIndex] += speed;
  } else {
    currentSize[scaleIndex] -= speed;
  }

  return(currentSize[scaleIndex]);
}



/*
  __  __         _      ___ _____  __
 |  \/  |_  _ __(_)__  / __| __\ \/ /
 | |\/| | || (_-< / _| \__ \ _| >  < 
 |_|  |_|\_,_/__/_\__| |___/_| /_/\_\
     
*/

// Libraries
import ddf.minim.*;
Minim minim;

// State tracking and config
boolean preloadingFinished = false;
int playingIndex = 0;
int shieldSoundIndex;
boolean shieldWarningTriggered = false;
int bulletshotIndex = 0;
int laserShotIndex = 10;
int shieldSoundEndDelay = 10;
int shieldSoundTick = 0;
boolean endingShieldSound = false;

// SFX and Music arrays
AudioPlayer[] musicArray = new AudioPlayer[10];
AudioPlayer[] soundArray = new AudioPlayer[30];

void preloading() { 
  // Loads music and SFX asynchronously, plays title music
  
  musicArray[0] = minim.loadFile("music/title.mp3");

  if (currentScreen == "title")
    musicManager("title");
    
  //Preload game sfx
  soundArray[0] = minim.loadFile("sounds/laserfire01.mp3"); //bullet 1
  soundArray[1] = minim.loadFile("sounds/laserfire01.mp3"); //bullet 1
  soundArray[2] = minim.loadFile("sounds/laserfire01.mp3"); //bullet 1
  soundArray[3] = minim.loadFile("sounds/burstfire.mp3"); //bullet 2
  soundArray[4] = minim.loadFile("sounds/laserfire02.mp3"); //bullet 3
  soundArray[5] = minim.loadFile("sounds/shield.mp3"); //shield activation
  soundArray[5].loop();
  soundArray[5].pause();
  shieldSoundIndex = 5;
  soundArray[6] = minim.loadFile("sounds/alarm.mp3");
  soundArray[7] = minim.loadFile("sounds/warningShield.mp3");
  soundArray[8] = minim.loadFile("sounds/attentionLifeform.mp3");
  soundArray[9] = minim.loadFile("sounds/eliminated.mp3");
  soundArray[10] = minim.loadFile("sounds/laserbeam.mp3");
  soundArray[11] = minim.loadFile("sounds/laserbeam.mp3");
  soundArray[12] = minim.loadFile("sounds/laserbeam.mp3");
  soundArray[13] = minim.loadFile("sounds/thruster.mp3");
  soundArray[14] = minim.loadFile("sounds/smallRockDestroy.wav");
  soundArray[15] = minim.loadFile("sounds/smallRockDestroy.wav");
  soundArray[16] = minim.loadFile("sounds/smallRockDestroy.wav");
  soundArray[17] = minim.loadFile("sounds/largeRockDestroy.wav");
  soundArray[18] = minim.loadFile("sounds/largeRockDestroy.wav");
  soundArray[19] = minim.loadFile("sounds/largeRockDestroy.wav");
  soundArray[20] = minim.loadFile("sounds/prespeech.mp3");
  soundArray[21] = minim.loadFile("sounds/bosslaugh.wav");
  
  soundArray[13].setGain(-20);
  soundArray[14].setGain(-10);
  soundArray[15].setGain(-10);
  soundArray[16].setGain(-10);
  soundArray[17].setGain(-1);
  soundArray[18].setGain(-1);
  soundArray[19].setGain(-1);
  
  preloadingFinished = true;
 
  // Load music tracks into an array
  musicArray[1] = minim.loadFile("music/s2.mp3");
  musicArray[2] = minim.loadFile("music/ThrustSequence.mp3");
  musicArray[3] = minim.loadFile("music/victorytheme.mp3");
  musicArray[4] = minim.loadFile("music/upgradeTheme.mp3");
  musicArray[5] = minim.loadFile("music/level1.mp3");
  musicArray[6] = minim.loadFile("music/trueepic.mp3");
  musicArray[7] = minim.loadFile("music/modulo4.mp3");
  musicArray[8] = minim.loadFile("music/boss1.mp3");
  musicArray[9] = minim.loadFile("music/boss2.mp3");
}

void fadeInSongCoroutine(String startSongString) {
  // Fade out current song, then fade in the given song
  // Must be called as a coroutine/async thread only
  
  musicArray[playingIndex].shiftGain(musicArray[playingIndex].getGain(),-80, 5000);
  delay(2500);
  musicManager("none");
  musicManager(startSongString);
}

void musicManager(String song) {
  // Handles and plays game music
  
  // Stop any playing songs to prevent overlap
  stopAllSongs();
  
  // Fade songs in and out
  
  switch (song) {
    case "none":
      // Stop any song that is currently playing
      if (musicArray[playingIndex].isPlaying()) {
        musicArray[playingIndex].pause();
      }
      break;
    case "title":
      // Play title theme STEVE might be good to list what each of these songs are?
      try {
        musicArray[0].rewind();
        musicArray[0].loop();
        musicArray[0].skip(15000);
        playingIndex = 0;
      }
      catch (NullPointerException e) {
        println("Song not yet loaded..");
      }
      break;
    case "epic":
      try {
        musicArray[1].rewind();
        musicArray[1].loop();
        musicArray[1].shiftGain(-50,-5, 5000);
        playingIndex = 1;
      }
      catch (NullPointerException e) {
        println("Song not yet loaded..");
      }
      break;
    case "thrust":
      try {
       musicArray[2].rewind(); 
       musicArray[2].loop();
       musicArray[2].shiftGain(-50,-10, 5000);
       playingIndex = 2;
     }
     catch (NullPointerException e) {
       println("Song not yet loaded..");
     }
     break;
     case "victory":
       try {
         musicArray[3].rewind();
         musicArray[3].loop();
         musicArray[3].shiftGain(-50,-10, 5000);
         playingIndex = 3;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
    case "upgrade":
     try {
         musicArray[4].rewind();
         musicArray[4].loop();
         musicArray[4].shiftGain(-50,-10, 5000);
         playingIndex = 4;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
   case "level1":
     try {
         musicArray[5].rewind();
         musicArray[5].play();
         musicArray[5].shiftGain(-50, -3, 5000); //out gain is -50, in gain is -1
         playingIndex = 5;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
  case "trueepic": 
     try {
         musicArray[6].rewind();
         musicArray[6].loop();
         musicArray[6].shiftGain(-50, -10, 5000); //out gain is -50, in gain is -1
         playingIndex = 6;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
   case "modulo4": 
     try {
         musicArray[7].rewind();
         musicArray[7].loop();
         musicArray[7].shiftGain(-50, -3, 5000); //out gain is -50, in gain is -1
         playingIndex = 7;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
    case "boss1": 
     try {
         musicArray[8].rewind();
         musicArray[8].loop();
         musicArray[8].shiftGain(-50, -3, 5000); //out gain is -50, in gain is -1
         playingIndex = 8;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
     case "boss2": // Short teaser song for level 1
     try {
         musicArray[9].rewind();
         musicArray[9].loop();
         musicArray[9].shiftGain(-50, -3, 5000); //out gain is -50, in gain is -1
         playingIndex = 9;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;  
  }
}

void stopAllSongs() {
  // Stops music tracks from playing
  
  for (int i = 0; i < musicArray.length; i++) {
    try {
      if (musicArray[i].isPlaying()) {
        musicArray[i].pause();  
      }
    }
    catch (NullPointerException e) {
      //We can catch a NullPointerException here since it will only occur for an unloaded async sound file STEVE, add catch code or just remove?
    }
  }
}

void shieldCriticalSoundSequence() {
  // Plays sound to alert player that shields are low
  // Note: only call this function asynchronously
  
  soundArray[6].rewind();
  soundArray[6].setGain(-5);
  soundArray[6].play();
  delay(1000);
  soundArray[7].rewind();
  soundArray[7].play();
}

void attentionLifeformSoundSequence() {
  
  // Boss spawn ('attention, unknown lifeform identified')
  soundArray[6].rewind();
  soundArray[6].setGain(-5);
  soundArray[6].play();
  delay(1000);
  soundArray[6].rewind();
  soundArray[6].setGain(-5);
  soundArray[6].play();
  delay(1000);
  soundArray[8].rewind();
  soundArray[8].play();
  
}


/*

   ___         _           _    
  / __|___ _ _| |_ _ _ ___| |___
 | (__/ _ \ ' \  _| '_/ _ \ (_-<
  \___\___/_||_\__|_| \___/_/__/
                             
*/

// KEYBOARD INPUT

void keyPressed() {
  if (key == 'a') {
    rotateLeft = true;
  }
  if (key == 'd') {
    rotateRight = true;
  }
  if (key == 'w') {
    accelerate = true;
  }
  
  if (key == ' ') {
    createBullet();
    // If standard gun has rapid fire, reload it automatically
   if (rapidFireUpgradeEnabled && weaponIndex == 1){
      gunReloaded = true;
    }
    else {
      gunReloaded = false;
    }
  }
  
  //Change weapon
  if (key == '1') {
    // Standard weapon
    changeWeapon(1);
    shipImageIndex = 0;
  }
  if (key == '2' && tripleLaserUpgradeEnabled) {
    // Triple fire
    changeWeapon(2);
    shipImageIndex = 1;
  }
  if (key == '3' && magnusEnforcedUpgradeEnabled) {
    // Recharging weapon
    changeWeapon(3);
    shipImageIndex = 2;
  }
  
  if (key == 'p') {
    if (!gameStarted) {
        score = 0;
        // Wait for preloading to finish before starting game
        while (!preloadingFinished) 
        delay(100);
      
      // Reset ship and boss data
      initialiseSprites();
      
      // Generate the starfield
      generateStars();
      
      // Handle level status
      thread("levelSequence");
      
      // Update states and change to game screen
      gameStarted = true;
      resetReady = false;
      currentScreen = "game";
    }
    else if (!gamePaused) {
      gamePaused = true;
    }
    else {
      gamePaused = false;
    }
  }

  // debug keys
  if (key == 'c' && debug) {
    createAsteroid(0, 0, "large");
  }
  if (key == 'n' && debug) { //temp for testing songs, delete in production STEVE REMOVE?
    if (playingIndex == 0)
      musicManager("thrust");
    else if (playingIndex == 1)
      musicManager("thrust");
    else if (playingIndex == 2)
      musicManager("epic");
  }
  if (key == 'b' && debug) { //temp, cycle and equip through diff shields, weapons. Normally this should only be possible at level up screen STEVE remove?
    if (shieldIndex == 1)
      changeShield(2);
    else if (shieldIndex == 2 && thrusterIndex == 1)
      changeThruster(2);
    else
      {
        changeShield(1);
        changeThruster(1);
      }
  }
}

void keyReleased() {

  if (key == 'a') {
    rotateLeft = false;
  }
  if (key == 'd') {
    rotateRight = false;
  }
  if (key == 'w') {
    accelerate = false;
  }
  if (key == ' ') {
   // check for rapidfire upgrade (rapidfire only available on standard gun)
   if (rapidFireUpgradeEnabled && weaponIndex == 1){
      gunReloaded = false;
    }
    else {
      gunReloaded = true;
    }
  }

}
