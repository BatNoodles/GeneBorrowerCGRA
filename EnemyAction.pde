class EnemyAction{
 private boolean targetSelf;
 private String actionType;
 private int amount;
 
 public EnemyAction(String targetSelf, String actionType, String amount){
   this.targetSelf = targetSelf == "true";
   this.actionType = actionType;
   this.amount = Integer.parseInt(amount);
 }
 
}
