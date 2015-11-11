PImage img;
TextureSphere ts;
TextureSphere sec;
PVector horizontal = new PVector(1,0,0);
PVector vertical = new PVector(0,1,0);
PVector out = new PVector(0,0,1);
PVector circle = new PVector(0,300,0);


PVector rotateZP(PVector r, float theta) {
  return ApplyMatrix(r,
                     cos(theta),-sin(theta),0,0,
                     sin(theta),cos(theta),0,0,
                     0,         0,         1,0,
                     0,         0,         0,1);
                     
}

void RotateZs(float theta) {
 horizontal = rotateZP(horizontal,theta);
 vertical =   rotateZP(vertical,theta);
 out =        rotateZP(out,theta); 
}

PVector rotateXP(PVector r, float theta) {
  return ApplyMatrix(r,
                     1, 0          ,0         ,0,
                     0, cos(theta),sin(theta),0,
                     0, -sin(theta), cos(theta),0,
                     0, 0,         0          ,1);
}

void RotateXs(float theta) {
  horizontal = rotateXP(horizontal,theta);
  out        = rotateXP(out,theta);
  vertical   = rotateXP(vertical,theta);
}

PVector rotateYP(PVector r,float theta) {
  return ApplyMatrix(r,
                     cos(theta), 0,   -sin(theta),  0,
                     0,          1,   0,            0,
                     sin(theta), 0,   cos(theta),   0,
                     0,          0,   0,            1);
}

void RotateYs(float theta) {
  horizontal = rotateYP(horizontal,theta);
  out =        rotateYP(out,theta);
  vertical =   rotateYP(vertical,theta);
}

void setup() {
 size(700,700,P3D);
 img = loadImage("earth.jpg"); 
 ts = new TextureSphere(3,50,45,img);
 
 PVector cp_vert = PVector.random3D();
 println(cp_vert.x + " " + cp_vert.y + " " + cp_vert.z);
 cp_vert = rotateZP(cp_vert,PI / 6);
 cp_vert = rotateZP(cp_vert,-PI / 6);
 println(cp_vert.x + " " + cp_vert.y + " " + cp_vert.z);
 
 pushMatrix();
}


boolean MorePositiveThanNot(PVector a) {
 int i = 0;
 if (a.x >= 0) i += 1;
 if (a.y >= 0) i += 1;
 if (a.z >= 0) i += 1;
 return i >= 2; 
}

void rotateAroundAxis(PVector axis, float theta) {
  PVector n = new PVector(axis.x,axis.y,axis.z);
  println(n.z);
  n.normalize();
  float alpha;
  if (n.x != 0 || n.z != 0) alpha = asin(n.x / sqrt(n.x*n.x + n.z*n.z));
  else alpha = 0;
  if(n.z < 0) alpha = PI - alpha;
  //float alpha = atan(n.x / n.z);
  n = new PVector(n.x*cos(alpha) - n.z*sin(alpha),
                  n.y, 
                  n.x*sin(alpha) + n.z*cos(alpha));
  n.normalize();
  float gamma = acos(n.dot(new PVector(0,0,-1)));
  if(axis.y < 0) gamma = acos(n.dot(new PVector(0,0,1)));
  
  if (n.y < 0) theta = -theta;
  
  rotateY(alpha);
  rotateX(gamma);
  rotateZ(theta);
  rotateX(-gamma);
  rotateY(-alpha);
  
  // This rotates the horizontal vector and the vector that points to the screen
  RotateYs(alpha);
  RotateXs(gamma);
  RotateZs(-theta);
  RotateXs(-gamma);
  RotateYs(-alpha);
  
  horizontal.normalize();
  vertical.normalize();
  out.normalize();
}

PVector ApplyMatrix(PVector v,
                    float a1, float a2, float a3, float a4,
                    float b1, float b2, float b3, float b4,
                    float c1, float c2, float c3, float c4,
                    float d1, float d2, float d3, float d4) {
  float x = v.x;
  float y = v.y;
  float z = v.z;
  return new PVector(x * a1 + y * a2 + z * a3 + 1 * a4,
                     x * b1 + y * b2 + z * b3 + 1 * b4,
                     x * c1 + y * c2 + z * c3 + 1 * c4);
                      
                    }                    


int t = 0;

void drawDebug(PVector v) {
  strokeWeight(5);
  stroke(255);
  line(0,0,0,v.x * 300,v.y * 300,v.z * 300);
  translate(v.x * 300,v.y * 300,v.z * 300);
  sphere(10);
  translate(-v.x * 300,-v.y * 300,-v.z * 300);
}

float sign(float n) {
 return abs(n) / n; 
}

float shift = 0;
float shift_two = 0;

