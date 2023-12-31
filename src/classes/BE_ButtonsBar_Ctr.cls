/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_ButtonsBar_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-11-15
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-15  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_ButtonsBar_Ctr {
    /**@Description Quotes*/
    final static String QUOTES='\'';
    /**@Description params to quotes*/
    final static String REFACTORPER='@@';
    /** private constructor */
    private BE_ButtonsBar_Ctr() {}
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
        if(String.isNotBlank((String)params.get('apexClass'))) {
            final BE_ButtonsBarCRUD_cls resCustom=(BE_ButtonsBarCRUD_cls)Type.forName((String)params.get('apexClass')).newInstance();
            res=resCustom.readRecords(params);
        } else {
            final String query = 'SELECT ID FROM '+ params.get('objectApiName') +' WHERE ' + params.get('filter');
            res.isSuccess=true;
            res.data=Database.query(String.escapeSingleQuotes(query).removeEndIgnoreCase('LIKE').replace(REFACTORPER,QUOTES));
        }
        return res;
    } 
}