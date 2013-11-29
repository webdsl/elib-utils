module elib-utils/wikitext

define outputRelaxed(s: WikiText){ rawoutput(s) }

//for WebDSL versions < r5693 use:
//define outputRelaxed(s: WikiText){ rawoutput(s.relaxedFormat()) }
//type WikiText{ org.webdsl.tools.RelaxedWikiFormatter.wikiFormat as relaxedFormat():String }
