/**
 * BE_CurrentPriceList_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Martín Mori - Diego Carbajal 03/11/2020          Original version.<p />
 *
 * @author Martín Mori - Diego Carbajal
 */
public with sharing class BE_CurrentPriceList_cls extends BE_SingleRelatedListCRUD_Cls {
	/* string OpportunityId value */
    Final static String STROPPID = 'OpportunityId';
	/* string concat value */
    Final static String STRCONCAT = ' - ';
	
	/*
	 * @Description  method readRecords
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String, Object> mapParams) {
		Final BE_SingleRelatedListCRUD_Cls.Response res = new BE_SingleRelatedListCRUD_Cls.Response(true, '');
		Final BE_SingleRelatedList_Ctr.Params param = new BE_SingleRelatedList_Ctr.Params();
		param.sObjName = (String)mapParams.get('sObjName');
		param.sObjFields = (String)mapParams.get('sObjFields');
		param.filterSQOL = (String)mapParams.get('filterSQOL');
		try {
            Final List<OpportunityLineItem> olis = [SELECT Id, Opportunity.AccountId, Product2.ProductCode FROM OpportunityLineItem WHERE OpportunityId = :(String)mapParams.get('recordId')];
            if(!olis.isEmpty()) {
                //Variables usadas en query dinamica
                Final String clientId = olis[0].Opportunity.AccountId;
                Final String productId = olis[0].Product2.ProductCode;
                if(clientId!=null && productId!=null) {
                    res.data = Database.query('SELECT '+String.escapeSingleQuotes(param.sObjFields)+', CurrencyIsoCode FROM '+String.escapeSingleQuotes(param.sObjName)+' WHERE '+String.escapeSingleQuotes(param.filterSQOL));
                    res.data = getFiles(res.data);
                    res.isSuccess = true;
                    res.message = 'Success';
                }
            }
		} catch (Exception e) {
			res.isSuccess = false;
			res.message = 'Error '+ e.getMessage();
		}
		return res;
	}
    
    /*
	 * @Description  method get files
	 */
	public List<sObject> getFiles(List<SObject> data) {
        Final Set<Id> ids = new Set<Id>();
        for(sObject obj : data) {
            if(obj.isSet(STROPPID)) {
                ids.add((String)obj.get(STROPPID));
            }
        }
        if(!ids.isEmpty()) {
            Final Map<String, Id> mapFileIds = getFileIds(ids);
            for(sObject obj : data) {
                Final String namePDF = (String)obj.get('price_quote_id__c') + STRCONCAT + (String)obj.getSObject('Opportunity').getSObject('Account').get('Name');
                Final String prodCode = (String)obj.getSObject('Product2').get('ProductCode');
                if(mapFileIds.containsKey((String)obj.get(STROPPID) + STRCONCAT + namePDF)) {
                    obj.put('Unique_id__c', mapFileIds.get((String)obj.get(STROPPID) + STRCONCAT + namePDF));
                }
            }
        }
        return data;
    }

	/*
	 * @Description  method get files ids
	 */
	private Map<String, Id> getFileIds(Set<Id> ids) {
        Final Map<String, Id> retMap = new Map<String, Id>();
        for(ContentDocumentLink cdl : [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :ids AND ContentDocument.FileType = 'pdf']) {
            retMap.put(cdl.LinkedEntityId + STRCONCAT + cdl.ContentDocument.Title, cdl.ContentDocumentId);
        }
        return retMap;
	}
}
