module elib/elib-utils/wikitext

define outputRelaxed(s: WikiText){ rawoutput(s) }

section input wikitext with a preview
/*
 Usage: 
 	put inputWithPreview( someEnt.someWikiTextProp ) where you want the ordinary input on wikitext
 	put wikiTextPreview( someEnt.someWikiTextProp ) at the area where you want the preview to be displayed
*/
define inputWithPreview( txt : Ref<WikiText> ){
	var owningEntity := txt.getEntity();
	var ph := "ph-" + (if(owningEntity != null) owningEntity.id.toString() else "");
	action ignore-validation updatePreview(){
		replace( ""+ph, wikiTextPreviewInternal(txt) );
	}
	input( txt )[onkeyup:=updatePreview()]
}

define wikiTextPreview( txt : Ref<WikiText> ){
	var owningEntity := txt.getEntity();
	var ph := "ph-" + (if(owningEntity != null) owningEntity.id.toString() else "");
	placeholder ""+ph{ wikiTextPreviewInternal( txt ) }
}

define ajax ignore-access-control wikiTextPreviewInternal( txt : WikiText ){
	output( txt )
}