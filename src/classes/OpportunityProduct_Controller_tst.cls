/**OpportunityProduct_Controller_tst
 *  object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Julio Medellin               7/05/2018          Original version.<p />
 *
 * @author Julio Medellin
 *
 * Modificado por Eduardo Castillo S. 1/11/2018
 */
@istest
public class OpportunityProduct_Controller_tst {
	//Setup data.
	@testSetup
	static void setupData() {
		//Create Accounts.
		test.startTest();

		//ECS Create Modality_mode__c
		create_modality_mode();

		Account acc = new Account();
		acc.Name = 'MyAccount';
		insert acc;
		Opportunity Opp = new Opportunity(Name = 'testopp', StageName = '01', Amount = 100, CloseDate = system.Date.today(), opportunity_status_type__c = '01', AccountId = acc.id);
		List<Account> lstAccounts = new List<Account>();
		List<task> lstTasks = new List<task>();
		for(Integer intI = 0; intI < 2; intI++) {
			lstAccounts.add(new Account(Name = 'AccountName' + intI));
			lstTasks.add(new Task(Subject = 'SIO1234567##' + (intI + 1) + 'er Ingreso a Controller##', Status = 'Inbound Email'));
		}
		insert lstTasks;
		insert lstAccounts;
		insert opp;
		Pricebook2 pb = new Pricebook2(Name = 'testPB');
		Product2 p = new  Product2(Name = 'testProduct');
		insert pb;
		insert p;
		PricebookEntry pes = new PricebookEntry(UnitPrice = 1, Pricebook2Id =  Test.getStandardPricebookId(), Product2Id = p.id);
		insert pes;
		PricebookEntry pe = new PricebookEntry(UnitPrice = 1, Pricebook2Id = pb.Id, Product2Id = p.id, IsActive = true);
		insert pe;
		OpportunityLineItem OLI  = new OpportunityLineItem(OpportunityId = opp.Id,
		                                                   Quantity = 1,
		                                                   TotalPrice = 9,
		                                                   PricebookEntryId = pe.Id,
		                                                   Product2Id = p.id);
		insert OLI;
		test.stopTest();
	}

	static testMethod void positiveTest() {
		task t = [SELECT Id FROM TASK LIMIT 1];
		opportunity opp = [SELECT ID FROM Opportunity LIMIT 1];
		//OpportunityProduct_Controller OPC = new OpportunityProduct_Controller(); //Yulino 11/12/2018 : Se comentó
		//OpportunityProduct_Controller.getTasks(opp.Id);
		OpportunityProduct_Controller.getTasks('SIO1234567');
		OpportunityProduct_Controller.getOppLI(opp.id);
		OpportunityProduct_Controller.saveSIO(opp.Id, t.Id);
		OpportunityProduct_Controller.sendApproval(opp.Id);
		opp.Risk_modality_type__c = '';
		update opp;
		String valor = OpportunityProduct_Controller.requestModality(opp.Id); // Yulino 11/12/2018 :Se aregó una variable para utilizar en el asset
		system.assertEquals('', valor);  // 11/12/2018 : Agregando el Assert
	}

	//Eduardo Castillo S. - Método creado para la clase OpporunityProduct_Controller
	public static void create_modality_mode() {
		Modality_Mode__c obj = new Modality_Mode__c();
		obj.Product_Name__c = '01';
		obj.Modalidad_producto__c = 'Modalidad_producto__c prueba';
		obj.Modality_Select__c = 'Modality_Select__c prueba';
		obj.Name = 'Name prueba';
		insert obj;
	}
}
