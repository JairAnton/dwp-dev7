/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SchemaUtils_Cls
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-01-08
   @Description
   @Changes
   Date        Author   Email                  				Type
   2021-01-08  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SchemaUtils_Cls {
    /* @Variable: CONTENTTYPE */
	private static Final String CONTENTTYPE = 'image/svg+xml';
    /* @Variable: CONTENTTYPE */
	private static Final String STRTEXTAREA = 'textarea';
    /* @Variable: CONTENTTYPE */
	private static Final String STRPICKLIST = 'picklist';
    /* @Variable: CONTENTTYPE */
	private static Final String STRCOMBOBOX = 'combobox';
    /* @Variable: CONTENTTYPE */
	private static Final String STRREFERENCE = 'reference';
    /* @Variable: CONTENTTYPE */
	private static Final String STRDOUBLE = 'double';
    
    /**
    @Description constructor of class
    */
    private BE_SchemaUtils_Cls() {
    }
    
    /**
    @Description return a Map of String with type of all fields of sObject.
    @param String sObjName the ApiName of sObject to be search.
    @param List<Object> fields the sObject to be search.
    @return List<Values> with information about the type of sObjectFields.
    */
    @AuraEnabled(cacheable=true)
    public static List<Values> getSObjectFieldsByList(String sObjName, List<Object> fields) {
		final List<Values> values = new List<Values>();
        try {
            final Map<String, Schema.SObjectField> mfields = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
            for(Object obj : fields) {
                final Map<Object, Object> data = (Map<Object, Object>)obj;
                final String field = String.valueOf(data.get('fieldName'));
                final String fieldName = String.valueOf(mfields.get(field.toLowerCase()).getDescribe().getName());
                final String fieldLabel = String.valueOf(mfields.get(field.toLowerCase()).getDescribe().getLabel());
                final String tipe = String.valueOf(mfields.get(field.toLowerCase()).getDescribe().getType()).toLowerCase();
                final String typeFinal = (tipe == STRDOUBLE) ? 'number' : tipe;
                Values item = new Values(typeFinal);
                final List<Options> options = new List<Options>();
                for (Schema.PicklistEntry pickListEntry : mfields.get(field.toLowerCase()).getDescribe().getPicklistValues()) {
                    options.add(new Options(pickListEntry.getLabel(), pickListEntry.getValue()));
                }
                if(!mfields.get(field.toLowerCase()).getDescribe().getReferenceTo().isEmpty()) {
                    item.relatedTo = addRelations(field, mfields);
                } else {
                    item.relatedTo = new List<RelatedTo>();
                }
                item.fieldName = fieldName;
                item.fieldType = typeFinal;
                if(item.relatedTo.size() > 1) {
                    item.isMultiReference = true;
                }
                item.options = options;
                item.fieldLabel = data.get('label') == null ? fieldLabel : String.valueOf(data.get('label'));
                item.isRequired = data.get('required') == null ? false : Boolean.valueOf(data.get('required')) ? true : false;
                item.isDisabled = data.get('disabled') == null ? false : Boolean.valueOf(data.get('disabled')) ? true : false;
                item.fieldValue = data.get('value') == null ? '' : String.valueOf(data.get('value'));
                if(item.fieldValue != '' && item.fieldType == STRREFERENCE) {
                    final Schema.SObjectType objType = ((Id)data.get('value')).getSobjectType();
                    item.objectName = String.valueOf(objType);
                }
                values.add(item);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return values ;
    }
    
    /**
    @Description method used to add relations to reference field.
    @param String field field to search.
    @param Map<String, Schema.SObjectField> mfields schema field to search.
    @return List<RelatedTo> ltsRelations with relations to reference field.
    */
    private static List<RelatedTo> addRelations(String field, Map<String, Schema.SObjectField> mfields) {
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
        final List<RelatedTo> ltsRelations = new List<RelatedTo>();
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
        return ltsRelations;
    }
    
    /**
    @Description return a Map of String with icons of sObject.
    @param Set<String> sObjectNames to search.
    @return Map<String, String> with icons name.
    */
    private static Map<String, String> getIconName(Set<String> sObjectNames) {
        final Map<String, String> iconNames = new Map<String, String>();
        final List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        final List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        final Map<String, List<Schema.DescribeIconResult>> iconsDesc = new Map<String, List<Schema.DescribeIconResult>>();
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
                if (ir.getContentType() == CONTENTTYPE) {
                    iconNames.put(key, 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_'));
                    break;
                }
            }
        }
        return iconNames;
    }
    
    /**
   	   -------------------------------------------------------------------------------------------------
       @Name Values
       @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
       @Date 2021-01-08
       @Description
       @Changes
       Date        Author   Email                  				Type
       2021-01-08  MAMCH    martin.mori.contractor@bbva.com    	Creation
       -------------------------------------------------------------------------------------------------
     */
    public class Values {
        /* @Variable: fieldName*/
        @AuraEnabled public String fieldName {set; get;}
        /* @Variable: fieldLabel*/
        @AuraEnabled public String fieldLabel {set; get;}
        /* @Variable: fieldType*/
        @AuraEnabled public String fieldType {set; get;}
        /* @Variable: isRequired*/
        @AuraEnabled public Boolean isRequired {set; get;}
        /* @Variable: isDisabled*/
        @AuraEnabled public Boolean isDisabled {set; get;}
        /* @Variable: isSingleReference*/
        @AuraEnabled public Boolean isSingleReference {set; get;}
        /* @Variable: isMultiReference*/
        @AuraEnabled public Boolean isMultiReference {set; get;}
        /* @Variable: isComboBox*/
        @AuraEnabled public Boolean isComboBox {set; get;}
        /* @Variable: isPickList*/
        @AuraEnabled public Boolean isPickList {set; get;}
        /* @Variable: isTextArea*/
        @AuraEnabled public Boolean isTextArea {set; get;}
        /* @Variable: isStandard*/
        @AuraEnabled public Boolean isStandard {set; get;}
        /* @Variable: fieldValue*/
        @AuraEnabled public String fieldValue {set; get;}
        /* @Variable: objectName*/
        @AuraEnabled public String objectName {set; get;}
        /* @Variable: relatedTo*/
        @AuraEnabled public List<RelatedTo> relatedTo {set; get;}
        /* @Variable: options*/
        @AuraEnabled public List<Options> options {set; get;}
        
        /**
        @Description constructor of class
        */
        public Values(String fieldType) {
            this.isSingleReference = false;
            this.isMultiReference = false;
            this.isComboBox = false;
            this.isPickList = false;
            this.isTextArea = false;
            this.isStandard = false;
            if(fieldType==STRREFERENCE) {
                this.isSingleReference = true;
            } else if(fieldType==STRCOMBOBOX) {
                this.isComboBox = true;
            } else if(fieldType==STRPICKLIST) {
                this.isPickList = true;
            } else if(fieldType==STRTEXTAREA) {
                this.isTextArea = true;
            } else {
                this.isStandard = true;
            }
        }
    }
    
    /**
   	   -------------------------------------------------------------------------------------------------
       @Name Options
       @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
       @Date 2021-01-08
       @Description
       @Changes
       Date        Author   Email                  				Type
       2021-01-08  MAMCH    martin.mori.contractor@bbva.com    	Creation
       -------------------------------------------------------------------------------------------------
     */
    public class Options {
        /* @Variable: label of option*/
        @AuraEnabled public String label {set; get;}
        /* @Variable: value of option*/
        @AuraEnabled public String value {set; get;}
        /**
        @Description constructor of class
        */
        
        public Options(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    
    /**
   	   -------------------------------------------------------------------------------------------------
       @Name RelatedTo
       @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
       @Date 2021-01-08
       @Description
       @Changes
       Date        Author   Email                  				Type
       2021-01-08  MAMCH    martin.mori.contractor@bbva.com    	Creation
       -------------------------------------------------------------------------------------------------
     */
    public class RelatedTo {
       	/* @Variable: label of related object*/
        @AuraEnabled public String label {set; get;}
        /* @Variable: objName of related object*/
        @AuraEnabled public String objName {set; get;}
        /* @Variable: pluralLabel of related object*/
        @AuraEnabled public String pluralLabel {set; get;}
        /* @Variable: displayFields of related object*/
        @AuraEnabled public String displayFields {set; get;}
        /* @Variable: displayFormat of related object*/
        @AuraEnabled public String displayFormat {set; get;}
        /* @Variable: iconName of related object*/
        @AuraEnabled public String iconName {set; get;}
    }
}