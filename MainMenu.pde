class MainMenu{
  //Instance Vars
  PFont font;
  int fontSize;
  
  //Constructor
  MainMenu(){
  }
  
  //Other methods
  void render(){
    //Draw background
    fill(0);
    rect(0,0,width,height);
    
    //*********************
    //Word stuff 
    //textFont(font,10); ignore until we have font files
    
    //Game Title
    image(title, 50, 50);
    
    //Start
    image(start, 300, 300);
    
    //HighScores
    image(highscore, 200, 400);
    
    //**********************
  }
}
