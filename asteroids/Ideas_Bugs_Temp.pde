/*
  _____                            _     
 |_   _|__ _ __  _ __   __ ___  __| |___ 
   | |/ -_) '  \| '_ \ / _/ _ \/ _` / -_)
   |_|\___|_|_|_| .__/ \__\___/\__,_\___|
                |_|                      
*/



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
