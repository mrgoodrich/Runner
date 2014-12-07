class Background
{
  private ArrayList clouds;
  private float timer;

  Background()
  {
    clouds = new ArrayList<Cloud>();
    timer = 0;
    clouds.add(new Cloud());
  }

  void render()
  {
    if (timer >= 30)
    {
      timer=0;
      clouds.add(new Cloud());
    }

     
    for (int i=clouds.size ()-1; i >=0; i--) 
    {
      Cloud p = (Cloud)clouds.get(i);

      // update each particle per frame
      p.render();
      if (p.isOutOfBounds())
      {
        clouds.remove(i);
      }
    }
    timer++;
  }
}

