/* ASDFPixelSort for video frames v1.0
Original ASDFPixelSort by Kim Asendorf <http://kimasendorf.com>
https://github.com/kimasendorf/ASDFPixelSort
Fork by dx <http://dequis.org> and chinatsu <http://360nosco.pe>

-- Usage:
1. Split a video into a series of pictures with ffmpeg:
  $ ffmpeg -i "input.mov" -an -f image2 "frame_%06d.png"
2. Change `String basedir` in this script to point to where the images are located.
3. Tweak things, that's what's most fun, isn't it?

-- Notes:
When joining the images back into video, you'll probably want to know what the framerate of the original video is. 
Example command with reasonable quality:
  $ ffmpeg -f image2 -r ntsc -i "frame_%06d.png" -c:v libx264 -preset slow "frames.mkv"
*/

// Main configuration
String basedir = "D:/things/pixelsortframes"; // Specify the directory in which the frames are located. Use forward slashes.
String fileext = ".png"; // Change to the format your images are in.
int resumeprocess = 0; // If you wish to resume a previously stopped process, change this value.

int mode = 1; // MODE: 0 = black, 1 = bright, 2 = white
int blackValue = -10000000;
int brightnessValue = -1;
int whiteValue = -6000000;
// -------

PImage img;
PImage initimg;
String[] filenames;
int row = 0;
int column = 0;
int i = 0;
java.io.File folder = new java.io.File(dataPath(basedir));
java.io.FilenameFilter extfilter = new java.io.FilenameFilter() {
  boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(fileext);
  }
};

void setup() {
  frameCount = 0;
  if (resumeprocess > 0) {frameCount = resumeprocess - 1;}
  filenames = folder.list(extfilter);
  initimg = loadImage(basedir+"/"+filenames[0]);
  size(initimg.width, initimg.height); // Takes the size of the first image in the folder.
}

void draw() {
  if (i +1 > filenames.length) {println("Uh.. Done!"); System.exit(0);}
  row = 0;
  column = 0;
  img = loadImage(basedir+"/"+filenames[i]);
  image(img,0,0);
  while(column < width-1) {
    img.loadPixels(); 
    sortColumn();
    column++;
    img.updatePixels();
  }
  
  while(row < height-1) {
    img.loadPixels(); 
    sortRow();
    row++;
    img.updatePixels();
  }
  image(img,0,0);
  saveFrame(basedir+"/out/"+filenames[i]);
  println("Frames processed: "+frameCount+"/"+filenames.length);
  i++;
}


void sortRow() {
  int x = 0;
  int y = row;
  int xend = 0;
  
  while(xend < width-1) {
    switch(mode) {
      case 0:
        x = getFirstNotBlackX(x, y);
        xend = getNextBlackX(x, y);
        break;
      case 1:
        x = getFirstBrightX(x, y);
        xend = getNextDarkX(x, y);
        break;
      case 2:
        x = getFirstNotWhiteX(x, y);
        xend = getNextWhiteX(x, y);
        break;
      default:
        break;
    }
    
    if(x < 0) break;
    
    int sortLength = xend-x;
    
    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + i + y * img.width];
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      img.pixels[x + i + y * img.width] = sorted[i];      
    }
    
    x = xend+1;
  }
}


void sortColumn() {
  int x = column;
  int y = 0;
  int yend = 0;
  
  while(yend < height-1) {
    switch(mode) {
      case 0:
        y = getFirstNotBlackY(x, y);
        yend = getNextBlackY(x, y);
        break;
      case 1:
        y = getFirstBrightY(x, y);
        yend = getNextDarkY(x, y);
        break;
      case 2:
        y = getFirstNotWhiteY(x, y);
        yend = getNextWhiteY(x, y);
        break;
      default:
        break;
    }
    
    if(y < 0) break;
    
    int sortLength = yend-y;
    
    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + (y+i) * img.width];
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      img.pixels[x + (y+i) * img.width] = sorted[i];
    }
    
    y = yend+1;
  }
}


//BLACK
int getFirstNotBlackX(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  while((c = img.pixels[x + y * img.width]) < blackValue) {
    x++;
    if(x >= width) return -1;
  }
  return x;
}

int getNextBlackX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  color c;
  while((c = img.pixels[x + y * img.width]) > blackValue) {
    x++;
    if(x >= width) return width-1;
  }
  return x-1;
}

//BRIGHTNESS
int getFirstBrightX(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  while(brightness(c = img.pixels[x + y * img.width]) < brightnessValue) {
    x++;
    if(x >= width) return -1;
  }
  return x;
}

int getNextDarkX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  color c;
  while(brightness(c = img.pixels[x + y * img.width]) > brightnessValue) {
    x++;
    if(x >= width) return width-1;
  }
  return x-1;
}

//WHITE
int getFirstNotWhiteX(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  while((c = img.pixels[x + y * img.width]) > whiteValue) {
    x++;
    if(x >= width) return -1;
  }
  return x;
}

int getNextWhiteX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  color c;
  while((c = img.pixels[x + y * img.width]) < whiteValue) {
    x++;
    if(x >= width) return width-1;
  }
  return x-1;
}


//BLACK
int getFirstNotBlackY(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  if(y < height) {
    while((c = img.pixels[x + y * img.width]) < blackValue) {
      y++;
      if(y >= height) return -1;
    }
  }
  return y;
}

int getNextBlackY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  color c;
  if(y < height) {
    while((c = img.pixels[x + y * img.width]) > blackValue) {
      y++;
      if(y >= height) return height-1;
    }
  }
  return y-1;
}

//BRIGHTNESS
int getFirstBrightY(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  if(y < height) {
    while(brightness(c = img.pixels[x + y * img.width]) < brightnessValue) {
      y++;
      if(y >= height) return -1;
    }
  }
  return y;
}

int getNextDarkY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  color c;
  if(y < height) {
    while(brightness(c = img.pixels[x + y * img.width]) > brightnessValue) {
      y++;
      if(y >= height) return height-1;
    }
  }
  return y-1;
}

//WHITE
int getFirstNotWhiteY(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  if(y < height) {
    while((c = img.pixels[x + y * img.width]) > whiteValue) {
      y++;
      if(y >= height) return -1;
    }
  }
  return y;
}

int getNextWhiteY(int _x, int _y) {
  int x = _x;
  int y = _y+1;
  color c;
  if(y < height) {
    while((c = img.pixels[x + y * img.width]) < whiteValue) {
      y++;
      if(y >= height) return height-1;
    }
  }
  return y-1;
}
