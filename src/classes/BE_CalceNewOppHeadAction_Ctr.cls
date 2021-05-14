/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalceCancellationsOfDay_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description BE_CalceNewOppHeadAction_Ctr for  New Opportunities
   @Changes
   Date        Author   Email                  				Type		Description
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   2020-07-14  MAMC     martin.mori.contractor@bbva.com		Modify		change to Exception for DMLException in catch sections
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CalceNewOppHeadAction_Ctr extends BE_SingleRelatedListCRUD_Cls {
	/** Lang Code */
	private static final List<String>LANG_CODE = new List<String> {'es','en_US'}; 
	/**
	   @Description createRecords
	   @param  List<SObject> sObjs
	   @return BE_SingleRelatedListCRUD_Cls.Response response
	 */
	public override Response createRecords(List<SObject>sObjs) {
		final Map<String,String> messages = new Map<String,String>();
		final BE_SingleRelatedListCRUD_Cls.Response res = new BE_SingleRelatedListCRUD_Cls.Response();
		final Savepoint savePoint = Database.setSavepoint();
		try {
			final Calce_Details__c calDet = (Calce_Details__c)sObjs[0];
			final Calce__c calce = [SELECT Id,OwnerId,status__c,close_date__c FROM Calce__c WHERE Id=:calDet.calce_id__c];
			final String accOwnerId=[SELECT Id,OwnerId FROM Account WHERE Id=:calDet.account_id__c].OwnerId;
			if(accOwnerId==calce.OwnerId) {
				final Opportunity opp = new Opportunity(Name=calDet.Name,AccountId = calDet.account_id__c,StageName = '02',opportunity_status_type__c = '03',
													   type='01',CloseDate = calce.close_date__c,opportunity_planning_date__c = calce.close_date__c,
													   CurrencyIsoCode = calDet.CurrencyIsoCode,Amount = calDet.amount__c,Field_Sup_Closing_Date__c = calce.close_date__c,
													   OwnerId=calce.OwnerId);
				insert opp;
				if(String.isNotBlank(calDet.product_id__c)) {
					final String entryId = [SELECT Id FROM PriceBookEntry WHERE Product2Id = :calDet.product_id__c AND CurrencyIsoCode = :opp.CurrencyIsoCode AND IsActive = TRUE LIMIT 1][0].Id;
					final String versionId = [SELECT Id FROM fprd__GBL_Product_version__c WHERE fprd__Product__c = :calDet.product_id__c AND fprd__Active__c = TRUE LIMIT 1][0].Id;
					final OpportunityLineItem oli = new OpportunityLineItem();
					oli.OpportunityId = opp.Id;
					oli.Quantity = 1;
					oli.UnitPrice = Opp.Amount;
					oli.PricebookEntryId = entryId;
					oli.fprd__GBL_Product_version__c = versionId;
					insert oli;
					messages.put(LANG_CODE[0], 'Oportunidad creada correctamente');
					messages.put(LANG_CODE[1], 'Opportunity created successfull');
					res.isSuccess = true;
					res.message = messages.get(UserInfo.getLanguage());
					BE_CalceDetailManger_Helper.setCalceStatus(calce);
				} else {
					Database.rollback(savePoint);
					messages.put(LANG_CODE[0], 'Producto no encontrado');
					messages.put(LANG_CODE[1], 'Product not found');
					res.isSuccess = false;
					res.message = messages.get(UserInfo.getLanguage());
				}
			} else { 
				messages.put(LANG_CODE[0], 'Solo puede crear oportunidades  para su cartera de clientes');
				messages.put(LANG_CODE[1], 'Only can create opportunity for your portafolio of clients.');  
				res.isSuccess = false;
				res.message = messages.get(UserInfo.getLanguage()); 
			}
		} catch (DMLException ex) {
			res.isSuccess = false;
			res.message = ex.getDmlMessage(0);
			Database.rollback(savePoint);
		}
		return res;
	}
}