/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CalceEarlyCancellations_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-06-21
   @Description Class Ctr for EarlyCancellations
   @Changes
    Date        Author   Email                  Type
    2020-06-21  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CalceEarlyCancellations_Ctr extends BE_SingleRelatedListCRUD_Cls {
	/** Opportunity type Cancelation */
	final static String OPP_TYPE='02';
	/** Opportunity type Cancelation */
	final static String CALCE_TYPE='03';
	/** @Indirect Product */
	final static List<String> PRODUCT_TYPES = new List<String> {'Direct','Indirect'};
	/** Lang Code */
	private static final List<String> LANG_CODE = new List<String> {'es','en_US'};
	/**
	   @Description updateRecords
	   @param  List<SObject> sObjs
	   @return BE_SingleRelatedListCRUD_Cls.Response response
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object>param) {
		final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
		final Map<String,String> messages = new Map<String,String>();
		try {
			final Calce__c calce= [SELECT Id,OwnerId,close_date__c,start_date__c FROM Calce__c WHERE Id=:(String)param.get('recordId')];
			BE_CalceDetailManger_Helper.earlyCancellations(calce, PRODUCT_TYPES, CALCE_TYPE, OPP_TYPE);
			final List<Calce_Details__c> resData =[SELECT ID,Name,account_id__r.Name,product_name__c,close_date__c,calce_id__c,account_contract_id__c,opportunity_id__c,amount__c,amount_cancelled__c,return__c,extension__c,CurrencyIsoCode FROM Calce_Details__c WHERE calce_id__c=: calce.Id AND sub_type__c=:CALCE_TYPE];
			messages.put(LANG_CODE[0], 'Consulta realizada correctamente.');
			messages.put(LANG_CODE[1], 'Search done successfully.');
			res.isSuccess = true;
			res.message = messages.get(UserInfo.getLanguage());
			res.data=resData;
		} catch (Exception ex) {
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
			res.message='Success';
			BE_CalceDetailManger_Helper.updateCalceStatus(sObjs[0].Id);
			update sObjs;
			messages.put(LANG_CODE[0], 'Cancelaciones anticipadas actualizadas correctamente.');
			messages.put(LANG_CODE[1], 'Early cancellations saved successfully.');
			res.isSuccess = true;
			res.message = messages.get(UserInfo.getLanguage());
		} catch (Exception ex) {
			res.isSuccess=false;
			res.message=ex.getDmlMessage(0);
		}
		return res;
	}
}