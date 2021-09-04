class TextWithBackground{
 private PImage backgroundImage;
 private int textureMult;
 private int framesLeft;
 private String text;
 public TextWithBackground(String text, String imageFilename, int textureMult){
   this.framesLeft = 0;
   this.text = text;
   this.backgroundImage = loadImage(imageFilename);
   this.textureMult = textureMult;
 }
 
 
 public void draw(int x, int y, int textSize){
   if (framesLeft == 0) return;
   int actualX =  x - backgroundImage.width * textureMult / 2;
   int actualY = y - backgroundImage.height * textureMult / 2;
   image(backgroundImage, actualX,actualY, backgroundImage.width * textureMult, backgroundImage.height * textureMult);
   textSize(textSize);
   text(this.text, actualX,actualY + backgroundImage.height * textureMult / 2 - backgroundImage.height * textureMult / 6, backgroundImage.width * textureMult, backgroundImage.height * textureMult / 2);
   if (framesLeft > 0 )framesLeft--;
 }
 
 public void setText(String text){
  this.text = text;
 }
 
 public void setFramesLeft(int framesLeft){
   this.framesLeft = framesLeft;
 }
 
}
