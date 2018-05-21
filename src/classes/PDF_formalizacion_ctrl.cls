public class PDF_formalizacion_ctrl extends OpportunityPDFWrap   {
    @InvocableMethod(label='Create PDF on Opportunity' description='Creates a PDF on an Opportunity')
    public static void PDF_formalization(list<String> oppIds){
        system.debug('Por tlaloc dime que llegaste aquí');
        list<attachment> insertAttachment = new list<attachment>();
        list<opportunityLineItem> OLI = new list<opportunityLineItem>();

        for(Id oppId: oppIds){
            pageReference pdf = Page.PDF_formalizacion_vfp;
            pdf.getParameters().put('id',oppId);
            Attachment attach = new Attachment();
            Blob body;
            if(!test.isRunningTest()){
                body = pdf.getContent();
            }else{
                body=blob.valueOf('TestString');
            }
            attach.Body = body;
            attach.Name = 'Oportunidad_Formalizada_'+oppId+'.pdf';
            attach.IsPrivate = false;
            attach.ParentId = oppId;
            insertAttachment.add(attach);
         }

         insert insertAttachment;


    }

    public PDF_formalizacion_ctrl(ApexPages.StandardController controller){

       setValues(controller.getId());

    }

}