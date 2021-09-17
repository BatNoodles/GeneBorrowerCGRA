class Action{
 private String type;
 private boolean targetOther;
 private int amount;
 //TODO make target other be 0, 1 or 2, with 2 being target all enemies
 
 public Action(String type, int targetOther, int amount){
   this.type = type;
   this.targetOther = targetOther == 1;
   this.amount = amount;
 }
 
 public String getType(){
  return this.type; 
 }
 
 public boolean getTarget(){
  return this.targetOther; 
 }
 
 public int getAmount(){
  return this.amount; 
 }
 
}
