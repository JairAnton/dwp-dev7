({
	getDataInit : function(cmp, event, helper) {
        let accountId = cmp.get("v.recordId");
        let dataCards = cmp.get("c.getData");
        dataCards.setParams({
            "accId" : accountId
        });
        dataCards.setCallback(this, function(response){
            let estado =response.getState();
            if(response.getState() === "SUCCESS"){
                let stringJson = '{"inputJsonCs": {'+
                    '"qvcd__GBL_Show_title__c":true,'+
                    '"Id":"inputJsonModeId",'+
                    '"qvcd__GBL_Orientation__c":2,'+
                    '"Name":"inputJsonModeCS"'+
                    '},'+
                    //'"defaultCardSelected": "Card1",'+
                    '"inputJsonData": '+
                    response.getReturnValue()+
                    '}';
                let device = $A.get("$Browser.formFactor");
                let num = 4;
                if($A.get("$Browser.isTablet") || $A.get("$Browser.isIPad") || $A.get("$Browser.isPhone")) {
                    num = 2;
                }
                $A.createComponent(
                    "qvcd:GBL_Carousel_CMP",
                    {
                        "inputJsonMode": true,
                        "allowCardClick": true,
                        "inputJson": JSON.parse(stringJson),
                        "isCarousel": true,
                        "infinite": true,
                        "slidesToShow": num
                    },
                    function(newComp, status, errorMessage){
                        //Add the new button to the body array
                        if (status === "SUCCESS") {
                            let body = cmp.get("v.body");
                            body.push(newComp);
                            cmp.set("v.body", body);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("estado No response from server or client is offline.")
                            // Show offline error
                        }
                            else if (status === "ERROR") {
                                console.log("Estado Error: " + errorMessage);
                                // Show error message
                            }
                    }
                );
            }
            setTimeout(function(){ cmp.set("v.showSpinner", false); }, 1500);
        });
        $A.enqueueAction(dataCards);
    },
})