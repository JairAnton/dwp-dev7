/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_AccountIncomeGraphic_Ctr>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-10
   @Description controller for BE_AccountIncomeGraphic_Lwc component
   @Changes
   Date        Author   Email                               Type
   2020-06-10  MAMC     martin.mori.contractor@bbva.com     Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_AccountIncomeGraphic_Ctr {
    /**
     @Description constructor of class
    */
    private BE_AccountIncomeGraphic_Ctr() {
    }

    /**
     @Description return a data of graphic
     @return a map<String, map<Integer, Decimal>> with data of graphic.
    */
	@AuraEnabled(cacheable = true)
	public static map<String, map<Integer, Decimal>> getAvgMthBal(Id recordId) {
		final map<String, map<Integer, Decimal>> years = new map<String, map<Integer, Decimal>>();
        final map<Integer, Decimal> lastYear = new map<Integer, Decimal>{1=>0, 2=>0, 3=>0, 4=>0, 5=>0, 6=>0, 7=>0, 8=>0, 9=>0, 10=>0, 11=>0, 12=>0};
        final map<Integer, Decimal> currentYear = new map<Integer, Decimal>();
        for(Integer numMonth=1; numMonth<=System.today().addMonths(-1).month(); numMonth++) {
            currentYear.put(numMonth, 0);
        }
        years.put('PEN ' + System.today().addMonths(-13).year(), lastYear);
        years.put('PEN ' + System.today().addMonths(-1).year(), currentYear);
        years.put('USD ' + System.today().addMonths(-13).year(), lastYear.clone());
        years.put('USD ' + System.today().addMonths(-1).year(), currentYear.clone());
        for(Account_Income__c item : [SELECT Id, gf_income_movement_date__c, CurrencyIsoCode, gf_income_amount__c FROM Account_Income__c WHERE account_id__c =: recordId AND gf_income_type__c = '04' AND Is_last_two_years__c = TRUE]) {
			final String key = item.CurrencyIsoCode + ' ' + item.gf_income_movement_date__c.year();
            final map<Integer, Decimal> ltsMonth = years.get(key);
            ltsMonth.put(item.gf_income_movement_date__c.month(), ltsMonth.get(item.gf_income_movement_date__c.month())+item.gf_income_amount__c);
            years.put(key, ltsMonth);
		}
		return years;
	}
    
    /**
     @Description return report
     @return a List<Object> with report.
    */
	@AuraEnabled(cacheable = true)
	public static List<Object> findReport(String developerName) {
		return [SELECT Id, Name FROM Report WHERE DeveloperName =: developerName LIMIT 1];
	}
}
