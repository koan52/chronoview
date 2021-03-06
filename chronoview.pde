import java.math.BigDecimal;

ChronoMain chrono;
Glyph glyph;

int r_view = 300;
int maxNodeSize = 0;
int rangeDisplayNode = 0;
int clickedTime = -1;

float period = 24;

boolean display_label = true;
boolean display_g_frq = false;

Date firstDate;
Date lastDate;

color[] gcl_h = 
{#f9344c,#fb4938,#fd662d,#ff8124,#ff9b15,#ffb61d,#ffd126,#ffed2f
,#d9e62f,#add72c,#88c83a,#6bba4b,#47ac59,#2fa46d,#22a286,#209998
,#218ea5,#2680ae,#3670b0,#5e66ae,#8461ac,#a65aa9,#c2549f,#dc4d95};

color[] gcl_hq =
{#253532,#2c433e,#33524b,#3a6158,#427066,#498074,#509082,#57a090,#5fb19f,#66c2ae};

boolean PLOT_MDS = true;

void setup(){
  size(1200, 699);
  smooth();
  
  firstDate = new Date();
  lastDate = new Date();
  chrono = new ChronoMain("shop316.csv");
  chrono.initialize();
  
  glyph = new Glyph('1');
  
  axi_step = 1;
  rangeDisplayNode = maxNodeSize;
}

void draw(){
  background(0);
  
  clickedTime = -1;

  translate(350,350);
  if(!PLOT_MDS) drawChronoViewWindow();
  
  chrono.calcMaxNodeSize();
  chrono.drawNodes();

  translate(400,240);
  //translate(400,600);
  drawOperationArea();
  
}  

float getTheta(float t, float period){
  return PI/2 - 2*PI*(t/period);
}

void drawChronoViewWindow(){
  textSize(12);
  textAlign(CENTER);
 
  stroke(255);
  noFill();
  ellipse(0, 0, r_view * 2, r_view * 2);
  
  for(int h = 0; h < period; h++){
    float theta = getTheta(h, period);
    float x = (r_view + 20) * cos(theta); 
    float y = (r_view + 20) * sin(theta);
    fill(gcl_h[h]);
    text(h, x, y * -1);
    
    if(dist(x, y * -1, mouseX-350, mouseY-350) < 50){
      clickedTime = h;
    }
  }
}

void drawOperationArea(){
  stroke(255);
  textSize(12);
  fill(255);
  
  text("rate of number of axes", 150, -20);
  line(0,0,300,0);
  text("range of display Nodes", 150, 60);
  line(0,80,300,80);
  
  if(mouseX > 750 && mouseY > 550 && mouseX <= 1080 && mouseY < 620){
    rateAxis = (mouseX - 750)/300.0;
    
    if(rateAxis > 1.0) rateAxis = 1.0;
    if(rateAxis < 0.05) rateAxis = 0.05;
    
    axi_step = (int)map(rateAxis,0.05,1.0,1,period/2);
    while(period % axi_step != 0){
      axi_step--;
    }
    
    /*BigDecimal bd = new BigDecimal(rateAxis);
    bd = bd.setScale(1,BigDecimal.ROUND_DOWN);
    rateAxis = bd.floatValue();
    d_axi = period/(period*rateAxis);*/
    chrono.calcNodesPoint();
  }
  
  if(mouseX > 750 && mouseY > 630 && mouseX <= 1080 && mouseY < 720){
    rangeDisplayNode = (int)map((mouseX - 750)/300.0, 0, 1.0, 0, maxNodeSize);
  }
}

void keyPressed(){
  
  if(key == 't'){
    display_label = !display_label;
  }
  
  if(key == 'f'){
    display_g_frq = !display_g_frq;
  }
  
  if(key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key =='0'){
    glyph.setGlyphType(key);
    
    if(key == '1'){ rateAxis = 1; }
    if(key == '2'){ rateAxis = 0.3; }
    
    axi_step = (int)map(rateAxis,0.05,1.0,1,period/2);
    while(period % axi_step != 0){
      axi_step--;
    }
    
    chrono.calcNodesPoint();
  }   
}