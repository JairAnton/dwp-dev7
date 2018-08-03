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
        TestFactory.createGuarantee(opp.Id);
        
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
    
    @isTest static void BeforeUpdate_V1(){
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        OLI.gipr_Tipo_Garantia__c='01';
        update OLI;
        OLI.gipr_Tipo_Garantia__c='02';
        update OLI;
        PriceBookEntry pbe = [select id from PriceBookEntry limit 1];
        OpportunityLineItem oli2 = new OpportunityLineItem(
            OpportunityId = OLI.OpportunityId,
            Product2Id = OLI.Product2Id,
            Quantity = 1,
            TotalPrice = 123,
            PriceBookEntryId = pbe.Id
        );
        insert oli2;
        Test.startTest();
        System.assertNotEquals(null, oli2.Id);
        Test.stopTest();
    }
    @isTest static void BeforeUpdate_V2(){
        Product2 prd = [select id from Product2 limit 1];
        	prd.ProductCode='PC00002';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.gipr_Plazo__c=4;
        	OLI.gipr_Periodicidad__c='01';
        update OLI;	
    }
        @isTest static void BeforeUpdate_V2_1(){
        Product2 prd = [select id from Product2 limit 1];
        	prd.ProductCode='PC00002';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.gipr_Plazo__c=4;
        	OLI.gipr_Periodicidad__c='02';
        update OLI;	
    }
    @isTest static void BeforeUpdate_V3(){
        Product2 prd = [select id from Product2 limit 1];
        prd.ProductCode='PC00011';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.cpliq_Fecha_Vencimiento__c=System.today().addDays(12);
        update OLI;	
    }
	@isTest static void BeforeUpdate_V4(){
        Product2 prd = [select id from Product2 limit 1];
        prd.ProductCode='PC00041';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.gipr_Plazo__c=3;
        update OLI;	
    }
    @isTest static void BeforeUpdate_V4_1(){
        Product2 prd = [select id from Product2 limit 1];
        prd.ProductCode='PC00041';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.gipr_Plazo__c=3;
        	OLI.cpliq_Periodicidad__c='02';
        update OLI;	
    }
    @isTest static void BeforeUpdate_V4_2(){
        Product2 prd = [select id from Product2 limit 1];
        prd.ProductCode='PC00041';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.gipr_Plazo__c=3;
        	OLI.cpliq_Periodicidad__c='03';
        update OLI;	
    }    
	@isTest static void BeforeUpdate_V5(){
        Product2 prd = [select id from Product2 limit 1];
        prd.ProductCode='PC00041';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	
        	OLI.cpliq_Fecha_Vencimiento__c=system.today().addDays(12);
        update OLI;	
    }
    @isTest static void BeforeUpdate_V6(){
        Product2 prd = [select id from Product2 limit 1];
        prd.ProductCode='PC00002';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.cpliq_Fecha_Vencimiento__c=system.today().addDays(442);
        update OLI;	
    }
    @isTest static void BeforeUpdate_V7(){
        Product2 prd = [select id from Product2 limit 1];
        prd.ProductCode='PC00002';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.cpliq_n__c=13;
        	OLI.cpliq_Periodicidad__c='01';
        update OLI;	
    }   
    @isTest static void BeforeUpdate_V7_1(){
        Product2 prd = [select id from Product2 limit 1];
        prd.ProductCode='PC00002';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.cpliq_n__c=13;
        	OLI.cpliq_Periodicidad__c='02';
        update OLI;	
    }   
	@isTest static void BeforeUpdate_V8(){
        Product2 prd = [select id from Product2 limit 1];
        prd.ProductCode='PC00010';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.cpliq_n__c=13;
        	OLI.cpliq_Periodicidad__c='01';
        update OLI;	
    }  
	@isTest static void BeforeUpdate_V8_1(){
        Product2 prd = [select id from Product2 limit 1];
        prd.ProductCode='PC00010';
        update prd;
        OpportunityLineItem OLI = [Select id, OpportunityId,Product2Id from OpportunityLineItem limit 1];
        	OLI.cpliq_n__c=13;
        	OLI.cpliq_Periodicidad__c='02';
        update OLI;
        Opportunity_Solution_Commitment__c opsolcom = new Opportunity_Solution_Commitment__c ();
        opsolcom.opp_solution_id__c = OLI.Id;
        insert opsolcom;
        delete OLI;
    }
}