class Action{
 private String type;
 private boolean targetOther;
 private int amount;
 
 
 public Action(String type, int targetOther, int amount){
   this.type = type;
   this.targetOther = targetOther == 1;
   this.amount = amount;
 }
 
 
 
}
