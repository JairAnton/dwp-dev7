/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CreateQuotation_cls>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-06
   @Description Class used to create quotation pdf
   @Changes
    Date        Author   Email                  			Type		Description
    2020-11-06  MAMCH    martin.mori.contractor@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CreateQuotation_cls {
	/**
	   @Description constructor method
	 */
    private BE_CreateQuotation_cls() {}

	/**
	   @Description method used to generate pdf and update opportunity
	   @param  String oppId id of opportunity
	 */
    public static void generatePDF(string oppId) {
        Final OpportunityLineItem ltsOli = [SELECT Id, Opportunity.Account.Name, price_quote_id__c, Product2.ProductCode FROM OpportunityLineItem WHERE OpportunityId = :oppId LIMIT 1];
		Final String namePDF = ltsOli.price_quote_id__c + ' - ' + ltsOli.Opportunity.Account.Name;
		Final List<ContentDocument> ltsContDoc = [SELECT ID FROM ContentDocument WHERE Title =:namePDF AND FileType = 'pdf'];

		Final pageReference pdfQuotation = Page.BE_Quotation_vfp;
		pdfQuotation.getParameters().put('id', oppId);
		Blob body;
		if(test.isRunningTest()) {
			body = blob.valueOf('TestString');
		} else {
			body = pdfQuotation.getContent();
		}
        
        if(ltsContDoc.isEmpty()) {
            Final ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S';
            conVer.versionData = body;
            conVer.title = namePDF;
            conVer.pathOnClient = conVer.title + '.pdf';
            insert conVer;
            
            Final Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            Final ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = oppId;
            conDocLink.ContentDocumentId = conDoc;
            conDocLink.shareType = 'V';
            insert conDocLink;
        } else {
            Final ContentVersion conVer = new ContentVersion();
            conVer.ContentDocumentId = ltsContDoc[0].Id;
            conVer.ContentLocation = 'S';
            conVer.versionData = body;
            conVer.title = namePDF;
            conVer.pathOnClient = conVer.title + '.pdf';
            conVer.IsMajorVersion = true;
            insert conVer;
        }
	}
}
