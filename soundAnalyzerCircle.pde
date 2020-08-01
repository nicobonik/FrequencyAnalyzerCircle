PImage img;  // Declare variable "a" of type PImage

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput input;
FFT analyzer;
Line lastLine = new Line(0, 0, 0, 0);

float range = 4;
float lineHeight = 4;
float radius = 520;
float centerX;
float centerY;
float offset = 0;

void setup() {
  size(1920, 1080);
  
  minim = new Minim(this);
  input = minim.getLineIn();
  analyzer = new FFT(input.bufferSize(), input.sampleRate());
  
  centerX = (width / 2) - 2 - ((width - 1920) / 2);
  centerY = (height / 2) + 35 - ((height - 900) / 2);
  
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  img = loadImage("background.jpg");  // Load the image into the program  
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  image(img, 0, 0);
 
  stroke(224);
 
  float renderAngle = offset;
  float renderRatio = (2.0 * PI) / (analyzer.specSize() / range);
 
  //circle(centerX, centerY, radius);
  analyzer.forward(input.mix);
  for(int i = 0; i < analyzer.specSize() / range; i++)
  {
    
    float lineX1 = centerX + (((radius + 10) / 2) * cos(renderAngle));
    float lineY1 = centerY - (((radius + 10) / 2) * sin(renderAngle));
    
    float randomHeight = random(1, 4);
    
    float lineX2 = lineX1 + ((lineHeight + randomHeight) * analyzer.getBand(i) * cos(renderAngle));
    float lineY2 = lineY1 - ((lineHeight + randomHeight) * analyzer.getBand(i) * sin(renderAngle));
    
    float lineLength = sqrt(pow(lineX2 - lineX1, 2) + pow(lineY2 - lineY1, 2));
    if(lineLength > 130) {
       lineX2 = lineX1 + (30 * cos(renderAngle));
       lineY2 = lineY1 - (30 * sin(renderAngle));
    }
    
    line( lineX1, lineY1, lineX2, lineY2 );
    
    line(avg(lineX1, lastLine.x1), avg(lineY1, lastLine.y1), avg(lineX2, lastLine.x2), avg(lineY2, lastLine.y2));
    
    renderAngle += renderRatio;
    lastLine.setLine(lineX1, lineY1, lineX2, lineY2);
  } 
  offset += 0.0;
}

float avg(float x, float y) {
  return (x + y) / 2.0f;
}

class Line {
  
  public float x1, x2, y1, y2;
  
  public Line(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }
  
  public void setLine(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }
  
}
