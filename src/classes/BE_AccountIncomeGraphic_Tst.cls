/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_AccountIncomeGraphic_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-10
   @Description test for BE_AccountIncomeGraphic_Ctr class
   @Changes
   Date        Author   Email                               Type
   2020-06-10  MAMC     martin.mori.contractor@bbva.com     Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_AccountIncomeGraphic_Tst {
    /**
     @Description test BE_AccountIncomeGraphic_Tst.getAvgMthBal(param), correct scenary
    */
    @IsTest
    static void getAvgMthBaltTest() {
        final Account acc = TestFactory.createAccount();
        final List<Account_Income__c> incomes = new List<Account_Income__c>();
        final Account_Income__c income1 = new Account_Income__c();
        income1.CurrencyIsoCode = 'USD';
        income1.account_id__c = acc.Id;
        income1.gf_income_amount__c = 4776000;
        income1.gf_income_movement_date__c = System.today();
        income1.gf_income_type__c = '04';
        income1.unique_id__c = '217161842019104PEN001101830100031112';
        income1.product_service_id__c = '001101830100031112';
        incomes.add(income1);
        final Account_Income__c income2 = new Account_Income__c();
        income2.CurrencyIsoCode = 'USD';
        income2.account_id__c = acc.Id;
        income2.gf_income_amount__c = 4776000;
        income2.gf_income_movement_date__c = System.today();
        income2.gf_income_type__c = '04';
        income2.unique_id__c = '217161842019104PEN001101830100031110';
        income2.product_service_id__c = '001101830100031110';
        incomes.add(income2);
        final Account_Income__c income3 = new Account_Income__c();
        income3.CurrencyIsoCode = 'USD';
        income3.account_id__c = acc.Id;
        income3.gf_income_amount__c = 4776000;
        income3.gf_income_movement_date__c = System.today().addYears(-1);
        income3.gf_income_type__c = '04';
        income3.unique_id__c = '217161842018104PEN001101830100031110';
        income3.product_service_id__c = '001101830100031110';
        incomes.add(income3);
        insert incomes;
        
        Test.startTest();
        final map<String, map<Integer, Decimal>> mapIncome = BE_AccountIncomeGraphic_Ctr.getAvgMthBal(acc.Id);
        System.assert(!mapIncome.isEmpty(), 'Correct Value');
        Test.stopTest();
    }
    
    /**
     @Description test BE_AccountIncomeGraphic_Tst.findReport(param), correct scenary
    */
    @IsTest(SeeAllData='true')
    static void findReportTest() {
        String reportDev;
        for(Report rep : [SELECT DeveloperName FROM Report LIMIT 1]) {
            reportDev = rep.DeveloperName;
        }
        Test.startTest();
        final List<Object> reportTest = BE_AccountIncomeGraphic_Ctr.findReport(reportDev);
        System.assert(!reportTest.isEmpty(), 'Correct Value');
        Test.stopTest();
    }
}
