/**
* @author Global_HUB developers
* @date 14-08-2018
*
* @group Global_HUB
*
* @description Controller class from SimulatePrice_cmp
**/
public with sharing class SimulatePrice_ctrl {
    static String idOli;
    @AuraEnabled
    //getInfo with the id of Opportunity
    public static Map<String,Object> getInfo(String recordId){
        Map<String,Object> mapReturn = new Map<String,Object>();
        Double minimtea;
        Double sugtea;
        Double spread;
        String genericError;
        try{
            //helper to call the service
            PriceRate_helper prate = new PriceRate_helper(recordId, true);
            //invoke the service
            HttpResponse invoke = prate.invoke();
            //get json body
            PriceRate_helper.ResponseSimulateRate_Wrapper jbody = prate.parse(invoke.getBody());
            //get values if statuscode=200
            if(invoke.getStatusCode() == 200){
                if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].interestRates != null &&
                   jbody.data.summary[0].interestRates.EffectiveRates != null){
                       List<PriceRate_helper.Response_EffectiveRates> lsttea = jbody.data.summary[0].interestRates.EffectiveRates;               
                       for (Integer i = 0; i<lsttea.size(); i++){
                           
                           if (lsttea[i].id == Label.MinTEA){
                               minimtea = lsttea[i].percentage*100;
                           } else if (lsttea[i].id == Label.SuggTEA){
                               sugtea = lsttea[i].percentage*100;
                           }                   
                       }             
                   }
                if(jbody.data != null && jbody.data.summary != null && jbody.data.summary[0].LiquidityIndicators !=null){
                    List<PriceRate_helper.Response_LiquidityIndicators> lstspread = jbody.data.summary[0].LiquidityIndicators;
                    for(Integer x =0; x<lstspread.size(); x++){
                        if (lstspread[x].id == Label.commSpread){
                            spread = lstspread[x].detail.percentage*100;
                        }
                    }
                }
                //get errors
            } else if (invoke.getStatusCode() == 409){
                WebServiceUtils.ResponseErrorMessage_Wrapper jerror = WebServiceUtils.parse(invoke.getBody());
                genericError = jerror.errormessage;
            } else{
                genericError = Label.GenericError;
            }
            
            SimulatePrice_ctrl.updateOLI(sugtea, minimtea, spread, recordId);
            
        }catch(Exception e){
            genericError = e.getMessage();
        }
        mapReturn.put('oli',idOli);
        mapReturn.put('minimtea', minimtea);
        mapReturn.put('sugtea',sugtea);
        mapReturn.put('spread',spread);
        mapReturn.put('genericError',genericError);
        
        return mapReturn;
    }
    // update OpportunityLineItem fields
    public static void updateOLI(Double teasug, Double teaminim, Double spread, String oppId){
        OpportunityLineItem oli =[Select Id, Name, minimun_apr_per__c, suggested_apr_per__c, spread_per__c
                                  from OpportunityLineItem where OpportunityId = : oppId];
        oli.minimun_apr_per__c = teaminim;
        oli.suggested_apr_per__c = teasug;
        oli.spread_per__c = spread;
        idOli = oli.Id;
        update oli;
    }
}