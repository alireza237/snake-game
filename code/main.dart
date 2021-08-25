import 'dart:html';
import 'dart:math';

CanvasElement platno;
CanvasRenderingContext2D ctx;
const int velikost=15;
Hlava hlava = new Hlava();
Stopwatch stopky = new Stopwatch();
int rychlost = 400;
List<Clanek> ocas= new List<Clanek>();
List<Clanek> mazanejOcas = new List<Clanek>();
List<Jidlo> vecere = new List<Jidlo>();
List<Jidlo> mazanaVecere = new List<Jidlo>();
bool konecHry=false;


void main() {
  platno = querySelector("#platno");
     ctx = platno.context2D;      
     init();
}


void init(){
  stopky.start();
  ctx.beginPath();
  ctx.fillStyle="grey";
  ctx.fillRect(0, 0, platno.width, platno.height);
  ctx.fill();
  window.onKeyDown.listen(zpracujKlavesu);
  draw();
}

void zpracujKlavesu(KeyboardEvent k){
  hlava.zmenSmer(k);  
}

void draw(){
  ctx.fillStyle="grey";
  ctx.beginPath();
  ctx.fillRect(0,0,platno.width,platno.height);
  ctx.fill();
  hlava.vykresliSe(ctx);
  vecere.forEach((jidlo)=> jidlo.vykresliSe(ctx));
  ocas.forEach((clanek) => clanek.vykresliSe(ctx));
  if (!konecHry) window.requestAnimationFrame(loop);
  else {
    ctx.fillStyle= 'black';
    ctx.fillText("Konec Hry!", 300, 300);
  }
}


void loop(num _){
  if ( stopky.elapsedMilliseconds>rychlost){
    hlava.pohyb();
    vecere.forEach((jidlo){
      if (jidlo.kolizniTest(hlava)){
        hlava.delka+=1;
        ocas.forEach((clanek)=> clanek.zivoty+=1);
        mazanaVecere.add(jidlo);
      }
    });
    
    ocas.forEach((clanek){
      if (clanek.kolizniTest(hlava)){
        konecHry=true;
      }
    });
    ocas.forEach((clanek){
      if (!clanek.zije()){
        mazanejOcas.add(clanek);
      }
    });
    mazanejOcas.forEach((clanek)=> ocas.remove(clanek));
    mazanejOcas.clear();
    mazanaVecere.forEach((jidlo)=> vecere.remove(jidlo));
    mazanaVecere.clear();
    if (vecere.length<3) Jidlo jidlo = new Jidlo();
    
    stopky.reset();
  }
  
  draw();
}



abstract class HerniObjekt{
  var x;
  var y;
  String barva;
  
  
  
  bool kolizniTest(HerniObjekt _obj) {
    Rectangle tento = new Rectangle(x, y, velikost, velikost);
    Rectangle tamten = new Rectangle(_obj.x, _obj.y, velikost, velikost);
    return tento.containsRectangle(tamten);
    
  }
  
  void znicSe(){
    
  }
  
  void vykresliSe(CanvasRenderingContext2D _ctx){
    _ctx.fillStyle = barva;
    _ctx.beginPath();
    _ctx.fillRect(x, y, velikost, velikost);
    _ctx.fill();
  }
}

class Hlava extends HerniObjekt{
 int smer;
 int delka;
 

 Hlava(){
   var random = new Random();
   x= random.nextInt(39)*15;
   y= random.nextInt(39)*15;
   smer = random.nextInt(3);
   barva = "red";
   delka = 3;
 }


 void zmenSmer(KeyboardEvent k){
   switch (k.keyCode)
   {
     case 37: smer = 3; break;
     case 38: smer = 0; break;
     case 39: smer = 1; break;
     case 40: smer = 2; break;
   }
 }

 void pohyb(){
   int docasneX=x;
   int docasneY=y;
   switch (smer){
     case 3: x -= velikost; if (x<0) x=585;break;
     case 0: y -= velikost; if (y<0) y=585;break;
     case 1: x += velikost; if (x>585) x=0;break;
     case 2: y += velikost; if (y>585) y=0;break;
   }
   
   Clanek clanek = new Clanek(docasneX,docasneY,delka);
   ocas.add(clanek);
 }
 
 void prodluzSe(){
   
 }
}

class Clanek extends HerniObjekt{
 int zivoty;
 
 Clanek(int _x, int _y, int _zivoty){
   barva = 'green';
   x = _x;
   y = _y;
   zivoty = _zivoty;
 }
 bool zije(){
   if ( zivoty > 1) {
     zivoty -= 1;
     return true;
     }
   else return false;
 }
}

class Jidlo extends HerniObjekt{
  Jidlo(){
     var random = new Random();
     x= random.nextInt(39)*15;
     y= random.nextInt(39)*15;
     barva = "blue";
     vecere.add(this);
  }
}