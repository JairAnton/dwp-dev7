/**
    @Author Jair Anton Atuncar (jair.anton.contractor@bbva.com)
    @Description (Vista Resumen PPG) Summary of family Financiamiento Corto Plazo y Largo Plazo
    Date        Author   Email                  				Type
    2021-08-02  JAA     jair.anton.contractor@bbva.com    	    Initial version
**/

public with sharing class BE_MP_Office_Summary_CPLP_Cls extends BE_SingleRelatedListCRUD_Cls {
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
        Double sumExpectedDrop { get; set; }
        /* Variable response model */
        Double expectedDrop { get; set; }
        /* Variable response model */
        Double retomaCP { get; set; }
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
            response.data = getSummaryCPLP(param);
            response.isSuccess = true;
			response.message = messageMap.get(UserInfo.getLanguage());
		} catch (DMLException ex) {
			response.isSuccess=false;
			response.message=ex.getDmlMessage(0);
		}
		return response;
	}

    public static List<dwp_frct__grouping__c> getSummaryCPLP(Map<String, Object> param) {
        /* Get Management Plan of Gerente recordId */
        Final List<dwp_frct__management_plan__c> mPlanList = [SELECT Name, dwp_frct__management_plan_start_date__c, dwp_frct__management_plan_end_date__c, OwnerId FROM dwp_frct__management_plan__c WHERE Id =: (String)param.get('recordId')];
        Final dwp_frct__management_plan__c mplan = mPlanList[0];
        
        /* Get grouping of category type 'Financimiento CP and LP' */
        Final List<dwp_frct__grouping__c> groupList = [SELECT Id, dwp_frct__management_plan_id__c, dwp_frct__management_plan_id__r.Name, dwp_frct__opportunity_expected_drop_amount__c, dwp_frct__solution_category_type__c,
                                                         dwp_frct__management_plan_id__r.OwnerId, dwp_frct__net_commitment_amount__c
                                                    FROM dwp_frct__grouping__c 
                                                    WHERE dwp_frct__solution_category_type__c IN ('Financiamiento a corto plazo', 'Financiamiento a largo plazo') AND 
                                                        (dwp_frct__management_plan_id__r.dwp_frct__user_id__c =: mplan.OwnerId OR dwp_frct__management_plan_id__r.OwnerId =: mplan.OwnerId) AND 
                                                        dwp_frct__management_plan_id__r.dwp_frct__management_plan_start_date__c >=: mplan.dwp_frct__management_plan_start_date__c AND 
                                                        dwp_frct__management_plan_id__r.dwp_frct__management_plan_end_date__c <=: mplan.dwp_frct__management_plan_end_date__c];
        
        Final Map<Id, ResponseModel> dtMap = new Map<Id, ResponseModel>();
        Final Map<Id, Id> groupOppMap = new Map<Id, Id>();
        Final Map<Id, Id> cpIdMap = new Map<Id, Id>();
        Final Set<Id> gpOppSet = new Set<Id>();
        
        /* Create map for calculate expected drop per category type */
        calculateCPLP(groupList, dtMap, cpIdMap, gpOppSet, groupOppMap);
        
        /* Get selected opportunities of type 'renewal' and 'new' */
        List<AggregateResult> groupOppList = [SELECT dwp_frct__grouping_id__c, COUNT(dwp_frct__opportunity_id__c) nOperation, SUM(dwp_frct__opportunity_id__r.Amount) sumAmount, dwp_frct__opportunity_id__r.OwnerId oppOwnerId, dwp_frct__opportunity_id__r.Type typeOpp
                                                FROM dwp_frct__grouping_opp__c 
                                                WHERE dwp_frct__grouping_id__c  IN : groupOppMap.keySet() AND dwp_frct__opportunity_id__r.Type IN ('01', '02') AND dwp_frct__opportunity_id__r.OwnerId IN : gpOppSet
                                                GROUP BY dwp_frct__opportunity_id__r.Type, dwp_frct__grouping_id__c, dwp_frct__opportunity_id__r.OwnerId];
        
        /* Loop for setear retomaCP and set operations, amount of operation per owner */
        Double sumAmount = calculateRetoma(groupOppList, groupOppMap, dtMap, cpIdMap);
        
        return setResultList(dtMap, sumAmount, param);
    }

    /**
     * Wrapper set result with sum per column
     */
    private static List<dwp_frct__grouping__c> setResultList(Map<Id, ResponseModel> dtMap, Double sumAmount, Map<String, Object> param) {
        Final List<dwp_frct__grouping__c> resultList = new List<dwp_frct__grouping__c>();

        /* Variable for calculate amount per column*/
        Double amountCol1 = 0, amountCol2 = 0, amountCol3 = 0, amountCol4 = 0, amountCol5 = 0, amountCol7 = 0, amountCol8 = 0, amountCol9 = 0;
        Integer amountCol6 = 0;
        
        /* Set response model for datatable */ 
        for(ResponseModel item : dtMap.values()) {
            Final dwp_frct__grouping__c grouping = new dwp_frct__grouping__c();
            grouping.dwp_frct__management_plan_id__c = item.planId;            
            grouping.Name = item.Name;
            grouping.dwp_frct__management_expected_drop_amount__c = item.sumExpectedDrop;
            grouping.dwp_frct__management_plan_amount__c = item.expectedDrop;
            grouping.dwp_frct__opportunity_selected_tot_amount__c = item.retomaCP;
            grouping.dwp_frct__opportunity_antcp_expiry_amount__c = calculatePercentage(item.expectedDrop, item.retomaCP, item.expectedDrop);
            grouping.dwp_frct__opportunity_amortization_amount__c = calculatePercentage(item.sumExpectedDrop, item.retomaCP, item.sumExpectedDrop);
            grouping.dwp_frct__solution_category_type__c = String.valueOf(item.nOperation);
            grouping.dwp_frct__opportunity_cancellation_amount__c = item.oppAmount;
            grouping.dwp_frct__opportunity_closed_amount__c = calculatePercentage(sumAmount, item.oppAmount, sumAmount);
            grouping.dwp_frct__original_commitment_amount__c = item.netCommitment;
            
            /* Sum amount per row */
            amountCol1 = amountCol1 + item.sumExpectedDrop;
            amountCol2 = amountCol2 + item.expectedDrop;
            amountCol3 = amountCol3 + item.retomaCP;
            amountCol4 = amountCol4 + calculatePercentage(item.expectedDrop, item.retomaCP, item.expectedDrop);
            amountCol5 = amountCol5 + calculatePercentage(item.sumExpectedDrop, item.retomaCP, item.sumExpectedDrop);
            amountCol6 = amountCol6 + item.nOperation;
            amountCol7 = amountCol7 + item.oppAmount;
            amountCol8 = amountCol8 + calculatePercentage(sumAmount, item.oppAmount, sumAmount);
            amountCol9 = amountCol9 + item.netCommitment;
            resultList.add(grouping);
        }
        
        /* Add item per total per column */
        Final dwp_frct__grouping__c calculateGP = new dwp_frct__grouping__c();
        calculateGP.dwp_frct__management_plan_id__c = (String)param.get('recordId');
        calculateGP.Name = 'TOTAL';
        calculateGP.dwp_frct__management_expected_drop_amount__c = amountCol1;
        calculateGP.dwp_frct__management_plan_amount__c = amountCol2;
        calculateGP.dwp_frct__opportunity_selected_tot_amount__c = amountCol3;
        calculateGP.dwp_frct__opportunity_antcp_expiry_amount__c = amountCol4;
        calculateGP.dwp_frct__opportunity_amortization_amount__c = amountCol5;
        calculateGP.dwp_frct__solution_category_type__c = String.valueOf(amountCol6);
        calculateGP.dwp_frct__opportunity_cancellation_amount__c = amountCol7;
        calculateGP.dwp_frct__opportunity_closed_amount__c = amountCol8;
        calculateGP.dwp_frct__original_commitment_amount__c = amountCol9;
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

    private static void calculateCPLP(List<dwp_frct__grouping__c> groupList, Map<Id, ResponseModel> dtMap, Map<Id, Id> cpIdMap, Set<Id> gpOppSet, Map<Id, Id> groupOppMap) {
        for(dwp_frct__grouping__c item : groupList) {
            if(dtMap.containsKey(item.dwp_frct__management_plan_id__r.OwnerId)) {
                Final ResponseModel itemMap = dtMap.get(item.dwp_frct__management_plan_id__r.OwnerId);
                itemMap.retomaCP = 0;
                itemMap.totalAmount = 0;
                itemMap.oppAmount = 0;
                itemMap.nOperation = 0;
                itemMap.sumExpectedDrop = itemMap.sumExpectedDrop + item.dwp_frct__opportunity_expected_drop_amount__c;
                itemMap.netCommitment = itemMap.netCommitment + item.dwp_frct__net_commitment_amount__c;
                
                validateCP(item, itemMap, cpIdMap);
                
                dtMap.put(item.dwp_frct__management_plan_id__r.OwnerId, itemMap);
            } else {
                Final ResponseModel itemMap = new ResponseModel();
                itemMap.planId = item.dwp_frct__management_plan_id__c;
                itemMap.name = item.dwp_frct__management_plan_id__r.Name;
                itemMap.sumExpectedDrop = item.dwp_frct__opportunity_expected_drop_amount__c;
                itemMap.retomaCP = 0;
                itemMap.totalAmount = 0;
                itemMap.oppAmount = 0;
                itemMap.nOperation = 0;
                itemMap.expectedDrop = 0;
                itemMap.netCommitment = item.dwp_frct__net_commitment_amount__c;
                
                validateCP(item, itemMap, cpIdMap);
                
                dtMap.put(item.dwp_frct__management_plan_id__r.OwnerId, itemMap);
            }
            
            gpOppSet.add(item.dwp_frct__management_plan_id__r.OwnerId);
            groupOppMap.put(item.Id, item.dwp_frct__management_plan_id__r.OwnerId);
        }
    }

    private static void validateCP(dwp_frct__grouping__c item, ResponseModel itemMap, Map<Id, Id> cpIdMap) {
        Final String categoryType = 'Financiamiento a corto plazo';

        if(item.dwp_frct__solution_category_type__c == categoryType) {
            itemMap.expectedDrop = item.dwp_frct__opportunity_expected_drop_amount__c;
            itemMap.groupId = item.Id;
            itemMap.ownerId = item.dwp_frct__management_plan_id__r.OwnerId;
            cpIdMap.put(item.Id, item.Id);
        }
    }

    private static Double calculateRetoma(List<AggregateResult> groupOppList, Map<Id, Id> groupOppMap, Map<Id, ResponseModel> dtMap, Map<Id, Id> cpIdMap) {
        Double sumAmount = 0;

        for(AggregateResult oppItem : groupOppList) {
            if(groupOppMap.containsKey((Id)oppItem.get('dwp_frct__grouping_id__c'))) {
                Final Id ownerId = groupOppMap.get((Id)oppItem.get('dwp_frct__grouping_id__c'));
                Final ResponseModel itemMap = dtMap.get(ownerId);
                
                sumAmount = searchOwner(itemMap, cpIdMap, oppItem, sumAmount);
            }
        }
        
        return sumAmount;
    }

    private static Double searchOwner(ResponseModel itemMap, Map<Id, Id> cpIdMap, AggregateResult oppItem, Double sumAmount) {
        Final String typeOpp = '02';
        Double finalSumAmount = sumAmount;

        if(itemMap.ownerId == (Id)oppItem.get('oppOwnerId')) {
            if((String)oppItem.get('typeOpp') == typeOpp) {
                if(cpIdMap.containsKey((Id)oppItem.get('dwp_frct__grouping_id__c'))) {
                    itemMap.retomaCP = (Double)oppItem.get('sumAmount');
                }                            
            } else {
                itemMap.nOperation = itemMap.nOperation + (Integer)oppItem.get('nOperation');
                itemMap.oppAmount = itemMap.oppAmount + (Double)oppItem.get('sumAmount');
                finalSumAmount = finalSumAmount + (Double)oppItem.get('sumAmount');
            }  
        }

        return finalSumAmount;
    }
}