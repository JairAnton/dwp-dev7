({
    sectionZero : function(component, event, helper) {
       helper.helperFun(component,event,'articleZero');
    },

    sectionOne : function(component, event, helper) {
       helper.helperFun(component,event,'articleOne');
    },
    
   sectionTwo : function(component, event, helper) {
      helper.helperFun(component,event,'articleTwo');
    },
   
   sectionThree : function(component, event, helper) {
      helper.helperFun(component,event,'articleThree');
   },
   
   sectionFour : function(component, event, helper) {
      helper.helperFun(component,event,'articleFour');
   },
  handleSelectedEvent : function(cmp, evt, helper) {
    var opportunityProductId = evt.getParam('productId');
    if(opportunityProductId==="")
      cmp.set('v.bProduct',false);
    else
      cmp.set('v.bProduct',true);
  }

})