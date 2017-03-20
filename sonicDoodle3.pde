import oscP5.*;
import netP5.*;
import processing.video.*;
  
// Declaring global variables
PImage mainBackground;
PImage noteImage;
PImage countDown;
int frameRateValue = 30;
int startFrameCount = 0;
//int lengthDisplay = 640, breadthDisplay = 360;
OscP5 oscP5;
NetAddress myRemoteLocation;
Movie myMovie;

int state = 0;

// Parameters
int bpm = 30;
int barLength = 16;
int interNoteDistance = 12;
int startFlag;

// Declaring colors for the GUI
color noteColor = color(255, 204, 0);
color conductorColor = color(0,0,255);

// Declaring variables for time keeping
int onBeat = 0;
int beatValue = 0;
int xPosition = 95;
int xUpdate = 1140/(barLength+1);
int xSmoothUpdate = 1140/(barLength*frameRateValue);
int xOffset = 30;
int[] output = new int[2];

int noteX = xPosition;
int noteY;
int midiNote;

int conductorX = xPosition + xOffset;
int conductorY;

float triggOn_B;
float triggOn_A;
float vibratoTrigg;
float pitch;
float roll;
float nunX;
float nunY;
float xval;
float yval;
float irX;
float irY;




int[] scale =  {62,64,65,67,69,71,72,74,76,77,79};

// Object definitions
class note {
  int n_status;    // 0 for off 1 for on
  int n_pitch;
  int n_position;  // position on the sequence.
  int n_volume;
  int n_expression; // Add or modify more expressions at note level
};

class layer {
  note[] l_sequence;
  int l_sequenceLength;
  // int l_isPolyphonic; // 1 to translate the layer to chords/polyphony
  // int l_instrument;   // identity of the instrument
};


// ------------------- Beginning of Code -------------------

void setup(){
  fullScreen();
  frameRate(frameRateValue); 
  // OSC object listening in port 3000 of the localhost
  oscP5 = new OscP5(this,3000);
  
  // background display
  //size(1280,835);
  
  mainBackground = loadImage("musicalstaff.jpg");
  //mainBackground.resize(640,360);
  noteImage = loadImage("note.png");
  
  // WiiMote OSC messages 
  oscP5.plug(this,"pry","/wii/1/accel/pry");
  oscP5.plug(this,"buttonB","/wii/1/button/B");
  oscP5.plug(this,"buttonA","/wii/1/button/A");
  oscP5.plug(this,"nunch","/wii/1/nunchuk/joy");
  oscP5.plug(this, "buttonZ","/wii/1/nunchuk/button/Z"); 
  oscP5.plug(this, "ir","/wii/1/ir");
  // Print display
  //image(mainBackground,0,0);
  
  // PD code
  OSCPDsetup();
  
  // Countdown code
  countDown = loadImage("3.jpg");
  startFlag = 1;
  
  playVideosetup();
}

// Main Loop
void draw(){
  
  
   if(state == 0) {
    float md = myMovie.duration();
    float mt = myMovie.time() + 0.1;
    if(mt >= md) {
      state = 1;
      image(mainBackground,0,0);
    }else{
      image(myMovie,0,0);
    }
  } else if(state == 1) {  
  
  //while (startFlag == 1){
  //  startFrameCount = frameCount;
  //  // TODO: something while we wait for trigger A to start the program
    
  //  if (triggOn_A == 1){
  //    print("Button got pressed");
  //    startFlag = 0;
  //    break;
  //  } 
  //}
  
  //while(frameCount < startFrameCount + frameRateValue  && frameCount > 0){
  //image(countDown,0,0);
  //}
  //image(mainBackground,0,0);
  
  
  //Calculating if its on beat
  onBeat = (frameCount - startFrameCount) % bpm;
  
  // Things to do on beat
  //    1) Check if wii is inserting a note.
  //    2) Entering the note into layer
  fill(conductorColor, 50);
  ellipse(conductorX, conductorY, 20, 20);
  conductorX = conductorX + xSmoothUpdate;
  
  if(onBeat == 0){
    
    beatValue++;
    //update position of cursor
    noteX = noteX + xUpdate;
    //noteX = noteX + xUpdate;
    if (triggOn_A == 1){
      image(noteImage,noteX,noteY, 70,70);
      // PD code
      OSCPDdraw(midiNote,vibratoTrigg,1);
      
    }
    
    else{
      OSCPDdraw(midiNote,vibratoTrigg,0);
    
    }
    
    
    if(beatValue > 16){
      beatValue = 0;
      // Print display
      image(mainBackground,0,0); 
      noteX = xPosition;
      conductorX = xPosition + xOffset;
    }
  

  }
  }
}

//void mouseMoved(){
   
//  noteY = mouseY;
  
//  if(noteY > 290)
//  noteY = 290;
  
//  if(noteY < 190)
//  noteY = 190;
  
    
//  conductorY = noteY + 350;
  
//}
void mousePressed(){
  print("pressed");
  print(mouseX, mouseY);
}


 
void pry(float _pitch, float _roll, float _yaw, float _accel) {

  pitch = _pitch;
  //yval = 800 * (1-pitch);
 
  
  conductorY = int((1-pitch) * 124 + 184);
  noteY = conductorY + 350;
  int[] notes = mapNotes(noteY, 542);
  noteY = notes[1];
  midiNote = notes[0];
  //println(midiNote);
  
   
  //roll = _roll;
  //xval = 800 * roll;
  //println(roll);

  //yaw = _yaw;
  //print(yaw);

}

int[] mapNotes(int notePos, int layerPos){
  layerPos = layerPos - interNoteDistance;
  int distance = notePos - layerPos;
  int newNotePos = (distance / interNoteDistance) * interNoteDistance;
  int d = newNotePos/interNoteDistance;
  
  int midiNote = scale[10-d];
  output[0] = midiNote;
  output[1] = newNotePos + layerPos;
  
  
  return output;
}

void buttonB(float _triggOn_B) {
  triggOn_B = int(_triggOn_B);
  //println(int(triggOn_B));
 
 
}

void buttonA(float _triggOn_A) {
  triggOn_A = int(_triggOn_A);
 
}

void nunch(float _x, float _y) {
  
  //nunX = _x;
  float nunY = _y;
  
  vibratoTrigg = nunY;

  //if (nunY > 1) {
  //  nunY = 1;
  //}
  println(nunY);
  
}

//void buttonZ(float _vibratoTrigg){
//  vibratoTrigg = int(_vibratoTrigg);
//  //print(vibratoTrigg);
//}

//void ir(float _x, float _y){
  
//  irX = _x;
//  irY = (1 - _y);
//  //println(irX,irY);
  
//  //pitch = _pitch;
//  //yval = 800 * (1-pitch);
 
  
//  conductorY = int(irY * 124 + 184);
//  noteY = conductorY + 350;
//  int[] notes = mapNotes(noteY, 542);
//  noteY = notes[1];
//  midiNote = notes[0];
//  //println(midiNote);

//}