/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group NONE
 *  * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		06/08/2020          modified version.<p />
 * @description TestFactory
 **/
@isTest
public class TestFactory {
    
    /** @Description  TIPO_GARANTIA*/
    static Final String TIPO_GARANTIA = 'TIPO_GARANTIA_pc00005';
    /** @Description  STR_TEST*/
    static Final String STR_TEST = 'Test';
    
    /** @Description  createUser*/
	public static User createUser(String userName, String perfil) {
        Final List<Profile> prof = new List<Profile>([SELECT Id, Name FROM Profile where Name = : perfil]);
        Final Double random = Math.random();
		Final User usuario = new User(Username = userName + 'u2@u.com.u' + random, LastName = userName + 'uLast2', Email = userName + 'u2@u.com', IsActive = true,
                                Alias = String.valueOf(random).substring(0, 3) + 'uAas2', TimeZoneSidKey = 'America/Mexico_City', EmailEncodingKey = 'ISO-8859-1',
                                LocaleSidKey = 'en_US', ProfileId =  prof[0].Id, LanguageLocaleKey = 'es');
		insert usuario;
		return usuario;
	}

	/** Description Eduardo Castillo S. Método creado para OpportunityPDFWrap*/
	public static User createUser_1(String userName, String perfil) {
        Final List<Profile> prof = new List<Profile>([SELECT Id, Name FROM Profile where Name = : perfil]);
        Final Double random = Math.random();
		Final User usuario = new User(Username = userName + 'u2@u.com.u' + random, LastName = userName + 'uLast2', Email = userName + 'u2@u.com', TimeZoneSidKey = 'America/Lima', 
                               Alias = String.valueOf(random).substring(0, 3) + 'uAas2', IsActive = true, LocaleSidKey = 'es_PE', EmailEncodingKey = 'ISO-8859-1', 
                               ProfileId =  prof[0].Id, LanguageLocaleKey = 'es');
		insert usuario;
		return usuario;
	}

    /** @Description  createOpportunity*/
	public static Opportunity createOpportunity(Id accountId, Id userId) {
		Final Opportunity opp = new Opportunity(ownerId = userId, Name = 'testopp', AccountId = accountId, StageName = '01', Amount = 100, 
                                                CloseDate = system.Date.today(), opportunity_status_type__c = '01');
		insert opp;
		return opp;
	}

    /** @Description  createAttachment*/
	public static Attachment createAttachment(Id parentId, String attachmentName) {
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
		Final Attachment attach = new Attachment(Name = attachmentName, body = bodyBlob, parentId = parentId, ContentType = 'application/msword', IsPrivate = false, 
                                                Description = STR_TEST);
		insert attach;
		return attach;
	}

    /** @Description  createProduct*/
	public static Product2 createProduct() {
		Final Product2 prod = new Product2(Name = 'Swift', Family = 'Credit', ProductCode = 'PC00009');
		insert prod;
		return prod;
	}

    /** @Description  createOLI*/
	public static OpportunityLineItem createOLI(Id oppId, Id prodId) {
		Final Id pricebookId = Test.getStandardPricebookId();
		Final PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prodId, UnitPrice = 10000, IsActive = true);
		insert standardPrice;

		Final Pricebook2 customPB = new Pricebook2(Name = 'PriceBook', isActive = true);
		insert customPB;

