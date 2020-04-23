/*
  _____                            _     
 |_   _|__ _ __  _ __   __ ___  __| |___ 
   | |/ -_) '  \| '_ \ / _/ _ \/ _` / -_)
   |_|\___|_|_|_| .__/ \__\___/\__,_\___|
                |_|                      
*/

  // Boss PVectors
  PVector bossLocation;
  PVector bossBladeRotation = new PVector(10,10); 
  
  // Boss graphics
  PImage[] bossGraphic = new PImage[2]; // ship image array
  int bossGraphicIndex = 0;
  PImage[] bossBladeGraphic = new PImage[2]; // ship image array
  int bossBladeGraphicIndex = 0;
  
    // Animation data
  float bossBladeAngle;
  
  // Movement data
  PVector target;
  float bossSpeed = .3;
  
  // Positioning data
  int bossBladeOffsetY = 30;


void spawnBoss(){
  // Spawns the boss
  //get vector pointing from ship to Boss
  PVector target = PVector.sub (shipLocation,bossLocation);
  
  // normalize to a unit vector in which each component is [0..1]
  target.normalize();

  // multiply target vector by speed to get vector from [0..speed]
  target.mult (bossSpeed);
  
  // Move the boss vector towards the ship
  bossLocation.add (target);
  
  // draw the ship
  println(bossLocation.x);
  println(bossLocation.y);
  
  bossBladeAngle = bossBladeAngle + 4;
  
  translate(bossLocation.x, bossLocation.y + bossBladeOffsetY);
  rotate( radians(bossBladeAngle) );
  image(bossBladeGraphic[bossBladeGraphicIndex], 0, 0);
  rotate(- radians(bossBladeAngle));
  translate(- bossLocation.x, - bossLocation.y - bossBladeOffsetY);
  image(bossGraphic[bossGraphicIndex], bossLocation.x, bossLocation.y);
  
  
}

/*
  ___    _             
 |_ _|__| |___ __ _ ___
  | |/ _` / -_) _` (_-<
 |___\__,_\___\__,_/__/
  
  - Ship 'helper' upgrade that gravitates towards main ship (never gets closer than X pixels) and shoots in random directions (upgradeable also?)
  - Ship upgrades as animated graphics that are overlayed over the ship (e.g selecting a bigger gun upgrade results in change to ships appearance)
  - Continuous vs single-use upgrades (e.g ship speed upgrade could let you go faster and faster, but cannon upgrade is only selected once)
  - Represent shield as a horizontal bar, rendered as a series of rectangles that fade from blue (full shield) to red (low shield)
  - Explosion SFX (perhaps a few so explosion sounds are less monotonous)
  - Different bullets have different rendering style
  - Use images for bullets (a bit more processor hungry)
  
  ___              
 | _ )_  _ __ _ ___
 | _ \ || / _` (_-<
 |___/\_,_\__, /__/
          |___/    

  - Pressing p while in-game creates more stars
  - Pressing space while on title screen plays shooting sound  
  - Looping audio on title screen pops and pauses strangely (find audio that loops well or fix existing?)
  - Explosion animation plays top-left when game starts
  _____ ___  ___   ___  
 |_   _/ _ \|   \ / _ \ 
   | || (_) | |) | (_) |
   |_| \___/|___/ \___/ 
   
   - Spawn asteroids at random location, ensuring they are not too close to the ship
   - Tidy up HUD
   - Proceeding to the upgrade screen (when asteroid count = 0?)
   - Proceeding from the upgrade screen
   - Initial level handling (increase asteroid count or speed per level?)
   - Replaying after game over (reset variables to default & play again - call from titleScreen(); ?)
   - Bug seeking & documenting bugs in one shared place
   - Refine music + SFX
   - Add medium sized asteroids
   - Mouse based interactions (Elizabeth?)
   - Animate title screen (raph planned)

*/
