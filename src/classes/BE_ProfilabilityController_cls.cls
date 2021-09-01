/**
 * ProfitabilityController_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * Eduardo Vargas               13-08-2021          Controller for Account Planning Rentability
 * -------------------------------------------------------------------
 * None				    		None          	Original version.<p />
 * @Class Using into a developer for a lithgning component
 *
 * @author Eduardo Vargas
 */
public without sharing class BE_ProfilabilityController_cls {
  /** @Description MARGIN_ORD */
  static final String MARGIN_ORD = 'Margen Ordinario';
  /** @Description COMMISION */
  static final String COMMISION = 'Comisiones';
  /** @Description MARGIN_FIN */
  static final String MARGIN_FIN = 'Margen Financiero';
  /** @Description SECTIONS */
  static final String SECTIONS = 'sections';
  /** @Description ERROR */
  static final String ERROR = 'error';
  /** @Description typeClass */
  static final string TYPECLASS = 'type';
  /** @Description rowClass */
  static final string ROWCLASS = 'row';
  /** @Description priorYearClass */
  static final string PRIORYEARCLASS = 'priorYear';
  /** @Description currentYearClass */
  static final string CURRENTYEARCLASS = 'currentYear';
  /** @Description cYEstClass */
  static final string CYESTCLASS = 'cyEstim';
  /** @Description nextYearClass */
  static final string NEXTYEARCLASS = 'nextYear';
  /** @Description cyAPClass */
  static final string CYAPCLASS = 'cyAP';
  /** @Description iconNameCYClass */
  static final string ICONNAMECYCLASS = 'iconNameCY';
  /** @Description iconNameNYClass */
  static final string ICONNAMENYCLASS = 'iconNameNY';
  /** @Description sectionIdClass */
  static final string SECTIONIDCLASS = 'sectionId';
  /** @Description sumCYClass */
  static final string ECONOMICGROUP = 'Economic Group';

  /**Constructor */
  private BE_ProfilabilityController_cls() {
  }

  /*
   * @Description  Get Custom Data for Profitability Information
   * @recordId Account Planning ID
   */
  @AuraEnabled(cacheable=true)
  public static Map<String, Object> getRDt(string recordId) {
    final acpl__Account_Planning__c accountPlanning = [SELECT Id, Name, acpl__participant_id__r.Id, acpl__participant_id__r.Name, acpl__participant_id__r.RecordType.Name FROM acpl__Account_Planning__c WHERE ID = :recordId];
    final List<Account> accounts = new List<Account>();
    final Map<string, AggregateResult> marOrd = new Map<string, AggregateResult>();
    final Map<string, AggregateResult> comi = new Map<string, AggregateResult>();
    final Map<string, AggregateResult> marFin = new Map<string, AggregateResult>();

    if (accountPlanning.acpl__participant_id__r.RecordType.Name == ECONOMICGROUP) {
      accounts.addAll([SELECT Id, Name FROM Account WHERE parentId = :accountPlanning.acpl__participant_id__r.Id]);
      marOrd.putAll(
        new Map<string, AggregateResult>(
          [
            SELECT Account_id__c cuenta, account_id__c Id, SUM(current_ydt_amount__c) sumCY, SUM(previous_ydt_amount__c) sumPY
            FROM Account_Profitability__c
            WHERE account_id__r.ParentID = :accountPlanning.acpl__participant_id__r.Id AND is_type_3_last_date__c = TRUE AND profitability_type__c = '03' AND (profitability_category_type__c = 'Comisiones' OR profitability_category_type__c = 'Margen financiero')
            GROUP BY Account_id__c
            ORDER BY Account_id__c
          ]
        )
      );
      comi.putAll(
        new Map<string, AggregateResult>(
          [
            SELECT Account_id__c cuenta, account_id__c Id, SUM(current_ydt_amount__c) sumCY, SUM(previous_ydt_amount__c) sumPY
            FROM Account_Profitability__c
            WHERE account_id__r.ParentID = :accountPlanning.acpl__participant_id__r.Id AND is_type_3_last_date__c = TRUE AND profitability_type__c = '03' AND profitability_category_type__c = 'Comisiones'
            GROUP BY Account_id__c
            ORDER BY Account_id__c
          ]
        )
      );
      marFin.putAll(
        new Map<string, AggregateResult>(
          [
            SELECT Account_id__c cuenta, account_id__c Id, SUM(current_ydt_amount__c) sumCY, SUM(previous_ydt_amount__c) sumPY
            FROM Account_Profitability__c
            WHERE account_id__r.ParentID = :accountPlanning.acpl__participant_id__r.Id AND is_type_3_last_date__c = TRUE AND profitability_type__c = '03' AND profitability_category_type__c = 'Margen financiero'
            GROUP BY Account_id__c
            ORDER BY Account_id__c
          ]
        )
      );
    } else {
      accounts.addAll([SELECT Id, Name FROM Account WHERE Id = :accountPlanning.acpl__participant_id__r.Id]);
      marOrd.putAll(
        new Map<string, AggregateResult>(
          [
            SELECT Account_id__c cuenta, account_id__c Id, SUM(current_ydt_amount__c) sumCY, SUM(previous_ydt_amount__c) sumPY
            FROM Account_Profitability__c
            WHERE account_id__r.Id = :accountPlanning.acpl__participant_id__r.Id AND is_type_3_last_date__c = TRUE AND profitability_type__c = '03' AND (profitability_category_type__c = 'Comisiones' OR profitability_category_type__c = 'Margen financiero')
            GROUP BY Account_id__c
            ORDER BY Account_id__c
          ]
        )
      );
      comi.putAll(
        new Map<string, AggregateResult>(
          [
            SELECT Account_id__c cuenta, account_id__c Id, SUM(current_ydt_amount__c) sumCY, SUM(previous_ydt_amount__c) sumPY
            FROM Account_Profitability__c
            WHERE account_id__r.Id = :accountPlanning.acpl__participant_id__r.Id AND is_type_3_last_date__c = TRUE AND profitability_type__c = '03' AND profitability_category_type__c = 'Comisiones'
            GROUP BY Account_id__c
            ORDER BY Account_id__c
          ]
        )
      );
      marFin.putAll(
        new Map<string, AggregateResult>(
          [
            SELECT Account_id__c cuenta, account_id__c Id, SUM(current_ydt_amount__c) sumCY, SUM(previous_ydt_amount__c) sumPY
            FROM Account_Profitability__c
            WHERE account_id__r.Id = :accountPlanning.acpl__participant_id__r.Id AND is_type_3_last_date__c = TRUE AND profitability_type__c = '03' AND profitability_category_type__c = 'Margen financiero'
            GROUP BY Account_id__c
            ORDER BY Account_id__c
          ]
        )
      );
    }

    final Map<String, Account_Plan_Rentability__c> accPlanRen = new Map<String, Account_Plan_Rentability__c>();
    for (Account_Plan_Rentability__c accPR : [SELECT Id, Current_Year_Account_Plan__c, Current_Year_Estimation__c, Icon_Name_Current_Year__c, Icon_Name_Next_Year__c, Next_Year__c, Section_Id__c, Spread__c, Spread_Month__c, Structured_Commission__c, Term__c, Type__c FROM Account_Plan_Rentability__c WHERE Account_Planning__c = :recordId]) {
      accPlanRen.put(accPR.Section_Id__c, accPR);
    }

    final List<Map<String, Object>> responseList = new List<Map<String, Object>>();
    for (Account acc : accounts) {
      final Map<String, Object> mapValues = new Map<String, Object>{ 'accountId' => acc.Id, 'accountName' => acc.Name };
      final List<Map<String, Object>> sectionsList = new List<Map<String, Object>>();

      sectionsList.add(generateRentSections(marFin, accPlanRen, acc, MARGIN_FIN));
      sectionsList.add(generateRentSections(comi, accPlanRen, acc, COMMISION));
      sectionsList.add(generateRentSections(marOrd, accPlanRen, acc, MARGIN_ORD));

      mapValues.put(SECTIONS, sectionsList);
      responseList.add(mapValues);
    }

    return new Map<String, Object>{ 'data' => responseList };
  }

  /*
   * @Description  Get data for Growth Variables
   * @recordId Account Planning ID
   */
  @AuraEnabled
  public static Map<String, Object> getGrowthVariableData(string recordId) {
    final Map<String, Object> response = new Map<String, Object>();
    final List<Map<String, Object>> estimationList = new List<Map<String, Object>>();
    final Map<String, Account_Plan_Rentability__c> accPlanRen = new Map<String, Account_Plan_Rentability__c>();

    for (Account_Plan_Rentability__c accPR : [
      SELECT Id, Current_Year_Account_Plan__c, Current_Year_Estimation__c, Icon_Name_Current_Year__c, Icon_Name_Next_Year__c, Next_Year__c, Section_Id__c, Spread__c, Spread_Month__c, Structured_Commission__c, Term__c, Type__c
      FROM Account_Plan_Rentability__c
      WHERE Account_Planning__c = :recordId AND Type__c = 'ESTVARIABLES'
    ]) {
      accPlanRen.put(accPR.Section_Id__c, accPR);
    }

    for (bupl__BP_GrowthDriver__c accountPlanning : [SELECT Id, bupl__solution_category_id__c, ClientAssigned__r.Name, ClientAssigned__r.Id, convertCurrency(Amount__c), ExpectedDate__c, CurrencyIsoCode FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c = :recordId]) {
      final Map<String, Object> estimationMap = new Map<String, Object>();
      estimationMap.put('opportunityId', accountPlanning.ClientAssigned__r.Id + '-' + accountPlanning.Id);
      estimationMap.put('accountId', accountPlanning.ClientAssigned__r.Id);
      estimationMap.put('opportunityName', accountPlanning.bupl__solution_category_id__c);
      estimationMap.put('AccountName', accountPlanning.ClientAssigned__r.Name);
      estimationMap.put('expectedDate', accountPlanning.ExpectedDate__c);
      estimationMap.put('opportunityValue', accountPlanning.Amount__c);
      estimationMap.put('CurrencyIsoCode', accountPlanning.CurrencyIsoCode);

      estimationMap.put('spread', compareWithSavedData(accPlanRen, accountPlanning, 'Spread__c'));
      estimationMap.put('calcSpreadM', compareWithSavedData(accPlanRen, accountPlanning, 'Spread_Month__c'));
      estimationMap.put('term', compareWithSavedData(accPlanRen, accountPlanning, 'Term__c'));
      estimationMap.put('strComm', compareWithSavedData(accPlanRen, accountPlanning, 'Structured_Commission__c'));
      estimationMap.put('calculatedMargin', 0);
      estimationMap.put('calComm', 0);

      estimationList.add(estimationMap);
    }
    response.put('data', estimationList);
    return response;
  }

  /** saveRentabilityDrivers */
  @AuraEnabled
  public static Map<String, Object> saveRentabilityDrivers(String rentability, String rentModUI, String recordId) {
    final Map<String, Object> response = new Map<String, Object>();
    try {
      final List<RentabilityUI> rentabilitiesUI = (List<RentabilityUI>) JSON.deserialize(rentability, List<RentabilityUI>.class);
      final List<RentabilityEstimationUI> rentsModUI = (List<RentabilityEstimationUI>) JSON.deserialize(rentModUI, List<RentabilityEstimationUI>.class);

      final Map<String, Id> apMap = new Map<String, Id>();
      for (Account_Plan_Rentability__c apr : [SELECT Id, Section_Id__c FROM Account_Plan_Rentability__c WHERE Account_Planning__c = :recordId]) {
        apMap.put(apr.Section_Id__c, apr.Id);
      }

      final List<Account_Plan_Rentability__c> apRent = rentabilityUIModalToSObject(rentabilitiesUI, rentsModUI, apMap, recordId);

      //response.put('example', apRent);
      upsert apRent;
    } catch (Exception e) {
      response.put(ERROR, e);
    }
    return response;
  }

  /**--------------------------------
   *        Utility Functions
   --------------------------------*/
  /** compareWithSavedData */
  public static Object compareWithSavedData(Map<String, Account_Plan_Rentability__c> accPlanRen, bupl__BP_GrowthDriver__c accountPlanning, String accountPlanField) {
    Object response;

    try {
      if (accPlanRen.containsKey(accountPlanning.ClientAssigned__r.Id + '-' + accountPlanning.Id)) {
        final Account_Plan_Rentability__c accPlan = accPlanRen.get(accountPlanning.ClientAssigned__r.Id + '-' + accountPlanning.Id);
        response = accPlan.get(accountPlanField);
      } else {
        response = 0;
      }
    } catch (System.NullPointerException e) {
      response = 0;
    }

    return response;
  }

  /** compareRentabilityWithSavedData */
  public static Object compareRentabilityWithSavedData(Map<String, Account_Plan_Rentability__c> accPlanRen, String accId, String accountPlanField, String rentType) {
    Object response = null;

    try {
      if (accPlanRen.containsKey(rentType + '-' + accId)) {
        final Account_Plan_Rentability__c accPlan = accPlanRen.get(rentType + '-' + accId);
        response = accPlan.get(accountPlanField);
      } else {
        response = 0;
      }
    } catch (System.NullPointerException e) {
      response = 0;
    }

    return response;
  }
  /**Mapper */
  private static List<Account_Plan_Rentability__c> rentabilityUIModalToSObject(List<RentabilityUI> rentabilitiesUi, List<RentabilityEstimationUI> rentsModalUI, Map<String, Id> apMap, String recordId) {
    final List<Account_Plan_Rentability__c> response = new List<Account_Plan_Rentability__c>();
    for (RentabilityUI rentabilityUI : rentabilitiesUi) {
      for (RentabilitySection sections : rentabilityUI.sections) {
        final Account_Plan_Rentability__c apl = new Account_plan_Rentability__c();
        apl.Account_Id__c = rentabilityUI.accountId;
        apl.Account_Planning__c = recordId;
        apl.Type__c = 'RENTABILITY';

        apl.Current_Year_Estimation__c = sections.cyEstim;
        apl.Current_Year_Account_Plan__c = sections.cyAP;
        apl.Icon_Name_Current_Year__c = sections.iconNameCY;
        apl.Icon_Name_Next_Year__c = sections.iconNameNY;
        apl.Next_Year__c = sections.nextYear;
        apl.Section_Id__c = sections.sectionId;

        if (apMap.containsKey(sections.sectionId)) {
          apl.Id = Id.valueOf(apMap.get(sections.sectionId));
        }

        response.add(apl);
      }
    }

    for (RentabilityEstimationUI estUI : rentsModalUI) {
      final Account_Plan_Rentability__c apl = new Account_plan_Rentability__c();

      apl.Account_Id__c = estUI.accountId;
      apl.Account_Planning__c = recordId;
      apl.Term__c = estUI.term;
      apl.Structured_Commission__c = estUI.strComm;
      apl.Spread__c = estUI.spread;
      apl.Spread_Month__c = estUI.calcSpreadM;
      apl.Section_Id__c = estUI.opportunityId;
      apl.Type__c = 'ESTVARIABLES';

      if (apMap.containsKey(estUI.opportunityId)) {
        apl.Id = Id.valueOf(apMap.get(estUI.opportunityId));
      }
      response.add(apl);
    }

    return response;
  }

  /*
   * @Description  Utility function
   * @map
   */
  private static Map<String, Object> generateRentSections(Map<string, AggregateResult> obj, Map<String, Account_Plan_Rentability__c> accPlanRen, Account acc, String rentType) {
    final Map<String, Object> sectionsMaps = new Map<String, Object>();
    Decimal sumCYClass = 0;
    Decimal sumPYClass = 0;

    if (obj.containsKey(acc.Id)) {
      sumCYClass = (Decimal) obj.get(acc.Id).get('sumCY');
      sumPYClass = (Decimal) obj.get(acc.Id).get('sumPY');
    }
    sectionsMaps.put(ROWCLASS, rentType);
    sectionsMaps.put(PRIORYEARCLASS, sumPYClass);
    sectionsMaps.put(CURRENTYEARCLASS, sumCYClass);

    sectionsMaps.put(SECTIONIDCLASS, rentType + '-' + acc.Id);

    sectionsMaps.put(CYESTCLASS, compareRentabilityWithSavedData(accPlanRen, acc.Id, 'Current_Year_Estimation__c', rentType));
    sectionsMaps.put(ICONNAMECYCLASS, compareRentabilityWithSavedData(accPlanRen, acc.Id, 'Icon_Name_Current_Year__c', rentType));
    sectionsMaps.put(ICONNAMENYCLASS, compareRentabilityWithSavedData(accPlanRen, acc.Id, 'Icon_Name_Next_Year__c', rentType));
    sectionsMaps.put(NEXTYEARCLASS, compareRentabilityWithSavedData(accPlanRen, acc.Id, 'Next_Year__c', rentType));
    sectionsMaps.put(CYAPCLASS, compareRentabilityWithSavedData(accPlanRen, acc.Id, 'Current_Year_Account_Plan__c', rentType));
    sectionsMaps.put(TYPECLASS, 1);
    return sectionsMaps;
  }

  /**--------------------------------
   *        Class Deff
   --------------------------------*/
  /** Class used by UI to parse the Rentability */
  public class RentabilityUI {
    /** accountId */
    public String accountId { get; set; }

    /** accountName */
    public String accountName { get; set; }

    /** sections */
    public List<RentabilitySection> sections { get; set; }
  }

  /** Class used by UI to parse the Rentability Modal */
  public class RentabilityEstimationUI {
    /** accountName */
    public String accountName { get; set; }

    /** accountId */
    public String accountId { get; set; }

    /** calComm */
    public Decimal calComm { get; set; }

    /** calculatedMargin */
    public Decimal calculatedMargin { get; set; }

    /** calcSpreadM */
    public Decimal calcSpreadM { get; set; }

    /** expectedDate */
    public Date expectedDate { get; set; }

    /** opportunityId */
    public String opportunityId { get; set; }

    /** opportunityName */
    public String opportunityName { get; set; }

    /** opportunityValue */
    public Decimal opportunityValue { get; set; }

    /** spread */
    public Decimal spread { get; set; }

    /** strComm */
    public Decimal strComm { get; set; }

    /** term */
    public Integer term { get; set; }
  }

  /** Subclass used for rentability */
  public class RentabilitySection {
    /** currentYear */
    public Decimal currentYear { get; set; }

    /** currentYearEstimation */
    public Decimal cyEstim { get; set; }

    /** cyAP */
    public Decimal cyAP { get; set; }

    /** iconNameCY */
    public String iconNameCY { get; set; }

    /** iconNameNY */
    public String iconNameNY { get; set; }

    /** nextYear */
    public Decimal nextYear { get; set; }

    /** priorYear */
    public Decimal priorYear { get; set; }

    /** row */
    public String row { get; set; }

    /** sectionId */
    public String sectionId { get; set; }

    /** type */
    public Integer type { get; set; }
  }
}
