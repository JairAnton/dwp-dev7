/**
    @Author Jair Anton Atuncar (jair.anton.contractor@bbva.com)
    @Description (Vista Resumen PPG para ejecutivo) Summary for Executive
    Date        Author   Email                  				Type
    2021-08-02  JAA     jair.anton.contractor@bbva.com          Initial version
**/

public class BE_MP_Executive_Summary_Cls extends BE_SingleRelatedListCRUD_Cls {
    public class ResponseModel {
        Id GroupId { get; set; }
        String name { get; set; }
        Double expectedDrop { get; set; }
        Double retoma { get; set; }
        Id OwnerId { get; set; }
        Integer nOperation { get; set; }
        Double oppAmount { get; set; }
        Double commitment { get; set; }
        Double netCommitment { get; set; }
    }

    public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object> param) {
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SingleRelatedListCRUD_Cls.Response();
        Final Map<String,String> messageMap = new Map<String,String>();

        try {
            /* Get Management Plan of Gerente recordId */
            Final List<dwp_frct__management_plan__c> mPlanList = [SELECT Id, Name, dwp_frct__management_plan_start_date__c, dwp_frct__management_plan_end_date__c, OwnerId FROM dwp_frct__management_plan__c WHERE Id =: (String)param.get('recordId')];
            response.isSuccess = true;
            response.message = messageMap.get(UserInfo.getLanguage());

            /* Validate if exists Management Plan */
            if(mPlanList.size() == 0){
                response.data = new List<AggregateResult>();
                return response;
            }

            Final dwp_frct__management_plan__c mplan = mPlanList[0];

            /* Get grouping of category type 'Recursos' */
            Final List<dwp_frct__grouping__c> groupList = [SELECT Id, dwp_frct__management_plan_id__c, dwp_frct__opportunity_expected_drop_amount__c, dwp_frct__solution_category_type__c, dwp_frct__management_plan_id__r.OwnerId,
                                                            dwp_frct__net_commitment_amount__c, dwp_frct__original_commitment_amount__c
                                                        FROM dwp_frct__grouping__c 
                                                        WHERE dwp_frct__solution_category_type__c IN ('Financiamiento a corto plazo', 'Financiamiento a largo plazo', 'Riesgo de firma', 'Recursos') AND 
                                                            (dwp_frct__management_plan_id__c =: mPlan.Id) AND 
                                                            dwp_frct__management_plan_id__r.dwp_frct__management_plan_start_date__c >=: mplan.dwp_frct__management_plan_start_date__c AND 
                                                            dwp_frct__management_plan_id__r.dwp_frct__management_plan_end_date__c <=: mplan.dwp_frct__management_plan_end_date__c];

            Final Map<Id, ResponseModel> dtMap = new Map<Id, ResponseModel>();
            Final List<dwp_frct__grouping__c> resultList = new List<dwp_frct__grouping__c>();
            Final Map<Id, Id> groupOppMap = new Map<Id, Id>();
            Final Set<Id> gpOppSet = new Set<Id>();

            /* Create map for expected drop, commitment, net commitment */
            for(dwp_frct__grouping__c item : groupList){
                Final ResponseModel dt = new ResponseModel();
                dt.name = item.dwp_frct__solution_category_type__c;
                dt.retoma = 0;
                dt.commitment = item.dwp_frct__original_commitment_amount__c;
                dt.oppAmount = 0;
                dt.nOperation = 0;
                dt.netCommitment = item.dwp_frct__net_commitment_amount__c;
                dt.expectedDrop = item.dwp_frct__opportunity_expected_drop_amount__c;
                dt.GroupId = item.Id;
                dt.OwnerId = item.dwp_frct__management_plan_id__r.OwnerId;
                groupOppMap.put(item.Id, item.dwp_frct__management_plan_id__r.OwnerId);

                dtMap.put(item.Id, dt);
            }

            /* Get selected opportunities of type 'renewal' and 'new' */
            List<AggregateResult> groupOppList = [SELECT dwp_frct__grouping_id__c, dwp_frct__grouping_id__r.Name, COUNT(dwp_frct__opportunity_id__c) nOperation, SUM(dwp_frct__opportunity_id__r.Amount) sumAmount, 
                                                        dwp_frct__opportunity_id__r.OwnerId oppOwnerId, dwp_frct__opportunity_id__r.Type typeOpp
                                                    FROM dwp_frct__grouping_opp__c 
                                                    WHERE dwp_frct__grouping_id__c  IN : groupOppMap.keySet() AND dwp_frct__opportunity_id__r.Type IN ('01', '02') AND dwp_frct__opportunity_id__r.OwnerId IN : groupOppMap.values()
                                                    GROUP BY dwp_frct__grouping_id__r.Name, dwp_frct__opportunity_id__r.Type, dwp_frct__grouping_id__c, dwp_frct__opportunity_id__r.OwnerId
                                                    ORDER BY dwp_frct__grouping_id__r.Name ASC];

            /* Loop for setear retoma and set operations, amount of operation per owner */
            groupOppList = validateGrouping(groupOppList, dtMap);

            Final Map<Integer, dwp_frct__grouping__c> groupingMap = new Map<Integer, dwp_frct__grouping__c>();      

            /* Set response model for datatable */ 
            for(ResponseModel item : dtMap.values()){    
                Final dwp_frct__grouping__c gp = new dwp_frct__grouping__c();           
                gp.Name = item.Name;
                gp.dwp_frct__management_expected_drop_amount__c = item.expectedDrop;
                gp.dwp_frct__opportunity_selected_tot_amount__c = item.retoma;
                gp.dwp_frct__solution_category_type__c = String.valueOf(item.nOperation);
                gp.dwp_frct__opportunity_cancellation_amount__c = item.oppAmount;
                gp.dwp_frct__original_commitment_amount__c = item.commitment;
                gp.dwp_frct__opportunity_closed_amount__c = item.netCommitment;
                
                groupingMap.put(validateName(item.Name, groupingMap), gp);             
            }

            /* order by family */
            Final List<Integer> ranksList = new List<Integer>();
            ranksList.addAll(groupingMap.keySet());
            ranksList.sort();

            for(Integer rank : ranksList){
                Final dwp_frct__grouping__c gp = groupingMap.get(rank);
                resultList.add(gp);
            }

            response.data = resultList;
        } catch (DMLException ex) {
            response.isSuccess = false;
            response.message = ex.getDmlMessage(0);
        }

        return response;
    }

    private static List<AggregateResult> validateGrouping(List<AggregateResult> groupOppList, Map<Id, ResponseModel> dtMap) {
        for(AggregateResult oppItem : groupOppList){
            if(dtMap.containsKey((Id)oppItem.get('dwp_frct__grouping_id__c'))){
                Final ResponseModel itemMap = dtMap.get((Id)oppItem.get('dwp_frct__grouping_id__c'));

                if((String)oppItem.get('typeOpp') == '02'){
                    itemMap.retoma = (Double)oppItem.get('sumAmount');
                }
                else {
                    itemMap.nOperation = (Integer)oppItem.get('nOperation');
                    itemMap.oppAmount = (Double)oppItem.get('sumAmount');
                }
            }
        }

        return groupOppList;
    }

    private static Integer validateName(String groupingName, Map<Integer, dwp_frct__grouping__c> groupingMap) {
        Integer groupingPosition = groupingMap.size() + 1;

        if(groupingName == 'Financiamiento a corto plazo') {
            groupingPosition = 1;
        }
        else if(groupingName == 'Financiamiento a largo plazo') {
            groupingPosition = 2;
        }
        else if(groupingName == 'Riesgo de firma') {
            groupingPosition = 3;
        }
        else if(groupingName == 'Recursos') {
            groupingPosition = 4;
        }

        return groupingPosition;
    }
}