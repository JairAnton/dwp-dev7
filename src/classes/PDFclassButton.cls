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
global class PDFclassButton implements dwp_dbpn.DynamicFlowValidationInterface{

    global static List<String> getErrorMessagesList(String recordId, String source, String validationClass)
        {

            list<String> lstErrorMessage = new List<String>();
            Opportunity op = [SELECT stageName FROM Opportunity WHERE Id = : recordId];
            try{
            id id1 = userinfo.getProfileId();

            String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;

            if(prof=='Operativo' || prof=='Administrador del Sistema' || prof=='Migracion'){
             if(op.StageName =='05'){
             list<String>oppIDs = new list<String>();
             oppIDs.add(recordId);
             PDF_formalizacion_ctrl.PDF_formalization(oppIds);
             }else{
              lstErrorMessage.add(label.stageIncorrectToPDF);
             }
            }else{
             lstErrorMessage.add(label.UserNotAllowedToCreatePDF);
            }
            }
            catch(exception e){
            lstErrorMessage.add(label.PDFError);
            }
           return lstErrorMessage;
        }
}
