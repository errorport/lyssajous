/**
 * This sketch demonstrates how to play a file with Minim using an AudioPlayer. <br />
 * It's also a good example of how to draw the waveform of the audio. Full documentation 
 * for AudioPlayer can be found at http://code.compartmental.net/minim/audioplayer_class_audioplayer.html
 * <p>
 * For more information about Minim and additional features, 
 * visit http://code.compartmental.net/minim/
 */

import ddf.minim.*;

Minim minim;
AudioPlayer player;
AudioInput recorder;
float prev_x=0;
float prev_y=0;
float index = 0;

void setup()
{
  size(displayWidth, displayHeight, P3D);
  //fullScreen();
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  player = minim.loadFile("hack.mp3");
  recorder = minim.getLineIn();
  background(#000000);
}

void draw()
{
  if(index==50)
  {
    stroke(#5CFFB4);
    line(0, prev_y, displayWidth, prev_y);
    line(prev_x, 0, prev_x, displayHeight);
    index=0;
  }
  index++;
  strokeWeight(0);
  rect(0, 0, displayWidth, displayHeight);
  fill(color(0,0,0, 20.0));
  strokeWeight(1);
  stroke(#5CFFB4);

  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value
  for (int i = 0; i < player.bufferSize() - 1; i++)
  {
    stroke(#5CFFB4);
    /*float x1 = map( i, 0, player.bufferSize(), 0, width );
     float x2 = map( i+1, 0, player.bufferSize(), 0, width );
     line( x1, 50 + player.left.get(i)*50, x2, 50 + player.left.get(i+1)*50 );
     line( x1, 150 + player.right.get(i)*50, x2, 150 + player.right.get(i+1)*50 );
    */
    //background(color(255, 255, 255, 200 ));
    //float x = 300+sin(radians(i*(player.right.get(i))))*500;
    //float y = 300+sin(radians(i*(player.left.get(i))))*500;
    float left = player.left.get(i);
    float right = player.right.get(i);
    float y = displayHeight/2+left*300;
    float x = displayWidth/2+right*300;
    line(prev_x, prev_y, x, y);
    if(i % player.bufferSize()/30 == 0){
    strokeWeight(0);
    rect(0, 0, displayWidth, displayHeight);
    fill(color(0,0,0, 5.0));
    strokeWeight(1);
    stroke(#5CFFB4);
    }
    prev_x=x;
    prev_y=y;
    //rotateZ(PI/3.0);
}

  // draw a line to show where in the song playback is currently located
  
  /*float posx = map(player.position(), 0, player.length(), 0, width);
   stroke(0,200,0);
   line(posx, 0, posx, height);
  */
  if ( player.isPlaying() )
  {
    text("Press any key to pause playback.", 10, 20 );
  } else
  {
    text("Press any key to start playback.", 10, 20 );
  }
}

void keyPressed()
{
  if ( player.isPlaying() )
  {
    player.pause();
  }
  // if the player is at the end of the file,
  // we have to rewind it before telling it to play again
  else if ( player.position() == player.length() )
  {
    player.rewind();
    player.play();
  } else
  {
    player.play();
  }
}
