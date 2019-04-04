private String getListValue(String value, fprd__GBL_Product_configuration__c parentConfig) {

    if (!parentConfig.fprd__Dependent_values__r.isEmpty()){
        for (fprd__GBL_Dependent_value__c dv : parentConfig.fprd__Dependent_values__r) {
            List <String> labels = dv.fprd__LoV_labels__c.split(',');
            List <String> values = dv.fprd__LoV_values__c.split(',');
            for (Integer i = 0; i < labels.size(); i++) {
                if (value == labels[i]) {
                    return values[i];
                }
            }
        }
    }
    return '';
}

List <fprd__GBL_Product_configuration__c> lst_pConfig = [SELECT Id, fprd__Visibility_control_field__c, fprd__Visibility_control_value__c,
 (SELECT Id, fprd__LoV_labels__c, fprd__Lov_Values__c, fprd__Values_control_value__c FROM fprd__Dependent_values__r) FROM fprd__GBL_Product_configuration__c 
 WHERE fprd__Visibility_control_field__c != null];

if (!lst_pConfig.isEmpty()) {
    Set <String> parentConfigDevNames = new Set <String>();
    for (fprd__GBL_Product_configuration__c pConfig : lst_pConfig) {
        if (pConfig.fprd__Visibility_control_field__c != null) {
            parentConfigDevNames.addAll(pConfig.fprd__Visibility_control_field__c.split(';'));
        }
    }
    List <fprd__GBL_Product_configuration__c> lst_parentConfigs = [SELECT Id, fprd__DeveloperName__c, (SELECT Id, fprd__LoV_labels__c, fprd__Lov_Values__c FROM fprd__Dependent_values__r)
    FROM fprd__GBL_Product_configuration__c WHERE fprd__DeveloperName__c IN: parentConfigDevNames];
    Map <String, fprd__GBL_Product_configuration__c> map_parentConfigs = new Map<String, fprd__GBL_Product_configuration__c>();
    for (fprd__GBL_Product_configuration__c pConfig : lst_parentConfigs) {
        map_parentConfigs.put(pConfig.fprd__DeveloperName__c, pConfig);
    }
    for (fprd__GBL_Product_configuration__c pConfig : lst_pConfig) {
        List <String> results = new List <String>();
        if(pConfig.fprd__Visibility_control_field__c != null){
            List <String> lst_parents = pConfig.fprd__Visibility_control_field__c.split(';');
            List <String> lst_values = pConfig.fprd__Visibility_control_value__c.split(';');
            for (Integer i = 0; i < lst_parents.size(); i++) {
                List <String> currentValues = lst_values[i].split(',');
                fprd__GBL_Product_configuration__c currentParent = map_parentConfigs.get(lst_parents[i]);
                String aux = '';
                for (Integer j = 0; j < currentValues.size(); j++) {
                    aux += getListValue(currentValues[j], currentParent) + ',';
                }
                results.add(aux.removeEnd(','));
            }
        }
        pConfig.fprd__Visibility_control_value__c = String.join(results, ';');
    }

}
update lst_pConfig;