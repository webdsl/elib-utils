module elib/elib-utils/wikitext

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
	inputWithPreview( txt, false, ph )[all attributes]
	
}
define inputWithPreview( txt : Ref<WikiText>, unsafe : Bool, ph : String){
	action ignore-validation updatePreview(){
		replace( ""+ph, wikiTextPreviewInternal(txt, unsafe) );
		rollback();
	}
	input( txt )[onkeyup:=updatePreview(), all attributes]
	markdownHelpLink
}

define wikiTextPreview( txt : Ref<WikiText> ){
	wikiTextPreview( txt, false )

}
define wikiTextPreview( txt : Ref<WikiText>, unsafe : Bool ){
	var owningEntity := txt.getEntity();
	var ph := if(owningEntity.version < 1) "wikitext-preview" else "ph-" + (if(owningEntity != null) owningEntity.id.toString() else "");
	wikiTextPreview(txt, unsafe, ph)	
}
define wikiTextPreview( txt : Ref<WikiText>, unsafe : Bool, ph : String){
	placeholder ""+ph{ wikiTextPreviewInternal( txt, unsafe ) }
}

define ajax ignore-access-control wikiTextPreviewInternal( txt : WikiText, unsafe : Bool ){
	if( unsafe ){
		rawoutput( txt )
	} else {
		output( txt )
	}
}


template markdownHelpLink(){
	navigate url("https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet")[target:="_blank", title:="Opens in new window"]{iQuestionSign() " Syntax Help"}
}