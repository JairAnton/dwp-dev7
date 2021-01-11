public without sharing class BE_SchemaUtils_Cls {
    /**
    @Description return a Map of String with type of all fields of sObject.
    @param sObjName the ApiName of sObject to be search.
    @return a Map<String,String> with information about the type of sObjectFields.
    */
    @AuraEnabled(cacheable=true)
    public static List<Values> getSObjectFieldsByList(String sObjName, List<Object> fields) {
		final Map<String, String> replaceIcons = new Map<String, String>();
        replaceIcons.put('user', 'user');
        replaceIcons.put('group', 'groups');
        replaceIcons.put('quote', 'user');
        replaceIcons.put('case', 'case');
        replaceIcons.put('asset', 'asset_object');
        replaceIcons.put('assetrelationship', 'asset_relationship');
        replaceIcons.put('contactrequest', 'contact_request');
        replaceIcons.put('contract', 'contract');
        replaceIcons.put('order', 'orders');
        replaceIcons.put('product', 'product');
        replaceIcons.put('solution', 'solution');
        final List<Values> values = new List<Values>();
        try {
            final Map<String, Schema.SObjectField> mfields = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
            for(Object obj : fields) {
                final Values item = new Values();
                final Map<Object, Object> data = (Map<Object, Object>)obj;
                final String field = String.valueOf(data.get('fieldName'));
                final String fieldName = String.valueOf(mfields.get(field.toLowerCase()).getDescribe().getName());
                final String fieldLabel = String.valueOf(mfields.get(field.toLowerCase()).getDescribe().getLabel());
                final String tipe = String.valueOf(mfields.get(field.toLowerCase()).getDescribe().getType()).toLowerCase();
                final String typeFinal = (tipe == 'double') ? 'number' : tipe;
                final List<Options> options = new List<Options>();
                final List<RelatedTo> ltsRelations = new List<RelatedTo>();
                for (Schema.PicklistEntry pickListEntry : mfields.get(field.toLowerCase()).getDescribe().getPicklistValues()) {
                    options.add(new Options(pickListEntry.getLabel(), pickListEntry.getValue()));
                }
                if(!mfields.get(field.toLowerCase()).getDescribe().getReferenceTo().isEmpty()) {
                    final Set<String> objList = new Set<String>();
                    for (Schema.SObjectType objectType : mfields.get(field.toLowerCase()).getDescribe().getReferenceTo()) {
                        objList.add(String.valueOf(objectType));
                    }
                    final Map<String,String> mapIcons = getIconName(objList);
                    for (Schema.SObjectType objectType : mfields.get(field.toLowerCase()).getDescribe().getReferenceTo()) {
                        Final RelatedTo relation = new RelatedTo();
                        relation.label = objectType.getDescribe().getLabel();
                        relation.objName = objectType.getDescribe().getName();
                        relation.pluralLabel = objectType.getDescribe().getLabelPlural();
                        relation.displayFields = 'Name';
                        relation.displayFormat = 'Name';
                        relation.iconName = 'standard:unmatched';
                        if(mapIcons.containskey(String.valueOf(objectType))) {
                            relation.iconName = mapIcons.get(String.valueOf(objectType));
                        }
                        if(replaceIcons.containskey(String.valueOf(objectType).toLowerCase())) {
                            relation.iconName = 'standard:'+replaceIcons.get(String.valueOf(objectType).toLowerCase());
                        }
                        ltsRelations.add(relation);
                    }
                }
                item.fieldName = fieldName;
                item.fieldType = typeFinal;
                item.relatedTo = ltsRelations;
                item.options = options;
                item.fieldLabel = String.valueOf(data.get('label'));
                item.isRequired = (data.get('required') != null && Boolean.valueOf(data.get('required'))) ? true : false;
                item.isDisabled = (data.get('disabled') != null && Boolean.valueOf(data.get('disabled'))) ? true : false;
                item.fieldValue = data.get('value') != null ? String.valueOf(data.get('value')) : '';
                if(item.fieldValue != '' && item.fieldType == 'reference') {
                    final Schema.SObjectType objType = ((Id)data.get('value')).getSobjectType();
                    item.objectName = String.valueOf(objType);
                }
                if(item.fieldType=='reference') {
                    if(item.relatedTo.size() == 1) {
                        item.isSingleReference = true;
                    } else {
                        item.isMultiReference = true;
                    }
                } else if(item.fieldType=='combobox') {
                    item.isComboBox = true;
                } else if(item.fieldType=='picklist') {
                    item.isPickList = true;
                } else if(item.fieldType=='textarea') {
                    item.isTextArea = true;
                } else {
                    item.isStandard = true;
                }
                values.add(item);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return values ;
    }
    
    private static Map<String, String> getIconName(Set<String> sObjectNames){
        Map<String, String> iconNames = new Map<String, String>();
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        Map<String, List<Schema.DescribeIconResult>> iconsDesc = new Map<String, List<Schema.DescribeIconResult>>();
        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }
        for(Schema.DescribeTabResult tr : tabDesc) {
            if(sObjectNames.contains(tr.getSobjectName())) {
                if( tr.isCustom() == true ) {
                    iconsDesc.put(tr.getSobjectName(), tr.getIcons());
                } else {
                    iconNames.put(tr.getSobjectName(), 'standard:' + tr.getSobjectName().toLowerCase());
                }
            }
        }
        for (String key : iconsDesc.keySet()) {
            for (Schema.DescribeIconResult ir : iconsDesc.get(key)) {
                if (ir.getContentType() == 'image/svg+xml'){
                    iconNames.put(key, 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_'));
                    break;
                }
            }
        }
        return iconNames;
    }
    
    public class Values {
        @AuraEnabled public String fieldName {set; get;}
        @AuraEnabled public String fieldLabel {set; get;}
        @AuraEnabled public String fieldType {set; get;}
        @AuraEnabled public Boolean isRequired {set; get;}
        @AuraEnabled public Boolean isDisabled {set; get;}
        @AuraEnabled public Boolean isSingleReference {set; get;}
        @AuraEnabled public Boolean isMultiReference {set; get;}
        @AuraEnabled public Boolean isComboBox {set; get;}
        @AuraEnabled public Boolean isPickList {set; get;}
        @AuraEnabled public Boolean isTextArea {set; get;}
        @AuraEnabled public Boolean isStandard {set; get;}
        @AuraEnabled public String fieldValue {set; get;}
        @AuraEnabled public String objectName {set; get;}
        @AuraEnabled public List<RelatedTo> relatedTo {set; get;}
        @AuraEnabled public List<Options> options {set; get;}
        public Values() {
            this.isSingleReference = false;
            this.isMultiReference = false;
            this.isComboBox = false;
            this.isPickList = false;
            this.isTextArea = false;
            this.isStandard = false;
        }
    }
    
    public class Options {
        @AuraEnabled public String label {set; get;}
        @AuraEnabled public String value {set; get;}
        public Options(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    
    public class RelatedTo {
        @AuraEnabled public String label {set; get;}
        @AuraEnabled public String objName {set; get;}
        @AuraEnabled public String pluralLabel {set; get;}
        @AuraEnabled public String displayFields {set; get;}
        @AuraEnabled public String displayFormat {set; get;}
        @AuraEnabled public String iconName {set; get;}
        public RelatedTo() {
            
        }
    }
}