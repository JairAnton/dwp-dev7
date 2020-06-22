/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Calce_Close_Batch>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Batchable class for close all calce
   @Changes
   Date        Author   Email                  				Type
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_Calce_Close_Batch implements Database.Batchable<sObject> {    
    /**
    @Description start method
    @param Database.BatchableContext BatchableContextof batch
    @return Database.QueryLocator QueryLocator result query of calce
    */
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id FROM Calce__c WHERE isClosed__c = false');
    }
    
    /**
    @Description execute method
    @param Database.BatchableContext BatchableContextof batch
	@param List<Calce__c> list of calce
    */
    public void execute(Database.BatchableContext context, List<Calce__c> lstCalce) {
        final Set<Id> ids = new Set<Id>();
        for(Calce__c calce : lstCalce) {
            calce.isClosed__c = true;
            calce.status__c = 'Compartido';
            ids.add(calce.Id);
        }
        update lstCalce;
        final Map<Id,Opportunity> mapOppInsert = new Map<Id,Opportunity>();
        final Map<Id, Decimal> mapOpps = new Map<Id, Decimal>();
        for(Calce_Details__c detail : [SELECT Id, Opportunity_id__c, portfolio_fall_balance__c FROM Calce_Details__c WHERE Calce_id__c IN :ids AND portfolio_fall_balance__c > 0 AND sub_type__c IN ('01', '03')]) {
            mapOpps.put(detail.Opportunity_id__c, detail.portfolio_fall_balance__c);
        }
        for(Opportunity opp : [SELECT Id, AccountId,Amount,Description,LeadSource,CurrencyIsoCode,Name,OwnerId,Pricebook2Id,
                               Probability,StageName,Type,Budget_Confirmed__c,Discovery_Completed__c,isProcess__c,Opportunity_of_campaign_type__c,
                               dwp_frct__opportunity_initial_amount__c,Field_Sup_Closing_Date__c,opportunity_planning_date__c,
                               opportunity_expiry_date__c,Formalization_Date__c,Branch_id__c,Dwp_DevolutionUser__c,ROI_Analysis_Completed__c,
                               renewal_contract_amount__c,rejection_amount__c,rejection_period_num__c,rejection_rate_per__c,
                               rejection_coin__c,Loss_Reason__c,rejection_winner_entity_name__c,priority_opp_of_campaign_type__c,
                               devolutionReason__c,Risk_modality_type__c,opportunity_origin_name__c,opportunity_status_type__c,
                               success_probability_desc__c,Support_currency__c,dwp_kitv__TrackingNumber__c,frm_ContractNumber__c,
                               contract_id__c,renewal_contract_currency__c,rejection_reason_id__c,opportunity_product__c,
                               opportunity_product_family__c,renewal_contract_id__c,sio_code__c,sio_status_type__c FROM Opportunity WHERE Id IN :mapOpps.keySet() ORDER BY Id]) {
                                   opp.Amount=mapOpps.get(opp.Id);
                                   opp.renewal_contract_amount__c=mapOpps.get(opp.Id);
                                   opp.StageName = '02';
                                   opp.opportunity_status_type__c = '03';
                                   opp.Field_Sup_Closing_Date__c = Date.today().addDays(1);
                                   opp.CloseDate = Date.today().addDays(1);
                                   mapOppInsert.put(opp.Id,opp.clone(false,false,false,false));
                               }
        insert mapOppInsert.values();
        final List<OpportunityLineItem> ltsOli = new List<OpportunityLineItem>();
        for(OpportunityLineItem oli : [SELECT Description,OpportunityId,PriceBookEntryId,Quantity,UnitPrice,fprd__GBL_All_fields_informed__c,
                                       fprd__GBL_Cloned__c,price_quote_availability_check__c,PE_List_Mejorado__c,fprd__GBL_Sample_Checkbox__c,
                                       cpliq_Fecha_Vencimiento__c,cpliq_Vcto_tarifa__c,price_quote_date__c,validityDate__c,
                                       fprd__GBL_Sample_Datetime__c,fprd__GBL_Empty_visible_fields__c,fprd__GBL_Visible_configurations__c,
                                       fprd__GBL_Product_version__c,price_quote_owner_id__c,da_Amount__c,capital_amount__c,da_Approved_Risk__c,
                                       da_Used_Risk__c,cpliq_Rof__c,gipr_Buy_Option_amt__c,gipr_Plazo__c,cpliq_n__c,cpliq_n_gracia__c,
                                       gipr_Quantity__c,additional_capital_per__c,additional_apread_per__c,cpliq_BBVA__c,cpliq_Bco_Correspondent__c,
                                       cancellation_fee_per__c,dlf_Portfolio_effectiveness__c,efficiency_cost__c,cpliq_Emission__c,expected_loss_per__c,
                                       financing_cost_stockholder_per__c,funding_cost_per__c,funding_cost_adjusted_per__c,cpliq_Increase__c,
                                       minimum_spread_per__c,minimun_apr_per__c,minimun_fee_per__c,cpliq_Negotiation__c,cpliq_Payment_Dif__c,
                                       proposed_apr_per__c,proposed_fee_per__c,cpliq_Extension__c,regulatory_capital_per__c,restructuring_fee_per__c,
                                       spread_per__c,Spread__c,suggested_apr_per__c,gipr_Cobertura__c,gipr_CuotaInicial__c,gipr_Opcioncompra__c,
                                       gipr_Class__c,cpliq_Commission__c,cpliq_Amortizacion__c,cpliq_liquidacion__c,cpliq_Periodicidad__c,
                                       cpliq_Periodicidad_gracia__c,cpliq_Tipo_amortizacion__c,da_Currency__c,da_Destination_Country__c,
                                       da_Line_Excess__c,da_Origin_Country__c,da_Replacement_financing__c,da_Replacement_Reason__c,FinancingType__c,
                                       cpliq_Way_to_Pay__c,gipr_Buy_Type_Option__c,gipr_Comex_Bag__c,gipr_Destino__c,gipr_Garantia__c,
                                       gipr_Importation_Modality__c,gipr_Modality__c,gipr_Origin__c,gipr_Origin_bank__c,gipr_Payment_Method__c,
                                       gipr_Periodicidad__c,gipr_Physical_token__c,gipr_Request__c,gipr_Tipo_Garantia__c,gipr_Type__c,
                                       gipr_Type_of_assets__c,gipr_Version__c,gipr_Currency_Destiny__c,gipr_Currency_Origin__c,gipr_Operativa__c,
                                       PE_List_Product_mode__c,tcf_Legal_VB_text__c,tcf_Periodicity_commission__c,tcf_type_beneficiary__c,
                                       Tipo_amortizacion__c,tcf_type_bail_letter__c,dlf_Operation_Deadlines__c,capital_currency_id__c,
                                       pricing_model_id__c,da_Merchandise_Detail__c,cpliq_Codigo_Simulacion__c,da_Alt_Email__c,da_Client_Email__c,
                                       price_quote_id__c,cpliq_Cuenta_vinculada__c,cpliq_Cuenta_Abono__c,cpliq_Cuenta_Cargo__c,da_nOperation__c,
                                       frm_ContractNumber__c,gipr_Contract_Number__c,price_operation_id__c,price_rates_calculation_Id__c,
                                       da_Exporter__c,da_Importer__c,da_Observations__c,Assigned_analyst__c,cpliq_Manual__c,price_availability_check_error__c,
                                       price_quote_status_id__c,tcf_beneficiary__c,Siocode__c,fprd__GBL_ClonedFromId__c FROM OpportunityLineItem WHERE OpportunityId IN :mapOpps.keySet() ORDER BY OpportunityId]) {
                                           final OpportunityLineItem auxOli = new OpportunityLineItem();
                                           auxOli = oli.clone(false,false,false,false);
                                           auxOli.UnitPrice=mapOpps.get(oli.OpportunityId);
                                           auxOli.OpportunityId=mapOppInsert.get(oli.OpportunityId).Id;
                                           ltsOli.add(auxOLI);
                               }
        insert ltsOli;
    }
    
    /**
    @Description finish method
	*/
    public void finish(Database.BatchableContext context) {
        
    }
}