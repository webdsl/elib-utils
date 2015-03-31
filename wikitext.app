module elib/elib-utils/wikitext

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
	var owningEntity := txt.getEntity();
	var ph := if(owningEntity.version < 1) "wikitext-preview" else "ph-" + (if(owningEntity != null) owningEntity.id.toString() else "");
	inputWithPreview( txt, unsafe, ph )[all attributes]
	
}

native class utils.BuildProperties as BuildProperties {
	static isWikitextHardwrapsEnabled() : Bool
}
define inputWithPreview( txt : Ref<WikiText>, unsafe : Bool, ph : String){
	var mathjaxHelpHTML := ", <a href='http://docs.mathjax.org/en/latest/mathjax.html'>MathJax</a> enabled, with delimiters: <code>\\\\\\\\( inline \\\\\\\\)</code> and <code>$$ block $$</code>."
	var liveprevservice := navigate(liveWikiTextPreview())
	var jsonParams := "[{name:'inputText', value:$('#" + ph + "-wrap textarea').val()}" + ( if(unsafe) ",{name:'allowUnsafe', value:'1'}]" else "]")
	span[id=ph+"-wrap"]{
		input( txt )[oninput:="replaceWithoutAction('" + liveprevservice + "', " + jsonParams + ", '" + ph + "');", all attributes]
	}
	div{
		markdownHelpLink " " span[class="hardwraps-info"]{ if(BuildProperties.isWikitextHardwrapsEnabled()){ "New lines are preserved (hardwraps enabled)" } else { "Single new lines are ignored (hardwraps disabled)" } }
		span[id="mathjax-"+ph]{}
		<script>
			if (typeof MathJax != "undefined"){
				$("#mathjax-~ph").append( "~mathjaxHelpHTML" );
			}
		</script>
	}
}

define wikiTextPreview( txt : Ref<WikiText> ){
	wikiTextPreview( txt, false )

}
define wikiTextPreview( txt : Ref<WikiText>, unsafe : Bool ){
	var owningEntity := txt.getEntity()
	var ph := if(owningEntity.version < 1) "wikitext-preview" else "ph-" + (if(owningEntity != null) owningEntity.id.toString() else "")
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
	var scriptId := getTemplate().getUniqueId()
	wikiTextPreviewInternal(toRender, getRequestParameter("allowUnsafe") != null)
	<script id=scriptId>
		if (typeof MathJax != "undefined"){
			MathJax.Hub.Queue(["Typeset",MathJax.Hub, $('#~scriptId').parent().attr('id')]);
		}
	</script>
}

template markdownHelpLink(){
	navigate url("https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet")[target:="_blank", title:="Opens in new window"]{iQuestionSign() " Syntax Help"}
}