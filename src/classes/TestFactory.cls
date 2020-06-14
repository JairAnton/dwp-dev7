@isTest
public class TestFactory {
	public static User createUser(String userName, String Perfil) {
		User u = new User();
		Final Double random = Math.random();
		u.Username = userName + 'u2@u.com.u' + random;
		u.LastName = userName + 'uLast2';
		u.Email = userName + 'u2@u.com';
		u.Alias = String.valueOf(random).substring(0, 3) + 'uAas2';
		u.TimeZoneSidKey = 'America/Mexico_City';
		u.IsActive = true;
		u.LocaleSidKey = 'en_US';
		u.EmailEncodingKey = 'ISO-8859-1';
		List<Profile> prof = new List<Profile>([SELECT Id, Name FROM Profile where Name = : Perfil]);
		u.ProfileId =  prof[0].Id;
		u.LanguageLocaleKey = 'es';
		insert u;
		return u;
	}

	//Eduardo Castillo S. Método creado para OpportunityPDFWrap
	public static User createUser_1(String userName, String Perfil) {
		User u = new User();
		Final Double random = Math.random();
		u.Username = userName + 'u2@u.com.u' + random;
		u.LastName = userName + 'uLast2';
		u.Email = userName + 'u2@u.com';
		u.Alias = String.valueOf(random).substring(0, 3) + 'uAas2';
		u.TimeZoneSidKey = 'America/Lima';
		u.IsActive = true;
		u.LocaleSidKey = 'es_PE';
		u.EmailEncodingKey = 'ISO-8859-1';
		List<Profile> prof = new List<Profile>([SELECT Id, Name FROM Profile where Name = : Perfil]);
		u.ProfileId =  prof[0].Id;
		u.LanguageLocaleKey = 'es';
		insert u;
		return u;
	}

	public static Opportunity createOpportunity(Id accountId, Id userId) {
		Opportunity opp = new Opportunity(ownerId = userId, Name = 'testopp', AccountId = accountId, StageName = '01', Amount = 100, CloseDate = system.Date.today(), opportunity_status_type__c = '01');
		insert opp;
		return opp;
	}

	public static Attachment createAttachment(Id parentId, String attachmentName) {
		Attachment attach = new Attachment();
		attach.Name = attachmentName;
		Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
		attach.body = bodyBlob;
		attach.parentId = parentId;
		attach.ContentType = 'application/msword';
		attach.IsPrivate = false;
		attach.Description = 'Test';
		insert attach;
		return attach;
	}

	public static Product2 createProduct() {
		Product2 prod = new Product2(Name = 'Swift', Family = 'Credit', ProductCode = 'PC00009');
		insert prod;
		return prod;
	}

	public static OpportunityLineItem createOLI(Id oppId, Id prodId) {
		Final Id pricebookId = Test.getStandardPricebookId();

		PricebookEntry standardPrice = new PricebookEntry(
			Pricebook2Id = pricebookId, Product2Id = prodId, UnitPrice = 10000, IsActive = true);
		insert standardPrice;

		Pricebook2 customPB = new Pricebook2(Name = 'PriceBook', isActive = true);
		insert customPB;

		PricebookEntry customPrice = new PricebookEntry(
			Pricebook2Id = customPB.Id, Product2Id = prodId,
			UnitPrice = 12000, IsActive = true);
		insert customPrice;

		OpportunityLineItem oli = New OpportunityLineItem(OpportunityId = oppId, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = customPrice.Id, Product2Id = prodId);
		insert oli;
		return oli;
	}

	public static Account createAccount() {
		Account acc = new Account(Name = 'TestAcct');
		insert acc;
		return acc;
	}

	public static Account createAccount(string Parent) {
		Account acc = new Account(Name = 'TestAcct', ParentId = Parent);
		insert acc;
		return acc;
	}

	public static Account_BBVA_Classification__c createAccBBVAClass(Id acc) {
		Account_BBVA_Classification__c accClass = new  Account_BBVA_Classification__c(account_id__c = acc);
		insert accClass;
		return accClass;
	}

	public static Account_Banking_System_Classification__c createAccBankingSystClass(Id acc) {
		Account_Banking_System_Classification__c accClass = new  Account_Banking_System_Classification__c(account_id__c = acc);
		insert accClass;
		return accClass;
	}

	public static Contact createContact(Id acc) {
		Contact c = new  Contact(accountid = acc, LastName = 'test', FirstName = 'test', Salutation = 'Mr.', decision_making_desc__c = 'Si');
		insert c;
		return c;
	}

	public static User_Branch__c createUserBranch(Id userId) {
		Branch__c branch = new Branch__c(Name = 'Test');
		insert branch;
		User_Branch__c userBranch = new User_Branch__c(branch_name__c = branch.id, User__c = userId);
		insert userBranch;
		return userBranch;
	}

	public static Account_Rating__c createAccRating(Id accountId) {
		Account_Rating__c accRating = new Account_Rating__c(account_id__c = accountId, total_rating_score_number__c = 1);
		insert accRating;
		return accRating;
	}

