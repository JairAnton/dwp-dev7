({
	putFilters : function(component, event, helper) {
        var arrayLabels = component.get("v.filterLabels").split(',');
        var arrayValues = component.get("v.filterValues").split(',');
        component.set("v.colorsTypes", component.get("v.colors").split(','));
        var filters = [];
        if(arrayLabels.length === arrayValues.length) {
            for(var i = 0; i < arrayLabels.length; i++) {
                var filter = {'label' : arrayLabels[i], 'value' : arrayValues[i]};
                filters.push(filter);
            }
        }
        component.set("v.dynamicFilters", filters);
    }
})
