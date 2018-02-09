({
    getInfo : function(cmp, evt, helper) {
        var action = cmp.get("c.getInfo");  
        action.setParams({sObjectStr: cmp.get('v.sObjectName')});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(result);
                if(undefined != result.data && null != result.data && result.data.length > 0){
                    console.log('Pasa');
                    var dataRow = result.data[0];
                    //title

                    var titleModal =  $A.getReference("$Label.c." + dataRow.Title_Label_API__c);
                    var btn1 =  $A.getReference("$Label.c." + dataRow.Button_Label_API_Agree__c);
                    var btn2 =  $A.getReference("$Label.c." + dataRow.Button_Label_API_Cancel__c);
                    var bodyStr =  $A.getReference("$Label.c." + dataRow.Body_Label_API__c);
                    console.log(dataRow.Title_Label_API__c);
                    console.log(dataRow.Button_Label_API_Agree__c);
                    console.log(dataRow.Button_Label_API_Cancel__c);
                    console.log(dataRow.Body_Label_API__c);
                    cmp.set('v.title',titleModal);
                    cmp.set('v.strButtonAgree',btn1);
                    cmp.set('v.strButtonCancel',btn2);
                    cmp.set('v.strBody',bodyStr);
                    cmp.set('v.redirectObject', dataRow.Object_Api_Name_to_Redirect__c);
                    
                }
            }
        });
        $A.enqueueAction(action);
    }
})