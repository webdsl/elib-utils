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
define inputWithPreview( txt : Ref<WikiText>, unsafe : Bool ){
	var owningEntity := txt.getEntity();
	var ph := "ph-" + (if(owningEntity != null) owningEntity.id.toString() else "");
	action ignore-validation updatePreview(){
		replace( ""+ph, wikiTextPreviewInternal(txt, unsafe) );
	}
	input( txt )[onkeyup:=updatePreview(), all attributes]
}

define wikiTextPreview( txt : Ref<WikiText> ){
	wikiTextPreview( txt, false )
}
define wikiTextPreview( txt : Ref<WikiText>, unsafe : Bool  ){
	var owningEntity := txt.getEntity();
	var ph := "ph-" + (if(owningEntity != null) owningEntity.id.toString() else "");
	placeholder ""+ph{ wikiTextPreviewInternal( txt, unsafe ) }
}

define ajax ignore-access-control wikiTextPreviewInternal( txt : WikiText, unsafe : Bool ){
	if( unsafe ){
		rawoutput( txt )
	} else {
		output( txt )
	}
}