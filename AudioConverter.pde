//AudioConverter converts mp3 audio waveforms into png images 
//Originally written by Thiago Hersan 4/2104
//Edited by Dot Silverman 6/2014

//note: in Audacity, must convert stereo to mono before running it through 
//this script

import ddf.minim.*;

Minim minim;
float[] ys; //y values for the line draw along width of screen
float minY;

void setup() {
  size(1280, 512);
  smooth();

  minim = new Minim(this);
  ys = new float[width]; //ys=width of output screen in pixels=1280

  for (String fn: (new File(dataPath(""))).list()) {
    if (fn.endsWith(".mp3")) {
      analyzeUsingAudioSample(fn);
      drawAudio(fn);
    }
  }
  println("minY= "+minY);
  //exit(); //uncomment if do not want pop-up
}

void analyzeUsingAudioSample(String fileName) {
  AudioSample audio = minim.loadSample(dataPath(fileName), 2048);
  float[] leftChannel = audio.getChannel(AudioSample.LEFT);
  audio.close();
  
  minY = 0;
  //spp = "samples per pixel" or "the # of samples taken for 
  //each pixel on average at a given time"
  int spp = (int)(leftChannel.length/width);
  
  //**ABOUT FOR LOOP**
  // Only drawing 1280 values, but leftChannel has (for example) 128000 samples. 
  // That means each pixel on the screen represents 100 samples of audio.
  // The nested loop reads audio samples in groups of 100 at a time.
  // Inner loop calculates the average of these groups of 100 and puts
  // them into the ys array. Outer loop specifies that I should do that
  // 1280 times. ys are the y coordinates and i in ys[i] is the x coordinate.
  for (int i=0; i<ys.length; i++) {
    float sum = leftChannel[i*spp]; //sample leftChannel every 1280 pixels here
    for (int j=1; j<spp; j++) {
      sum += leftChannel[i*spp+j]; //sum up all values of pixels in audio
    }
    ys[i] = (sum/spp); //calc average here
    minY = (ys[i] < minY)?ys[i]:minY; //ternary operator: variable = condition ? value_if_true : value_if_false
  }
}

void drawAudio(String fileName) {
  pushMatrix();

  //configure image in display
  //translate(0,-100);
  translate(0,5);

  background(255);
  fill(255);
  stroke(255);
  strokeWeight(10);

  for (int i=1; i<ys.length; i++) {
    ellipse(i, 0, height/8, ys[i]/(minY)*2*height);
  }

  fill(0);
  stroke(0);
  strokeWeight(0);

  for (int i=1; i<ys.length; i++) {
    ellipse(i, 0, height/8, ys[i]/(minY)*2*height);
  }

  //save image as png
  saveFrame(dataPath(fileName+".png"));
  popMatrix();
}

void draw() {
}
