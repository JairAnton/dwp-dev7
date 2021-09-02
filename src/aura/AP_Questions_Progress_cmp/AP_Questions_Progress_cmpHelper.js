({
    doInit : function(component, event, helper) {
        component.set('v.isLoaded', false);
        var recordId = component.get('v.recordId');
        var action = component.get("c.calculateQuestions");
        action.setParams({
            "recordId" : recordId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();

            if(state === 'SUCCESS') {
                component.set('v.questionsAswered', Math.round(result['questionsAswered']));
                component.set('v.questionsMandatory', Math.round(result['questionsMandatory']));
                component.set('v.questionsNotMandatory', Math.round(result['questionsNotMandatory']));
                component.set('v.isLoaded', true);

                if(result['totalMandatory'] === result['qMandatoryAswered']) {
                    component.set('v.completeMandatory', true);
                } else {
                    component.set('v.completeMandatory', false);
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": 'Error',
                    "message": 'Ocurrión un error en el progreso de preguntas.',
                    "type": 'error'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})
