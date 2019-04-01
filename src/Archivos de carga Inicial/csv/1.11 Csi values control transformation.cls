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

List <fprd__GBL_Complex_section_item__c> lst_csi = [SELECT Id, fprd__Values_control_field__c,
 (SELECT Id, fprd__LoV_labels__c, fprd__Lov_Values__c, fprd__Values_control_value__c FROM fprd__Dependent_values__r) FROM fprd__GBL_Complex_section_item__c 
 WHERE fprd__Values_control_field__c != null];

if (!lst_csi.isEmpty()) {
    List <fprd__GBL_Complex_list_value__c> toUpdate = new List <fprd__GBL_Complex_list_value__c>();
    Set <String> parentConfigDevNames = new Set <String>();
    for (fprd__GBL_Complex_section_item__c csi : lst_csi) {
        if (csi.fprd__Values_control_field__c != null) {
            parentConfigDevNames.add(csi.fprd__Values_control_field__c);
        }
    }
    List <fprd__GBL_Complex_section_item__c> lst_parentConfigs = [SELECT Id, fprd__DeveloperName__c, (SELECT Id, fprd__LoV_labels__c, fprd__Lov_Values__c FROM fprd__Dependent_values__r)
    FROM fprd__GBL_Complex_section_item__c WHERE fprd__DeveloperName__c IN: parentConfigDevNames];
    Map <String, fprd__GBL_Complex_section_item__c> map_parentConfigs = new Map<String, fprd__GBL_Complex_section_item__c>();
    for (fprd__GBL_Complex_section_item__c csi : lst_parentConfigs) {
        map_parentConfigs.put(csi.fprd__DeveloperName__c, csi);
    }
    for (fprd__GBL_Complex_section_item__c csi : lst_csi) {
        if (csi.fprd__Values_control_field__c != null && !csi.fprd__Dependent_values__r.isEmpty()) {
            fprd__GBL_Complex_section_item__c currentParent = map_parentConfigs.get(csi.fprd__Values_control_field__c);
            for (fprd__GBL_Complex_list_value__c dv : csi.fprd__Dependent_values__r) {
                List <String> results = new List <String>();
                List <String> controlValues = dv.fprd__Values_control_value__c.split(',');
                for (String value : controlValues){
                    results.add(getListValue(value, currentParent));
                }
                dv.fprd__Values_control_value__c = String.join(results, ',');
                toUpdate.add(dv);
            }
        }
    }
    update toUpdate;
}