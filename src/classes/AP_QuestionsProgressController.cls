/** AP_QuestionsProgressController
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Jair Anton 				02/09/2021			Calcula el progreso de las preguntas de un AP.
 */
public without sharing class AP_QuestionsProgressController {
    private AP_QuestionsProgressController() {}

    /* calculated questions */
    @AuraEnabled
    public static Map<String, Decimal> calculateQuestions(String recordId) {
        Final Map<String, Decimal> response = new Map<String, Decimal>();

        Final List<acpl__AP_Question__c> questionsList = [SELECT Id, Name, acpl__Answered__c, acpl__gf_account_planning_id__r.acpl__Account_Planning_Type__c FROM acpl__AP_Question__c WHERE acpl__gf_account_planning_id__c =: recordId];
        Final Set<Id> qMandatoryAswered = new Set<Id>();
        Final Set<Id> qNotAswered = new Set<Id>();
        Final Set<Id> totalMandatory = new Set<Id>();
        Final Map<String, acpl__AP_Question__c> questionsMap = new Map<String, acpl__AP_Question__c>();
        
        for(acpl__AP_Question__c item : questionsList) {
            questionsMap.put(item.Name, item);
        }

        if(questionsList.isEmpty() == false && questionsList[0].acpl__gf_account_planning_id__c != null && questionsList[0].acpl__gf_account_planning_id__r.acpl__Account_Planning_Type__c != null) {
            searchQuestions(questionsList, qMandatoryAswered, qNotAswered, questionsMap, totalMandatory);
        }

        response.put('questionsMandatory', calculatePercentage(Decimal.valueOf(qMandatoryAswered.size()), Decimal.valueOf(questionsList.size())));
        response.put('questionsNotMandatory', calculatePercentage(Decimal.valueOf(qNotAswered.size()), Decimal.valueOf(questionsList.size())));
        response.put('questionsAswered', calculatePercentage(Decimal.valueOf(qMandatoryAswered.size() + qNotAswered.size()), Decimal.valueOf(questionsList.size())));
        response.put('totalMandatory', totalMandatory.size());
        response.put('qMandatoryAswered', qMandatoryAswered.size());
        return response;
    }

    private static Decimal calculatePercentage(Decimal value1, Decimal value2) {
        Decimal response = 0;

        if(value2 > 0) {
            response = (value1 / value2) * 100;
        }

        return response;
    }

    private static void searchQuestions(List<acpl__AP_Question__c> questionsList, Set<Id> qMandatoryAswered, Set<Id> qNotAswered, Map<String, acpl__AP_Question__c> questionsMap, Set<Id> totalMandatory) {
        Final List<dyfr__Template__c> templateList = [SELECT Id, acpl__Account_Planning_Type__c FROM dyfr__Template__c WHERE acpl__Account_Planning_Type__c =: questionsList[0].acpl__gf_account_planning_id__r.acpl__Account_Planning_Type__c LIMIT 1];

        if(templateList.isEmpty() == false) {
            Final List<dyfr__Tab__c> tabList = [SELECT Id, dyfr__Template__c FROM dyfr__Tab__c WHERE dyfr__Template__c =: templateList[0].Id];

            if(tabList.isEmpty() == false) {
                searchFields(tabList, qMandatoryAswered, qNotAswered, questionsMap, totalMandatory);
            }
        }
    }

    private static void searchFields(List<dyfr__Tab__c> tabList, Set<Id> qMandatoryAswered, Set<Id> qNotAswered, Map<String, acpl__AP_Question__c> questionsMap, Set<Id> totalMandatory) {
        FInal List<dyfr__Field_Config__c> fieldList = [SELECT Id, dyfr__Tab__c, dyfr__DeveloperName__c, dyfr__Important__c FROM dyfr__Field_Config__c WHERE dyfr__Tab__c =: tabList[0].Id];
    
        for(dyfr__Field_Config__c item : fieldList) {
            if(questionsMap.containsKey(item.dyfr__DeveloperName__c)) {
                acpl__AP_Question__c questionItem = questionsMap.get(item.dyfr__DeveloperName__c);
                
                validateQuestions(questionItem, item, qMandatoryAswered, qNotAswered, totalMandatory);
                
            }
        }
    }

    private static void validateQuestions(acpl__AP_Question__c questionItem, dyfr__Field_Config__c item, Set<Id> qMandatoryAswered, Set<Id> qNotAswered, Set<Id> totalMandatory) {
        if(item.dyfr__Important__c == true && questionItem.acpl__Answered__c == true) {
            qMandatoryAswered.add(item.Id);
        } else if(item.dyfr__Important__c == false && questionItem.acpl__Answered__c == true) {
            qNotAswered.add(item.Id);
        }

        if(item.dyfr__Important__c == true) {
            totalMandatory.add(item.Id);
        }
    }
}
