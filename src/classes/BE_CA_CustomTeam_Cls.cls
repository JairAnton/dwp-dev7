/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CA_CustomTeam_Cls>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2021-03-10
   @Description Class Ctr for BE_CA_CustomTeam_Cls
   @Changes
    Date        Author   Email                  			Type		Description
    2021-03-10  LMBR     lolo.bravo@bbva.com    			Creation
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class  BE_CA_CustomTeam_Cls extends BE_SingleRelatedListCRUD_Cls {
    	/**@Description Quotes*/
		final static String QUOTES='\'';
		/**@Description params to quotes*/
		final static String REFACTORPER='@@';
		/**
	   @Description readRecords
	   @param  List<SObject> sObjs
	   @return BE_SingleRelatedListCRUD_Cls.Response response
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object>param) {
		final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
		try {
            final Id recordId=(String)param.get('recordId');
            final String query= 'SELECT '+ String.escapeSingleQuotes((String)param.get('sObjFields'))+ ' FROM '+String.escapeSingleQuotes((String)param.get('sObjName'))+' WHERE '+String.escapeSingleQuotes((String)param.get('filterSQOL')).removeEndIgnoreCase('LIKE').replace(REFACTORPER,QUOTES);
            res.isSuccess=true;
            res.data=Database.query(query);
            System.debug('##recordId##'+recordId);
		} catch (DMLException ex) {
			res.isSuccess=false;
			res.message=ex.getDmlMessage(0);
		}
		return res;
	}
    
    /**
    @Description createRecords
    @param  List<SObject> sObjs
    @return BE_SingleRelatedListCRUD_Cls.Response response
    */
    public override BE_SingleRelatedListCRUD_Cls.Response createRecords(List<SObject> sObjs) {
		final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
        final altm__Commercial_Alert__Share jobShr  = new altm__Commercial_Alert__Share();
        insert sObjs;
        jobShr.ParentId = (String)sObjs[0].get('Commercial_Alert__c');
        jobShr.UserOrGroupId = (String)sObjs[0].get('ctcp__gf_team_users_desc__c');
        jobShr.AccessLevel = 'Edit';
        jobShr.RowCause = Schema.altm__Commercial_Alert__Share.RowCause.Manual;
        final Database.SaveResult sResult = Database.insert(jobShr,false);
        if(sResult.isSuccess()) {
         	res.isSuccess=true;
        } else {
            res.isSuccess=false;
        }
        return res;
    }

}