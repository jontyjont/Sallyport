timer1=0;
timer2=0;
timerScroll=0;

flagSlideShow= false;
flagPortrait=false;



function loadPic() {
	if (pics[0].complete)
	{
	clearTimeout(timer1);
	toViewer(0);
	setInterval('resizeImg()',1000);
	thumbs();
	
	}
	else
	{
	checkReady();
	}
	
}


var h
var w
  
  function resizeImg(){
  x=WWidth();
  if (h!=x/2)
  {
	  h=x/3;
	  w=x/2
	  if (flagPortrait==true)
	  {
	 	 w=x/3;
	  }
	 
	  Element.setStyle($("viewer"),"width:"+w.toString()+";height:"+h.toString()+";");
  }
  }
  
  
      function WWidth()
 
      {

              var x = 0;
   
              if (self.innerHeight)
  
              {
 
                      x = self.innerWidth;

              }

              else if (document.documentElement && document.documentElement.clientHeight)
  
              {
  
                      x = document.documentElement.clientWidth;
  
              }
  
              else if (document.body)
 
              {

                      x = document.body.clientWidth;
 
              }
  
              return x;

      }
  
       

      function WHeight()

      {

              var y = 0;

              if (self.innerHeight)

              {

                      y = self.innerHeight;

              }

              else if (document.documentElement && document.documentElement.clientHeight)

              {
               y = document.documentElement.clientHeight;

              }

              else if (document.body)

              {
 
                      y = document.body.clientHeight;

              }

              return y;

      }



function checkReady()
{
	timer1=setTimeout('loadPic()',300);
}



function thumbs() {

for (i=0;i<pics.length;i++)
{
	
	Element.insert($('main'),"<div class='thumb' onClick="+
	'fromThumb('+i.toString()+');'
	+"><img id=thumb"+
	i.toString()+" src="+
	pics[i].src+" width=120 height=90 " + 
	"\/><\/div>" );
}

}

function fromThumb(indx){
if (flagSlideShow)
{
	slideshow();
}
scroll();

setTimeout('toViewer('+indx.toString()+');',1000);
}

function toViewer(index) {
Effect.Fade($("viewer"),{duration:0.5});
flagPortrait=false;
setTimeout('delayView('+index.toString()+')', 900);
}

function delayView(indx){
document.getElementById("viewer").src=pics[indx].src; 
if (imageinfo[indx][3]=="true")
{flagPortrait=true;}
nm=imageinfo[indx][0]
ev=imageinfo[indx][1];
yr=imageinfo[indx][2];
comment=imageinfo[indx][4];
str ="<div class='imgmeta' id='meta'>"
str+="<h3>This Picture:</h3>";
str+="<p> "+nm.toString()+"<br/>";
str +=  ev.toString()+" event<br/>";
str += yr.toString()+"<br/>";
str += comment.toString()+"</p>";
str+="</div>"
Element.replace("meta",str);
Effect.Appear($("viewer"), {duration: 0.5});
}

var index =0;

function slideshow(){
if (flagSlideShow)
{
	clearInterval(timer2);
	flagSlideShow=false;
}
else {
flagSlideShow=true;
index = -1;
nextpic();
timer2=setInterval('nextpic()',8000);
}
}

function nextpic(){
if (index>=pics.length-1)
{
index=0;
}
else
{
index++;
}

toViewer(index);

}

//aniscroll performs poorly on ie and chrome .'. kiss!
function aniscroll()
{
	timerScroll=setInterval('scroll();' , 100);
}

function getScrollXY() {
  var scrOfX = 0, scrOfY = 0;
  if( typeof( window.pageYOffset ) == 'number' ) {
    //Netscape compliant
    scrOfY = window.pageYOffset;
    scrOfX = window.pageXOffset;
  } else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
    //DOM compliant
    scrOfY = document.body.scrollTop;
    scrOfX = document.body.scrollLeft;
  } else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
    //IE6 standards compliant mode
    scrOfY = document.documentElement.scrollTop;
    scrOfX = document.documentElement.scrollLeft;
  }
  return   scrOfY ;
}

function scroll()
{
	//~ y=getScrollXY();
	//~ if (y<=150)
	//~ {
		//~ clearInterval(timerScroll);
	//~ }
	//~ else
	//~ {
		//~ scrollBy(0,-100);
	//~ }
	
	//kiss!:
	
	scrollTo(0,150);
	
}

function replaceTD(id)
{
	
}