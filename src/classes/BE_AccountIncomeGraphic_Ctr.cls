public with sharing class BE_AccountIncomeGraphic_Ctr {
	@AuraEnabled(cacheable = true)
	public static map<String, map<Integer, Decimal>> getAvgMthBal(Id recordId) {
		map<String, map<Integer, Decimal>> years = new map<String, map<Integer, Decimal>>();
		String key;
		String oldkey;
		map<Integer, Decimal> months;
		Integer numMth;
		for(Account_Income__c item : [SELECT Id, gf_income_movement_date__c, CurrencyIsoCode, gf_income_amount__c FROM Account_Income__c WHERE account_id__c =: recordId AND gf_income_type__c = '04' AND(gf_income_movement_date__c = LAST_YEAR OR gf_income_movement_date__c = THIS_YEAR) ORDER BY CurrencyIsoCode, gf_income_movement_date__c]) {
			key = item.CurrencyIsoCode + ' ' + item.gf_income_movement_date__c.year();
			if(oldkey == null) {
				oldkey = item.CurrencyIsoCode + ' ' + item.gf_income_movement_date__c.year();
				months =  new map<Integer, Decimal>();
				numMth = 1;
			} else if(oldkey != key) {
				years.put(oldkey, months);
				oldkey = item.CurrencyIsoCode + ' ' + item.gf_income_movement_date__c.year();
				months =  new map<Integer, Decimal>();
				numMth = 1;
			}
			while(numMth < item.gf_income_movement_date__c.month()) {
				months.put(numMth, 0.0);
				numMth++;
			}
			if(months.containsKey(item.gf_income_movement_date__c.month())) {
				months.put(item.gf_income_movement_date__c.month(), months.get(item.gf_income_movement_date__c.month()) + item.gf_income_amount__c);
			} else   {
				months.put(item.gf_income_movement_date__c.month(), item.gf_income_amount__c);
				numMth++;
			}
		}
		years.put(key, months);
		return years;
	}

	@AuraEnabled(cacheable = true)
	public static List<Object> findReport(String developerName) {
		return [SELECT Id, Name FROM Report WHERE DeveloperName =: developerName LIMIT 1];
	}
}