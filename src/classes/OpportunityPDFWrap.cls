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
    public static Integer totalC {get;set;}
    public static String title{get;set;}
    public static opportunity opp{get;set;}
    public static string Modalidad{get;set;}
    public static map<String,String>checkDoc{get;set;}
    private static list<Attachment> docs{get;set;}

    private static String getQuery(String Objeto){
        String SOQLQuery;
       SObjectType objType = Schema.getGlobalDescribe().get(Objeto);
       Map<String,Schema.SObjectField> Mfields = objType.getDescribe().fields.getMap();
       SOQLQuery = 'SELECT ';
        for(Schema.SObjectField mf : Mfields.values()){
          schema.describefieldresult dfield = mf.getDescribe();
            system.debug(String.valueOf(dfield.getType()));
            if(String.valueOf(dfield.getType())=='PICKLIST'){
                SOQLQuery += 'toLabel('+dfield.getname() +'), ';
                    } else{
                        SOQLQuery += dfield.getname() +', ';
                    }
        }
    SOQLQuery =SOQLQuery.substring(0, SOQLQuery.length() - 2);
    SOQLQuery+=' FROM '+Objeto;
    return SOQLQuery;
    }



    public static string setValues(String Oppid){
        string msg;
        checkDoc = new map<string,string>();
        checkDoc.put('Instrucción de transferencia', 'No');
        checkDoc.put('Sustento de operación Comex: Copia Bill of lading ', 'No');
        checkDoc.put('Sustento de operación Comex: Facturas o Letras', 'No');
        checkDoc.put('Pagaré', 'No');
        checkDoc.put('Facturas', 'No');
        checkDoc.put('Tasa', 'No');
        checkDoc.put('Otros documento', 'No');

        try{
            msg= 'Datos incompletos en oportunidad';
            opp = database.query(getQuery('Opportunity')+' WHERE id =\''+Oppid+'\' LIMIT 1');
            Modalidad =opp.Risk_modality_type__c;
            msg= 'Datos incompletos en producto oportunidad';
            OLI = database.query(getQuery('OpportunityLineItem')+' WHERE  OpportunityID =\''+Oppid +'\'ORDER BY CreatedDate DESC LIMIT 1');
            msg= 'Datos incompletos en producto';
            Product = database.query(getQuery('Product2')+' WHERE  Id =\''+OLI.Product2Id +'\' LIMIT 1');
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
            Intervenientes = database.query(getQuery('fprd__GBL_Intervener__c')+' WHERE  Opportunity__c =\''+OppId+'\'');
            msg= 'Datos incompletos en garantias';
            Garantias = database.query(getQuery('fprd__GBL_Guarantee__c')+' WHERE  Opportunity__c =\''+Oppid+'\'');
            totalComprimisos = [SELECT COUNT_DISTINCT(Id) total FROM compromiso__c WHERE Oportunidad__c =:Oppid];
            totalC=Integer.valueOf(totalComprimisos[0].get('total'));
            docs = [SELECT ID,Name FROM attachment WHERE ParentId =:Oppid];
            for(attachment d : docs){
                if(d.name =='Instrucción de transferencia'){
                    checkDoc.put('Instrucción de transferencia', 'Sí');
                }
                if(d.name =='Sustento de operación Comex: Copia Bill of lading'){
                    checkDoc.put('Sustento de operación Comex: Copia Bill of lading', 'Sí');
                }
                if(d.name =='Sustento de operación Comex: Facturas o Letras'){
                    checkDoc.put('Sustento de operación Comex: Facturas o Letras', 'Sí');
                }
                if(d.name =='Pagaré'){
                    checkDoc.put('Pagaré', 'Sí');
                }
                if(d.name =='Facturas'){
                    checkDoc.put('Facturas', 'Sí');
                }
                if(d.name =='Tasa'){
                    checkDoc.put('Tasa', 'Sí');
                }
                if(d.name !='Facturas' && d.name !='Tasa' && d.name !='Facturas' && d.name !='Pagaré' && d.name !='Sustento de operación Comex: Facturas o Letras' && d.name !='Sustento de operación Comex: Copia Bill of lading' && d.name !='Instrucción de transferencia'){
                    checkDoc.put('Otros documento', 'Sí');
                }
            }
            msg= 'SUCCESS';

            title = 'PDF Formalización '+Opportunity.Name;
        }catch(System.Exception e){
            system.debug('Exception : '+e.getMessage());
            return msg;
        }

        return msg;
    }


}
