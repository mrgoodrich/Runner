PrintWriter output;
BufferedReader reader;
ArrayList<Integer> scores;
boolean firstSave, readError;
ArrayList<Integer> test;
String testString;
File f = new File("highscores.txt");
HighScores h;
int mostRecentScoreIndex;

class HighScores{
  HighScores(){
    scores = new ArrayList<Integer>();
    mostRecentScoreIndex = -1;
  }
  void loadScores(){ 
    try{
      reader = createReader("highscores.txt");
      for(int i=0;i<10;i++){
          String temp = reader.readLine();
          if (temp != null){
          scores.add(Integer.parseInt(temp)); 
        }
      }
    }
    catch (NullPointerException e){
      createNewScoreFile();
    }
    catch (IOException e){
      createNewScoreFile();
    }
  }
  void createNewScoreFile(){
    scores.clear();
    output = createWriter("highscores.txt");
    for(int i=0;i<9;i++){
      output.println(0);
      scores.add(0);
    }
    output.flush();
    output.close();
    mostRecentScoreIndex = -1;
  }
  void saveScores(int newScore){
    boolean doneSorting = false;
    output = createWriter("highscores.txt");
    for(int i=0; i<scores.size();i++){
      if ((int) scores.get(i) < newScore && !doneSorting){
        scores.add(i, newScore);
        doneSorting = true;
        mostRecentScoreIndex = i;
      }
    }
    for(int i=0; i<scores.size();i++){
      output.println(scores.get(i));
    }
    output.flush();
    output.close();
  }
  void render(){
    textSize(64);
    fill(255);
    loadScores();
    image(scoreTitle,50,25);
    for(int i=0;i<10;i++){
      if(i == mostRecentScoreIndex){
        fill(color(255,0,0));
      } else {
        fill(255);    
      }
      text(scores.get(i),400,200+i*40);
    }
  }
  int curHighScore(){
    int highScore = 0;
    for(int i=0; i<scores.size();i++){
      if(scores.get(i)>highScore){
        highScore = scores.get(i);
      } 
    }
    return highScore;
  }
}
