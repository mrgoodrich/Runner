class Platform implements Collidable {
  private int type;
  
  private color col;
  
  private PVector loc;
  
  private float platWidth;
  
  Platform(float x, float platHeight, float platWidth) {
    loc = new PVector(x, height - platHeight);
    this.platWidth = platWidth;
    switch(round(random(2))){
      case 0:
        col = color(random(128,255),random(25),random(25));
        break;
      case 1:
        col = color(random(25),random(128,255),random(25));
        break;
      case 2:
        col = color(random(25),random(25),random(128,255));
        break;
    }
  }
  
  float getX() {
    return loc.x;
  }
  
  void update(float dx) {
    loc.x += dx;
  }
  
  void render() {
    fill(col);
    rect(loc.x, loc.y, platWidth, height);
  }
  
  //returns whether the player is in the platform (VERTICAL ONLY)
  float yCollision(Player p) {
    //return how far the player is into the platform
    return p.getBound(SOUTH) - loc.y;
  }
  
  boolean isDead() {
    return loc.x + platWidth < 0;
  }
  
  //getBound implementation for platforms
  float getBound(int dir) {
    switch(dir) {
      case Collidable.NORTH:
        return loc.y;
      case Collidable.SOUTH:
        return height;
      case Collidable.EAST:
        return loc.x + platWidth;
      case Collidable.WEST:
        return loc.x;
      default:
        println("getBound method called incorrectly for an instance of the class: Platform");
        return 0.0;
    }
  }
  
  color getColor() {
    return col;
  }
}
