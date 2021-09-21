class ButtonWithText extends Button{
  private String text;
  private String card;
 public ButtonWithText(PImage spritesheet, int x, int y, int textureMult, String name, String text, String card){
   super(spritesheet, x, y, textureMult, name);
   this.text = text;
   this.card = card;
 }
 public ButtonWithText(PImage spritesheet, int x, int y, int textureMult, String name, String text){
   super(spritesheet, x, y, textureMult, name);
   this.text = text;
   this.card = null;
 }
 
 public void draw(){
  super.draw();
  fill(0);
  textSize(50);
  textAlign(CENTER);
  text(this.text, this.x, this.y, this.sprites[0].width * this.textureMult, this.sprites[0].height * this.textureMult);
 }
 public String getCard(){
  return this.card; 
 }
}
