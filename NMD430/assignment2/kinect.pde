
float[] findSelector(){
  
  //get array of pixels with depth information  
  int[] depth = kinect.getRawDepth();
  
  img.loadPixels();
  
  //set totals for all pixels in the given range
  float sumX = 0; 
  float sumY = 0;
  float totalPixels = 0;
  

  for (int x=0; x<img.width; x++) {
    for (int y=0; y<img.height; y++) {
      
      int offset = x+y*kinect.width;
      int d = depth[offset];
      
      if(d > 0 && d < 600){
        img.pixels[offset] = color(255,0,150);
        sumX += x;
        sumY += y;
        totalPixels++;
      }else{
        img.pixels[offset] = color(0,0,200);
      }
    }
  }
  
  img.updatePixels();
  //display the image! 
  image(img, -10,0);
  
  float avgX = sumX / totalPixels;
  float avgY = sumY / totalPixels;
  
  fill(255,0,0);
  ellipse(avgX,avgY, 30,30); 
  float[] vals = {avgX,avgY}; 
  
  return vals;
}