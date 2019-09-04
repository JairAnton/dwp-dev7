/**
* ------------------------------------------------------------------------------------------------
* @Name AssistantFormalization_helper
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-08-26
* @Group 
* @Description Esta clase gestiona el proceso de formalización desde el asistente
*/
public without sharing class AssistantFormalization_helper {

    @AuraEnabled
    public static Map<String, Object> validateAssistant(Id oppId) {
        Map<String, Object> mapRes = new Map<String, Object>{'isError' => false};
        //Roles de Asistentes
        Final Set<String> rolAsis = Formalization_helper.getRolTeam('Asistentes_Operativos');
        Final User usuario = [SELECT Id, Profile.Name, prof_position_id__c FROM User WHERE Id=:UserInfo.getUserId()];
        Case[] caso = [SELECT Id, DWP_AssistantOwner__c, DWP_AssistantOwner__r.Name FROM Case WHERE Opportunity_id__c=:oppId AND recordType.Name='Formalization' 
                       AND status IN ('01','05', '09') limit 1];
        Final Integer casoSize = caso.size();
        if(rolAsis.contains(usuario.prof_position_id__c) && usuario.profile.Name=='Operativo' && casoSize > 0) {
            Final Map<String, String> owner = new Map<String, String>{'id' => caso[0].DWP_AssistantOwner__c, 'name' => caso[0].DWP_AssistantOwner__r.Name};
            mapRes.putAll(Formalization_helper.validateUser(owner, true));
        } else{
            mapRes.put('isError', true);
            mapRes.put('msgError', Label.Dwp_msgGenericError);
        }
        return mapRes;
    }
    
    @AuraEnabled
    public static Map<String, Object> reasignCaseFromOpp(Id oppId) {
        Map<String, Object> mapRes = validateAssistant(oppId);
        if(!(Boolean)mapRes.get('isError')) {
            Case[] caso = [SELECT Id, opportunity_id__c FROM Case WHERE Opportunity_id__c=:oppId AND recordType.Name='Formalization' AND status IN ('01','05') limit 1];
            Final Map<Schema.SObjectField, Object> mapValues = new Map<Schema.SObjectField, Object>{Case.OwnerId => UserInfo.getUserId(), Case.bypass__c => true, 
                Case.DWP_AssistantOwner__c => UserInfo.getUserId(), Case.status => '05'};
            mapRes = Formalization_helper.reasignAssOrSG(caso[0], 'Asistentes_Operativos', mapValues);
            if(!(Boolean)mapRes.get('isError')) {
				mapRes.put('msgSuccess', '¡Te asignaste la petición exitosamente! Ahora puedes enviar a formalizar esta oportunidad.');
            }
        }
        return mapRes;
    }
    
    @AuraEnabled
    public static Map<String, Object> getData(Id oppId) {
        return Formalization_helper.getInfo(oppId);
    }
    
    @AuraEnabled
    public static Map<String, Object> sentToFormalize(Id oppId, String values) {
        Map<String, Object> mapRes = new Map<String, Object>{'isError' => true};
        Final Map<String, Object> mapInputs = (Map<String, Object>) JSON.deserializeUntyped(values);
        Map<Schema.SObjectField, Object> mapCaseFields;
        Map<Schema.SObjectField, Object> mapOppFields;
        Opportunity opp = new Opportunity(Id=oppId);
        Case[] caso = [SELECT Id, CaseNumber, DWP_AssistantOwner__c, DWP_AssistantOwner__r.Name, OwnerId, status, Opportunity_id__c, DWP_SGofOwner__c FROM Case WHERE 
                       Opportunity_id__c=:oppId AND recordType.Name='Formalization' AND status IN ('05','09') limit 1];
        Map<String, Object> lstView = Dwp_Utils_helper.getListView('Case', 'Tier_1_Formalization_Case');
        List<ListView> view = ((Boolean)lstView.get('isError') ? null : (List<ListView>) lstView.get('listView'));
        Final String contractNumber = (String)mapInputs.get('contractNumber');
        Final String devolutionReason = (String)mapInputs.get('devolutionReason');
        Final String comments = (String)mapInputs.get('comments');
        Final String option = (String)mapInputs.get('option');
        switch on option {
            when 'sentToFormalize' {
                Final Map<String, Object> mapFormatt = Dwp_Utils_helper.validateFormatt('[0-9]{4}-[0-9]{4}-[0-9]{10}', contractNumber);
                if(!(Boolean)mapFormatt.get('isError')) {
                    if(String.isEmpty(caso[0].DWP_SGofOwner__c)) {
                        Final List<Group> queue = [SELECT Id, DeveloperName FROM Group WHERE Type='Queue' AND DeveloperName='Tier_2_Formalization'];
                        mapCaseFields = new Map<Schema.SObjectField, Object>{Case.OwnerId => queue[0].Id, Case.status => '07', Case.Dwp_ElevatedDate__c => DateTime.now()};
                        Formalization_helper.dynamicUpdateCase(caso[0], mapCaseFields);
                    } else {
                        mapCaseFields = new Map<Schema.SObjectField, Object>{Case.OwnerId => caso[0].DWP_SGofOwner__c, Case.status => '08'};
                        Formalization_helper.dynamicUpdateCase(caso[0], mapCaseFields);
                    }
                    mapOppFields = new Map<Schema.SObjectField, Object>{Opportunity.frm_ContractNumber__c => contractNumber , Opportunity.opportunity_status_type__c => '19'};
                    opp = Formalization_helper.dynamicUpdateOpp(opp, mapOppFields);
                    //Auditoria
                    new OpportunityTraceability_cls().addOpportunityTraceability(Product_cls.getStatusLabel('19'),'<b>Número de contrato:</b> '+ contractNumber,'Opportunity',opp.Id,'elevate','TRFO00001',UserInfo.getUserId(),'embedded',1,true);                        
                    mapRes.put('isError', false);
                    mapRes.put('msgSuccess', '¡Has enviado a formalizar la oportunidad exitosamente!');
                    mapRes.put('listView', ((Boolean)lstView.get('isError') ? '' : view[0].Id));
                } else {
                    mapRes.put('msgError', 'Coloca un número de contrato para enviar a formalizar la oportunidad.');
                }
            }
            when 'returnByDocumentation' {
                Final Map<String, Object> mapReason = Formalization_helper.validateDevolutionReason(devolutionReason, comments);
                if(!(Boolean)mapReason.get('isError')) {
                    mapCaseFields = new Map<Schema.SObjectField, Object>{Case.status => '06', Case.dwp_returned_date__c => DateTime.now()};
                    Formalization_helper.dynamicUpdateCase(caso[0], mapCaseFields);
                    mapOppFields = new Map<Schema.SObjectField, Object>{Opportunity.devolutionReason__c => devolutionReason ,Opportunity.opportunity_status_type__c => '20', Opportunity.Dwp_DevolutionUser__c => UserInfo.getUserId()};
                    opp = Formalization_helper.dynamicUpdateOpp(opp, mapOppFields);
                    //Auditoria y Notificación
                    Final Map<String, String> devolution = Dwp_Utils_helper.getPicklistValues('Opportunity', 'devolutionReason__c');
                    new OpportunityTraceability_cls().addOpportunityTraceability(Product_cls.getStatusLabel('20'),'<b>Razón de devolución: </b>'+devolution.get(devolutionReason)+'<br/><b>Comentarios:</b> '+ (comments == null ? '' : comments),'Opportunity',opp.Id,'sendBack','TRFO00001',UserInfo.getUserId(),'embedded',1,true);
                    mapRes.put('isError', false);
                    mapRes.put('msgSuccess', '¡Has devuelto exitosamente la petición N° '+ caso[0].CaseNumber + ' al ejecutivo!');
                    mapRes.put('listView', ((Boolean)lstView.get('isError') ? '' : view[0].Id));
                } else {
                    mapRes.put('msgError',(String)mapReason.get('msgError'));
                }
            }
            when else {
                mapRes.put('msgError', Label.Dwp_msgGenericError);
            }
        }
        return mapRes;
    }
     
}