class TextureSphere {
  int nSegs;
  float a;
  float c;
  PImage img;
  
  TextureSphere(float at, float ct, int numSegs, PImage tex) {
   a = at;
   c = ct;
   nSegs = numSegs;
   img = tex; 
  }
  
  float xpos(float u, float v) {
    return (c + a * cos(v)) * cos(u);
  }
  
  float ypos(float u, float v) {
    return (c + a * cos(v)) * sin(u);
  }
  
  float zpos(float u, float v) {
   return a * sin(v); 
  }
  
  void createVertex(float u, float v) {
   float x = xpos(u,v);
   float y = ypos(u,v);
   float z = zpos(u,v);

   PVector norm = new PVector(x,y,z);
   norm.normalize();
   normal(norm.x,norm.y,norm.z);
   vertex(x,y,z,map(u,0,2 * PI,0,1),map(v,-PI, PI, 0,1));
  }
  
  float xposK(float u, float v) {
    return (a + cos(.5 * u) * sin(v) -  sin(.5 * u) * sin(2 * v)) * cos(u); 
  }
  
  float yposK(float u, float v) {
    return (a + cos(.5 * u) * sin(v) - sin(.5 * u) * sin(2 * v)) * sin(u);
  }
  
  float zposK(float u, float v) {
     return sin(.5 * u) * sin(v) + cos(.5 * u) * sin(2 * v);
  }  
  
  void createVertexK(float u, float v,float shift,float shift_two) {
   float x = c * xposK(u,v);
   float y = c * yposK(u,v);
   float z = c * 2 * zposK(u,v);

   PVector norm = new PVector(x,y,z);
   norm.normalize();
   normal(-norm.x,-norm.y,-norm.z);
   vertex(x,y,z,map(u,0 + shift,2 * PI + shift,0,1),map(v,-PI + shift_two, PI + shift_two, 0,1));
  }  
  
  
  void displayKlein(float shift,float shift_two) {
    beginShape(QUADS);
    texture(img);
    textureMode(NORMAL);
    float ustep = 2 * PI / nSegs;
    float vstep = PI / nSegs;
    for(float u = 0 + shift;u < 2 * PI + shift; u += ustep) {
      for(float v = -PI + shift_two;v < PI + shift_two;v += vstep) {
        createVertexK(u,v,shift,shift_two);
        createVertexK(u + ustep,v,shift,shift_two);
        createVertexK(u + ustep,v + vstep,shift,shift_two);
        createVertexK(u,v + vstep,shift,shift_two);
      }
    }  
    
    endShape(); 
  }

  
  void display() {
    beginShape(QUADS);
    texture(img);
    textureMode(NORMAL);
    float ustep = 2 * PI / nSegs;
    float vstep = PI / nSegs;
    for(float u = 0;u < 2 * PI; u += ustep) {
      for(float v = -PI;v < PI;v += vstep) {
        createVertex(u,v);
        createVertex(u + ustep,v);
        createVertex(u + ustep,v + vstep);
        createVertex(u,v + vstep);
      }
    }  
    
    endShape(); 
  }
}
