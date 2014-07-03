module elib/elib-utils/markup 
  
section markup

  template header1(){ <h1> elements </h1> }
  template header2(){ <h2> elements </h2> }
  template header3(){ <h3> elements </h3> }
  template header4(){ <h4> elements </h4> }
  template header5(){ <h5> elements </h5> }
  template header6(){ <h6> elements </h6> }
  
  template anchorHeader1(){ var hashtext:=/\W/.replaceAll("-", rendertemplate(elements)); <h1><a href="#"+hashtext style="text-decoration:inherit; color:inherit;" name=hashtext class="anchor">elements</a></h1>}
  template anchorHeader2(){ var hashtext:=/\W/.replaceAll("-", rendertemplate(elements)); <h2><a href="#"+hashtext style="text-decoration:inherit; color:inherit;" name=hashtext class="anchor">elements</a></h2>}
  template anchorHeader3(){ var hashtext:=/\W/.replaceAll("-", rendertemplate(elements)); <h3><a href="#"+hashtext style="text-decoration:inherit; color:inherit;" name=hashtext class="anchor">elements</a></h3>}
  template anchorHeader4(){ var hashtext:=/\W/.replaceAll("-", rendertemplate(elements)); <h4><a href="#"+hashtext style="text-decoration:inherit; color:inherit;" name=hashtext class="anchor">elements</a></h4>}
  template anchorHeader5(){ var hashtext:=/\W/.replaceAll("-", rendertemplate(elements)); <h5><a href="#"+hashtext style="text-decoration:inherit; color:inherit;" name=hashtext class="anchor">elements</a></h5>}
  template anchorHeader6(){ var hashtext:=/\W/.replaceAll("-", rendertemplate(elements)); <h6><a href="#"+hashtext style="text-decoration:inherit; color:inherit;" name=hashtext class="anchor">elements</a></h6>}         
  
  template hrule(){ <hr /> }
  
//  template par() { <p> elements </p> }

section dynamic styling

template contrastText(itemClass : String){
	<script>
	    $('.~itemClass').each(function(){
		    var rgb = $(this).css( "background-color" ).match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
		    
		    //http://www.w3.org/TR/AERT#color-contrast		    
		    var o = Math.round(((parseInt(rgb[1]) * 299) + (parseInt(rgb[2]) * 587) + (parseInt(rgb[3]) * 114)) /1000);
		    
		    if(o > 125) {
		        $(this).css('color', 'black');
		    }else{ 
		        $(this).css('color', 'white');
		    }
		});
	</script>
}

section forms

  // define formEntry(l: String){ 
  //   <div class="formentry">
  //     <span class="formentrylabel">output(l)</span>
  //     elements
  //   </div>
  // }
  
  define save() { submit action{ } { "Save" } }

