/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CalceCancellationsOfDay_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-06-21
   @Description Class Ctr for BE_CalceCancellationsOfDay_Ctr
   @Changes
    Date        Author   Email                  			Type		Description
    2020-06-21  LMBR     lolo.bravo@bbva.com    			Creation
	2020-07-14  MAMC     martin.mori.contractor@bbva.com	Modify		change to Exception for DMLException in catch sections
    2021-07-21  JASM     jaime.silva.contractor@bbva.com 	Update
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CalceCancellationsOfDay_Ctr extends BE_SingleRelatedListCRUD_Cls {
	/** Lang Code */
	final private static List<String>LANG_CODE = new List<String> {'es','en_US'};
	/** Opportunity type Cancelation */
	final static String OPP_TYPE='02';
	/** Opportunity type Cancelation */
	final static String CALCE_TYPE='01';
	/** @Indirect Product */
	final static List<String>PRODUCT_TYPES = new List<String> {'Direct','Indirect','Resource'};
	/**
	   @Description readRecords
	   @param  List<SObject> sObjs
	   @return BE_SingleRelatedListCRUD_Cls.Response response
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object>param) {
		final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
		final Map<String,String> messages = new Map<String,String>();
		try {
			final Calce__c calce= [SELECT Id,OwnerId,close_date__c,start_date__c, Get_Date__c FROM Calce__c WHERE Id=:(String)param.get('recordId')];
			BE_CalceDetailManger_Helper.updateCancellationsOfDay(calce,PRODUCT_TYPES,CALCE_TYPE,OPP_TYPE);
			final List<Calce_Details__c> resData =[SELECT ID,Name,account_id__r.Name,product_name__c,close_date__c,calce_id__c,account_contract_id__c, CALCE_ID__r.Get_Date__c,opportunity_id__c,amount__c,amount_cancelled__c,return__c,extension__c,CurrencyIsoCode FROM Calce_Details__c WHERE calce_id__c=: calce.Id AND sub_type__c=:CALCE_TYPE AND close_date__c=: calce.Get_Date__c ];
			res.data=resData;
			res.isSuccess=true;
			messages.put(LANG_CODE[0], 'Cancelaciones del día consultado correctamente');
			messages.put(LANG_CODE[1], 'Cancellations of day searched successfully');
			res.message = messages.get(UserInfo.getLanguage());
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
		final Map<String,String> messages = new Map<String,String>();
		try {
			res.isSuccess=true;
			messages.put(LANG_CODE[0], 'Cancelaciones del día actualizada correctamente');
			messages.put(LANG_CODE[1], 'Cancellations of day update successfully');
			res.message = messages.get(UserInfo.getLanguage());
			BE_CalceDetailManger_Helper.updateCalceStatus(sObjs[0].Id);
			update sObjs;
		} catch (DmlException ex) {
			res.isSuccess=false;
			res.message=ex.getDmlMessage(0);
		}
		return res;
	}
}