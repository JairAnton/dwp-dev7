/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_HistoricalQuotes_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-02-16
   @Description Test class from BE_HistoricalQuotes_Ctr and BE_ListQuotationRequest_Helper
   @Changes
   Date        Author   Email                  				Type		Description
   2021-02-16  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@istest
public class BE_HistoricalQuotes_Tst {
	/* string cache */
    final static String STRCACHE = 'iaso.ServicesPartition';
    /* string endpoint ListQuotationRequests ok */
    final static String URLOK = 'https://ListQuotationRequest/OK';
    /* string endpoint grantingticket */
    final static String URLGT = 'https://validation/ok';
    /* string grantingtickets */
    final static String STRGT = 'grantingtickets';
    /* string ListQuotationRequests */
    final static String STRLQ = 'ListQuotationRequests';
    /* string isOk */
    final static String STROK = 'isOk';
    /* string error */
    final static String STRERROR = 'error!!!';
	/* integer six result */
    final static Integer SIX = 6;

	/**@Description method used to success scenary for BE_HistoricalQuotes_Ctr*/
    @isTest
	static void testOK() {
        Final Account acc = TestFactory.createAccount();
        acc.main_code_id__c = '26835866';
        update acc;
        Final Product2 prod = TestFactory.createProduct();
		prod.Type_of_quote__c = 'Web';
        prod.PRICE_APPROVAL_WEB_SERVICE_ID__C = '15';
		update prod;
        
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRGT, iaso__Url__c = URLGT, iaso__Cache_Partition__c = STRCACHE);
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRLQ, iaso__Url__c = URLOK, iaso__Cache_Partition__c = STRCACHE);
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		
        Test.startTest();
        Final Map<String, Object> mapReturnLQ = BE_HistoricalQuotes_Ctr.getQuotes(acc.Id, 'ListQuotationRequests');
        Boolean isOk = false;
        if(mapReturnLQ.get('totalPages') == SIX) {
            isOk = true;
        }
		System.assert(isOk, 'correct!!!');
		Test.stopTest();
	}
    
    /**@Description method used to generic error scenary for BE_HistoricalQuotes_Ctr class*/
    @isTest
	static void testError() {
		Test.startTest();
        Final Map<String, Object> mapReturnLQ = BE_HistoricalQuotes_Ctr.getQuotes('26835866', 'ListQuotationRequests');
		System.assert(!(Boolean)mapReturnLQ.containsKey('totalPages'), STRERROR);
		Test.stopTest();
	}
}