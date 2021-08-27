/**
 enemy data file will follow the format:
 
 name
 maxhealth
 
 //then all of the action groups (as a monsters action could have multiple sub actions, such as attacking and healing, etc)
 associated gene/body part
 whether or not the action targets the monster
 action type: attack, evade or some kind off buff (buffs to be added later)
 action amount
 ...
 \n to seperate action groups
 
 
 **/


class Enemy {
  private int health;
  private int maxHealth;
  private int defense;

  private ArrayList<EnemyActionGroup> possibleActions;

  private String imageFilename;
  private PImage image;

  private String filename;

  private String name;

  public Enemy(String filename, String imageFilename) {
    this.filename = filename;
    this.imageFilename = imageFilename;
    this.image = loadImage(this.imageFilename);
    String[] lines = loadStrings(this.filename);
    
    this.name = lines[0];
    this.maxHealth = Integer.parseInt(lines[1]);
    this.health = this.maxHealth;
    
    
    possibleActions = new ArrayList<EnemyActionGroup>();
    
    this.defense = 0;
    
    
    //loading action groups
    
    
    
    
  }
}
