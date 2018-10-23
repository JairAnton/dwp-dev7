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
    
    @AuraEnabled
    public Static List<String> RecuperaServicio(String IdAccount){
        set<String> lita = new set<String>();
        List<Account_Profitability__c> Profitability = new List<Account_Profitability__c>();
        Profitability =[SELECT product_desc__c FROM Account_Profitability__c where account_id__c =:IdAccount and product_desc__c !='' order by product_desc__c ];
        for(Account_Profitability__c pro: Profitability){
            if(!lita.contains(pro.product_desc__c))
                lita.add(pro.product_desc__c); 
        }
        List<String> Retur = new List<String>();
        Retur.addall(lita);
        Retur.sort();
        return Retur;
    }
}