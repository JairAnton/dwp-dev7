trigger Grouping_Trigger on dwp_frct__grouping__c (before insert) {

    dwp_frct.Grouping_Handler handler = new dwp_frct.Grouping_Handler ();
    if(trigger.isAfter) {
        if(trigger.isUpdate) {
            handler.GroupingAfterUpdate(trigger.new, Trigger.oldMap);
            /*
            Set<Id> ids = new Set<Id>();
            //Set owners ids 
            Set<Id> idsOwners = new Set<Id>();
            //Set product families
            Set<String> families = new Set<String>();
            //Set start dates
            Set<Date> dates = new Set<Date>();
            Map<Id,ForecastingQuota> mapGroupQuote = new Map<Id,ForecastingQuota>();
            list<ForecastingQuota> newQuotas = new List<ForecastingQuota>();
            list<ForecastingQuota> updateQuotas = new List<ForecastingQuota>();
            List<ForecastingType> foretypes = new List<ForecastingType>();
            List<dwp_frct__grouping__c> grouplist = new List<dwp_frct__grouping__c>();
          
            for ( dwp_frct__grouping__c gr: trigger.new) {
              if ( Trigger.oldMap.get(gr.id).dwp_frct__original_commitment_amount__c != gr.dwp_frct__original_commitment_amount__c ){
                ids.add(gr.Id);
                System.debug(gr.Id);  
              }
            }
      
            if (!ids.isEmpty()){
                for (dwp_frct__grouping__c gr: [SELECT id,dwp_frct__original_commitment_amount__c, dwp_frct__management_plan_id__r.dwp_frct__management_plan_start_date__c,dwp_frct__management_plan_id__r.OwnerId, CurrencyIsoCode, dwp_frct__solution_category_type__c FROM dwp_frct__grouping__c WHERE Id in: ids AND dwp_frct__management_plan_id__r.dwp_frct__management_plan_stage_type__c = '04']){
                     grouplist.add(gr);
                     Date dategroup = gr.dwp_frct__management_plan_id__r.dwp_frct__management_plan_start_date__c.date(); 
                     dates.add(dategroup);
                     idsOwners.add(gr.dwp_frct__management_plan_id__r.OwnerId);
                     families.add(gr.dwp_frct__solution_category_type__c);
                }
                foretypes = [Select id, IsActive from ForecastingType WHERE IsActive= true ];
                list<ForecastingQuota> quotaList = [SELECT id, QuotaOwnerId, ProductFamily, StartDate FROM ForecastingQuota WHERE QuotaOwnerId in: idsOwners AND ProductFamily in: families AND StartDate in:dates];
                for (dwp_frct__grouping__c gr:grouplist){
                    for (ForecastingQuota qt:quotaList){
                        Date dateGr = gr.dwp_frct__management_plan_id__r.dwp_frct__management_plan_start_date__c.date();
                        if ( (gr.dwp_frct__management_plan_id__r.OwnerId == qt.QuotaOwnerId) && (gr.dwp_frct__solution_category_type__c == qt.ProductFamily ) && (dateGr == qt.StartDate) ){
                              mapGroupQuote.put(gr.Id, qt);
                        }
                    }
                    
                }
                for (dwp_frct__grouping__c gr:grouplist){
                    if (mapGroupQuote.containsKey(gr.Id)){
                        
                        ForecastingQuota fq = mapGroupQuote.get(gr.Id);
                        fq.QuotaAmount = gr.dwp_frct__original_commitment_amount__c;
                        updateQuotas.add(fq);
                        
                    }else{
                        
                        ForecastingQuota quota = new ForecastingQuota();
                        quota.QuotaAmount = gr.dwp_frct__original_commitment_amount__c;
                        quota.CurrencyIsoCode = gr.CurrencyIsoCode;
                        quota.QuotaOwnerId = gr.dwp_frct__management_plan_id__r.OwnerId;
                        quota.ForecastingTypeId = foretypes[0].Id;
                        Datetime quotaDate = gr.dwp_frct__management_plan_id__r.dwp_frct__management_plan_start_date__c;
                        quota.StartDate = quotaDate.date();
                        quota.ProductFamily = gr.dwp_frct__solution_category_type__c;
                        newQuotas.add(quota); 
                    }
                }
                if ( !newQuotas.isEmpty() ){
                    insert newQuotas;
                }
                if ( !updateQuotas.isEmpty() ){
                    update updateQuotas;
                }
                    
            }*/
     	}
  	}
    
}