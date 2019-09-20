/**PDFclassButton
*  object.
* <p /><p />
* Modification log:<p />
* -------------------------------------------------------------------
* Developer                    Date                Description<p />
* -------------------------------------------------------------------
* Julio Medellin               18/05/2018          Original version.<p />
*
* @author Julio Medellin
*/
global without sharing class PDFclassButton  implements dwp_dbpn.DynamicFlowValidationInterface{
    
    Final static Set<String> ROL_ASIS = Formalization_helper.getRolTeam('Asistentes_Operativos');
    Final static Set<String> ROL_SG = Formalization_helper.getRolTeam('Subgerentes_Operativos');

    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
            list<String> lstErrorMessage = new List<String>();
            Opportunity op = [SELECT stageName FROM Opportunity WHERE Id = : recordId];
            try {
                if(op.StageName !='05') {
                    lstErrorMessage.add(label.stageIncorrectToPDF);
                }
            } catch(exception e) {
                lstErrorMessage.add(label.PDFError);
            }
           return lstErrorMessage;
        }

    @AuraEnabled
    public static Map<String, Object> validateUser(String recordId) {
        Map<String, Object> mapRes = new Map<String, Object>{'isError' => true, 'msgError' => Label.Dwp_msgGenericError};
        Final User usuario = [SELECT Id, Profile.Name, prof_position_id__c FROM User WHERE Id=:UserInfo.getUserId()];
        if(ROL_ASIS.contains(usuario.prof_position_id__c)) {
            mapRes = AssistantFormalization_helper.validateAssistant(recordId);
        } else if(ROL_SG.contains(usuario.prof_position_id__c)) {
            mapRes = SgofFormalization_helper.validateSgof(recordId);
        } 
        return mapRes;
    }
    
    @AuraEnabled
    public static Map<String, Object> reasignCase(String recordId) {
        Map<String, Object> mapRes = new Map<String, Object>{'isError' => true, 'msgError' => Label.Dwp_msgGenericError};
        Final User usuario = [SELECT Id, Profile.Name, prof_position_id__c FROM User WHERE Id=:UserInfo.getUserId()];
        if(ROL_ASIS.contains(usuario.prof_position_id__c)) {
            mapRes = AssistantFormalization_helper.reasignCaseFromOpp(recordId);
        } else if(ROL_SG.contains(usuario.prof_position_id__c)) {
            mapRes = SgofFormalization_helper.reasignCaseFromOpp(recordId);
        } 
        return mapRes;
    }
    
   @auraenabled
    public static string  PDF_formalization(String recordId){
        string msg;
        Case[] caso = [SELECT Id, OwnerId FROM Case WHERE Opportunity_id__c=:recordId AND RecordType.DeveloperName='Formalization' 
                     AND status NOT IN ('03','04','10','11') AND OwnerId=:UserInfo.getUserId() limit 1];
        if(caso.size() > 0) {
            //list<opportunityLineItem> OLI = new list<opportunityLineItem>(); //Yuliño: correcion
            Map<ID, Opportunity> m = new Map<ID, Opportunity>([SELECT Id, Name FROM Opportunity WHERE ID = :recordId  LIMIT 1]);
            String NamePDF = 'Oportunidad formalizada '+m.get(recordId).Name+'.pdf';
            list<Attachment> deleteAttach =[SELECT ID from Attachment WHERE Name =:NamePDF AND ParentId =:recordId];
            delete deleteAttach;
    
             pageReference pdf = Page.PDF_formalizacion_vfp;pdf.getParameters().put('id',recordId);
             msg=PDF_formalizacion_ctrl.msg(recordId);
             Attachment attach = new Attachment();
             Blob body;
             if(!test.isRunningTest()){
                 body = pdf.getContent();
             }else{
                 body=blob.valueOf('TestString');
             }
             attach.Body = body;
             attach.Name = NamePDF;
             attach.IsPrivate = false;
             attach.ParentId = recordId;
    
             insert attach;
        }
         return msg;
    }
}