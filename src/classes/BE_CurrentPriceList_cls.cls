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
	/* string Web value */
    Final static String STROPPID = 'OpportunityId';
	
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
                res.data = Database.query('SELECT '+String.escapeSingleQuotes(param.sObjFields)+', CurrencyIsoCode FROM '+String.escapeSingleQuotes(param.sObjName)+' WHERE '+String.escapeSingleQuotes(param.filterSQOL));
                res.data = getFiles(res.data);
                res.isSuccess = true;
			    res.message = 'Success';
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
        Final Map<String, Id> mapFileIds = getFileIds(ids);
        for(sObject obj : data) {
            Final String namePDF = (String)obj.getSObject('Opportunity').getSObject('Account').get('Name') + ' - cotización Nro. ' + (String)obj.get('price_quote_id__c');
            Final String prodCode = (String)obj.getSObject('Product2').get('ProductCode');
            if(prodCode == Label.lblPDFProductCartaTecnicaEconomica || prodCode == Label.lblPDFProductCartaTecnicaImport) {
                obj.put('proposed_apr_per__c', (String)obj.get('proposed_fee_per__c'));
            }
            if(mapFileIds.containsKey((String)obj.get(STROPPID) + ' - ' + namePDF)) {
                obj.put('Unique_id__c', mapFileIds.get((String)obj.get(STROPPID) + ' - ' + namePDF));
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
            retMap.put(cdl.LinkedEntityId + ' - ' + cdl.ContentDocument.Title, cdl.ContentDocumentId);
        }
        return retMap;
	}
}