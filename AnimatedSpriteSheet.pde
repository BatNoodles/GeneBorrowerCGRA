class AnimatedSpriteSheet extends SpriteSheet{
    private int frames;
    private int currentFrame;
    private int spriteIndex;
    public AnimatedSpriteSheet(PImage baseImage, int width, int imageMult, int frames){
        super(baseImage, baseImage.width / width, imageMult);
        this.frames = frames;
        this.currentFrame = 0;
        this.spriteIndex = 0;
    }

    public boolean draw(int x, int y){ //needed to return whether the animation is over, this will be used to play attack animations for entities;
        super.draw(x,y, this.spriteIndex);
        if (currentFrame == frames){
            currentFrame = 0;
            return next();
            
        }
        else{
            currentFrame ++;
            return false;
        }
        
    }

    private boolean next(){
        if (this.spriteIndex == this.sprites.length - 1){
            this.spriteIndex = 0;
            return true;
        }
        else{
            this.spriteIndex ++;
            return false;
        }
    }
}