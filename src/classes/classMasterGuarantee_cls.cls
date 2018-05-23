/*-------------------------------------------------------------------------
 * Name: classMasterGuarantee_cls
 * Description : Class Master row Guarantee
 * Created date : May 22 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/
public with sharing class classMasterGuarantee_cls {
	@InvocableMethod(label='Create Master Guarantee' description='Create the row from Product_Guarantee')
 	public static void createMasterGuarantee(List<OpportunityLineItem> listRow)
    {
        List<Product_Gurantee__c> row =[SELECT Id FROM Product_Gurantee__c WHERE Product__c=: listRow[0].Product2Id and Opportunity__c=: listRow[0].OpportunityId and  isMaster__c=true];
 		if(row.isEmpty())
 		{
 			Product_Gurantee__c nRow = new Product_Gurantee__c();
 			nRow.Product__c=listRow[0].Product2Id;
 			nRow.Opportunity__c=listRow[0].OpportunityId;
 			nRow.GuaranteeType__c=listRow[0].gipr_Tipo_Garantia__c;
 			nRow.Guarantee__c=listRow[0].gipr_Garantia__c;
 			nRow.isMaster__c=true;
 			insert nRow;
  		}
  		else
  		{
  			row[0].GuaranteeType__c=listRow[0].gipr_Tipo_Garantia__c;
  			row[0].Guarantee__c=listRow[0].gipr_Garantia__c;
  			update row;
  		}        
    }
}