({
    getInfo: function (cmp, evt, helper) {
        var action = cmp.get("c.getInfoTable");
        action.setParams({
            "recordId": cmp.get('v.oppRecordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var ordenField = ['opp_solution_comt_product_name__c', 'CurrencyIsoCode', 'opp_solution_commitment_amount__c',
                    'opp_solution_commitment_number__c', 'opp_soln_comt_expiry_days_number__c', 'opp_soln_comt_stay_days_number__c'];
                var objSetup = {
                    'lstHead': [],
                    'lstData': []
                };
                for (var h in ordenField) {
                    objSetup['lstHead'].push(ret.schemaSetup.mapLabel[ordenField[h]]); // 2018/11/27 - 16:56 CORRECCION DEUDA TECNICA Ernesto
                }
                for (var i in ret.lstCommitments) {
                    var row = {
                        'id': ret.lstCommitments[i]['Id'],
                        'lstInfo': []
                    };
                    for (var j in ordenField) {
                        row['lstInfo'].push(ret.lstCommitments[i][ordenField[j]]);
                    }
                    objSetup['lstData'].push(row);
                }
                cmp.set('v.objSetup', objSetup);
                cmp.set('v.isLoad', true);
                cmp.set('v.hasRecord', (ret.lstCommitments.length == 0 ? false : true));
            }
        });
        $A.enqueueAction(action);
    },
    continue: function (cmp, evt, helper) {
        cmp.set('v.isLoad', false);
        if (cmp.get('v.quoteMethod') === 'Web') {
            var action = cmp.get("c.requestQuote");
            action.setParams({
                "recordId": cmp.get('v.oppRecordId')
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var ret = response.getReturnValue();
                    var compEvent = cmp.getEvent("commitmentsEvent");
                    if (ret.success === 'true') {
                        if (ret.nextCallout !== undefined && ret.nextCallout === true) {
                            var action2 = cmp.get("c.requestQuote");
                            action2.setParams({
                                "recordId": cmp.get('v.oppRecordId')
                            });
                            action2.setCallback(this, function (response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    var ret = response.getReturnValue();
                                    var compEvent = cmp.getEvent("commitmentsEvent");
                                    var otherData = null;
                                    if (ret.success === 'true') {
                                        otherData = {
                                            "quotationStatusMessage": ret.quotationStatusMessage,
                                            "auditId": ret.auditId,
                                            "quotationStatusIcon": ret.quotationStatusIcon
                                        };
                                        compEvent.setParams({ "typeMode": 'DOCONTINUE', "data": otherData });
                                    }
                                    else {
                                        otherData = { "errorCode": ret.errorMessage };
                                        compEvent.setParams({ "typeMode": 'DOERROR', "data": otherData });
                                    }
                                    compEvent.fire();
                                }
                            });
                            $A.enqueueAction(action2);
                        } else {
                            var otherData = {
                                "quotationStatusMessage": ret.quotationStatusMessage,
                                "auditId": ret.auditId,
                                "quotationStatusIcon": ret.quotationStatusIcon
                            };
                            compEvent.setParams({ "typeMode": 'DOCONTINUE', "data": otherData });
                        }
                    }
                    else {
                        var otherData = { "errorCode": ret.errorMessage };
                        compEvent.setParams({ "typeMode": 'DOERROR', "data": otherData });
                    }
                    compEvent.fire();
                }
            });
            $A.enqueueAction(action);
        } else {
            var compEvent = cmp.getEvent("commitmentsEvent");
            compEvent.setParams({ "typeMode": 'DOCONTINUE' });
            compEvent.fire();
        }
    }
})
