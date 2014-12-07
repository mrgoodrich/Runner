import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//Import linked list for the World class
import java.util.LinkedList;
//Import Iterators
import java.util.Iterator;

//DFA STATE INTEGERS
final int MAIN_MENU = 0;
final int HIGH_SCORE = 1;
final int START_GAME = 2;
final int IN_GAME = 3;
final int EXIT_GAME = 4;

PImage title, start, highscore, curScore, scoreTitle, curHighScore;

PFont font;

//DFA, controls game state
int[][] dfa = new int[5][3];
int state;

//The main menu
MainMenu menu;

//The player
Player player;

//The world
World world;

//The high score menu
HighScores highscores;

Background background;
Minim minim;
AudioPlayer aPlayer;
BeatDetect beat;
Music music;

//The next score to be written
int score;
//if the current score has been written
boolean scoreWritten;

ArrayList<PImage> images;

void setup() {

  minim = new Minim(this);
  aPlayer = minim.loadFile("02 On My Level.mp3");
  beat = new BeatDetect();

  music = new Music();

  title = loadImage("Title.png");
  start = loadImage("start.png");
  highscore = loadImage("mhighscores.png");
  curScore = loadImage("Singame.png");
  scoreTitle = loadImage("HStitle.png");
  curHighScore = loadImage("HSingame.png");

  font = createFont("pixelated.ttf", 64);
  textFont(font);
  textAlign(CENTER, CENTER); 

  images = new ArrayList<PImage>();
  images.add(loadImage("0.png"));
  images.add(loadImage("1.png"));
  images.add(loadImage("2.png"));
  images.add(loadImage("3.png"));
  images.add(loadImage("4.png"));
  images.add(loadImage("5.png"));
  images.add(loadImage("6.png"));
  images.add(loadImage("7.png"));
  /*
  * LOAD ASSETS HERE
   */

  //init DFA

  //Exit or play from menu
  dfa[MAIN_MENU][0] = START_GAME;
  dfa[MAIN_MENU][1] = HIGH_SCORE;
  dfa[MAIN_MENU][2] = EXIT_GAME;

  //Init highscore menu
  dfa[HIGH_SCORE][0] = MAIN_MENU;
  dfa[HIGH_SCORE][1] = MAIN_MENU;
  dfa[HIGH_SCORE][2] = MAIN_MENU;

  //Always go to game from start game state
  dfa[START_GAME][0] = IN_GAME;
  dfa[START_GAME][1] = IN_GAME;
  dfa[START_GAME][2] = IN_GAME;

  //Go to game over only if player runs into building
  //(input 1)
  dfa[IN_GAME][0] = START_GAME;
  dfa[IN_GAME][1] = HIGH_SCORE;
  dfa[IN_GAME][2] = HIGH_SCORE;

  //Go back to start if input is 1

  //Don't need to init EXIT_GAME paths.

  //init main menu
  menu = new MainMenu();

  //init high scores
  highscores = new HighScores();
  highscores.loadScores();

  //start in the menu
  state = 0;

  size(800, 600, P3D);
}

void newGame() {
  background = new Background();

  //the height of the first platform
  float startHeight = random(World.HEIGHT_MIN, World.HEIGHT_MAX);

  //the horizontal scrolling acceleration coefficient
  float difficultyCoef = random(1, 3);

  //init world
  world = new World(startHeight, difficultyCoef);

  //init player
  player = new Player(startHeight, 20);

  score = 0;
  scoreWritten = false;

  music.play();
}

void draw() {
  background(0);

  switch(state) {
  case MAIN_MENU:
    menu.render();
    break;
  case HIGH_SCORE:
    if (!scoreWritten) {
      highscores.saveScores(score);
      scoreWritten = true;
    }
    highscores.render();
    break;
  case START_GAME:
    newGame();
    updateState(0);
    break;
  case IN_GAME:
    beat.detect(aPlayer.mix);

    player.update();
    world.update();

    background.render();

    player.render();
    world.render();
    image(curScore, 0, 0);
    image(curHighScore, 0, 70);
    textAlign(RIGHT, TOP);
    fill(255);
    textSize(96);
    text(score, 800, 10);
    text(highscores.curHighScore(), 800, 80);
    textAlign(CENTER, CENTER);
    break;
  case EXIT_GAME:
    exit();
  }
}

void updateState(int input) {
  state = dfa[state][input];
}

void keyPressed() {
  switch(state) {
  case MAIN_MENU:
    if (key == 'y') {
      updateState(1);
    } else if (key == ESC) {
      updateState(2);
    } else {
      updateState(0);
    }
    break;
  case IN_GAME:
    player.jump();
    break;
  case HIGH_SCORE:
    if (key == '`') {
      highscores.createNewScoreFile();
    }
    updateState(0);
    break;
  }
}

void keyReleased() {
  if (state == IN_GAME) {
    player.stopJump();
  }
}

