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

    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass)
        {

            list<String> lstErrorMessage = new List<String>();
            Opportunity op = [SELECT stageName FROM Opportunity WHERE Id = : recordId];
            try{
             if(op.StageName !='05'){
              lstErrorMessage.add(label.stageIncorrectToPDF);
             }
            }
            catch(exception e){
            lstErrorMessage.add(label.PDFError);
            }
           return lstErrorMessage;
        }

   @auraenabled
    public static string  PDF_formalization(String recordId){
     {
      string msg;
        //list<opportunityLineItem> OLI = new list<opportunityLineItem>(); //Yuliño: correcion
        Map<ID, Opportunity> m = new Map<ID, Opportunity>([SELECT Id, Name FROM Opportunity WHERE ID = :recordId  LIMIT 1]);
        String NamePDF = 'Oportunidad formalizada '+m.get(recordId).Name+'.pdf';
        list<Attachment> deleteAttach =[SELECT ID from Attachment WHERE Name =:NamePDF AND ParentId =:recordId];
        delete deleteAttach;

            pageReference pdf = Page.PDF_formalizacion_vfp;
            pdf.getParameters().put('id',recordId);
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
           return msg;

             }
    }

    private ReasignButtonClass(){ //Yuliño: correcion
    }

}