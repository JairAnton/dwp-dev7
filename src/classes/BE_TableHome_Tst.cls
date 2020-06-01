/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_TableHome_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-03-26
   @Description test for BE_TableHome_Ctr class
   @Changes
   Date        Author   Email                               Type
   2019-09-13  MAMC     martin.mori.contractor@bbva.com     Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_TableHome_Tst {
	/**
	   @Description test BE_TableHome_Ctr.getId(param), correct scenary
	 */
	@IsTest(SeeAllData = 'true')
	static void getIdTest() {
		String reportDev;
		for(Report rep : [SELECT DeveloperName FROM Report WHERE Format = 'Tabular' LIMIT 1]) {
			reportDev = rep.DeveloperName;
		}
		final String reportId = BE_TableHome_Ctr.getId(reportDev);
		System.assert (!String.isBlank(reportId), 'Correct Value');
	}

	/**
	   @Description test BE_TableHome_Ctr.getData(param), correct scenary
	 */
	@IsTest(SeeAllData = 'true')
	static void getDataTest() {
		String reportId;
		for(Report rep : [SELECT Id FROM Report WHERE Format = 'Tabular' LIMIT 1]) {
			reportId = rep.Id;
		}
		final List<List<String>> data = BE_TableHome_Ctr.getData(reportId, 5);
		System.assert (!data.isEmpty(), 'Correct Value');
	}
}
