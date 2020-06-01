({
    getTableData: function (cmp) {
        var accountId = cmp.get("v.recordId");
        var object = cmp.get("v.object");
        var FieldNameRelation = cmp.get("v.FieldNameRelation");
        var fields = cmp.get("v.fields");
        var filters = cmp.get("v.filters");
        var orders = cmp.get("v.orders");
        var limits = cmp.get("v.showRecords");
        var relatedOpps = cmp.get("c.getRelatedVisit");
        relatedOpps.setParams({
            "accId": accountId,
            "objectName": object,
            "fieldNameRelation": FieldNameRelation,
            "fields": fields,
            "filters": filters,
            "orderRow": orders,
            "limitRow": limits
        });
        relatedOpps.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var resultData = JSON.parse(response.getReturnValue());
                if (resultData.length <= 0) { cmp.set("v.resultResponse", false); }
                var i;
                for (i = 0; i < resultData.length; i++) {
                    resultData[i].Id = '/' + resultData[i].Id;
                }
                cmp.set("v.data", resultData);
            } else {
                cmp.set("v.resultResponse", false)
            }
        });
        $A.enqueueAction(relatedOpps);
    }
})
