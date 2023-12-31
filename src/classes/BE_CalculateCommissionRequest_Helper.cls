    /**
     -------------------------------------------------------------------------------------------------
    @Name <BE_CalculateCommissionRequest_Helper>
    @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
    @Date 2021-03-17
    @Description Class used to call CalculateCommissionRequest method
    @Changes
    Date        Author   Email                  				Type		Description
    2021-03-17  MAMC     martin.mori.contractor@bbva.com    	Creation
    -------------------------------------------------------------------------------------------------
    */
    public with sharing class BE_CalculateCommissionRequest_Helper {
        /* variable request wrapper */
        public CalculateCommissionRequest_Wrapper inputDataMapping {get; set;}
        /* */
        public List<String> requestStages = new List<String>{'12', '18', '14', '15', '16', '17', '24', '13', '03'};
        /*  */
        public List<String> authorizedStages = new List<String>{'09', '11', '08'};

        /* Method use to get input information */
        public BE_CalculateCommissionRequest_Helper(Product_Commission__c commission, String status) {
            if(commission!=null) {
                Final CalculateCommissionRequest_Wrapper requestWrapper = new CalculateCommissionRequest_Wrapper(commission, status, requestStages, authorizedStages);
                this.inputDataMapping = requestWrapper;
            }
        }

        /** method to check if value is null or empty */
        private static Boolean StringIsNullOrEmpty(String text) {
            Boolean result = false;
            if(text == null) {
                result = true;
            } 
            if(text == '') {
                result = true;
            }
            return result;
        }

        /* Wrapper class to map the input values with the input attributes of the webservice */
        public class CalculateCommissionRequest_Wrapper {
            /* variable initialAmount.Amount  */
            public String initialAmountAmount {get; set;}
            /* variable initialAmount.currency  */
            public String initialAmountCurrency {get; set;}
            /* variable term.frequency.id  */
            public String termNumber {get; set;}
            /* variable fixedFee.id  */
            public String fixedFeeId {get; set;}
            /* variable termFrequencyId.id  */
            public String termFrequencyId {get; set;}
            /* variable rates.itemizeRates[n].rateUnit (LIST)  */
            public String ratesItemizeRatesRateUnit {get; set;}
            /* variable rates.questions (LIST)  */
            public String questions {get; set;}
            
            /* constructor method */
            public CalculateCommissionRequest_Wrapper(Product_Commission__c commission, String status, List<String> requestStages, List<String> authorizedStages) {
                this.initialAmountAmount = String.valueOf( Integer.valueOf(commission.Opportunity_Product__r.unitprice));
                this.initialAmountCurrency = commission.Opportunity_Product__r.CurrencyIsoCode;
                this.termNumber = (commission.Term_Number__c == null ? '6' : String.valueOf(commission.Term_Number__c));
                this.termFrequencyId = commission.Term_Frequency_Id__c == null ? 'MONTHLY' : commission.Term_Frequency_Id__c;
                this.fixedFeeId = (commission.Code__c == null ? '' : commission.Code__c);
                
                /**Calculate Rate */
                Decimal rate = calculateRate(commission, status, requestStages, authorizedStages);
                String isoCode = calculateIsoCode(commission);
            
                if(commission.Suggested_Rate_Type__c == 'PERCENTAGE') {
                    this.ratesItemizeRatesRateUnit = '{"unitRateType":"'+commission.Suggested_Rate_Type__c.toUppercase()+'","percentage":'+rate +'}';
                } else {
                    this.ratesItemizeRatesRateUnit = '{"unitRateType":"'+commission.Suggested_Rate_Type__c.toUppercase()+'","amount":'+rate+',"currency":"'+isoCode+'"}';
                }

                /**Calculate */
                if(commission.Commission_Questions__r.size() >= 1) {
                    this.questions = calculateQuestionnaires(commission, status, requestStages, authorizedStages);
                } else {
                    this.questions = '';
                }
            }
        }
        
        /*method calculateQuestionnaires*/
        public static String calculateQuestionnaires(Product_Commission__c commission, String status, List<String> requestStages, List<String> authorizedStages) {
            string questions = ',"questions":[';
            for(Commission_Question__c question : commission.Commission_Questions__r) {
                String answer = '';
                if(question.Answer__c == 'true') {
                    answer = 'SI';
                } else if(question.Answer__c == 'false') {
                    answer = 'NO';
                } else {
                    answer = String.valueOf(question.Answer__c);
                }
                questions = questions + '{"id":'+ String.valueOf(question.Code__c) +',"answer":"'+answer+'"},';
            }
            questions = questions + ']';
            questions = questions.replace('},]', '}]');
            return questions;
        }
        
        /*method calculateRate*/
        public static Decimal calculateRate(Product_Commission__c commission, String status, List<String> requestStages, List<String> authorizedStages) {         		 
            Decimal rate = 0;
            if(!StringIsNullOrEmpty(commission.Suggested_Rate__c)) {
                rate = Decimal.valueOf(commission.Suggested_Rate__c);
            }
            if(commission.Requested_Rate_Value__c != null) {
                rate = commission.Requested_Rate_Value__c;
            } 
            if (commission.Authorized_Rate_Value__c != null && status !='24' && status != '03') {
                rate = commission.Authorized_Rate_Value__c;
            } 

            return rate;
        }

        /* method to convert the input data mapping to a JSON structure */
        public String generateJSONRequest() {
            return JSON.serialize(this.inputDataMapping);
        }

        /**Calculate Iso Code */
        public static string calculateIsoCode(Product_Commission__c commission) {
            String isoCode = commission.CurrencyIsoCode;
            if(commission.Suggested_Rate_Iso_Code__c != null) {
                IsoCode = commission.Suggested_Rate_Iso_Code__c;
            }
            return isoCode;
        }

        /* Method to invoke the webservice */
        public System.HttpResponse invoke() {
            return iaso.GBL_Integration_GenericService.invoke('CalculateCommission', generateJSONRequest());
        }
    }