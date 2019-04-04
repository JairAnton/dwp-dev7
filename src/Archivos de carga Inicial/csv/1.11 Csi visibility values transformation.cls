private String getListValue(String value, fprd__GBL_Complex_section_item__c parentConfig) {

    if (!parentConfig.fprd__Dependent_values__r.isEmpty()){
        for (fprd__GBL_Complex_list_value__c dv : parentConfig.fprd__Dependent_values__r) {
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

List <fprd__GBL_Complex_section_item__c> lst_csi = [SELECT Id, fprd__Visibility_control_field__c, fprd__Visibility_control_value__c,
 (SELECT Id, fprd__LoV_labels__c, fprd__Lov_Values__c, fprd__Values_control_value__c FROM fprd__Dependent_values__r) FROM fprd__GBL_Complex_section_item__c 
 WHERE fprd__Visibility_control_field__c != null];

if (!lst_csi.isEmpty()) {
    Set <String> parentConfigDevNames = new Set <String>();
    for (fprd__GBL_Complex_section_item__c csi : lst_csi) {
        if (csi.fprd__Visibility_control_field__c != null) {
            parentConfigDevNames.addAll(csi.fprd__Visibility_control_field__c.split(';'));
        }
    }
    List <fprd__GBL_Complex_section_item__c> lst_parentConfigs = [SELECT Id, fprd__DeveloperName__c, (SELECT Id, fprd__LoV_labels__c, fprd__Lov_Values__c FROM fprd__Dependent_values__r)
    FROM fprd__GBL_Complex_section_item__c WHERE fprd__DeveloperName__c IN: parentConfigDevNames];
    Map <String, fprd__GBL_Complex_section_item__c> map_parentConfigs = new Map<String, fprd__GBL_Complex_section_item__c>();
    for (fprd__GBL_Complex_section_item__c csi : lst_parentConfigs) {
        map_parentConfigs.put(csi.fprd__DeveloperName__c, csi);
    }
    for (fprd__GBL_Complex_section_item__c csi : lst_csi) {
        List <String> results = new List <String>();
        if(csi.fprd__Visibility_control_field__c != null){
            List <String> lst_parents = csi.fprd__Visibility_control_field__c.split(';');
            List <String> lst_values = csi.fprd__Visibility_control_value__c.split(';');
            for (Integer i = 0; i < lst_parents.size(); i++) {
                List <String> currentValues = lst_values[i].split(',');
                fprd__GBL_Complex_section_item__c currentParent = map_parentConfigs.get(lst_parents[i]);
                String aux = '';
                for (Integer j = 0; j < currentValues.size(); j++) {
                    aux += getListValue(currentValues[j], currentParent) + ',';
                }
                results.add(aux.removeEnd(','));
            }
        }
        csi.fprd__Visibility_control_value__c = String.join(results, ';');
    }

}
update lst_csi;