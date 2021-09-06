class ButtonWithText extends Button{
  private String text;
  private String card;
 public ButtonWithText(PImage spritesheet, int x, int y, int textureMult, String name, String text, String card){
   super(spritesheet, x, y, textureMult, name);
   this.text = text;
   this.card = card;
 }
 
 
 public void draw(){
  super.draw();
  text(this.text, this.x, this.y, this.sprites[0].width * this.textureMult, this.sprites[0].height);
 }
}