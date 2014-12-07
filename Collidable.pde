interface Collidable {
  static final int NORTH = 0;
  static final int SOUTH = 1;
  static final int EAST = 2;
  static final int WEST = 3;
  
  //returns the bound of the side provided
  public float getBound(int side);
}
