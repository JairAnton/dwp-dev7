/*
* Autor: Arsenio Perez Lopez
* Class: DynamicRelateProfability_cls
* Description: 
* History:
* ------------------------------------------------------
* Autor----------fecha-------------Cambio
* ------------------------------------------------------
* Arsenio Perez-----19/10/2018-----------Creacion.
* 
*/
public with sharing class DynamicRelateProfability_cls {
    
    @AuraEnabled public Static List<String> recuperaServicio(String idAccount){
		final set<String> lita = new set<String>();
        List<Account_Profitability__c> profitability = new List<Account_Profitability__c>();
        profitability =[SELECT product_desc__c FROM Account_Profitability__c where account_id__c =:idAccount and product_desc__c !='' order by product_desc__c ];
        for(Account_Profitability__c pro: profitability){
			if(!lita.contains(pro.product_desc__c))
				lita.add(pro.product_desc__c); 
        }
        List<String> retur = new List<String>();
		retur.addall(lita);
		retur.sort();
		return retur;
    }
}