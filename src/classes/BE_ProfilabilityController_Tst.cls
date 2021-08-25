/**BE_ProfilabilityController_Tst
 *  object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                       Date                Description<p />
 * -------------------------------------------------------------------
 * Eduardo Vargas    13/08/2021          Original version.<p />
 *
 * @author Eduardo Vargas
 */

@Istest
public with sharing class BE_ProfilabilityController_Tst {
  /**
	   @Description setup data
	 */
  @testSetup
  static void setup() {
    final User manager = TestFactory.createUser('sample', 'Ejecutivo');
    final Account acc1 = new Account(Name = 'ASIA MOTORS');
    insert acc1;
    final List<Account> accs = new List<Account>{ new Account(Name = 'DM Shangai SAC', ParentId = acc1.Id), new Account(Name = 'Tokio Tyres', ParentId = acc1.Id), new Account(Name = 'Pekin cooling SAC', ParentId = acc1.Id) };
    insert accs;

    final acpl__Account_Planning__c accPlan = new acpl__Account_Planning__c();
    accPlan.NAME = 'AP-REVIEW EV V1';
    accPlan.ACPL__EXTERNAL_REFERENCE_ID__C = 'AP-REVIEW EV V11';
    accPlan.ACPL__GF_ACCOUNT_PLANNING_NAME__C = 'Full';
    accPlan.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = true;
    accPlan.ACPL__GF_AP_LAUNCH_NAME__C = 'General period';
    accPlan.ACPL__GF_AP_LAUNCH_PERIOD_DESC__C = '04/21';
    accPlan.ACPL__GF_AP_LIMIT_DATE__C = Date.newInstance(2030, 12, 31);
    accPlan.ACPL__GF_AP_REQ_VALIDATION_IND_TYPE__C = 'Yes';
    accPlan.ACPL__GF_AP_STATUS_TYPE_NAME__C = 'Not started';
    accPlan.ACPL__GF_AP_SUBSTATUS_TYPE_NAME__C = 'Not started';
    accPlan.ACPL__GF_MANDATORY_TYPE__C = 'Mandatory';
    accPlan.acpl__participant_id__c = acc1.Id; //Asia Motors
    accPlan.acpl__proposal_manager_id__c = manager.Id; // EDUARDO VARGAS

    insert accPlan;

    final bupl__BusinessPlan__c bussinessPl = [SELECT ID, Name FROM bupl__BusinessPlan__c LIMIT 1];

    writeDate(accPlan, bussinessPl, acc1, accs);
  }

  /**
	 @Description test success method
	*/
  @isTest
  public static void unitTest() {
    final acpl__Account_Planning__c accountPlan = [SELECT Id FROM acpl__Account_Planning__c WHERE Name = 'AP-REVIEW EV V1' LIMIT 1];

    final Map<String, Object> rentabilityUI = BE_ProfilabilityController_cls.getRDt(accountPlan.Id);
    Integer count = 0;
    for (Object accsObj : (List<Object>) rentabilityUI.get('data')) {
      final Map<String, Object> accsMap = (Map<String, Object>) accsObj;
      for (Object sect : (List<Object>) accsMap.get('sections')) {
        System.debug(sect);
        count++;
      }
    }

    System.assertEquals(count, 9, 'Wrong number of Accounts');
  }

  /** testGetGrowthVariableData */
  @isTest
  public static void testGetGrowthVariableData() {
    final acpl__Account_Planning__c accountPlan = [SELECT Id FROM acpl__Account_Planning__c WHERE Name = 'AP-REVIEW EV V1' LIMIT 1];
    final Map<String, Object> rentabilityUI = BE_ProfilabilityController_cls.getGrowthVariableData(accountPlan.Id);

    Integer rentCount = 0;
    for (Object rentObj : (List<Object>) rentabilityUI.get('data')) {
      System.debug(rentObj);
      rentCount++;
    }
    System.assertEquals(rentCount, 3, 'Rentability Growth Variables');
  }

  /** writeDate */
  private void writeDate(acpl__Account_Planning__c accPlan, bupl__BusinessPlan__c bussinessPl, Account acc1, List<Account> accs) {
    final List<bupl__BP_GrowthDriver__c> growDrivers = new List<bupl__BP_GrowthDriver__c>{
      new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = accPlan.Id, Amount__c = 160000, bupl__solution_category_id__c = 'Financiamiento a largo plazo', ClientAssigned__c = accs[1].Id, CurrencyIsoCode = 'PEN', ExpectedDate__c = date.valueOf('2021-11-11'), bupl__gf_business_plan_id__c = bussinessPl.Id),
      new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = accPlan.Id, Amount__c = 90000, bupl__solution_category_id__c = 'Financiamiento a corto plazo', ClientAssigned__c = accs[1].Id, CurrencyIsoCode = 'USD', ExpectedDate__c = date.valueOf('2021-09-30'), bupl__gf_business_plan_id__c = bussinessPl.Id),
      new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = accPlan.Id, Amount__c = 300000, bupl__solution_category_id__c = 'Tesorería', ClientAssigned__c = accs[2].Id, CurrencyIsoCode = 'PEN', ExpectedDate__c = date.valueOf('2021-09-30'), bupl__gf_business_plan_id__c = bussinessPl.Id)
    };

    insert growDrivers;

    final List<Account_Profitability__c> accProf = new List<Account_Profitability__c>{
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 24254, previous_ydt_amount__c = 147399, profitability_category_type__c = 'Margen Financiero', profitability_type__c = '03', year_month_day_date__c = date.valueOf('2018-10-31')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 151914, previous_ydt_amount__c = 67789, profitability_category_type__c = 'Margen Financiero', profitability_type__c = '03', year_month_day_date__c = date.valueOf('2018-10-31')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 0, previous_ydt_amount__c = 0, profitability_category_type__c = 'Margen Financiero', profitability_type__c = '03', year_month_day_date__c = date.valueOf('2018-10-31')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 38775, previous_ydt_amount__c = 78252, profitability_category_type__c = 'Comisiones', profitability_type__c = '03', year_month_day_date__c = date.valueOf('2018-10-31')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 0, previous_ydt_amount__c = 0, profitability_category_type__c = 'Altas', profitability_type__c = '01', year_month_day_date__c = date.valueOf('2020-09-28')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 0, previous_ydt_amount__c = 0, profitability_category_type__c = 'Spread', profitability_type__c = '02', year_month_day_date__c = date.valueOf('2020-04-28')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 0, previous_ydt_amount__c = 0, profitability_category_type__c = 'Tasa', profitability_type__c = '02', year_month_day_date__c = date.valueOf('2020-04-28')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 39388, previous_ydt_amount__c = 61751, profitability_category_type__c = 'Margen Financiero', profitability_type__c = '03', year_month_day_date__c = date.valueOf('2018-09-28')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 0, previous_ydt_amount__c = 0, profitability_category_type__c = 'Margen Financiero', profitability_type__c = '03', year_month_day_date__c = date.valueOf('2018-09-28')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 98395, previous_ydt_amount__c = 168050, profitability_category_type__c = 'Comisiones', profitability_type__c = '03', year_month_day_date__c = date.valueOf('2018-09-28')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 0, previous_ydt_amount__c = 0, profitability_category_type__c = 'Altas', profitability_type__c = '01', year_month_day_date__c = date.valueOf('2020-08-28')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 0, previous_ydt_amount__c = 0, profitability_category_type__c = 'DI', profitability_type__c = '02', year_month_day_date__c = date.valueOf('2020-04-28')),
      new Account_Profitability__c(account_id__c = acc1.Id, current_ydt_amount__c = 4019, previous_ydt_amount__c = 9325, profitability_category_type__c = 'Margen Financiero', profitability_type__c = '03', year_month_day_date__c = date.valueOf('2018-09-28'))
    };
    insert accProf;
  }
}
