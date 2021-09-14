module elib/elib-utils/wikitext

imports elib/elib-bootstrap/icons

access control rules
rule page liveWikiTextPreview(){ true }

section templates

define outputRelaxed(s: WikiText){ rawoutput(s) }

section input wikitext with a preview
/*
 Usage: 
 	put inputWithPreview( someEnt.someWikiTextProp ) where you want the ordinary input on wikitext
 	put wikiTextPreview( someEnt.someWikiTextProp ) at the area where you want the preview to be displayed
*/

define inputWithPreview( txt : Ref<WikiText> ){
	inputWithPreview( txt, false )[all attributes]
}

define inputWithPreview( txt : Ref<WikiText>, unsafe : Bool){
  var owningEntity := txt.getEntity()
  var ph := if(owningEntity == null || owningEntity.version < 1) "wikitext-preview" else "ph-" + owningEntity.id.toString() + "-" + txt.getReflectionProperty().getName()
	inputWithPreview( txt, unsafe, ph )[all attributes]
	
}

native class utils.BuildProperties as BuildProperties {
	static isWikitextHardwrapsEnabled() : Bool
}
define inputWithPreview( txt : Ref<WikiText>, unsafe : Bool, ph : String){
	var mathjaxHelpHTML := ", <a href=\\\"http://docs.mathjax.org/en/v2.7-latest/mathjax.html\\\" target=\\\"_blank\\\" title=\\\"Opens in new window\\\">MathJax</a> enabled, with delimiters: <code>\\\\\\\\( inline \\\\\\\\)</code> and <code>$$ block $$</code>."
	var liveprevservice := navigate(liveWikiTextPreview())
	var jsonParams := "[{name:'inputText', value: textVal}" + ( if(unsafe) ",{name:'allowUnsafe', value:'1'}]" else "]")
	span[id=ph+"-wrap"]{
		input( txt )[oninput:="var textVal = $('#" + ph + "-wrap textarea').val(); checkForUnsupportedCharacters( textVal ); replaceWithoutAction('" + liveprevservice + "', " + jsonParams + ", '" + ph + "');", all attributes]
	}
	div[class="help-block"]{
		markdownHelpLink " " span[class="hardwraps-info"]{ if(BuildProperties.isWikitextHardwrapsEnabled()){ "New lines are preserved (hardwraps enabled)" } else { "Single new lines are ignored (hardwraps disabled)" } }
		span[id="mathjax-"+id]{}
		<script>
			if (typeof MathJax != "undefined"){
				$("#mathjax-~id").append( "~mathjaxHelpHTML" );
			}
		</script>
	}
}

define wikiTextPreview( txt : Ref<WikiText> ){
	wikiTextPreview( txt, false )

}
define wikiTextPreview( txt : Ref<WikiText>, unsafe : Bool ){
	var owningEntity := txt.getEntity()
	var ph := if(owningEntity == null || owningEntity.version < 1) "wikitext-preview" else "ph-" + owningEntity.id.toString() + "-" + txt.getReflectionProperty().getName()
	wikiTextPreview(txt, unsafe, ph)	
}
define wikiTextPreview( txt : Ref<WikiText>, unsafe : Bool, ph : String){
	placeholder ""+ph{  wikiTextPreviewInternal( txt, unsafe ) } 
}

define ignore-access-control wikiTextPreviewInternal( txt : WikiText, unsafe : Bool){
	if( unsafe ){
		rawoutput( txt )
	} else {
		output( txt )
	}
}

page liveWikiTextPreview(){
	mimetype("text/plain")
	var toRender := (getRequestParameter("inputText") as WikiText)
	// var scriptId := "preview-" + now().getTime()
	wikiTextPreviewInternal(toRender, getRequestParameter("allowUnsafe") != null)

//The following script is not needed anymore (requires WebDSL version > 13 Feb 2017) when using postProcess template, e.g.
//postProcess("Prism.highlightAll( node ); if(node != document){ MathJax.Hub.Queue([\"Typeset\",MathJax.Hub, node]); }")

	// <script id=scriptId>
	// var mathJaxEnabled = typeof MathJax != "undefined";
	// var prismEnabled = typeof Prism != "undefined";
	// if (mathJaxEnabled || prismEnabled){
	//   var parent = $('#~scriptId').parent();
	//   if(mathJaxEnabled){
	//     MathJax.Hub.Queue(["Typeset",MathJax.Hub, parent.get()]);
	//   }
	//   if(prismEnabled){
	//     Prism.highlightAll( parent );
	//   }
	// }
	// </script>
}

template markdownHelpLink(){
	navigate url("https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet")[target:="_blank", title:="Opens in new window"]{iQuestionSign() " Syntax Help"}
}