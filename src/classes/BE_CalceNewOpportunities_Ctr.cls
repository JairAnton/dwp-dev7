/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CalceNewOpportunities_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-02-24
   @Description Class Ctr for NewOpportunities
   @Changes
    Date        Author   Email                  			Type		Description
    2020-06-21  LMBR     lolo.bravo@bbva.com    			Creation
	2020-07-14  MAMC     martin.mori.contractor@bbva.com	Modify		change to Exception for DMLException in catch sections
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CalceNewOpportunities_Ctr extends BE_SingleRelatedListCRUD_Cls {
	/** Lang Code */
	final private static List<String>LANG_CODE = new List<String> {'es','en_US'};
	/** Opportunity type Cancelation */
	final static String OPP_TYPE='01';
	/** Opportunity type Cancelation */
	final static String CALCE_TYPE='02'; 
	/** @Indirect Product */
	final static List<String>PRODUCT_TYPES = new List<String> {'Direct','Indirect','Resource'}; 
	/**
	   @Description updateRecords
	   @param  List<SObject> sObjs
	   @return BE_SingleRelatedListCRUD_Cls.Response response
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords (Map<String,Object>param) {
		final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
		final Map<String,String>messages = new Map<String,String>();
		try {
			final Calce__c calce= [SELECT Id,OwnerId,close_date__c,start_date__c FROM Calce__c WHERE Id=:(String)param.get('recordId')];
			BE_CalceDetailManger_Helper.updateNewOpps(calce, PRODUCT_TYPES, CALCE_TYPE, OPP_TYPE);
			final List<Calce_Details__c>resData = [SELECT ID,Name,account_id__r.Name,product_name__c,close_date__c,calce_id__c,account_contract_id__c,opportunity_id__c,amount__c,amount_cancelled__c,opportunity_stage_name__c,return__c,extension__c,CurrencyIsoCode FROM Calce_Details__c WHERE calce_id__c=: calce.Id AND sub_type__c=:CALCE_TYPE];
			res.isSuccess=true;
			messages.put(LANG_CODE[0], 'Oportunidades actualizadas correctamente.');
			messages.put(LANG_CODE[1], 'Opportunities updated successfully.');
			res.message = messages.get(UserInfo.getLanguage());
			res.data=resData;
		} catch (DMLException ex) {
			res.isSuccess=false;
			res.message=ex.getDmlMessage(0);
		}
		return res;
	}
	/**
			@Description updateRecords
			@param  List<SObject> sObjs
			@return BE_SingleRelatedListCRUD_Cls.Response response
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response updateRecords(List<SObject>sObjs) {
		final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
		final Map<String,String>messages = new Map<String,String>();
		final Map<Id,Opportunity>oppsMap =new Map<Id,Opportunity>();
		try {
			for(Calce_Details__c calceDetItem : (List<Calce_Details__c>)sObjs) {
				if(String.isNotBlank(String.valueOf(calceDetItem.get('close_date__c')))) {
					oppsMap.put(calceDetItem.Id,new Opportunity(CloseDate=(Date)calceDetItem.get('close_date__c')));
				} else if(String.isNotBlank(String.valueOf(calceDetItem.get('amount_cancelled__c')))) {
					oppsMap.put(calceDetItem.Id,new Opportunity(Amount=(Decimal)calceDetItem.get('amount_cancelled__c')));
				}
			}
			for(Calce_Details__c item : [SELECT ID, opportunity_id__c FROM Calce_Details__c WHERE Id IN:(oppsMap.keySet())]) {
				oppsMap.get(item.Id).Id=item.opportunity_id__c;
			}
			res.isSuccess=true;
			messages.put(LANG_CODE[0], 'Oportunidades actualizadas correctamente.');
			messages.put(LANG_CODE[1], 'Opportunities updated successfully.');
			res.message = messages.get(UserInfo.getLanguage());
			BE_CalceDetailManger_Helper.updateCalceStatus(sObjs[0].Id);
			update oppsMap.values();
			update sObjs;
		} catch (DMLException ex) {
			res.isSuccess=false;
			res.message=ex.getDmlMessage(0);
		}
		return res;
	}
}