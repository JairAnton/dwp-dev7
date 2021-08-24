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
  static void setupData() {
    final Account acc1 = new Account(Name = 'ASIA MOTORS');
    insert acc1;
    final List<Account> accs = new List<Account>{
      new Account(Name = 'DM Shangai SAC', ParentId = acc1.Id),
      new Account(Name = 'Tokio Tyres', ParentId = acc1.Id),
      new Account(Name = 'Pekin cooling SAC', ParentId = acc1.Id)
    };
    insert accs;

    final List<acpl__Account_Planning__c> accountPlanning = new List<acpl__Account_Planning__c>{
      new acpl__Account_Planning__c(Name = 'AP ASIA MOTORS', acpl__participant_id__c = acc1.Id)
    };
    insert accountPlanning;

    final List<Account_Profitability__c> accountProfilability = new List<Account_Profitability__c>{
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 24254.0,
        profitability_type__c = '03',
        profitability_category_type__c = 'Margen Financiero',
        year_month_day_date__c = date.valueOf('2018-10-31')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 151914.0,
        profitability_type__c = '03',
        profitability_category_type__c = 'Margen Financiero',
        year_month_day_date__c = date.valueOf('2018-10-31')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 0.0,
        profitability_type__c = '03',
        profitability_category_type__c = 'Margen Financiero',
        year_month_day_date__c = date.valueOf('2018-10-31')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 38775.0,
        profitability_type__c = '03',
        profitability_category_type__c = 'Comisiones',
        year_month_day_date__c = date.valueOf('2018-10-31')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 0.0,
        profitability_type__c = '01',
        profitability_category_type__c = 'Altas',
        year_month_day_date__c = date.valueOf('2020-09-28')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 0.0,
        profitability_type__c = '02',
        profitability_category_type__c = 'Spread',
        year_month_day_date__c = date.valueOf('2021-06-28')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 0.0,
        profitability_type__c = '02',
        profitability_category_type__c = 'Tasa',
        year_month_day_date__c = date.valueOf('2020-04-28')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 39388.0,
        profitability_type__c = '03',
        profitability_category_type__c = 'Margen Financiero',
        year_month_day_date__c = date.valueOf('2018-09-28')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 0.0,
        profitability_type__c = '03',
        profitability_category_type__c = 'Margen Financiero',
        year_month_day_date__c = date.valueOf('2018-09-28')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 98395.0,
        profitability_type__c = '03',
        profitability_category_type__c = 'Comisiones',
        year_month_day_date__c = date.valueOf('2018-09-28')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 0.0,
        profitability_type__c = '01',
        profitability_category_type__c = 'Altas',
        year_month_day_date__c = date.valueOf('2020-08-28')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 0.0,
        profitability_type__c = '02',
        profitability_category_type__c = 'DI',
        year_month_day_date__c = date.valueOf('2020-04-28')
      ),
      new Account_Profitability__c(
        account_id__c = acc1.Id,
        current_ydt_amount__c = 4019.0,
        profitability_type__c = '03',
        profitability_category_type__c = 'Margen Financiero',
        year_month_day_date__c = date.valueOf('2018-09-28')
      )
    };
    insert accountProfilability;
  }

  /**
	 @Description test success method
	*/
  @isTest
  public static void unitTest() {
    final acpl__Account_Planning__c accountPlan = [
      SELECT Id
      FROM acpl__Account_Planning__c
      WHERE Name = 'AP ASIA MOTORS'
      LIMIT 1
    ];

    Map<String, Object> resp = BE_ProfilabilityController_cls.getData(accountPlan.Id);

    System.assert(true, 'success!!!');
  }
}