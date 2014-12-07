class Player implements Collidable {
  static final float GRAVITY = -1;
  static final float LEFT_SIDE = 64;
  static final float RIGHT_SIDE = LEFT_SIDE + 30;

  private float animCycle, animFrame;
  private color col;


  //whether the player is on the ground
  boolean onGround;

  //the vertical velocity of the player
  float y, vel, jumpSpeed;

  PImage player;

  Player(float initHeight, float jumpSpeed) {
    col = (255);
    onGround = true;

    y = height - initHeight;
    vel = 0;
    this.jumpSpeed = jumpSpeed;

    animFrame = 0;
    //set timer for next frame to zero
    animCycle = 0;

    player = createImage(images.get(0).width, images.get(0).height, ARGB);
    player.loadPixels();
  }

  void jump() {
    if (onGround) {
      vel = jumpSpeed;
      onGround = false;
    }
  }

  void stopJump() {
    if (vel > 0) {
      vel = 0; //22
    }
  }

  void update() {
    Platform curPlat = world.getPlayerPlat(this);
    if (curPlat == null) {
      col = color(255);
      onGround = false;
    } else {
      col = color(255);
    }

    if (!onGround) {
      y -= min(vel, 24);
      vel += GRAVITY;

      //Collision detection is currently not finalized (it's broken)
      if (curPlat!=null) {

        float overlap = curPlat.yCollision(this);
        if (overlap <= 25 && overlap >= 0) {
          onGround = true;
          y = curPlat.getBound(Collidable.NORTH);
        } else if (overlap < 0) {
          onGround = false;
        } else {
          updateState(1);
          println("Game over");
        }
      } else {
        if (y <= 0) {
          //We fell off the world
          println("Game over");
          updateState(1);
        }
      }
    }
  }

  void render() {
    int frame = frameUpdate();
    player = createImage(images.get(0).width, images.get(0).height, ARGB);
    player.loadPixels();
    PImage cur = images.get(frame);
    cur.loadPixels();
    for (int i = 0; i < cur.pixels.length; i++) {
      color c = cur.pixels[i];
      if (brightness(c) > 10) {
        player.pixels[i] = col;
      } else {
        player.pixels[i] = color(0, 0, 0, 0);
      }
    } 
    player.updatePixels();

    image(player, LEFT_SIDE, y - 50);
    score++;
  }

  //getBound implementation for the player
  float getBound(int dir) {
    switch(dir) {
    case Collidable.NORTH:
      return y - 64;
    case Collidable.SOUTH:
      return y;
    case Collidable.EAST:
      return RIGHT_SIDE;
    case Collidable.WEST:
      return LEFT_SIDE;
    default:
      println("getBound method called incorrectly for an instance of the class: Player");
      return 0.0;
    }
  }

  int frameUpdate()
  {
    float curSpeed;
    curSpeed = world.getSpeed();

    if (animCycle >= 7 && onGround) //sets base rotation of animation frames to once every 7 frames
    {
      if (animFrame == 7) {
        animFrame = 0;
      } else
      {
        animFrame++;
      }
      animCycle = 0;
    }

    if (!onGround) //jumping frames this might not work right
    {
      animFrame=2;
    }

    animCycle+= (int)(curSpeed/3);

    return (int) animFrame; //returns frame to animate
  }
}

