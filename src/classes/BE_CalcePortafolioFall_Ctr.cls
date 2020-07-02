/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalceCancellationsOfDay_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description BE_CalceNewOppHeadAction_Ctr for  New Opportunities
   @Changes
   Date        Author   Email                  				Type
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CalcePortafolioFall_Ctr extends BE_SingleRelatedListCRUD_Cls {
/** Opportunity type Cancelation */
final static String CALCE_TYPE='04';
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
		BE_CalceDetailManger_Helper.updatePortfolioFall(calce,CALCE_TYPE);
		final List<Calce_Details__c>resData =[SELECT ID,Name,Contract_Number__c,account_id__r.Name,close_date__c,calce_id__c,account_contract_id__c,amount__c,amount_cancelled__c,extension__c,return__c,CurrencyIsoCode FROM Calce_Details__c WHERE sub_type__c=:CALCE_TYPE AND calce_id__c=: calce.Id];
		res.data=resData;
		messages.put(LANG_CODE[0], 'Caida de cartera consultado correctamente.');
		messages.put(LANG_CODE[1], 'Portafolio fall search sucessfully.');
		res.isSuccess = true;
		res.message = messages.get(UserInfo.getLanguage());
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
		messages.put(LANG_CODE[0], 'Caida de cartera actualizado correctamente.');
		messages.put(LANG_CODE[1], 'Portafolio fall saved sucessfully.');
		res.isSuccess = true;
		res.message = messages.get(UserInfo.getLanguage());
		BE_CalceDetailManger_Helper.updateCalceStatus(sObjs[0].Id);
		update sObjs;
	} catch (Exception ex) {
		res.isSuccess=false;
		res.message=ex.getDmlMessage(0);
	}
	return res;
}
}