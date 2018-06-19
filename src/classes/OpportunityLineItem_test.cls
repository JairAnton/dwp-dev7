/*
@Autor: Arsenio Perez Lopez
@Proyect: BBVA PERU
@Version:1
@HIstorial de cambios:
- Creacion del Desencadenador
*/
@isTest
public class OpportunityLineItem_test {
    
    @testSetup static void BeforeInsertSetup(){
        
        Opportunity opp = new Opportunity(
            Name = 'XXX Test',
            CloseDate = Date.today().addDays(1),
            StageName = 'Prospecting',
            Amount = 111111
        );
        insert opp;
        
        Product2 prd = new Product2(
            Name = 'Test Product',
            ProductCode = 'TEST',
            Family = 'Family',
            IsActive = true
        );
        insert prd;
        
        PriceBookEntry pbe = new PriceBookEntry(
            Product2Id = prd.Id,
            PriceBook2Id = Test.getStandardPricebookId(),
            UnitPrice = 1,
            UseStandardPrice = false,
            IsActive = true
        );
        insert pbe;
        
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Product2Id = prd.Id,
            Quantity = 1,
            TotalPrice = 123,
            PriceBookEntryId = pbe.Id
        );
        insert oli;
    }
    @isTest static void BeforeInsert(){
        double s= [select TotalPrice from OpportunityLineItem limit 1].TotalPrice;
        Test.startTest();
        System.assertEquals(111111, s);
        Test.stopTest();
    }
    
}