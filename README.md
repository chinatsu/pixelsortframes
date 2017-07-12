# pixelsortframes

Processing script based on Kim Asendorf's [ASDFPixelSort](https://github.com/kimasendorf/ASDFPixelSort), which sorts portions of pixels in an image.
pixelsortframes processes multiple images, best used on animations or videos split into single frames.

Default branch is now the p3 version, and any future development will happen here. The Processing 2 version can still be found [here](https://github.com/chinatsu/pixelsortframes/tree/master)


### Video branch

There is a branch for direct video processing [here](https://github.com/chinatsu/pixelsortframes/tree/video), which requires the Video library by The Processing Foundation. To install the library, select `Sketch -> Import Library... -> Add Library...` from within Processing. From there, you can find and install the Video library.

As of right now, I have decided against programatically generating a video, and instead have the project output frames. You can then use the Processing Movie Maker to output a .mov file. Select `Tools -> Movie Maker`, and point it to the `out` folder with frames.

### Authors
* Kim Asendorf - <http://kimasendorf.com>
* dx - <http://dequis.org>
* chinatsu - <http://cute.enterprises>