boolean xy = true;
void keyPressed() {
 xy = !xy; 
 if (key == 'z') speedShift = speedShift / 2;
 else speedShift = speedShift * 2;
}

float speedShift = 2048;

void draw() {

 popMatrix();
 lights();
 translate(width / 2, height / 2,0);
 background(0);
 circle = rotateZP(circle,PI / 128);
 translate(circle.x,circle.y,circle.z);
 pushStyle();
 fill(color(255,191,0));
 sphere(10);
 popStyle();
 translate(-circle.x,-circle.y,-circle.z); 
 pointLight(255,191,0,circle.x,circle.y,circle.z);
 pointLight(191,120,0,0,0,0);
 //drawDebug(horizontal);
 //drawDebug(vertical);
 //drawDebug(out);
 
 if ((mousePressed && (pmouseX != mouseX || pmouseY != mouseY))) {
   
   PVector dir = new PVector(mouseX - pmouseX,mouseY - pmouseY,0);
   //PVector dir;
   //if (xy) dir = new PVector(mouseX - pmouseX,0,0);
   //else dir = new PVector(0,mouseY - pmouseY,0);
   PVector new_dir = PVector.add(PVector.mult(horizontal,dir.x),PVector.mult(vertical,dir.y));
   new_dir.normalize();
   PVector axis = new_dir.cross(out);
   axis.normalize();
   //drawDebug(axis);
   
   PVector pAxis = dir.cross(new PVector(0,0,1));
   if (dir.mag() != 0) {
     rotateAroundAxis(axis,1 * dir.mag() / 150);
     //rotateAroundAxisTwo(axis,dir.mag() / 150);
   }
 }

 


 
 noStroke();
 ts.displayKlein(shift,shift_two);
 shift += PI / speedShift;
 shift_two += PI / speedShift;
 translate(-width / 2, - height / 2,0);
 pushMatrix();
}























void rotateAroundAxisTwo(PVector axis, float theta) {
  if (axis.x == 0 && axis.y == 0) {
   rotateZ(theta);
   RotateZs(-theta);
   return;
  }
  if (axis.y == 0 && axis.z == 0) {
   rotateX(theta);
   RotateXs(-theta);
   return;
  }
  if (axis.x == 0 && axis.z == 0) {
   rotateY(theta);
   RotateYs(-theta);
   return;
  }
  PVector w = axis.get();
  w.normalize();
  PVector t = w.get();
  if (w.x == min(w.x, w.y, w.z)) {
    t.x = 1;
  } 
  else if (w.y == min(w.x, w.y, w.z)) {
    t.y = 1;
  } 
  else if (w.z == min(w.x, w.y, w.z)) {
    t.z = 1;
  }
  PVector u = w.cross(t);
  u.normalize();
  PVector v = w.cross(u);
  applyMatrix(u.x, v.x, w.x, 0, 
              u.y, v.y, w.y, 0, 
              u.z, v.z, w.z, 0, 
              0.0, 0.0, 0.0, 1);
              
  horizontal = ApplyMatrix(horizontal,
              u.x, v.x, w.x, 0, 
              u.y, v.y, w.y, 0, 
              u.z, v.z, w.z, 0, 
              0.0, 0.0, 0.0, 1);
  out = ApplyMatrix(out,
              u.x, v.x, w.x, 0, 
              u.y, v.y, w.y, 0, 
              u.z, v.z, w.z, 0, 
              0.0, 0.0, 0.0, 1);
  vertical = ApplyMatrix(vertical,
              u.x, v.x, w.x, 0, 
              u.y, v.y, w.y, 0, 
              u.z, v.z, w.z, 0, 
              0.0, 0.0, 0.0, 1);    
              
  rotateZ(theta);
  RotateZs(-theta);
  
  applyMatrix(u.x, u.y, u.z, 0, 
              v.x, v.y, v.z, 0, 
              w.x, w.y, w.z, 0, 
              0.0, 0.0, 0.0, 1);
              
  horizontal = ApplyMatrix(horizontal,
              u.x, u.y, u.z, 0, 
              v.x, v.y, v.z, 0, 
              w.x, w.y, w.z, 0, 
              0.0, 0.0, 0.0, 1);
  vertical = ApplyMatrix(vertical,
              u.x, u.y, u.z, 0, 
              v.x, v.y, v.z, 0, 
              w.x, w.y, w.z, 0, 
              0.0, 0.0, 0.0, 1);
  out = ApplyMatrix(out,
              u.x, u.y, u.z, 0, 
              v.x, v.y, v.z, 0, 
              w.x, w.y, w.z, 0, 
              0.0, 0.0, 0.0, 1);
  
}
