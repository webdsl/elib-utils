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
	inputWithPreview( txt, unsafe, ph )[all attributes]
	
}

native class utils.BuildProperties as BuildProperties {
	static isWikitextHardwrapsEnabled() : Bool
}
define inputWithPreview( txt : Ref<WikiText>, unsafe : Bool, ph : String){
	// var hardWrapToggle := !(/^<!--(DISABLE_HARDWRAPS|NO_HARDWRAPS)-->/.find(txt));
	// var sm := "<";
	
	action ignore-validation updatePreview(){
		replace( ""+ph, wikiTextPreviewInternal(txt, unsafe) );
		rollback();
	}
	action ignore-validation toggleHW(){
		
	}
	span[id=ph+"-wrap"]{
	input( txt )[oninput:=updatePreview(), all attributes]
	}
	div{
		// <input type="checkbox" id=ph+"-hwtoggle"> " Preserve new lines" </input> " "
		markdownHelpLink " " span[class="hardwraps-info"]{ if(BuildProperties.isWikitextHardwrapsEnabled()){ "New lines are preserved (hardwraps enabled)" } else { "Single new lines are ignored (hardwraps disabled)" } }
	}
	// <script>
	// 	$('#~ph'+'-hwtoggle').prop('checked', ~hardWrapToggle);
	// 	$('#~ph'+'-hwtoggle').change(function() {
	// 		var input = $('#~(ph)' + '-wrap textarea');
	// 		var currentVal = input.val();
	//         if($(this).is(":checked")) {
	//             var newVal = currentVal.replace(/^~sm!--(DISABLE_HARDWRAPS|NO_HARDWRAPS)-->[\r\n]?/,"")
	//             input.val(newVal);
	//             input.trigger('oninput');
	//         } else {
	//         	if(!( /^~sm!--(DISABLE_HARDWRAPS|NO_HARDWRAPS)-->/.test(currentVal) )){
	// 	            var newVal = '~sm!--DISABLE_HARDWRAPS-->\n'+currentVal;
	// 	            input.val(newVal);
	// 	            input.trigger('oninput');
	//             }
	//         }     
	//     });
	// </script>
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