({
    sectionZero: function (component, event, helper) {
        helper.helperFun(component, event, 'articleZero');
    },

    sectionOne: function (component, event, helper) {
        helper.helperFun(component, event, 'articleOne');
    },

    sectionTwo: function (component, event, helper) {
        helper.helperFun(component, event, 'articleTwo');
    },

    sectionThree: function (component, event, helper) {
        helper.helperFun(component, event, 'articleThree');
    },

    sectionFour: function (component, event, helper) {
        helper.helperFun(component, event, 'articleFour');
    },
    handleSelectedEvent: function (cmp, evt, helper) {
        var opportunityProductId = evt.getParam('productId');
        if (opportunityProductId === "")
            cmp.set('v.bProduct', false);
        else {
            cmp.set('v.bProduct', true);
            var action = cmp.get("c.getProduct2");
            action.setParams({
                "ProdId": opportunityProductId
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set("v.Prod2", response.getReturnValue());
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);
        }
    }
})
