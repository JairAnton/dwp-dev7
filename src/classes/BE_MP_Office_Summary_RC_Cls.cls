/**
    @Author Jair Anton Atuncar (jair.anton.contractor@bbva.com)
    @Description (Vista Resumen PPG) Summary of family Recursos
    Date        Author   Email                  				Type
    2021-08-02  JAA     jair.anton.contractor@bbva.com    	    Initial version
**/

public with sharing class BE_MP_Office_Summary_RC_Cls extends BE_SingleRelatedListCRUD_Cls {
    /* type opp */
    private static Final String TYPEOPP = '02';
    /**
     * Wrapper class to the response
     */
    public class ResponseModel {
        /* Variable response model */
        Id planId { get; set; }
        /* Variable response model */
        Id groupId { get; set; }
        /* Variable response model */
        String name { get; set; }
        /* Variable response model */
        Double expectedDrop { get; set; }
        /* Variable response model */
        Double retomaR { get; set; }
        /* Variable response model */
        Id ownerId { get; set; }
        /* Variable response model */
        Integer nOperation { get; set; }
        /* Variable response model */
        Double oppAmount { get; set; }
        /* Variable response model */
        Double totalAmount { get; set; }
        /* Variable response model */
        Double netCommitment { get; set; }
    }
    
    /**
     * Read records 
    */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String, Object> param) {
		Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
		Final Map<String,String> messageMap = new Map<String,String>();
        
		try {
            response.data = getSummaryRC(param);
            response.isSuccess = true;
			response.message = messageMap.get(UserInfo.getLanguage());
		} catch (DMLException ex) {
			response.isSuccess = false;
			response.message = ex.getDmlMessage(0);
		}
		return response;
	}

    /**
     * get Summary RC
    */
    public static List<dwp_frct__grouping__c> getSummaryRC(Map<String, Object> param) {
        /* Get Management Plan of Gerente recordId */
        Final List<dwp_frct__management_plan__c> mPlanList = [SELECT Name, dwp_frct__management_plan_start_date__c, dwp_frct__management_plan_end_date__c, OwnerId FROM dwp_frct__management_plan__c WHERE Id =: (String)param.get('recordId')];
        Final dwp_frct__management_plan__c mplan = mPlanList[0];
        
        /* Get grouping of category type 'Recursos' */
        Final List<dwp_frct__grouping__c> groupList = [SELECT Id, dwp_frct__management_plan_id__c, dwp_frct__management_plan_id__r.Name, dwp_frct__opportunity_expected_drop_amount__c, dwp_frct__solution_category_type__c,
                                                         dwp_frct__management_plan_id__r.OwnerId, dwp_frct__net_commitment_amount__c
                                                    FROM dwp_frct__grouping__c 
                                                    WHERE dwp_frct__solution_category_type__c = 'Recursos' AND 
                                                        (dwp_frct__management_plan_id__r.dwp_frct__user_id__c =: mplan.OwnerId OR dwp_frct__management_plan_id__r.OwnerId =: mplan.OwnerId) AND 
                                                        dwp_frct__management_plan_id__r.dwp_frct__management_plan_start_date__c >=: mplan.dwp_frct__management_plan_start_date__c AND 
                                                        dwp_frct__management_plan_id__r.dwp_frct__management_plan_end_date__c <=: mplan.dwp_frct__management_plan_end_date__c];
        
        Final Map<Id, ResponseModel> dtMap = new Map<Id, ResponseModel>();
        Final Map<Id, Id> groupOppMap = new Map<Id, Id>();
        Final Set<Id> gpOppSet = new Set<Id>();
        
        /* Create map for expected drop */
        for(dwp_frct__grouping__c item : groupList) {
            Final ResponseModel dtItem = new ResponseModel();
            dtItem.planId = item.dwp_frct__management_plan_id__c;
            dtItem.name = item.dwp_frct__management_plan_id__r.Name;
            dtItem.retomaR = 0.00;
            dtItem.totalAmount = 0;
            dtItem.oppAmount = 0;
            dtItem.nOperation = 0;
            dtItem.netCommitment = item.dwp_frct__net_commitment_amount__c;
            dtItem.expectedDrop = item.dwp_frct__opportunity_expected_drop_amount__c;
            dtItem.groupId = item.Id;
            dtItem.ownerId = item.dwp_frct__management_plan_id__r.OwnerId;
            groupOppMap.put(item.Id, item.dwp_frct__management_plan_id__r.OwnerId);
            
            dtMap.put(item.dwp_frct__management_plan_id__r.OwnerId, dtItem);
            gpOppSet.add(item.dwp_frct__management_plan_id__r.OwnerId);
        }
        
        /* Get selected opportunities of type 'renewal' and 'new' */
        List<AggregateResult> groupOppList = [SELECT dwp_frct__grouping_id__c, COUNT(dwp_frct__opportunity_id__c) nOperation, SUM(dwp_frct__opportunity_id__r.Amount) sumAmount, dwp_frct__opportunity_id__r.OwnerId oppOwnerId, dwp_frct__opportunity_id__r.Type typeOpp
                                              FROM dwp_frct__grouping_opp__c 
                                              WHERE dwp_frct__grouping_id__c  IN : groupOppMap.keySet() AND dwp_frct__opportunity_id__r.Type IN ('01', '02') AND dwp_frct__opportunity_id__r.OwnerId IN : gpOppSet
                                              GROUP BY dwp_frct__opportunity_id__r.Type, dwp_frct__grouping_id__c, dwp_frct__opportunity_id__r.OwnerId];
        
        /* Loop for setear retomaCP and set operations, amount of operation per owner */
        Double sumAmount = calculateRetoma(groupOppList, groupOppMap, dtMap);
        
        return setResultList(dtMap, sumAmount);
    }

    private static List<dwp_frct__grouping__c> setResultList(Map<Id, ResponseModel> dtMap, Double sumAmount) {
        Final List<dwp_frct__grouping__c> resultList = new List<dwp_frct__grouping__c>();
        
        /* Variable for calculate amount per column */
        Double amountCol1 = 0, amountCol2 = 0, amountCol3 = 0, amountCol5 = 0, amountCol6 = 0, amountCol7 = 0;
        Integer amountCol4 = 0;
           
        /* Set response model for datatable */ 
        for(ResponseModel item : dtMap.values()) {    
            Final dwp_frct__grouping__c grouping = new dwp_frct__grouping__c();
            grouping.dwp_frct__management_plan_id__c = item.planId;            
            grouping.Name = item.Name;
            grouping.dwp_frct__management_expected_drop_amount__c = item.expectedDrop;
            grouping.dwp_frct__opportunity_selected_tot_amount__c = item.retomaR;
            grouping.dwp_frct__opportunity_antcp_expiry_amount__c = calculatePercentage(item.expectedDrop, item.retomaR, item.expectedDrop);
            grouping.dwp_frct__solution_category_type__c = String.valueOf(item.nOperation);
            grouping.dwp_frct__opportunity_cancellation_amount__c = item.oppAmount;
            grouping.dwp_frct__opportunity_closed_amount__c = calculatePercentage(item.oppAmount, item.oppAmount, sumAmount);
            grouping.dwp_frct__original_commitment_amount__c = item.netCommitment;
            
            /* Sum amount per row */
            amountCol1 = amountCol1 + item.expectedDrop;
            amountCol2 = amountCol2 + item.retomaR;
            amountCol3 = amountCol3 + calculatePercentage(item.expectedDrop, item.retomaR, item.expectedDrop);
            amountCol4 = amountCol4 + item.nOperation;
            amountCol5 = amountCol5 + item.oppAmount;
            amountCol6 = amountCol6 + calculatePercentage(sumAmount, item.oppAmount, sumAmount);
            amountCol7 = amountCol7 + item.netCommitment;
            resultList.add(grouping);
        }
        
        /* Add item per total per column */
        Final dwp_frct__grouping__c calculateGP = new dwp_frct__grouping__c();
        calculateGP.Name = 'TOTAL';
        calculateGP.dwp_frct__management_expected_drop_amount__c = amountCol1;
        calculateGP.dwp_frct__opportunity_selected_tot_amount__c = amountCol2;
        calculateGP.dwp_frct__opportunity_antcp_expiry_amount__c = amountCol3;
        calculateGP.dwp_frct__solution_category_type__c = String.valueOf(amountCol4);
        calculateGP.dwp_frct__opportunity_cancellation_amount__c = amountCol5;
        calculateGP.dwp_frct__opportunity_closed_amount__c = amountCol6;
        calculateGP.dwp_frct__original_commitment_amount__c = amountCol7;
        resultList.add(calculateGP);

        return resultList;
    }

    private static Double calculatePercentage(Double value1, Double value2, Double value3) {
        Double calculatedValue = 0;

        if(value1 > 0) {
            calculatedValue = value2 / value3;
        }

        return calculatedValue;
    }

    private static Double calculateRetoma(List<AggregateResult> groupOppList, Map<Id, Id> groupOppMap, Map<Id, ResponseModel> dtMap) {
        Double sumAmount = 0;

        for(AggregateResult oppItem : groupOppList) {
            if(groupOppMap.containsKey((Id)oppItem.get('dwp_frct__grouping_id__c'))) {
                Final Id ownerId = groupOppMap.get((Id)oppItem.get('dwp_frct__grouping_id__c'));
                Final ResponseModel itemMap = dtMap.get(ownerId);
                
                sumAmount = searchOwner(itemMap, oppItem, sumAmount);
            }
        }

        return sumAmount;
    }

    private static Double searchOwner(ResponseModel itemMap, AggregateResult oppItem, Double sumAmount) {
        Double finalSumAmount = sumAmount;

        if(itemMap.OwnerId == (Id)oppItem.get('oppOwnerId')) {
            if((String)oppItem.get('typeOpp') == TYPEOPP) {
                itemMap.retomaR = (Double)oppItem.get('sumAmount');
            } else {
                itemMap.nOperation = (Integer)oppItem.get('nOperation');
                itemMap.oppAmount = (Double)oppItem.get('sumAmount');
                finalSumAmount = finalSumAmount + itemMap.oppAmount;
            }	   
        }

        return finalSumAmount;
    }
}