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
        Account acc = TestFactory.createAccount();
        List<Account_Income__c> incomes = new List<Account_Income__c>();
        Account_Income__c income = new Account_Income__c();
        income.CurrencyIsoCode = 'USD';
        income.account_id__c = acc.Id;
        income.gf_income_amount__c = 4776000;
        income.gf_income_movement_date__c = System.today();
        income.gf_income_type__c = '04';
        income.unique_id__c = '217161842019104PEN001101830100031112';
        income.product_service_id__c = '001101830100031112';
        incomes.add(income);
        income = new Account_Income__c();
        income.CurrencyIsoCode = 'USD';
        income.account_id__c = acc.Id;
        income.gf_income_amount__c = 4776000;
        income.gf_income_movement_date__c = System.today();
        income.gf_income_type__c = '04';
        income.unique_id__c = '217161842019104PEN001101830100031110';
        income.product_service_id__c = '001101830100031110';
        incomes.add(income);
        income = new Account_Income__c();
        income.CurrencyIsoCode = 'USD';
        income.account_id__c = acc.Id;
        income.gf_income_amount__c = 4776000;
        income.gf_income_movement_date__c = System.today().addYears(-1);
        income.gf_income_type__c = '04';
        income.unique_id__c = '217161842018104PEN001101830100031110';
        income.product_service_id__c = '001101830100031110';
        incomes.add(income);
        insert incomes;
        
        Test.startTest();
        map<String, map<Integer, Decimal>> mapIncome = BE_AccountIncomeGraphic_Ctr.getAvgMthBal(acc.Id);
        Boolean isSuccess = false;
        if(mapIncome.size()>0) {
            isSuccess = true;
        }
        System.assert(isSuccess, 'Correct Value');
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
        Boolean isSuccess = false;
        if(reportTest.size()>0) {
            isSuccess = true;
        }
        System.assert(isSuccess, 'Correct Value');
        Test.stopTest();
    }
}