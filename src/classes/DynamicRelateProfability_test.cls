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
        Account clie = [select id from account]; 
        TestFactory.createAccountProfit(clie.id);
        Account_Profitability__c Proba = [select id from Account_Profitability__c];
        Proba.product_desc__c='producto1';
        update Proba;
    }

    @isTest static void TestRecuperaServicio(){
        Account temp1 = [select id from account]; 
        DynamicRelateProfability_cls.RecuperaServicio(temp1.id);
		system.assertNotEquals(lista, null);
    }
}