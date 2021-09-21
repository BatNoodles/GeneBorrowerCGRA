class SpriteSheet{
    protected PImage[] sprites;
    protected int width;
    protected int height;
    public SpriteSheet(PImage baseImage, int spriteCount, int imageMult){
        sprites = new PImage[spriteCount];
        int W = baseImage.width / spriteCount;
        int H = baseImage.height;
        for (int i = 0; i < spriteCount; i++){
            sprites[i] = baseImage.get(i * W, 0, W, H);
        }
        this.width = sprites[0].width * imageMult;
        this.height = sprites[0].height * imageMult;
    }

    public void draw(int x,int y, int index){
        image(sprites[index], x , y, width, height);
    }
}
