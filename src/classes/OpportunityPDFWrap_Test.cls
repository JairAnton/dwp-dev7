@istest
public class OpportunityPDFWrap_Test {
    
    @testSetup
    static void setupData(){
        Account acc=TestFactory.createAccount();
        TestFactory.createAccBBVAClass(acc.id);
        TestFactory.createAccBankingSystClass(acc.id);
        
		TestFactory.createContact(acc.id);
        User user=TestFactory.createUser('TestAdmin','Migracion');
        TestFactory.createUserBranch(user.Id);
        
        Opportunity opp=TestFactory.createOpportunity(acc.Id,user.Id);                
        Product2 prod=TestFactory.createProduct();
        TestFactory.createOLI(opp.id,prod.id);
        TestFactory.createParticipants(opp.id);
        TestFactory.createGuarantee(opp.id);
        TestFactory.createAttachment(opp.id,'Instrucción de transferencia');
        TestFactory.createAttachment(opp.id,'Sustento de operación Comex: Copia Bill of lading');
        TestFactory.createAttachment(opp.id,'Sustento de operación Comex: Facturas o Letras');
        TestFactory.createAttachment(opp.id,'Pagaré');
        TestFactory.createAttachment(opp.id,'Facturas');
        TestFactory.createAttachment(opp.id,'Tasa');
        TestFactory.createAttachment(opp.id,'Otros');

    }
        
    public static testMethod void generatePDF(){
		Opportunity opp = [SELECT ID FROM Opportunity LIMIT 1];
        Account acc = [SELECT ID FROM Account LIMIT 1];

        String returnMsg=OpportunityPDFWrap.setValues(opp.id);
        System.assertEquals(returnMsg, 'Datos incompletos en calificación cliente');

        TestFactory.createAccRating(acc.id); 
        returnMsg=OpportunityPDFWrap.setValues(opp.id);

        System.assertEquals(returnMsg, 'SUCCESS');
    }
}