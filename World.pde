class World {
  static final float HEIGHT_MIN = 100;
  static final float HEIGHT_MAX = 300;
  
  static final float START_SPEED = 3.0;
  static final float ACCEL = 0.01;
  static final float START_GAP = 128;
  
  //Allocate the linked list that will store three current platforms
  private LinkedList<Platform> curPlatforms;
  
  //The speed we are going in pixels per frame and the X coord to add new platforms at
  private float speed, addX, diffCoef, gap;
  
  World(float initHeight, float diffCoef) {
    speed = START_SPEED;
    addX = 0;
    this.diffCoef = diffCoef;
    gap = START_GAP;
    
    curPlatforms = new LinkedList<Platform>();
    
    //Add the first platform at startHeight and make sure it has the right width
    curPlatforms.add(new Platform(addX, initHeight, widthFromSpeed()));
    updateAddX();
    
    //Add the second and third platforms
    curPlatforms.add(new Platform(addX, random(HEIGHT_MIN, HEIGHT_MAX), widthFromSpeed()));
    updateAddX();
    curPlatforms.add(new Platform(addX, random(HEIGHT_MIN, HEIGHT_MAX), widthFromSpeed()));
    updateAddX();
    curPlatforms.add(new Platform(addX, random(HEIGHT_MIN, HEIGHT_MAX), widthFromSpeed()));
    updateAddX();
    curPlatforms.add(new Platform(addX, random(HEIGHT_MIN, HEIGHT_MAX), widthFromSpeed()));
  }
  
  void updateAddX() {
    Platform last = curPlatforms.getLast();
    addX = last.getBound(Collidable.EAST) + gapFromSpeed();
  }
  
  void update() {
    //Updates all of the platforms in the list
    Iterator<Platform> i = curPlatforms.iterator();
    while(i.hasNext()) {
      Platform cur = i.next();
      cur.update(-speed);
    }
    
    //Handle removal of dead platforms
    if(curPlatforms.getFirst().isDead()) {
      //Get rid of the first item.
      curPlatforms.pop();
      
      //Make sure addX is correct
      updateAddX();
      
      //Add a new platform
      curPlatforms.add(new Platform(addX, random(HEIGHT_MIN, HEIGHT_MAX), widthFromSpeed()));
    }
    
    //Accelerate
    speed += diffCoef * ACCEL;
  }
  
  void render() {
    //Render all platforms in the list (could be made more eff, the last element is never onscreen)
    Iterator<Platform> i = curPlatforms.iterator();
    while(i.hasNext()) {
      i.next().render();
    }
  }
  
  //Returns the platform that the player is colliding with horizontally (HORIZONTAL ONLY)
  Platform getPlayerPlat(Player p) {
    Iterator<Platform> i = curPlatforms.iterator();
    while(i.hasNext()) {
      Platform cur = i.next();
      float playerWidth = player.getBound(Collidable.EAST) - player.getBound(Collidable.WEST);
      if(player.getBound(Collidable.EAST) > cur.getBound(Collidable.WEST) && player.getBound(Collidable.WEST) < cur.getBound(Collidable.EAST)) {
        return cur;
      }
    }
    return null;
  }
  
  //A method to get the width of a new platform
  private float widthFromSpeed() {
    return 128 + random(speed * 16, speed * 32);
  }
  
  private float gapFromSpeed() {
    return gap += speed;
  }
  
  //Returns speed
  float getSpeed() {
    return speed;
  }
}
