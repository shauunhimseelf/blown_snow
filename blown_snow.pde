import ddf.minim.*;

class Balloon {
  PVector 
    location, 
    velocity, 
    acceleration;
    
  float mass;
  
  
  Balloon(float m, float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    mass = m;
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(5);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void applyForce( PVector force ) {
    PVector f = PVector.div(force, mass);
    acceleration.add( f );
  }
  
  void checkEdges() {
    if(location.y < 0){
      location.y = height;
    } else if (location.y > height){
      location.y = 0;
    }
    if(location.x < 0)
    {
      velocity.x *= -0.25;
      location.x = 0;
    } else if ( location.x > width )
    {
      velocity.x *= -0.25;
      location.x = width;
    }
  }
  
  void display() {
    noStroke();
    fill(255, 20);
    ellipse(location.x, location.y, mass*16, mass*16);
  }

}

Balloon[] balloons;
int numBalloons = 200;
PVector lift = new PVector(0, -0.005);
PVector gust = new PVector(-0.5, 0);

float t;

Minim minim;
AudioInput in;

void setup() {
  size(640, 640);
  background(0, 5, 35);
  smooth();
  
  minim = new Minim(this);
  in = minim.getLineIn();

  t = 0.01;
  
  balloons = new Balloon[numBalloons];
  
  for( int i = 0; i < numBalloons; i++ )
  {
    balloons[i] = new Balloon(random(0.1,5), width/2, 0);
  }
  
}

void draw() {
  fill(0, 5, 35, 20);
  rect(0, 0, width, height);
  for( int i = 0; i < numBalloons; i++ ){
    balloons[i].applyForce( lift );
    balloons[i].applyForce( calculateWind() );
    println( in.mix.level() );
    if( round(in.mix.level()) == 1 ) {
      balloons[i].applyForce( gust );
    }
    balloons[i].update();
    balloons[i].display();
    balloons[i].checkEdges();
  }
  
  t += 0.01;
  
}

PVector calculateWind() {
  PVector wind = new PVector();

  float xoff, yoff;
  xoff = random(100);
  yoff = random(100);

  wind.x = map(noise(xoff + t), 0.001, 1, -0.4, 0.5);
  wind.y = map(noise(yoff + t), 0, 1, -0.01, 0.01);
  
  return wind;
}