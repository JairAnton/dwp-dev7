/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CalceDetailManger_Helper>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-06-21
   @Description Class Helper for create and update Calce Details
   @Changes
    Date        Author   Email                  Type
    2020-06-21  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CalceDetailManger_Helper {
	/** Opportunity type Cancelation */
	final static list<String>CLOSE_STATUS= new List<String> {'Iniciado','En progreso'};
	/** Product C */
	final static Map<Integer,String>PRODUCTS_CODE=new Map<Integer,String> {1=>'PC00001',9=>'PC00009',20=>'PRESTAMOS EMPRESAS'};
	/** private constructor */
    final static String CLOSE_OPP='07';
	/** Product C */
	private BE_CalceDetailManger_Helper () {
	}
	/*
	@Description updateCancellationsOfDay
	@param  calce Sobject
	@param  productTypes type of product
	@param  calceType type CancellationsOfDay
	@param  oppType type Renewal
	 */
	public static void updateCancellationsOfDay(Calce__c calce, List<String>productTypes,String calceType, String oppType) {
		try {
			final List<Calce_Details__c>calceDetailUpsert = new List<Calce_Details__c>();
			Map<Id,Calce_Details__c>calceDetailsMap = new Map<Id,Calce_Details__c>();
			for(Calce_Details__c cDetItem : [SELECT ID,calce_id__c,account_contract_id__c,opportunity_id__c,amount__c,amount_cancelled__c FROM Calce_Details__c WHERE calce_id__c=: calce.Id AND sub_type__c=:calceType]) {
				calceDetailsMap.put(cDetItem.opportunity_id__c,cDetItem);
			}
			final Map<Id,Calce_Details__c>oldOpps=calceDetailsMap;
			for(OpportunityLineItem oppItem : [SELECT Id,Product2.Name,OpportunityId,Opportunity.Name,Opportunity.Amount,
			                                   Opportunity.renewal_contract_amount__c,Opportunity.CloseDate,Opportunity.Account.Name,
			                                   Opportunity.AccountId,Product2Id,Product2.type__c,ProductCode,Opportunity.CurrencyIsoCode FROM OpportunityLineItem WHERE
			                                   Opportunity.Type=:oppType AND Product2.type__c IN:(productTypes) AND Opportunity.StageName!=:CLOSE_OPP AND
			                                   Opportunity.OwnerId=:calce.OwnerId AND Opportunity.opportunity_expiry_date__c <=: calce.close_date__c AND Opportunity.opportunity_expiry_date__c >=: calce.start_date__c AND
			                                   Opportunity.CloseDate<=:calce.close_date__c AND Opportunity.CloseDate>=:calce.start_date__c AND Opportunity.Account.RecordType.DeveloperName='Record_Type_Client']) {
				final Calce_Details__c targetDetail=new Calce_Details__c(
					calce_id__c=calce.Id,
					Name=oppItem.Opportunity.Name,
					product_id__c=oppItem.Product2Id,
					product_code__c=oppItem.ProductCode,
					product_name__c=oppItem.Product2.Name,
					account_id__c=oppItem.Opportunity.AccountId,
					opportunity_id__c=oppItem.OpportunityId,
					CurrencyIsoCode=oppItem.Opportunity.CurrencyIsoCode,
					amount__c=oppItem.Opportunity.renewal_contract_amount__c,
					amount_cancelled__c=oppItem.Opportunity.Amount,
					type__c=oppItem.Product2.type__c,
					close_date__c=oppItem.Opportunity.CloseDate,
					sub_type__c=calceType
					);
				if(calceDetailsMap.containsKey(oppItem.OpportunityId)) {
					targetDetail.Id=calceDetailsMap.get(oppItem.OpportunityId).Id;
					targetDetail.amount_cancelled__c=String.isNotBlank(String.valueOf(calceDetailsMap.get(oppItem.OpportunityId).amount_cancelled__c)) ? calceDetailsMap.get(oppItem.OpportunityId).amount_cancelled__c : targetDetail.amount_cancelled__c;
					oldOpps.remove(oppItem.OpportunityId);
				}
				calceDetailUpsert.add(targetDetail);
			}
			upsert calceDetailUpsert;
			delete oldOpps.values();
		} catch (Exception ex) {
			System.debug(ex.getMessage());
		}
	}
	/*
	@Description updateCancellationsOfDay
	@param  calce Sobject
	@param  productTypes type of product
	@param  calceType type New Opportunities
	@param  oppType type new
	 */
	public static void updateNewOpps(Calce__c calce, List<String>productTypes,String calceType, String oppType) {
		try {
			final List<Calce_Details__c>calceDetailUpsert = new List<Calce_Details__c>();
			final Map<Id,Calce_Details__c>calceDetailsMap = new Map<Id,Calce_Details__c>();
			for(Calce_Details__c cDetItem : [SELECT ID,calce_id__c,account_contract_id__c,opportunity_id__c,amount__c,amount_cancelled__c FROM Calce_Details__c WHERE calce_id__c=: calce.Id AND sub_type__c=:calceType]) {
				calceDetailsMap.put(cDetItem.opportunity_id__c,cDetItem);
			}
			final Map<Id,Calce_Details__c>oldOpps=calceDetailsMap;
			for(OpportunityLineItem oppItem : [SELECT Id,Product2.Name,OpportunityId,Opportunity.Name,Opportunity.Amount,
			                                   Opportunity.CloseDate,Opportunity.Account.Name,Opportunity.AccountId,toLabel(Opportunity.StageName),Product2Id,Product2.type__c,ProductCode,
			                                   Opportunity.CurrencyIsoCode FROM OpportunityLineItem WHERE Opportunity.Type=:oppType AND Product2.type__c IN:(productTypes) AND Opportunity.StageName!=:CLOSE_OPP AND
			                                   Opportunity.OwnerId=:calce.OwnerId AND Opportunity.CloseDate<=:calce.close_date__c AND Opportunity.CloseDate>=:calce.start_date__c AND Opportunity.Account.RecordType.DeveloperName='Record_Type_Client']) {
				final Calce_Details__c targetDetail=new Calce_Details__c(
					calce_id__c=calce.Id,
					Name=oppItem.Opportunity.Name,
					product_id__c=oppItem.Product2Id,
					product_code__c=oppItem.ProductCode,
					product_name__c=oppItem.Product2.Name,
					account_id__c=oppItem.Opportunity.AccountId,
					opportunity_id__c=oppItem.OpportunityId,
					opportunity_stage_name__c=oppItem.Opportunity.StageName,
					currencyIsoCode=oppItem.Opportunity.CurrencyIsoCode,
					amount__c=oppItem.Opportunity.Amount,
					amount_cancelled__c=oppItem.Opportunity.Amount,
					type__c=oppItem.Product2.type__c,
					close_date__c=oppItem.Opportunity.CloseDate,
					sub_type__c=calceType
					);
				if(calceDetailsMap.containsKey(oppItem.OpportunityId)) {
					targetDetail.Id=calceDetailsMap.get(oppItem.OpportunityId).Id;
					oldOpps.remove(oppItem.OpportunityId);
				}
				calceDetailUpsert.add(targetDetail);
			}
			upsert calceDetailUpsert;
			delete oldOpps.values();
		} catch (Exception ex) {
			System.debug(ex.getMessage());
		}
	}
	/*
	@Description earlyCancellations
	@param  calce Sobject
	@param  productTypes type of product
	@param  calceType type CancellationsOfDay
	@param  oppType type Renewal
	 */
	public static void earlyCancellations(Calce__c calce, List<String>productTypes,String calceType, String oppType) {
		try {
			final List<Calce_Details__c>calceDetailUpsert = new List<Calce_Details__c>();
			final Map<Id,Calce_Details__c>calceDetailsMap = new Map<Id,Calce_Details__c>();
			for(Calce_Details__c cDetItem : [SELECT ID,calce_id__c,account_contract_id__c,opportunity_id__c,amount__c,amount_cancelled__c FROM Calce_Details__c WHERE calce_id__c=: calce.Id AND sub_type__c=:calceType]) {
				if(String.isNotBlank(cDetItem.opportunity_id__c)) {
					calceDetailsMap.put(cDetItem.opportunity_id__c,cDetItem);
				}
			}
			final Map<Id,Calce_Details__c>oldOpps=calceDetailsMap;
			for(OpportunityLineItem oppItem : [SELECT Id,Product2.Name,OpportunityId,Opportunity.Name,Opportunity.Amount,
			                                   Opportunity.CloseDate,Opportunity.Account.Name,Opportunity.AccountId,Product2Id,
			                                   ProductCode,Product2.type__c FROM OpportunityLineItem WHERE
			                                   Opportunity.opportunity_expiry_date__c >: calce.close_date__c AND Opportunity.Type=:oppType
			                                   AND Product2.type__c IN:(productTypes) AND Opportunity.OwnerId=:calce.OwnerId AND Opportunity.StageName!=:CLOSE_OPP AND
			                                   Opportunity.CloseDate<=:calce.close_date__c AND Opportunity.CloseDate>=:calce.start_date__c]) {
				final Calce_Details__c targetDetail=new Calce_Details__c(
					calce_id__c=calce.Id,
					Name=oppItem.Opportunity.Name,
					account_id__c=oppItem.Opportunity.AccountId,
					product_id__c=oppItem.Product2Id,
					product_code__c=oppItem.ProductCode,
					product_name__c=oppItem.Product2.Name,
					type__c=oppItem.Product2.type__c,
					opportunity_id__c=oppItem.OpportunityId,
					amount__c=oppItem.Opportunity.Amount,
					amount_cancelled__c=oppItem.Opportunity.Amount,
					close_date__c=oppItem.Opportunity.CloseDate,
					sub_type__c=calceType
					);
				if(calceDetailsMap.containsKey(oppItem.OpportunityId)) {
					targetDetail.Id=calceDetailsMap.get(oppItem.OpportunityId).Id;
					targetDetail.amount_cancelled__c=String.isNotBlank(String.valueOf(calceDetailsMap.get(oppItem.OpportunityId).amount_cancelled__c)) ? calceDetailsMap.get(oppItem.OpportunityId).amount_cancelled__c : targetDetail.amount_cancelled__c;
					oldOpps.remove(oppItem.OpportunityId);
				}
				calceDetailUpsert.add(targetDetail);
			}
			upsert calceDetailUpsert;
			delete oldOpps.values();
		} catch (Exception ex) {
			System.debug(EX.getMessage());
		}
	}
	/*
	@Description updatePortfolioFall
	@param  calce Sobject
	@param  calceType type
	 */
	public static void updatePortfolioFall(Calce__c calce, String calceType) {
		try {
			final Integer numDayLeas = 90+calce.start_date__c.daysBetween(calce.close_date__c);
			final Integer numDayCart = 15+calce.start_date__c.daysBetween(calce.close_date__c);
			final Integer numDayOther = 16+calce.start_date__c.daysBetween(calce.close_date__c);
			final List<Calce_Details__c>calceDetailUpsert = new List<Calce_Details__c>();
			final Map<Id,Calce_Details__c>calceDetailsMap = new Map<Id,Calce_Details__c>();
			for(Calce_Details__c cDetItem : [SELECT ID,calce_id__c,account_contract_id__c,opportunity_id__c,amount__c,amount_cancelled__c,extension__c,return__c,CurrencyIsoCode FROM Calce_Details__c WHERE calce_id__c= :calce.Id AND sub_type__c=:calceType ]) {
				calceDetailsMap.put(cDetItem.account_contract_id__c,cDetItem);
			}
            final Map<Id,Calce_Details__c>oldContracts=calceDetailsMap;
			final DateTime dtContract = [SELECT CreatedDate FROM Account_Contract__c ORDER BY CreatedDate DESC LIMIT 1][0].CreatedDate;
			final Date dateFilter = date.newinstance(dtContract.year(), dtContract.month(), dtContract.day());
			for(Account_Contract__c contract : [SELECT ID, CURRENCYISOCODE, F_VCTO__C, GF_TL_BAL_CONTRACT_OC_AMOUNT__C, GF_LC_CONTRACT_LC_AMOUNT__C, CONTRACT_ID__C, solution_expiry_type__c,
			                                    SOLUTION_CATEGORY_NAME__C, ACCOUNT_ID__C, ACCOUNT_ID__R.NAME, subproduct_type__c FROM Account_Contract__C
			                                    WHERE PRODUCT_TYPE__C='01' AND ACCOUNT_ID__r.OwnerId = :calce.OwnerId AND DAY_ONLY(CREATEDDATE) = :dateFilter
			                                    AND ((SOLUTION_CATEGORY_NAME__C IN ('PRESTAMOS EMPRESAS', 'LETRAS', 'FORFAITING', 'FACTORING', 'COMEX IMPORTACION', 'COMEX EXPORTACION') AND UNPAID_DAYS__C >= 16 AND UNPAID_DAYS__C <= :numDayOther)OR
			                                    (SOLUTION_CATEGORY_NAME__C = 'CARTAS FIANZAS' AND UNPAID_DAYS__C >= 15 AND UNPAID_DAYS__C <= :numDayCart) OR
			                                    (SOLUTION_CATEGORY_NAME__C = 'LEASING' AND UNPAID_DAYS__C >= 90 AND UNPAID_DAYS__C <= :numDayLeas))]) {
				Calce_Details__c targetDetail = new Calce_Details__c();
				targetDetail.calce_id__c=calce.Id;
				targetDetail.sub_type__c=calceType;
				targetDetail = setValues(contract, targetDetail);
				if(calceDetailsMap.containsKey(contract.ID)) {
					targetDetail.Id=calceDetailsMap.get(contract.ID).Id;
					oldContracts.remove(contract.ID);
				}
				calceDetailUpsert.add(targetDetail);
			}
			upsert calceDetailUpsert;
			delete oldContracts.values();
		} catch (Exception ex) {
			System.debug(ex.getMessage());
		}
	}
	/*
	@Description setValues
	@param  Account_contract__c contract
	@param  Calce_Details__c calce details
	@return Calce_Details__c
	 */
	public static Calce_Details__c setValues(Account_contract__c contract, Calce_Details__c detailParam) {
		final Map<String, String>mapTypes = new Map<String, String>();
		mapTypes.put('01', 'Direct');
		mapTypes.put('02', 'Indirect');
		final Map<String, String>mapCodes = new Map<String, String>();
		mapCodes.put('PRESTAMOS EMPRESAS01', PRODUCTS_CODE.get(1));
		mapCodes.put('PRESTAMOS EMPRESAS02', PRODUCTS_CODE.get(9));
		mapCodes.put('LEASING', 'PC00010');
		mapCodes.put('LETRAS', 'PC00005');
		mapCodes.put('FORFAITING', 'PC00004');
		mapCodes.put('FACTORING', 'PC00006');
		mapCodes.put('COMEX IMPORTACION', 'PC00002');
		mapCodes.put('COMEX EXPORTACION', 'PC00003');
		mapCodes.put('CARTAS FIANZAS', 'PC00011');
		Calce_Details__c detail = detailParam;
		detail.Name = contract.SOLUTION_CATEGORY_NAME__C;
		detail.type__c=mapTypes.get(contract.subproduct_type__c);
		if(contract.SOLUTION_CATEGORY_NAME__C==PRODUCTS_CODE.get(20)) {
			detail.product_code__c=mapCodes.get(detail.Name+contract.solution_expiry_type__c);
		} else {
			detail.product_code__c=mapCodes.get(detail.Name);
		}
		if(detail.product_code__c== PRODUCTS_CODE.get(1)) {
			detail.Name += ' CP';
		} else if(detail.product_code__c==PRODUCTS_CODE.get(9)) {
			detail.Name += ' LP';
		}
		detail.CurrencyIsoCode='PEN';
		detail.account_contract_id__c=contract.Id;
		detail.account_id__c=contract.ACCOUNT_ID__C;
		detail.Contract_Number__c=contract.CONTRACT_ID__c;
		detail.close_date__c=contract.F_VCTO__C;
		if(detail.product_code__c!=PRODUCTS_CODE.get(1) && detail.product_code__c!=PRODUCTS_CODE.get(9) && detail.product_code__c!=PRODUCTS_CODE.get(10)) {
			detail.amount__c=contract.GF_LC_CONTRACT_LC_AMOUNT__C;
		}
		return detail;
	}
	/*
	@Description getProductCode
	@param  Account_contract__c contract
	@return String
	 */
	public static void updateCalceStatus(String calDetId) {
		final Calce_Details__c calceDet=[SELECT ID,calce_id__c,calce_id__r.status__c FROM Calce_Details__c WHERE Id=:calDetId];
		setCalceStatus(new Calce__c(Id=calceDet.calce_id__c,status__c=calceDet.calce_id__r.status__c));
	}
	/*
	@Description setCalceStatus
	@param  Calce__c calce
	 */
	public static void setCalceStatus(Calce__c calce) {
		if(calce.status__c==CLOSE_STATUS[0]) {
			calce.status__c=CLOSE_STATUS[1];
			update calce;
		}
	}
}
