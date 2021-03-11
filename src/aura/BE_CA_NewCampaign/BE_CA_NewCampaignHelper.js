({
	validateUser: function (cmp, evt, helper) {
        var action = cmp.get("c.validateUser");
        action.setParams({});
        console.log("1...",action);
        action.setCallback(this, function (response) {
            var state = response.getState();
        	console.log("2...",state);
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                console.log("VALIDATE USER:::::::",ret);
                cmp.set("v.settings", ret);
                cmp.set("v.loaded", true);
                
            } else {
                cmp.set("v.loaded", false);
                this.showToast('Error', 'Comuniquese con su administrador', 'error');
            }
        });
        $A.enqueueAction(action);
    },
    showToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    /**VALIDATE NULL, EMPTY AND BLANK*/
    isNotEmpty: function (obj) {
        const notEmpty = (obj === null || obj === undefined || obj === "") ? false : true;
        return notEmpty;
    }
})