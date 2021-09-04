class FadingText{
 private int maxFrames;
 private int frame;
 private String text;
 private int x;
 private int y;
 
   public FadingText(int maxFrames, String text, int x, int y){
     this.maxFrames = maxFrames;
     this.text =text;
     this.x = x;
     this.y = y;
   }
   public void draw(){
    if (this.frame < this.maxFrames) this.frame++;
    textSize(30);
    fill(255,0,0, 255 * (1 -frame / (float)maxFrames));
    text(this.text, this.x, this.y);
   }
   public boolean done(){
    return this.frame == this.maxFrames; 
   }
 
}
