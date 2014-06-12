module elib/elib-utils/lib

imports elib/elib-utils/math 
imports elib/elib-utils/pageindex
imports elib/elib-utils/string
imports elib/elib-utils/accesscontrol
imports elib/elib-utils/datetime
imports elib/elib-utils/markup 
imports elib/elib-utils/editable
imports elib/elib-utils/coordinates
imports elib/elib-utils/modal-dialog
imports elib/elib-utils/rss
imports elib/elib-utils/wikitext
imports elib/elib-utils/counter
imports elib/elib-utils/tabs
imports elib/elib-utils/list
imports elib/elib-utils/checkboxWikiText
imports elib/elib-utils/geo

section ajax lib

  define ajax ignore-access-control empty(){}
  
  	native class java.lang.StringBuffer as StringBuffer{
  		toString() : String
  		append(String) : StringBuffer
  	}
	native class javax.servlet.http.HttpServletRequest as HttpServletRequest{
    	getRequestURL() : StringBuffer
    	getQueryString() : String
	}
	
  function requestURL(): String {
  	var request := getDispatchServlet().getRequest();
  	if(request.getQueryString() == null){
  		return request.getRequestURL().toString();	
  	} else{
  		return request.getRequestURL().append("?").append(request.getQueryString()).toString();
	}
  }
  