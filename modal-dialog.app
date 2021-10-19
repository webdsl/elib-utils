module elib/elib-utils/modal-dialog

imports elib/elib-utils/lib

  define modalDialogPopup(context: String) {
    action close() { replace(context+"", empty); }
    <div class="modalDialogBG">
      <div class="modalDialog">
         block[class="modalDialogClose"]{ 
           submitlink close() { "[close]" }
         }
         elements
      </div>
    </div>
  }
  
  

  