	public static fprd__GBL_Intervener__c createParticipants(Id oppId) {
		fprd__GBL_Intervener__c part = new fprd__GBL_Intervener__c(Name = 'Test', fprd__GBL_Opportunity_product__c = 'IDOP');
		insert part;
		return part;
	}

	public static fprd__GBL_Guarantee__c createGuarantee(Id oppId) {
		fprd__GBL_Guarantee__c guarant = new fprd__GBL_Guarantee__c(fprd__GBL_Opportunity_product__c = 'IDOP');
		insert guarant;
		return guarant;
	}

	/**
	 * Method Created: dwp_kitv__Visit__c
	 **/
	public static dwp_kitv__Visit__c createVisitKit() {
		dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c();
		visit.dwp_kitv__visit_duration_number__c = '2';
		visit.dwp_kitv__visit_start_date__c = system.today();
		insert visit;
		return visit;
	}

	/**
	 * Method Created: dwp_kitv__Visit_Contact__c
	 **/

	public static dwp_kitv__Visit_Contact__c VisitConta(Id visit, Id contact) {
		dwp_kitv__Visit_Contact__c visitConta = new dwp_kitv__Visit_Contact__c(dwp_kitv__visit_id__c = visit, dwp_kitv__contact_id__c = contact);
		insert visitConta;
		return visitConta;
	}

	/**
	 * Method Created: dwp_kitv__Visit_Management_Team__c
	 **/
	public static dwp_kitv__Visit_Management_Team__c CreateVisitManagement(Id visitID, Id UserKit) {
		dwp_kitv__Visit_Management_Team__c kit_Manage = new dwp_kitv__Visit_Management_Team__c
		                                                    (dwp_kitv__visit_id__c = visitID,
		                                                    dwp_kitv__user_id__c = UserKit);
		insert kit_Manage;
		return kit_Manage;
	}

	public static void createAccountProfit(Id Account) {
		Account_Profitability__c accp = new Account_Profitability__c(
			account_id__c = Account,
			profitability_type__c = '03',
			profitability_category_type__c = 'Comisiones'
			);
		insert accp;
		Datetime yesterday = Datetime.now().addDays(-1);
		Test.setCreatedDate(accp.Id, yesterday);
	}

	//ECS
	public static void createAccountProfit_1(Id Account) {
		Account_Profitability__c accp = new Account_Profitability__c(
			account_id__c = Account,
			profitability_type__c = '03',
			profitability_category_type__c = 'Comisiones',
			year_month_day_date__c = date.newInstance(2018, 09, 06),
			currenct_mon_amount__c = 15498.0,
			current_ydt_amount__c = 15498.0
			);
		insert accp;
		Datetime yesterday = Datetime.now().addDays(-1);
		Test.setCreatedDate(accp.Id, yesterday);
	}

	public static Case createCase(Id userId) {
		Case casetest = new Case();
		casetest.Status = 'New';
		casetest.OwnerId = userId;
		insert casetest;
		return casetest;
	}

	public static void productConfiguration(Id IDProduct) {
		fprd__GBL_Product_Configuration__c PC = new fprd__GBL_Product_Configuration__c(
			FPRD__DEFAULT_VALUE__C = '2',
			FPRD__DEVELOPERNAME__C = 'gipr_Periodicidad_PC00007',
			FPRD__HEADER__C = false,
			FPRD__HEADER_ORDER__C = 0,
			FPRD__HIDDEN__C = false,
			FPRD__IMPORTANT__C = false,
			FPRD__LABEL__C = 'Periocidad',
			FPRD__LOV_LABELS__C = 'Días,Meses',
			FPRD__LOV_VALUES__C = '01,02',
			FPRD__LOWER_LIMIT__C = 0,
			FPRD__MANDATORY__C = false,
			FPRD__MAP_FIELD__C = 'gipr_Periodicidad__c',
			FPRD__ORDER__C = 6,
			FPRD__PRODUCT__C = IDProduct,
			FPRD__READ_ONLY__C = false,
			FPRD__RELATED_MAP_FIELDS__C = '',
			FPRD__SECTION_NAME__C = 'Criterios de pago y liquidación',
			FPRD__SECTION_ORDER__C = 1,
			FPRD__TYPE__C = 'List',
			FPRD__UPPER_LIMIT__C = 0,
			FPRD__VALUES_CONTROL_FIELD__C = 'gipr_Tipo_garantia_PC00005',
			FPRD__VISIBILITY_CONDITION__C  = '',
			FPRD__VISIBILITY_CONTROL_FIELD__C = 'gipr_Tipo_garantia_PC00005',
			FPRD__VISIBILITY_CONTROL_VALUE__C = 'No dineraria,Dineraria'
			);
		Insert PC;
	}

