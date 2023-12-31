public without sharing virtual class OpportunityPDFWrap {
    
	/** Class method*/
	public static OpportunityLineItem OLI {get; set;}
    
	/** Class method*/
	public static OpportunityLineItem OLI2 {get; set;}
    
	/** Class method*/
	public static OpportunityLineItem OLI3 {get; set;}
    
	/** Class method*/
	public static List<Product_Commission__c> commissions1 {get; set;}
    
	/** Class method*/
	Public Static Account_BBVA_Classification__c ABBVAC {get; set;}
    
	/** Class method*/
	Public static Product2 Product {get; set;}
    
	/** Class method*/
	Public static Account Client {get; set;}
    
	/** Class method*/
	Public static User_Branch__c[] usuarioOficina {get; set;}
    
	/** Class method*/
	Public static Branch__c Oficina {get; set;}
    
	/** Class method*/
	Public static Account_Rating__c Rating {get; set;}
    
	/** Class method*/
	Public static list<fprd__GBL_Intervener__c > Intervenientes {get; set;}
    
	/** Class method*/
	Public static list<fprd__GBL_Guarantee__c> Garantias {get; set;}
    
	/** Class method*/
	public static AggregateResult[] totalComprimisos {get; set;}
    
	/** Class method*/
	public static AggregateResult[] totalGarantiasNoFormalizadas {get; set;}
    
	/** Class method*/
	public static fprd__GBL_Product_Configuration__c[] ProductConfiguration {get; set;}
    
	/** Class method*/
	public static fprd__GBL_Product_Configuration__c[] A {get; set;}
    
	/** Class method*/
	public static fprd__GBL_Product_Configuration__c[] B {get; set;}
    
	/** Class method*/
	public static Integer totalC {get; set;}
    
	/** Class method*/
	public static Integer numGnF {get; set;}
    
	/** Class method*/
	public static String title {get; set;}
    
	/** Class method*/
	public static opportunity Opp {get; set;}
    
	/** Class method*/
	public static map<id, boolean> fieldVisibility {get; set;}
    
	/** Class method*/
	private static list<dwp_cvad__Action_Audit__c> Audit {get; set;}
    
	/** Class method*/
	Public static list<dwp_cvad__Action_Audit__c> Comen {get; set;}
    
	/** Class method*/
	public static String FechaAut {get; set;}
    
	/** Class method*/
	public static String FauthPrecio {get; set;}
    
	/** Class method*/
	public static String Comentarios {get; set;}

	private static String getQuery(String Objeto) {
		String SOQLQuery;
		SObjectType objType = Schema.getGlobalDescribe().get(Objeto);
		Map<String, Schema.SObjectField> Mfields = objType.getDescribe().fields.getMap();
		SOQLQuery = 'SELECT ';
		for(Schema.SObjectField mf : Mfields.values()) {
			schema.describefieldresult dfield = mf.getDescribe();
			SOQLQuery += dfield.getname() + ', ';
		}
		SOQLQuery = SOQLQuery.substring(0, SOQLQuery.length() - 2);
		SOQLQuery += ' FROM ' + Objeto;
		return SOQLQuery;
	}

	private static void  filterVisibility(list<fprd__GBL_Product_Configuration__c> PrdConfg) {
		A = new list<fprd__GBL_Product_Configuration__c>();
		B = new list<fprd__GBL_Product_Configuration__c>();
		fieldVisibility = new map<id, boolean>();
		String SOQLQuery;
		String SOQLQueryDepend;
		SObjectType objType = Schema.getGlobalDescribe().get('OpportunityLineItem');
		Map<String, Schema.SObjectField> Mfields = objType.getDescribe().fields.getMap();
		SOQLQuery = 'SELECT ';
		SOQLQueryDepend = 'SELECT ';
		for(Schema.SObjectField mf : Mfields.values()) {
			schema.describefieldresult dfield = mf.getDescribe();
			if(String.valueOf(dfield.getType()) == 'PICKLIST') {
				SOQLQuery += 'toLabel(' + dfield.getname() + '), ';
			} else {
				SOQLQuery += dfield.getname() + ', ';
			}
			SOQLQueryDepend += dfield.getname() + ', ';
		}
		SOQLQuery = SOQLQuery.substring(0, SOQLQuery.length() - 2);
		SOQLQueryDepend = SOQLQueryDepend.substring(0, SOQLQueryDepend.length() - 2);
		final String Opps = Opp.Id;
		SOQLQuery += ' FROM OpportunityLineItem WHERE OpportunityId =:Opps';
		SOQLQueryDepend += ' FROM OpportunityLineItem WHERE OpportunityId =:Opps';
		OLI2 = Database.query(String.escapeSingleQuotes(SOQLQuery)); //Yulino 04/12/2018 : se agrego String.escapeSingleQuotes()
		OLI3 = Database.query(String.escapeSingleQuotes(SOQLQueryDepend));
		boolean found;
		for(fprd__GBL_Product_Configuration__c pc : PrdConfg) {
			found = false;
            if(pc.fprd__Hidden__c) {
                fieldVisibility.put(pc.Id, false);
            } else if(String.isNotBlank(pc.FPRD__VISIBILITY_CONTROL_FIELD__C)) {
                fieldVisibility.put(pc.Id, false);
                final String[] controlFields = pc.FPRD__VISIBILITY_CONTROL_FIELD__C.split(';');
                final String[] controlValues = pc.FPRD__VISIBILITY_CONTROL_VALUE__C.split(';');
                Integer pos = 0;
                for(String fieldName : controlFields) {
                    found = false;
                    for(fprd__GBL_Product_Configuration__c prc : PrdConfg) {
                        If(fieldName ==  prc.fprd__DeveloperName__c) {
                            fieldName =  prc.fprd__Map_field__c;
                            break;
                        }
                    }
                    Final List<String> ctrValuesItem = controlValues[pos].split(',');
                    if(ctrValuesItem.contains((String)OLI3.get(fieldName))) {
                        found = true;
                    }
                    pos++;
                    if(!found) {
                        break;
                    }
                }
                if(found) {
                    fieldVisibility.put(pc.Id, true);
                }
			} else {
                fieldVisibility.put(pc.Id, true);
			}
		}
		for(fprd__GBL_Product_Configuration__c pc : PrdConfg) {
			if(pc.FPRD__SECTION_NAME__C == 'Información general del producto' && fieldVisibility.get(pc.Id)) {
				A.add(pc);
			}
			if(pc.FPRD__SECTION_NAME__C == 'Criterios de pago y liquidación' && fieldVisibility.get(pc.Id)) {
				B.add(pc);
			}
		}
	}
    
	public static string setValues(String Oppid) {
		try {
			oficina = new Branch__c();
			Rating = new Account_Rating__c();
			list<dwp_cvad__Action_Audit_Detail__c> DetalleComentario = new list<dwp_cvad__Action_Audit_Detail__c>();
			Opp = database.query(String.escapeSingleQuotes(getQuery('Opportunity') + ' WHERE id =:Oppid LIMIT 1'));
			final String idTempo = Opp.Id;
			OLI = database.query(String.escapeSingleQuotes(getQuery('OpportunityLineItem') + ' WHERE  OpportunityID =:idTempo ORDER BY CreatedDate DESC LIMIT 1'));
			commissions1 =  [SELECT Calculation_Type__c , Commission_Calculation_Amount__c, Product_Commission_Name__c, Suggested_Rate__c, Suggested_Rate_Type__c, Requested_Rate_Value__c,Authorized_Rate_Value__c, Final_Rate__c, Rate_Is_Amount__c, Suggested_Rate_Iso_Code__c, Rate_Is_Percent__c, Commission_Calculation_Currency__c FROM Product_Commission__c WHERE Opportunity_Product__c = :oli.Id and Is_Negotiable__c = TRUE ];
			system.debug('Commissions:'+commissions1);

			final List<String> Litemp = new list<String> {'Autorizado por riesgos', 'Riesgo aprobado dentro de línea'};
			Audit = database.query(String.escapeSingleQuotes(getQuery('dwp_cvad__Action_Audit__c') + ' WHERE  dwp_cvad__action_audit_name__c IN:Litemp  AND  DWP_CVAD__ACTION_AUDIT_RECORD_ID__C =:idTempo  ORDER BY CreatedDate DESC'));
			if(Audit.size() > 0) {
				FechaAut = String.valueOf(Date.valueOf(Audit[0].dwp_cvad__action_audit_date__c));
			} else  {
				FechaAut = Label.lblNoAuthDate;
			}
			FauthPrecio = String.valueOf(OLI.price_quote_date__c);
			final List<String> Litemp2 = new list<String> {'Precio autorizado bajo delegación oficina', 'Autorizado por precios'};
			Comen = database.query(String.escapeSingleQuotes(getQuery('dwp_cvad__Action_Audit__c') + ' WHERE  DWP_CVAD__ACTION_AUDIT_RECORD_ID__C =:idTempo AND dwp_cvad__action_audit_name__c IN:Litemp2  ORDER BY CreatedDate DESC'));
			if(Comen.size() > 0) {
				final String idComent = Comen[0].Id;
				DetalleComentario = database.query(String.escapeSingleQuotes(getQuery('dwp_cvad__Action_Audit_Detail__c') + ' WHERE dwp_cvad__action_audit_id__c =:idComent '));
				if(DetalleComentario.size() > 0) {
					Comentarios = DetalleComentario[0].dwp_cvad__action_audit_detail_content__c;
					Comentarios = Comentarios.substringAfterLast('>Comentarios</h3>');
					Comentarios = Comentarios.substringBefore('</span>');
					Comentarios = Comentarios.stripHtmlTags();
				}
				system.debug(idComent);
			}
			final string Olitemp = OLI.Product2Id;
			Product = database.query(String.escapeSingleQuotes(getQuery('Product2') + ' WHERE  Id =:Olitemp LIMIT 1'));
			final String ProductTemp = Product.UNIQUE_ID__C;
			final List<String> Litemp3 = new List<String> {'Criterios de pago y liquidación', 'Información general del producto'};
			ProductConfiguration = database.query(String.escapeSingleQuotes(getQuery('fprd__GBL_Product_Configuration__c') + ' WHERE FPRD__PRODUCT__R.UNIQUE_ID__C =:ProductTemp AND FPRD__SECTION_NAME__C IN:Litemp3  ORDER BY FPRD__SECTION_NAME__C,FPRD__ORDER__C'));
			system.debug('ProductConfiguration' + ProductConfiguration);
			filterVisibility(ProductConfiguration);
			final String ClieAcountID = opp.Accountid;
			Client = database.query(String.escapeSingleQuotes(getQuery('Account') + ' WHERE  Id =:ClieAcountID LIMIT 1'));
			final String Cliente = Client.Id;
			final String ClienteOwner = opp.ownerId;
			usuarioOficina = database.query(String.escapeSingleQuotes(getQuery('User_Branch__c') + ' WHERE  User__c =:ClienteOwner LIMIT 1'));
			final String IdBRanch = usuarioOficina[0].branch_name__c;
			if(usuarioOficina.size() > 0) {
				oficina =  database.query(String.escapeSingleQuotes(getQuery('Branch__c') + ' WHERE  id =:IdBRanch LIMIT 1'));
			}
			//Fix When Account Rating is not present
			if(!database.query(String.escapeSingleQuotes(getQuery('Account_Rating__c') + ' WHERE  account_id__c =:Cliente ORDER BY createdDate LIMIT 1')).isEmpty()) {
				Rating = database.query(String.escapeSingleQuotes(getQuery('Account_Rating__c') + ' WHERE  account_id__c =:Cliente ORDER BY createdDate LIMIT 1'));
			}
			Intervenientes = database.query(String.escapeSingleQuotes(getQuery('fprd__GBL_Intervener__c') + ' WHERE  fprd__GBL_Opportunity_product__c =:idTempo'));
			//Fix When Guarantee Rating is not present
			if(!database.query(String.escapeSingleQuotes(getQuery('fprd__GBL_Guarantee__c') + ' WHERE  fprd__GBL_Opportunity_product__c =:idTempo')).isEmpty()) {
				Garantias = database.query(String.escapeSingleQuotes(getQuery('fprd__GBL_Guarantee__c') + ' WHERE  fprd__GBL_Opportunity_product__c =:idTempo'));
			}
			totalComprimisos = [SELECT COUNT_DISTINCT(Id) total FROM Opportunity_Solution_Commitment__c WHERE Opportunity_Id__c =:Opp.id];
			totalC = Integer.valueOf(totalComprimisos[0].get('total'));
			system.debug(IdBRanch + '' + Litemp + '' + Litemp2 + '' + Litemp3 + '' + idTempo + '' + Olitemp + '' + ProductTemp + '' + ClieAcountID + '' + Cliente + '' + ClienteOwner);
			totalGarantiasNoFormalizadas = [SELECT COUNT_DISTINCT(Id) total FROM fprd__GBL_Guarantee__c WHERE fprd__GBL_Opportunity_product__c =:Opp.Id AND guarantee_status_type__c = '02'];
			numGnF = Integer.valueOf(totalGarantiasNoFormalizadas[0].get('total'));
			title = 'PDF Formalización ' + Opportunity.Name;

		} catch(System.Exception e) {
			system.debug('Exception : ' + e.getMessage());
		}
		return 'SUCCESS';
	}
}