		Final PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prodId, UnitPrice = 12000, IsActive = true);
		insert customPrice;

		Final OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = oppId, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = customPrice.Id, Product2Id = prodId);
		insert oli;
		return oli;
	}

    /** @Description  createAccount*/
	public static Account createAccount() {
		Final Account acc = new Account(Name = 'TestAcct');
		insert acc;
		return acc;
	}

    /** @Description  createAccount*/
	public static Account createAccount(string Parent) {
		Final Account acc = new Account(Name = 'TestAcct', ParentId = Parent);
		insert acc;
		return acc;
	}

    /** @Description  createAccBBVAClass*/
	public static Account_BBVA_Classification__c createAccBBVAClass(Id acc) {
		Final Account_BBVA_Classification__c accClass = new Account_BBVA_Classification__c(account_id__c = acc);
		insert accClass;
		return accClass;
	}

    /** @Description  createAccBankingSystClass*/
	public static Account_Banking_System_Classification__c createAccBankingSystClass(Id acc) {
		Final Account_Banking_System_Classification__c accClass = new  Account_Banking_System_Classification__c(account_id__c = acc);
		insert accClass;
		return accClass;
	}

    /** @Description  createContact*/
	public static Contact createContact(Id acc) {
		Final Contact cont = new  Contact(accountid = acc, LastName = STR_TEST, FirstName = STR_TEST, Salutation = 'Mr.', decision_making_desc__c = 'Si');
		insert cont;
		return cont;
	}

    /** @Description  createUserBranch*/
	public static User_Branch__c createUserBranch(Id userId) {
		Final Branch__c branch = new Branch__c(Name = STR_TEST);
		insert branch;
		Final User_Branch__c userBranch = new User_Branch__c(branch_name__c = branch.id, User__c = userId);
		insert userBranch;
		return userBranch;
	}

    /** @Description  createAccRating*/
	public static Account_Rating__c createAccRating(Id accountId) {
		Final Account_Rating__c accRating = new Account_Rating__c(account_id__c = accountId, total_rating_score_number__c = 1);
		insert accRating;
		return accRating;
	}

    /** @Description  createParticipants*/
	public static fprd__GBL_Intervener__c createParticipants(Id oppId) {
		Final fprd__GBL_Intervener__c part = new fprd__GBL_Intervener__c(Name = STR_TEST, fprd__GBL_Opportunity_product__c = 'IDOP');
		insert part;
		return part;
	}

    /** @Description  createGuarantee*/
	public static fprd__GBL_Guarantee__c createGuarantee(Id oppId) {
		Final fprd__GBL_Guarantee__c guarant = new fprd__GBL_Guarantee__c(fprd__GBL_Opportunity_product__c = 'IDOP');
		insert guarant;
		return guarant;
	}

	/**
	 * Method Created: dwp_kitv__Visit__c
	 **/
	public static dwp_kitv__Visit__c createVisitKit() {
		Final dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c(dwp_kitv__visit_duration_number__c = '2', dwp_kitv__visit_start_date__c = system.today());
		insert visit;
		return visit;
	}

	/**
	 * Method Created: dwp_kitv__Visit_Contact__c
	 **/
	public static dwp_kitv__Visit_Contact__c VisitConta(Id visit, Id contact) {
		Final dwp_kitv__Visit_Contact__c visitConta = new dwp_kitv__Visit_Contact__c(dwp_kitv__visit_id__c = visit, dwp_kitv__contact_id__c = contact);
		insert visitConta;
		return visitConta;
	}

	/**
	 * Method Created: dwp_kitv__Visit_Management_Team__c
	 **/
	public static dwp_kitv__Visit_Management_Team__c CreateVisitManagement(Id visitID, Id UserKit) {
		Final dwp_kitv__Visit_Management_Team__c kit_Manage = new dwp_kitv__Visit_Management_Team__c(dwp_kitv__visit_id__c = visitID, dwp_kitv__user_id__c = UserKit);
		insert kit_Manage;
		return kit_Manage;
	}

    /** @Description  createAccountProfit*/
	public static void createAccountProfit(Id Account) {
		Final Account_Profitability__c accp = new Account_Profitability__c(account_id__c = Account, profitability_type__c = '03', profitability_category_type__c = 'Comisiones');
		insert accp;
		Final Datetime yesterday = Datetime.now().addDays(-1);
		Test.setCreatedDate(accp.Id, yesterday);
	}

	/** @Description  ECS*/
	public static void createAccountProfit_1(Id Account) {
		Final Account_Profitability__c accp = new Account_Profitability__c(account_id__c = Account, profitability_type__c = '03', profitability_category_type__c = 'Comisiones', 
                                                                     year_month_day_date__c = date.newInstance(2018, 09, 06), currenct_mon_amount__c = 15498.0, 
                                                                     current_ydt_amount__c = 15498.0);
		insert accp;
		Final Datetime yesterday = Datetime.now().addDays(-1);
		Test.setCreatedDate(accp.Id, yesterday);
	}

    /** @Description  createCase*/
	public static Case createCase(Id userId) {
		Final Case casetest = new Case(Status = 'New', OwnerId = userId);
		insert casetest;
		return casetest;
	}

    /** @Description  productConfiguration*/
	public static void productConfiguration(Id IDProduct) {
		Final fprd__GBL_Product_Configuration__c gblPC = new fprd__GBL_Product_Configuration__c(FPRD__DEFAULT_VALUE__C = '2', FPRD__DEVELOPERNAME__C = 'gipr_Periodicidad_PC00007', 
                                                                                       FPRD__HEADER__C = false, FPRD__HEADER_ORDER__C = 0, FPRD__HIDDEN__C = false, 
                                                                                       FPRD__IMPORTANT__C = false, FPRD__LABEL__C = 'Periocidad', FPRD__LOV_LABELS__C = 'Días,Meses', 
                                                                                       FPRD__LOV_VALUES__C = '01,02', FPRD__LOWER_LIMIT__C = 0, FPRD__MANDATORY__C = false, 
                                                                                       FPRD__MAP_FIELD__C = 'gipr_Periodicidad__c', FPRD__ORDER__C = 6, FPRD__PRODUCT__C = IDProduct, 
                                                                                       FPRD__READ_ONLY__C = false, FPRD__RELATED_MAP_FIELDS__C = '', FPRD__SECTION_ORDER__C = 1, 
                                                                                       FPRD__SECTION_NAME__C = 'Criterios de pago y liquidación', FPRD__TYPE__C = 'List', 
                                                                                       FPRD__UPPER_LIMIT__C = 0, FPRD__VALUES_CONTROL_FIELD__C = TIPO_GARANTIA, 
                                                                                       FPRD__VISIBILITY_CONDITION__C  = '', FPRD__VISIBILITY_CONTROL_FIELD__C = TIPO_GARANTIA, 
                                                                                       FPRD__VISIBILITY_CONTROL_VALUE__C = 'No dineraria,Dineraria');
		Insert gblPC;
	}

	//Eduardo Castillo S. Método creado para OpportunityPDFWrap_Test
	public static void productConfiguration_1(Id IDProduct) {
		insert new fprd__GBL_Product_Configuration__c(FPRD__DEFAULT_VALUE__C = '2', FPRD__DEVELOPERNAME__C = TIPO_GARANTIA, FPRD__HEADER__C = false, 
                                                      FPRD__HEADER_ORDER__C = 0, FPRD__HIDDEN__C = false, FPRD__IMPORTANT__C = false, FPRD__LABEL__C = 'Periocidad', 
                                                      FPRD__LOV_LABELS__C = 'Días,Meses', FPRD__LOV_VALUES__C = '01,02', FPRD__LOWER_LIMIT__C = 0, FPRD__MANDATORY__C = false, 
                                                      FPRD__MAP_FIELD__C = 'gipr_Periodicidad__c', FPRD__ORDER__C = 6, FPRD__PRODUCT__C = IDProduct, FPRD__READ_ONLY__C = false, 
                                                      FPRD__RELATED_MAP_FIELDS__C = '', FPRD__SECTION_ORDER__C = 1, FPRD__SECTION_NAME__C = 'Criterios de pago y liquidación', 
                                                      FPRD__TYPE__C = 'List', FPRD__VISIBILITY_CONTROL_VALUE__C = 'No dineraria,Dineraria', FPRD__VALUES_CONTROL_FIELD__C = TIPO_GARANTIA,
                                                      FPRD__UPPER_LIMIT__C = 0, FPRD__VISIBILITY_CONDITION__C  = '', FPRD__VISIBILITY_CONTROL_FIELD__C = TIPO_GARANTIA);
	}

	//Eduardo Castillo S. Método creado para OpportunityPDFWrap_Test
	public static List<dwp_cvad__Action_Audit__c> create_Action_Audit(String idopp) {
		Final List<dwp_cvad__Action_Audit__c> action_audit_list = new List<dwp_cvad__Action_Audit__c>();
		for(integer i = 0; i < 2; i++) {
			Final dwp_cvad__Action_Audit__c obj = new dwp_cvad__Action_Audit__c(DWP_CVAD__ACTION_AUDIT_RECORD_ID__C = idopp, dwp_cvad__action_audit_object_api_name__c = 'Opportunity', 
                                                                         dwp_cvad__action_audit_style__c = 'restudy', dwp_cvad__action_audit_type__c = 'Price Approval', 
                                                                         CurrencyIsoCode = 'PEN');
            obj.dwp_cvad__action_audit_name__c = (i == 0) ? 'Autorizado por precios' : 'Autorizado por riesgos';
			action_audit_list.add(obj);
		}
		insert action_audit_list;
		return action_audit_list;
	}

	//Eduardo Castillo S. Método creado para OpportunityPDFWrap_Test
	public static void create_Action_Audit_Detail(String action_audit_id) {
		insert new dwp_cvad__Action_Audit_Detail__c(dwp_cvad__action_audit_id__c = action_audit_id, dwp_cvad__action_audit_detail_content__c = 'Comentarios de prueba', 
                                                   dwp_cvad__action_audit_detail_display_order__c = 1.0, dwp_cvad__action_audit_detail_display_type__c = 'Price Approval');
	}

	//Eduardo Castillo S. Método creado para OpportunityPDFWrap_Test
	public static void create_guarantee(String id) {
		insert new fprd__GBL_Guarantee__c(fprd__GBL_Opportunity_product__c = id);
	}

	/* Create User with Dynamic Fields*/
	public static User getUser(Boolean doInsert, Map<Schema.SObjectField, Object> mapFields) {
        Final Double random = Math.random();
		Final User obj = new User(LastName = 'User' + random, Username = 'User' + random + '@user.com.u', Email = 'User' + random + 'user@u.com.u', EmailEncodingKey = 'ISO-8859-1', 
                                  Alias = String.valueOf(random).substring(0, 3) + 'uAas2', TimeZoneSidKey = 'America/Mexico_City', IsActive = true, LocaleSidKey = 'en_US', LanguageLocaleKey = 'es');
		for(Schema.SObjectField sfield : mapFields.keySet()) {
			obj.put(sfield, mapFields.get(sfield));
		}
		if(doInsert) {
			insert obj;
		}
		return obj;
	}

	/* Create dynamic Account*/
	public static Account getAccount(Boolean doInsert, Map<Schema.SObjectField, Object> mapFields) {
        Final Decimal random = Math.random();
		Final Account obj = new Account(name = 'Test Business Account' + Math.round(random));
		for(Schema.SObjectField sfield : mapFields.keySet()) {
			obj.put(sfield, mapFields.get(sfield));
		}
		if(doInsert) {
			insert obj;
		}
		return obj;
	}
}