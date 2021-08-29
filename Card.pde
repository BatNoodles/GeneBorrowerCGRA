/**
Card text files should follow the format:


Name
Cost

-- any amount of actions below --

Action key (a for attack, b for block, d for discard -- more to be added later)
targetOther (0 for false, 1 for true)
amount (numerical value for the action, e.g how much damage the attack does

**/



class Card{
  private String filename;
  private String imageFilename;
  private String name; //name used internally, card name is printed on card
  private int cost;
  
  private boolean cardHasTargets;
  
  private ArrayList<Action> actions;
  
  private PImage image;
  
  public Card(String filename, String imageFilename){
    this.cardHasTargets = false;
    this.actions = new ArrayList<Action>();
    this.filename = "cardData/" + filename;
    this.imageFilename = imageFilename;
    this.readActions();
    this.image = loadImage("cardSprites/" + this.imageFilename);
  }
  
  public Card(Card card){
    this.cardHasTargets = card.getTargets();
    this.actions = card.getActions();
    this.filename = card.getFilename();
    this.imageFilename = card.getImageFilename();
    this.image = card.getImage();
    this.cost = card.getCost();
    this.name = card.getName();
  }
  
  
  public int getCost(){
   return this.cost; 
  }
  
  public boolean getTargets(){
   return this.cardHasTargets; 
  }
  
  public ArrayList<Action> getActions(){
   return new ArrayList<Action>(this.actions);
  }
  
  public String getFilename(){
   return this.filename; 
  }
  
  public String getImageFilename(){
   return this.imageFilename; 
  }
  
  private void readActions(){
    String[] lines = loadStrings(this.filename);
    this.name = lines[0];
    this.cost = Integer.parseInt(lines[1]);
    assert (lines.length - 2) % 3 == 0 : 
    "Card: " + this.filename + " is formatted incorrectly";
    
    
    for (int line = 2; line < lines.length; line += 3){

      if (Integer.parseInt(lines[line+1]) == 1){
       this.cardHasTargets = true; 
       
      }
     actions.add(new Action(lines[line], 
     Integer.parseInt(lines[line+1]), 
     Integer.parseInt(lines[line+2]))); 
    }
  }
  
  
  
  public String getName(){
   return this.name; 
  }
  
  public PImage getImage(){
   return this.image; 
  }
  
  
  
  
}
