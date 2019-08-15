({
    doInit : function(cmp, event, helper) {
        var isHtml = cmp.get('v.isHtml');
        if(isHtml === true){
            helper.init(cmp, event, helper);
        }
    }
})
