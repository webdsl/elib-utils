module elib/elib-utils/string

  type String{
    substring(Int,Int):String
  }

  entity StringPair { 
    left :: String
    right :: String
  }

  // does string have no other characters than whitespace?
  function isEmptyString(x : String) : Bool {
    return x == null || (x == "") || /[\n\t\r\ ]+/.replaceAll("", x) == "";
  }
  
  // remove trailing whitespace
  function removeTrailingSpaces(x : String) : String { 
    return /^[\n\t\ ]+/.replaceAll("",/[\n\t\ ]+$/.replaceAll("",x));
  }

  function words(x : String) : List<String> { 
    return /[\t\n\ ]+/.split(removeTrailingSpaces(x)); 
  }
  
  function lines(x: String): List<String> {
  	return /[\n]/.split(x);
  }
  
  function prefix(pref: String, lines: List<String>): List<String> {
  	return [pref + line | line: String in lines];
  }
  
  function text(lines: List<String>): String {
  	var t := "";
  	for(line: String in lines) { t := t + line + "\n"; }
  	return t;
  }
  
  function commentOut(comm: String, x: String): String {
  	// When the text is empty or contains only whitespace,
  	// do not comment out anything and just return an empty string.
  	if (isEmptyString(x)) { return ""; }
  	return text(prefix(comm, lines(x)));
  }
  
  function splitCommaSeparated(x : String) : List<String> {
      return [removeTrailingSpaces(y).toLowerCase() | y : String in x.split(",") where !isEmptyString(y)];
  }
  
  function paragraphs(x : String) : List<String> {
    return /[\n]([\t\ ]*[\n])+/.split(x);
  }
  
  function keyFromName(name : String) : String {
    return (/(\ )+|(\/)+/.replaceAll("-",removeTrailingSpaces(name))).toLowerCase(); 
  }
  
  // replace multiple adjacent whitespace with single space
  // remove trailing whitespace
  function normalizeName(name : String) : String {
    return /[\n\t\ ]+/.replaceAll(" ", removeTrailingSpaces(name));
  }

  function normalizeCiteKey(key : String) : String {
    return makeValidKeyForURL(/[\/+\n\t\ ]+/.replaceAll("-", removeTrailingSpaces(key)));
  }

  function isValidKeyForURL(url : String) : Bool {
    return /[a-zA-Z0-9:\-\.]+/.match(url);
  }

  function makeValidKeyForURL(url : String) : String {
    return /[^a-zA-Z0-9:\-\.]/.replaceAll("", url);
  }

  function prefix(x : String) : String {
    /*
    var p : String := "";
    var chars : List<String> := x.split();
    for(i : Int from 0 to chars.length) { p := p + chars.get(i); }
    return p;
    */
    return x;
  }

  function substring(x : String, i : Int, j : Int) : String {
    /*
    var p : String := "";
    var chars : List<String> := x.split();
    for(i : Int from max(0, min(i, chars.length)) to min(j, chars.length)) { p := p + chars.get(i); }
    return p;
    */
    return x.substring(i,j);
  }
  
  function isURL(x : String) : Bool {
    return !isEmptyString(x) && x != "http://" && x != "http:///";
    /* /"http:\/\/\*"/.match(x) && !isEmptyString(/"http:\/\/"/.replaceAll("",x)); */
  }
  
  function isAffiliation(x : String) : Bool {
    return !isEmptyString(x);
  }
  
  function isnull(x : String) : String { 
    if(x == null) { return ""; } else { return x; }
  }
  
  function prefixSuffix(s : String, prefixLen : Int, suffixLen : Int) : String{
  	if(s.length() <= (prefixLen + suffixLen+4)){
  		return s;
  	} else {
  		return prefix(s,prefixLen) + "... " + suffix(s,suffixLen);
  	}
  }
  
  function abbreviate(s : String, length : Int) : String {
    return abbreviate(s, length, true);
  }
  
  function abbreviate(s : String, length : Int, hardbreak : Bool) : String {
    if(s.length() <= length) {
      return s;
    } else {
      var abbr := if(hardbreak) prefix(s, length - 4) else /\S+$/.replaceAll("", prefix(s, length - 4));
      return abbr + " ...";
    }
  }
  
  function abbreviateNE(s : String, length : Int) : String {
    if(s.length() <= length) {
      return s;
    } else {
      return prefix(s, length);
    }
  }
    
  function concat(xs: List<String>, sep: String): String {
  	if(xs.length == 0) { 
  		return "";
  	} else {
  		var x := xs[0];
  		var i := 1;
  		while(i < xs.length) {
  			x := x + sep + xs[i];
  			i := i + 1;
  		}
  		return x;
  	}
  }

  type String{
    substring(Int):String
    substring(Int,Int):String
  }

  function prefix(s : String, length : Int) : String {
    return s.substring(0, length);
    /*
    if(s.length() <= length) {
      return s;
    } else {
      var sChar := s.split();
      sChar.removeAt(length);
      return prefix(sChar.concat(), length);
    }
    */
  }
  function suffix(s : String, length : Int) : String {
  	var len := s.length();
  	return s.substring(s.length()-min(length, len), s.length());
  }
  
	function plural(singular : String, num : Int ) : String{
	  return if(num == 1) singular else singular + "s";
	}
	function plural(singular : String, plural : String, num : Int) : String{
	  return if(num == 1) singular else plural;
	}
	function capitalize(name : String) : String{
	  return if( name.length() > 0 ) name.substring( 0,1 ).toUpperCase() + name.substring( 1, name.length() ) else name;
	}
  
section live preview on text

define inputWithPreview( txt : Ref<Text> ){
	inputWithPreview(txt, false)
}

define inputWithPreview( txt : Ref<Text>, rawoutput : Bool ){
	var owningEntity := txt.getEntity();
	var ph := if(owningEntity.version < 1) "html-preview" else "ph-" + (if(owningEntity != null) owningEntity.id.toString() else "");
	inputWithPreview( txt, rawoutput, ph )[all attributes]
}

define inputWithPreview( txt : Ref<Text>, rawoutput : Bool, ph : String){
	action ignore-validation updatePreview(){
		replace( ""+ph, livePreviewInternal(txt, rawoutput) );
		rollback();
	}
	input( txt )[oninput:=updatePreview(), all attributes]
}

define livePreview( txt : Ref<Text> ){
	livePreview(txt, false)
}

define livePreview( txt : Ref<Text>,  rawoutput : Bool ){
	var owningEntity := txt.getEntity();
	var ph := if(owningEntity.version < 1) "html-preview" else "ph-" + (if(owningEntity != null) owningEntity.id.toString() else "");
	livePreview(txt, rawoutput, ph)	
}
define livePreview( txt : Ref<Text>, rawoutput : Bool, ph : String){
	placeholder ""+ph{ livePreviewInternal( txt, rawoutput ) }
}

define ajax ignore-access-control livePreviewInternal( txt : Text, rawoutput : Bool ){
	if( rawoutput ){
		rawoutput( txt )
	} else {
		output( txt )
	}
}
