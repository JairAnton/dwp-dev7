/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CalceNewEarlyCancellations_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-06-21
   @Description Class Ctr for CalceNewEarlyCancellations
   @Changes
    Date        Author   Email                  Type
    2020-06-21  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CalceNewEarlyCancellations_Ctr extends BE_SingleRelatedListCRUD_Cls {
/** Lang Code */
private static final List<String> LANG_CODE = new List<String> {'es','en_US'};
/**
   @Description createRecords
   @param  List<SObject> sObjs
   @return BE_SingleRelatedListCRUD_Cls.Response response
 */
public override Response createRecords(List<SObject>sObjs) {
	final BE_SingleRelatedListCRUD_Cls.Response response=new BE_SingleRelatedListCRUD_Cls.Response();
	final Map<String,String> messages = new Map<String,String>();
	final Calce_Details__c calDet=(Calce_Details__c)sObjs[0];
	try {
		final Calce__c calce = [SELECT Id,OwnerId,close_date__c FROM Calce__c WHERE Id=:calDet.calce_id__c];
		final String accOwnerId=[SELECT Id,OwnerId FROM Account WHERE Id=:calDet.account_id__c].OwnerId;
		if(accOwnerId==calce.OwnerId) {
			final Product2 product=[SELECT Name,ProductCode,type__c FROM Product2 WHERE Id=:calDet.product_id__c];
			calDet.sub_type__c='03';
			calDet.Name=String.valueOf(calce.close_date__c);
			calDet.close_date__c=calce.close_date__c;
			calDet.product_name__c=product.Name;
			calDet.product_code__c=product.ProductCode;
			calDet.type__c=product.type__c;
			insert calDet;
			messages.put(LANG_CODE[0], 'Cancelación Anticipada creada correctamente');
			messages.put(LANG_CODE[1], 'Early cancellation created successfully');
			response.isSuccess = true;
			response.message = messages.get(UserInfo.getLanguage());
		} else {
			messages.put(LANG_CODE[0], 'Solo puede crear cancelaciones anticipadas para su cartera de cliente');
			messages.put(LANG_CODE[1], 'Only can create early cancellation for your portafolio of clients.');
			response.isSuccess = false;
			response.message = messages.get(UserInfo.getLanguage());
		}
	} catch (DmlException ex) {
		response.isSuccess=false;
		response.message=ex.getDmlMessage(0);
	}
	return response;
}
/**
   @Description deleteRecords
   @param  List<SObject> sObjs
   @return BE_SingleRelatedListCRUD_Cls.Response response
 */
public override Response deleteRecords(List<SObject>sObjs) {
	final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
	final Map<String,String>messages = new Map<String,String>();
	try {
		res.isSuccess=true;
		messages.put(LANG_CODE[0], 'Cancelación anticipada eliminada correctamente.');
		messages.put(LANG_CODE[1], 'Early cancellation deleted successfully.');
		res.message = messages.get(UserInfo.getLanguage());
		for(Calce_Details__c item : [SELECT ID, opportunity_id__c FROM Calce_Details__c WHERE Id IN:(sObjs)]) {
			if(String.isNotBlank(String.valueOf(item.opportunity_id__c))) {
				res.isSuccess=false;
				messages.put(LANG_CODE[0], 'No puede eliminar una oportunidad de tipo cancelación');
				messages.put(LANG_CODE[1], 'Can not delete opportunity type cancellation');
				res.message = messages.get(UserInfo.getLanguage());
				break;
			}
		}
		if(res.isSuccess) {
			delete sObjs;
		}
	} catch (DmlException ex) {
		res.isSuccess=false;
		res.message=ex.getDmlMessage(0);
	}
	return res;
}
}