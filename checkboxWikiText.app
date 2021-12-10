module elib/elib-utils/checkboxWikiText


section checkbox 

  template selectcheckboxWiki(set:Ref<Set<Entity>>){
    selectcheckboxWiki(set, set.getAllowed())[all attributes]{ elements }
  }
  template selectcheckboxWiki(set:Ref<Set<Entity>>, readonly: Bool){

    if(readonly){
      selectcheckboxWiki(set)[all attributes, disabled="true"]{ elements }
    } else{
      selectcheckboxWiki(set)[all attributes]{ elements }
    }
    
  }
  
  template selectcheckboxWiki(set:Ref<Set<Entity>>, from : List<Entity>){
    
    template outputLabel(e : Entity){
      output(e.name as WikiText)
    }
    selectcheckbox(set, from)[all attributes]{
      elements
    }
  }
