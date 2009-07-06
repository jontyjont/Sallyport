var currelem=""

var flagLoaded=false
var currTimer=0
var current=0
var currFunction=nextpic

pictures=new Array(3);

function loadimgs(){
  pictures[0]=new Image();
pictures[0].src='/images/morpeth.jpg';
pictures[1]=new Image();
pictures[1].src='/images/pithead.jpg';
pictures[2]=new Image();
pictures[2].src='/images/Tanfield gates.jpg';

  }
  
  function nextpic(){
  currelem.src=pictures[current].src;
  currelem.setOpacity(0);
  count=0;
  fadein();
 current++;
 if(current==3){current=0};
     
  }
  
  function checkload() {
     
  if (pictures[0].complete&&pictures[1].complete&&pictures[2].complete){
      flagLoaded=true;
     clearInterval(currTimer);
     current=0
     currelem.src=pictures[current].src;
     current ++ ;
     fadein();
  }
  
  }
  
  function fadein(){
  clearInterval(currTimer);
  clearTimeout(currTimer);
  
     currelem.appear({duration:2.0});
         currTimer= setTimeout('fadeout()',8000);
      }
       




function fadeout(){
 
  currelem.fade({duration: 3.0});  
   
 currTimer=setTimeout('currFunction()',3300);
  

}

function imagerotate(){
 currFunction=nextpic;
currelem=$("viewer");
currelem.setOpacity(0);
loadimgs();
currTimer=setInterval("checkload()",100);
 
}

function empty(){};




function showInfo(text){
 count=0;
 clearInterval(currTimer);
  clearTimeout(currTimer);
  currFunction=empty;
  currelem.update(text);
  currelem.setOpacity(0);
  currelem.setStyle('visibility:visible;');
 fadein();
}
