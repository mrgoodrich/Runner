class Cloud
{
  private float vel, minSide, curSide, x, y, loop;
  private color c, t; //current and target colors


  Cloud()
  {
    vel = random(1, 4);
    minSide = random(20, 70);
    x=1000; //start offscreen
    y=random(0, 600);
    c = color(random(128), random(128), random(128), random(40, 60)); //random current and target colors
    t = color(random(200, 256), random(200, 256), random(200, 256), random(200, 230));
    loop = 0;
  }

  void render()
  {
    noStroke();
    fill(c); //fill to color
    rect(x, y, curSide*2, curSide);  
    if (beat.isOnset() && curSide == minSide)
    {
      curSide=minSide*1.5;  //side scaling
    } else {
      curSide*=.99; //side decay
      if (curSide < minSide)
      {
        curSide = minSide;
      }
    }
    if (loop>=3)//time delay on color interpolaion from c to t
    {
      c = lerpColor(c, t, 0.01);
      loop=0;
    }
    loop++;
    x-=vel; //moves cloud
  }

  boolean isOutOfBounds() //checks cloud bounds
  {
    if (x<-300)
      return true;
    else
      return false;
  }
}