	//Eduardo Castillo S. Método creado para OpportunityPDFWrap_Test
	public static void productConfiguration_1(Id IDProduct) {
		fprd__GBL_Product_Configuration__c PC = new fprd__GBL_Product_Configuration__c(
			FPRD__DEFAULT_VALUE__C = '2',
			FPRD__DEVELOPERNAME__C = 'gipr_Tipo_garantia_PC00005',
			FPRD__HEADER__C = false,
			FPRD__HEADER_ORDER__C = 0,
			FPRD__HIDDEN__C = false,
			FPRD__IMPORTANT__C = false,
			FPRD__LABEL__C = 'Periocidad',
			FPRD__LOV_LABELS__C = 'Días,Meses',
			FPRD__LOV_VALUES__C = '01,02',
			FPRD__LOWER_LIMIT__C = 0,
			FPRD__MANDATORY__C = false,
			FPRD__MAP_FIELD__C = 'gipr_Periodicidad__c',
			FPRD__ORDER__C = 6,
			FPRD__PRODUCT__C = IDProduct,
			FPRD__READ_ONLY__C = false,
			FPRD__RELATED_MAP_FIELDS__C = '',
			FPRD__SECTION_NAME__C = 'Criterios de pago y liquidación',
			FPRD__SECTION_ORDER__C = 1,
			FPRD__TYPE__C = 'List',
			FPRD__UPPER_LIMIT__C = 0,
			FPRD__VALUES_CONTROL_FIELD__C = 'gipr_Tipo_garantia_PC00005',
			FPRD__VISIBILITY_CONDITION__C  = '',
			FPRD__VISIBILITY_CONTROL_FIELD__C = 'gipr_Tipo_garantia_PC00005',
			FPRD__VISIBILITY_CONTROL_VALUE__C = 'No dineraria,Dineraria'
			);
		Insert PC;
	}

	//Eduardo Castillo S. Método creado para OpportunityPDFWrap_Test
	public static List<dwp_cvad__Action_Audit__c> create_Action_Audit(String idopp) {
		List<dwp_cvad__Action_Audit__c> action_audit_list = new List<dwp_cvad__Action_Audit__c>();
		for(integer i = 0; i < 2; i++) {
			dwp_cvad__Action_Audit__c obj = new dwp_cvad__Action_Audit__c();
			if(i == 0) {
				obj.dwp_cvad__action_audit_name__c = 'Autorizado por precios';
			} else {
				obj.dwp_cvad__action_audit_name__c = 'Autorizado por riesgos';
			}
			obj.DWP_CVAD__ACTION_AUDIT_RECORD_ID__C = idopp;
			obj.dwp_cvad__action_audit_object_api_name__c = 'Opportunity';
			obj.dwp_cvad__action_audit_style__c = 'restudy';
			obj.dwp_cvad__action_audit_type__c = 'Price Approval';
			obj.CurrencyIsoCode = 'PEN';
			action_audit_list.add(obj);
		}
		insert action_audit_list;
		return action_audit_list;
	}

	//Eduardo Castillo S. Método creado para OpportunityPDFWrap_Test
	public static void create_Action_Audit_Detail(String action_audit_id) {
		dwp_cvad__Action_Audit_Detail__c action_audit_d_list = new dwp_cvad__Action_Audit_Detail__c();
		action_audit_d_list.dwp_cvad__action_audit_id__c = action_audit_id;
		action_audit_d_list.dwp_cvad__action_audit_detail_content__c = 'Comentarios de prueba';
		action_audit_d_list.dwp_cvad__action_audit_detail_display_order__c = 1.0;
		action_audit_d_list.dwp_cvad__action_audit_detail_display_type__c = 'Price Approval';
		insert action_audit_d_list;
	}

	//Eduardo Castillo S. Método creado para OpportunityPDFWrap_Test
	public static void create_guarantee(String id) {
		fprd__GBL_Guarantee__c obj = new fprd__GBL_Guarantee__c();
		obj.fprd__GBL_Opportunity_product__c = id;
		insert obj;
	}

	/* Create User with Dynamic Fields*/
	public static User getUser(Boolean doInsert, Map<Schema.SObjectField, Object> mapFields) {
		User obj = new User();
		Final Double random = Math.random();
		obj.LastName = 'User' + random;
		obj.Username = obj.LastName + '@user.com.u';
		obj.Email = obj.LastName + 'user@u.com.u';
		obj.Alias = String.valueOf(random).substring(0, 3) + 'uAas2';
		obj.TimeZoneSidKey = 'America/Mexico_City';
		obj.IsActive = true;
		obj.LocaleSidKey = 'en_US';
		obj.EmailEncodingKey = 'ISO-8859-1';
		obj.LanguageLocaleKey = 'es';
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
		Account obj = new Account();
		Final Decimal random = Math.random();
		obj.name = 'Test Business Account' + Math.round(random);
		for(Schema.SObjectField sfield : mapFields.keySet()) {
			obj.put(sfield, mapFields.get(sfield));
		}
		if(doInsert) {
			insert obj;
		}
		return obj;
	}
}
