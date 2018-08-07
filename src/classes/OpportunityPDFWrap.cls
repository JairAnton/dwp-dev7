public  virtual class OpportunityPDFWrap {

    public static OpportunityLineItem OLI {get;set;}
    Public Static Account_BBVA_Classification__c ABBVAC {get;set;}
    Public static Account_Banking_System_Classification__c  CSBS {get;set;}
    Public static Product2 Product {get;set;}
    Public static Account Client {get;set;}
    Public static Contact Contacto {get;set;}
    Public static User_Branch__c usuarioOficina {get;set;}
    Public static Branch__c Oficina {get;set;}
    Public static Account_Rating__c  Rating {get;set;}
    Public static list<fprd__GBL_Intervener__c > Intervenientes {get;set;}
    Public static list<fprd__GBL_Guarantee__c> Garantias {get;set;}
    public static AggregateResult[] totalComprimisos{get;set;}
    public static AggregateResult[] totalGarantiasNoFormalizadas{get;set;}
    public static fprd__GBL_Product_Configuration__c[] ProductConfiguration{get;set;}
    public static Integer totalC {get;set;}
    public static Integer numGnF {get;set;}
    public static String title{get;set;}
    public static opportunity opp{get;set;}
    public static map<id,boolean> fieldVisibility{get;set;}
    private static list<dwp_cvad__Action_Audit__c> Audit {get;set;}
    public static String FechaAut{get;set;}
    private static String getQuery(String Objeto){
        String SOQLQuery;
        SObjectType objType = Schema.getGlobalDescribe().get(Objeto);
        Map<String,Schema.SObjectField> Mfields = objType.getDescribe().fields.getMap();
        SOQLQuery = 'SELECT ';
        for(Schema.SObjectField mf : Mfields.values()){
            schema.describefieldresult dfield = mf.getDescribe();
                        SOQLQuery += dfield.getname() +', ';
        }
        SOQLQuery =SOQLQuery.substring(0, SOQLQuery.length() - 2);
        SOQLQuery+=' FROM '+Objeto;
        return SOQLQuery;
    }


    private static void  filterVisibility(list<fprd__GBL_Product_Configuration__c> PrdConfg){
        fieldVisibility = new map<id,boolean>();
       list<fprd__GBL_Product_Configuration__c> PrdConfg2;
        String fieldName;
        String SOQLQuery;
        SObjectType objType = Schema.getGlobalDescribe().get('fprd__GBL_Product_Configuration__c');
        Map<String,Schema.SObjectField> Mfields = objType.getDescribe().fields.getMap();
        SOQLQuery = 'SELECT ';
        for(Schema.SObjectField mf : Mfields.values()){
            schema.describefieldresult dfield = mf.getDescribe();
                       if(String.valueOf(dfield.getType())=='PICKLIST'){
                SOQLQuery += 'toLabel('+dfield.getname() +'), ';
                    } else{
                        SOQLQuery += dfield.getname() +', ';
                    }
        }
        SOQLQuery =SOQLQuery.substring(0, SOQLQuery.length() - 2);
        SOQLQuery+=' FROM fprd__GBL_Product_Configuration__c WHERE FPRD__PRODUCT__R.UNIQUE_ID__C =\''+Product.ProductCode+'\' AND FPRD__SECTION_NAME__C =\''+label.PDFSectionPayment+'\'';
        PrdConfg2 = Database.query(SOQLQuery);
       system.debug('SSS'+Product.ProductCode+'s'+label.PDFSectionPayment);
        for(fprd__GBL_Product_Configuration__c pc : PrdConfg2){
            boolean Found = false;
            If(String.isNotBlank(pc.FPRD__VISIBILITY_CONTROL_FIELD__C)){
                fieldName = pc.FPRD__VISIBILITY_CONTROL_FIELD__C;
                fieldName = fieldName.LEFT(fieldName.length()-Product.ProductCode.length())+'_c';


                for(String val : pc.FPRD__VISIBILITY_CONTROL_VALUE__C.split(',')){
                    if(val==OLI.get(fieldName)) Found = true;
                }

                if(Found){
                    fieldVisibility.put(pc.Id, true);
                }else{
                    fieldVisibility.put(pc.Id, false);}
            }else{
                fieldVisibility.put(pc.Id, true);
            }
        }
       for (integer index=0; index<ProductConfiguration.size();index++) {
           if(!fieldVisibility.get(ProductConfiguration[index].Id)){
               ProductConfiguration.remove(index);
           }
        }
    }
    public static string setValues(String Oppid){
        string msg;
        try{
            Audit = database.query(getQuery('dwp_cvad__Action_Audit__c')+' WHERE id =\''+Oppid+'\' AND (dwp_cvad__action_audit_name__c=\''+Label.SIOstatus3+'\' OR dwp_cvad__action_audit_name__c=\''+Label.SIOstatus2+'\' OR dwp_cvad__action_audit_name__c=\''+Label.SIOstatus1+'\' )ORDER BY CreatedDate DESC');

            if(Audit.size()>0){FechaAut = String.valueOf(Date.valueOf(Audit[0].dwp_cvad__action_audit_date__c));}else{FechaAut=Label.lblNoAuthDate;}
            msg= 'Datos incompletos en oportunidad';
            opp = database.query(getQuery('Opportunity')+' WHERE id =\''+Oppid+'\' LIMIT 1');
            msg= 'Datos incompletos en producto oportunidad';
            OLI = database.query(getQuery('OpportunityLineItem')+' WHERE  OpportunityID =\''+Oppid +'\' ORDER BY CreatedDate DESC LIMIT 1');
            msg= 'Datos incompletos en producto';
            Product = database.query(getQuery('Product2')+' WHERE  Id =\''+OLI.Product2Id +'\' LIMIT 1');
            ProductConfiguration = database.query(getQuery('fprd__GBL_Product_Configuration__c')+' WHERE FPRD__PRODUCT__R.UNIQUE_ID__C =\''+Product.ProductCode+'\' AND FPRD__SECTION_NAME__C =\''+label.PDFSectionPayment+'\'');
            filterVisibility(ProductConfiguration);
            msg= 'Datos incompletos en cliente';
            Client =database.query(getQuery('Account')+' WHERE  Id =\''+opp.Accountid +'\' LIMIT 1');
            msg= 'Datos incompletos en clasificación BBVA-Cliente';
            ABBVAC = database.query(getQuery('Account_BBVA_Classification__c')+' WHERE  account_id__c =\''+Client.ID +'\' LIMIT 1');
            msg= 'Datos incompletos en SBS';
            CSBS= database.query(getQuery('Account_Banking_System_Classification__c')+' WHERE  account_id__c =\''+Client.ID +'\' LIMIT 1');
            msg= 'Datos incompletos en contacto';
            Contacto = database.query(getQuery('Contact')+' WHERE  AccountId =\''+Client.ID +'\' LIMIT 1');
            msg= 'Datos incompletos en usuario oficina';
            usuarioOficina = database.query(getQuery('User_Branch__c')+' WHERE  User__c =\''+opp.ownerId +'\' LIMIT 1');
            msg= 'Datos incompletos en Oficina';
            oficina =  database.query(getQuery('Branch__c')+' WHERE  id =\''+usuarioOficina.branch_name__c +'\' LIMIT 1');
            msg= 'Datos incompletos en calificación cliente';
            Rating =  database.query(getQuery('Account_Rating__c')+' WHERE  account_id__c =\''+Client.Id+'\' ORDER BY createdDate LIMIT 1');
            msg= 'Datos incompletos en intervieniente';
            Intervenientes = database.query(getQuery('fprd__GBL_Intervener__c')+' WHERE  fprd__GBL_Opportunity_product__c =\''+OLI.Id+'\'');
            msg= 'Datos incompletos en garantias';
            Garantias = database.query(getQuery('fprd__GBL_Guarantee__c')+' WHERE  fprd__GBL_Opportunity_product__c =\''+OLI.Id+'\'');
            totalComprimisos = [SELECT COUNT_DISTINCT(Id) total FROM Commitment_Value__c WHERE commitment_product_name__c =:Product.ProductCode];
            totalC=Integer.valueOf(totalComprimisos[0].get('total'));
            totalGarantiasNoFormalizadas = [SELECT COUNT_DISTINCT(Id) total FROM fprd__GBL_Guarantee__c   WHERE fprd__GBL_Opportunity_product__c=:OLI.Id AND Status__c='02'];
            numGnF=Integer.valueOf(totalGarantiasNoFormalizadas[0].get('total'));

            msg= 'SUCCESS';
            title = 'PDF Formalización '+Opportunity.Name;
        }catch(System.Exception e){
            system.debug('Exception : '+e.getMessage());
            return msg;
        }

        return msg;
    }


}
