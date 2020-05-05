/*
  _____                            _     
 |_   _|__ _ __  _ __   __ ___  __| |___ 
   | |/ -_) '  \| '_ \ / _/ _ \/ _` / -_)
   |_|\___|_|_|_| .__/ \__\___/\__,_\___|
                |_|                      
*/

void resetGame() {
  stopAllSounds();
  
  // Re-initialise ship and boss 'start of level' state
  initialiseSprites();
  
  // Empty enemy asteroid array
  enemyObject = new ArrayList<int[]>(); 
  
  // Reset game states
  levelComplete = true;
  bossActivated = false;
  continueLevel = false;
  levelComplete = false; 
  gameStarted = false;
  
  // Rebuild icon image array
  populateImageArray(iconsUI, "images/icons/icon_", 10);
  
  // Reset shield and thruster
  changeThruster(1);
  changeShield(1);
  
  // Reset upgrades
  tripleLaserUpgradeEnabled = false;
  magnusEnforcedUpgradeEnabled = false;
  MK2ShieldUpgradeEnabled = false;
  thrusterUpgradeEnabled = false;
  rapidFireUpgradeEnabled = false;
  upGradeActive = new boolean[]{ false, false, false, false, false };
  
  // Empty star field and reset title screen
  starObject = new ArrayList<int[]>(); 
  titleSetup();
      
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
