public without sharing class AnalyzeRate_helper {
    public RequestAnalyzeRate_Wrapper inputDataMapping { get; set; } //Ernesto 04/12/2018 : se agregó el get y set

    public AnalyzeRate_helper(String recordId, String strRequestedTea){
        List<String> lstFeesLabels_str = new List<String>{Label.PriceWSLabel10,Label.PriceWSLabel14,Label.PriceWSLabel15,Label.PriceWSLabel08,Label.PriceWSLabel05,Label.PriceWSLabel04};
        List<String> lstFeesLabels_str_ApiName = new List<String>{'expected_loss_per__c','financing_cost_stockholder_per__c','funding_cost_adjusted_per__c','efficiency_cost__c','regulatory_capital_per__c','additional_capital_per__c'};
        
        List<String> lstFeesLabels_cur = new List<String>{Label.PriceWSLabel03};
        List<String> lstFeesLabels_cur_ApiName = new List<String>{'capital_amount__c,capital_currency_id__c'};

        List<String> lstLiquitidyIndicators_str = new List<String>{Label.PriceWSLabel13, Label.PriceWSLabel11, Label.PriceWSLabel12};
        List<String> lstLiquitidyIndicators_ApiName = new List<String>{'additional_apread_per__c','minimum_spread_per__c','spread_per__c'};
        final String querytemp=String.join(lstFeesLabels_cur_ApiName, ',') ;
        final String querytemp2=String.join(lstLiquitidyIndicators_ApiName, ',') ;
        final String querytemp3=String.join(lstFeesLabels_str_ApiName, ',') ;
        final String querytemp4 = '\''+System.escapeSingleQuotes(recordId)+'\'';
        List<OpportunityLineItem> oliInfo = Database.query('SELECT Id,CurrencyIsoCode,Product2.price_approval_web_service_id__c,UnitPrice, ' +querytemp3 + 
                                                                ', ' +querytemp + 
                                                                ', ' + querytemp2 + 
                                                            ' FROM OpportunityLineItem WHERE OpportunityId = ' + querytemp4 ); //Ernesto 2018/12/04: se agrego String.escapeSingleQuotes                                                           
        if(!oliInfo.isEmpty()){
            List<Object> lstFeeds = new List<Object>();
            Integer pos = 0;
            for(String strFeed : lstFeesLabels_str_ApiName){
                Request_fees_str reqFees = new Request_fees_str();
                Request_detail_str reqDet = new Request_detail_str();
                reqDet.percentage = (oliInfo[0].get(strFeed)==null?'':String.valueOf(Double.valueOf(oliInfo[0].get(strFeed))/100));
                Request_feeType reqTyp = new Request_feeType();
                reqTyp.id = lstFeesLabels_str[pos];

                reqFees.detail = reqDet;
                reqFees.feeType = reqTyp;
                lstFeeds.add(reqFees);
                pos++;
            }
            pos = 0;
            for(String strFeed : lstFeesLabels_cur_ApiName){
                List<String> splitStrFeed = strFeed.split(',');

                Request_fees_cur reqFees = new Request_fees_cur();

                Request_detail_cur reqDet = new Request_detail_cur();
                reqDet.amount = Double.valueOf(oliInfo[0].get(splitStrFeed[0]));
                reqDet.currency_type = String.valueOf(oliInfo[0].get(splitStrFeed[1]));

                Request_feeType reqTyp = new Request_feeType();
                reqTyp.id = lstFeesLabels_cur[pos];

                reqFees.detail = reqDet;
                reqFees.feeType = reqTyp;

                lstFeeds.add(reqFees);
                pos++;
            }
            List<Object> lstLiquit = new List<Object>();
            pos = 0;
            for(String strLiquit : lstLiquitidyIndicators_ApiName){
                Request_liquidityIndicators liquit = new Request_liquidityIndicators();

                Request_detail_num detailNum = new Request_detail_num();
                detailNum.percentage = (oliInfo[0].get(strLiquit) == null? null : Double.valueOf(oliInfo[0].get(strLiquit)) / 100);

                liquit.detail = detailNum;
		        liquit.id = lstLiquitidyIndicators_str[pos];

                lstLiquit.add(liquit);
                pos++;
            }

            RequestAnalyzeRate_Wrapper requestInput = new RequestAnalyzeRate_Wrapper();
            requestInput.lstFees = JSON.serialize(lstFeeds);
            requestInput.strRequestedTea = strRequestedTea;
            requestInput.lstLiquitidyIndicators = JSON.serialize(lstLiquit);
            requestInput.productId = String.valueOf(oliInfo[0].Product2.price_approval_web_service_id__c);
            requestInput.strAmount = String.valueOf(oliInfo[0].UnitPrice);
            requestInput.currencyIsoCode = String.valueOf(oliInfo[0].CurrencyIsoCode);
            this.inputDataMapping = requestInput;
        }
        
    }

    public String generateJSONRequest(){
        String json = JSON.serialize(this.inputDataMapping);
        json = json.replace('currency_type', 'currency');
        return json;
    }

     //method to invoke the webservice 
    public System.HttpResponse invoke(){
        return iaso.GBL_Integration_GenericService.invoke('AnalyzeRate',generateJSONRequest());
    }

    public class RequestAnalyzeRate_Wrapper{
        public String lstFees { get; set; } //Yulino 29/11/2018 : se agregó el get y set
        public String strRequestedTea { get; set; } //Yulino 29/11/2018 : se agregó el get y set
        public String lstLiquitidyIndicators { get; set; } //Yulino 29/11/2018 : se agregó el get y set
        public String productId { get; set; } //Yulino 29/11/2018 : se agregó el get y set
        public String strAmount { get; set; } //Yulino 29/11/2018 : se agregó el get y set
        public String currencyIsoCode { get; set; } //Yulino 29/11/2018 : se agregó el get y set
    }
    public class Request_fees_str {
		public Request_detail_str detail { get; set; } //Yulino 29/11/2018 : se agregó el get y set
		public Request_feeType feeType { get; set; } //Yulino 29/11/2018 : se agregó el get y set
	}
    public class Request_detail_str {
		public String percentage { get; set; } //Yulino 29/11/2018 : se agregó el get y set
	}
    public class Request_feeType {
		public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
	}
    public class Request_fees_cur {
		public Request_detail_cur detail { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
		public Request_feeType feeType { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
	}
    public class Request_detail_cur {
		public Double amount { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
        public String currency_type { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
	}
    class Request_liquidityIndicators {
		public Request_detail_num detail { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
		public String id { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
	}
    public class Request_detail_num {
		public Double percentage { get; set; } //Ernesto 04/12/2018 : se agregó el get y set
	}
}