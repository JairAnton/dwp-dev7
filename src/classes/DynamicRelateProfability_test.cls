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
@isTest
public class DynamicRelateProfability_test {
    
    @testSetup static void loadData(){
		TestFactory.createAccount();
        final Account clie = [select id from account where id !='']; 
        TestFactory.createAccountProfit(clie.id);
        final Account_Profitability__c proba = [select id from Account_Profitability__c where id !=''];
        Proba.product_desc__c='producto1';
        update proba;
    }
    @isTest static void testRecuperaServicio(){
        final Account temp1 = [select id from account where id !='']; 
        final List<String> lista = DynamicRelateProfability_cls.RecuperaServicio(temp1.id);
        system.assertNotEquals(lista, null);
    }
}