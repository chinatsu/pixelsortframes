// Main configuration
int mode = 1; // MODE: 0 = black, 1 = bright, 2 = white
int modifier = 100; // modifier: previously brightnessValue, blackValue, whiteValue
// -------

int row = 0;
int column = 0;
import processing.video.*;
Movie m;

void setup() {
  size(480, 270); // source video resolution
  m = new Movie(this, "frames.mp4");
  m.play();
}

void draw() {
  row = 0;
  column = 0;
  m.play();
  if (m.available()) {
    m.pause();
    image(m, 0, 0);
    m.read();

    while(column < width-1) {
     m.loadPixels();
     sortColumn();
     column++;
     m.updatePixels();
    }
  
    while(row < height-1) {
     m.loadPixels();
     sortRow();
     row++;
     m.updatePixels();
    }
    saveFrame("out/######.png");
  }
}

void sortRow() {
  int x = row;
  int y = 0;
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
      unsorted[i] = m.pixels[x + i + y * m.width];
    }

    sorted = sort(unsorted);

    for(int i=0; i<sortLength; i++) {
      m.pixels[x + i + y * m.width] = sorted[i];
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
      unsorted[i] = m.pixels[x + (y+i) * m.width];
    }

    sorted = sort(unsorted);

    for(int i=0; i<sortLength; i++) {
      m.pixels[x + (y+i) * m.width] = sorted[i];
    }

    y = yend+1;
  }
}


//BLACK
int getFirstNotBlackX(int _x, int _y) {
  int x = _x;
  int y = _y;
  color c;
  while((c = m.pixels[x + y * m.width]) < modifier) {
    x++;
    if(x >= width) return -1;
  }
  return x;
}

int getNextBlackX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  color c;
  while((c = m.pixels[x + y * m.width]) > modifier) {
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
  while(brightness(c = m.pixels[x + y * m.width]) < modifier) {
    x++;
    if(x >= width) return -1;
  }
  return x;
}

int getNextDarkX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  color c;
  while(brightness(c = m.pixels[x + y * m.width]) > modifier) {
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
  while((c = m.pixels[x + y * m.width]) > modifier) {
    x++;
    if(x >= width) return -1;
  }
  return x;
}

int getNextWhiteX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  color c;
  while((c = m.pixels[x + y * m.width]) < modifier) {
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
    while((c = m.pixels[x + y * m.width]) < modifier) {
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
    while((c = m.pixels[x + y * m.width]) > modifier) {
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
    while(brightness(c = m.pixels[x + y * m.width]) < modifier) {
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
    while(brightness(c = m.pixels[x + y * m.width]) > modifier) {
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
    while((c = m.pixels[x + y * m.width]) > modifier) {
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
    while((c = m.pixels[x + y * m.width]) < modifier) {
      y++;
      if(y >= height) return height-1;
    }
  }
  return y-1;
}
