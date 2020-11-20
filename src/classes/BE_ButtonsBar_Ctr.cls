public with sharing class BE_ButtonsBar_Ctr {
    /**
      @Description return about setting metadata
      @param nameMetaData developerName
      @return a List<SObject> with information setting metadata
    */
    @AuraEnabled(cacheable=true)
    public static Object getConfigMeta(String nameMetaData) {
    	return [SELECT Id,Buttons__c FROM BE_ButtonBarSettings__mdt WHERE DeveloperName=: nameMetaData];
    }

    /**
      @Description return about setting metadata
      @param nameMetaData developerName
      @return a List<SObject> with information setting metadata
    */
    @AuraEnabled(cacheable=false)
    public static Object getObjectId(Map<String,Object> params) {
        BE_ButtonsBarCRUD_cls.Response res= new BE_ButtonsBarCRUD_cls.Response();
        if(String.isNotBlank((String)params.get('apexClass'))){
            BE_ButtonsBarCRUD_cls resCustom=(BE_ButtonsBarCRUD_cls)Type.forName((String)params.get('apexClass')).newInstance();
            res=resCustom.readRecords(params);
        }else {
            final String query = 'SELECT ID FROM '+ params.get('objectApiName') +' WHERE ' + params.get('filter');
            res.isSuccess=true;
            res.data=Database.query(query);
            
        }
        return res;
    } 
}