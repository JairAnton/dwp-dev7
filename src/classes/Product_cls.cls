/*-------------------------------------------------------------------------
* Name: Product_cls
* Description : Class to insert a record from Account
* Created date : May 15 2018
* Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/

public without sharing class Product_cls {
	/*Description
	Comments to describe the functionality of this method
	*/
	@AuraEnabled public static List<OpportunityLineItem> getIdProductByOpportunity(String IdOpportunity){
		List<OpportunityLineItem> row= [SELECT  PE_POR_Comision_liquidacion_anticipada__c,PE_POR_ID_COTIZA__c,Product2Id,gipr_Tipo_Garantia__c,gipr_Garantia__c,Product2.Type_of_quote__c,PE_DATE_Fecha_cotizacion__c,Product2.Name,Opportunity.Amount,gipr_Plazo__c,toLabel(gipr_Periodicidad__c),PE_POR_TEA_propuesta__c,PE_POR_Spread__c,PE_POR_Comision__c FROM OpportunityLineItem Where OpportunityId=: IdOpportunity LIMIT 1];
		if(!row.isEmpty())
			return row;
		else
			return null;
	}
	/*Description
	Comments to describe the functionality of this method
	*/
	@AuraEnabled public static Boolean verifyIfHasQuoted(String IdOpportunity){
		List<OpportunityLineItem> rowOpp=getIdProductByOpportunity(IdOpportunity);
		if(!rowOpp.isEmpty())
		{
			if(rowOpp[0].PE_DATE_Fecha_cotizacion__c!=null && String.valueOf(rowOpp[0].PE_DATE_Fecha_cotizacion__c)!='') return true; else return false;
		}else return false;
	}
	/*Description
	Comments to describe the functionality of this method
	*/
	@AuraEnabled public static List<Product_Gurantee__c> getGuaranteeDataByProduct(String IdOpportunity,String IdProduct){	
		List<Product_Gurantee__c> objData= [SELECT Id,GuaranteeType__c,toLabel(Guarantee__c), toLabel(Modality__c), toLabel(Status__c),Term__c, toLabel(Periodicity__c),nGuarantee__c,Amount__c,isMaster__c FROM Product_Gurantee__c Where Product__c=: IdProduct AND Opportunity__c=: IdOpportunity Order by isMaster__c desc];
		return objData;
	}
	/*Description
	Comments to describe the functionality of this method
	*/
	@AuraEnabled public static List<Product_Gurantee__c> getGuaranteeDataByProductValues(String PGuaranteeId){	

		List<Product_Gurantee__c> objData= [SELECT Id,GuaranteeType__c,Guarantee__c, Modality__c, Status__c,Term__c, Periodicity__c,nGuarantee__c,Amount__c,isMaster__c FROM Product_Gurantee__c Where Id=: PGuaranteeId];
		return objData;
	}
	/*Description
	Comments to describe the functionality of this method
	*/
	@AuraEnabled public static List<Product_Participants__c> getParticipantDataByProduct(String IdOpportunity,String IdProduct){	
		List<Product_Participants__c> objData= [SELECT Id,Name,toLabel(DOI__c), toLabel(Marital_Status__c), toLabel(Participation__c),N_DOI__c,isMaster__c FROM Product_Participants__c Where Product__c=: IdProduct AND Opportunity__c=: IdOpportunity Order by isMaster__c desc];
		return objData;
	}
	/*Description
	Comments to describe the functionality of this method
	*/
	@AuraEnabled public static List<Product_Participants__c> getParticipantDataByProductValues(String PParticipantId){	
		List<Product_Participants__c> objData= [SELECT Id,Name,DOI__c, Marital_Status__c, Participation__c,N_DOI__c,isMaster__c FROM Product_Participants__c Where  Id=: PParticipantId];
		return objData;
	}
	/*Description
	Comments to describe the functionality of this method
	*/         
	@AuraEnabled public static List<compromiso__c> getCompromisoDataByProduct(String IdOpportunity){	
		List<compromiso__c> objData= [SELECT Product_relate__c,PE_DIVISA_Importe__c,PE_NUM_Plazo_Vcto__c,PE_FOR_Fecha_Vcto__c,PE_NUM_Permanencia__c,CurrencyIsoCode FROM compromiso__c Where  Oportunidad__c=:IdOpportunity];
		return objData;
	}

	@AuraEnabled public static List<OpportunityLineItem> getOpportunityLineItemDataByProduct(String IdOpportunity,String IdProduct){	
		List<OpportunityLineItem> objData= [SELECT Product2.Name,Opportunity.Amount,gipr_Plazo__c,toLabel(gipr_Periodicidad__c),PE_POR_TEA_propuesta__c,PE_POR_Spread__c,PE_POR_Comision__c FROM OpportunityLineItem Where OpportunityId=:IdOpportunity and Product2Id=:IdProduct];
		return objData;
	}

	@AuraEnabled public static String getOportunidadSytem(String Filtro) {       
        return Object_Controller.getOportunidadSytem(Filtro);       
    }
    
    @AuraEnabled public static Boolean deleteGuaranteeDataByProduct(String IdProductGuarantee){
        Product_Gurantee__c objData= [SELECT Id FROM Product_Gurantee__c Where Id=: IdProductGuarantee];
        delete objDAta;
        return true;
    }
    
    @AuraEnabled public static Boolean deleteParticipantDataByProduct(String IdProductParticipant){
        Product_Participants__c objData= [SELECT Id FROM Product_Participants__c Where Id=: IdProductParticipant];
        delete objDAta;
        return true;
    }
    
    @AuraEnabled public static Boolean saveGuaranteeDataByProduct(String PGuaranteeId,String IdOpportunity,String IdProuduct,String GuaranteeType,String Guarantee,String Modality,Decimal Amount,String Status,Integer Term,String Periodicity,Integer nGuarantee){
        Product_Gurantee__c row;
        if(PGuaranteeId!=null)		
            row = [SELECT Id,GuaranteeType__c,Guarantee__c, Modality__c, Status__c,Term__c, Periodicity__c,nGuarantee__c,Amount__c FROM Product_Gurantee__c Where Id=: PGuaranteeId];
        else row = new Product_Gurantee__c();
        
        row.Opportunity__c=IdOpportunity;
        row.Product__c=IdProuduct;
        row.GuaranteeType__c=GuaranteeType;
        row.Guarantee__c=Guarantee;
        row.nGuarantee__c=nGuarantee;
        row.Modality__c=Modality;
        row.Amount__c=Amount;
        row.Status__c=Status;
        row.Term__c=integer.valueOf(Term);
        row.Periodicity__c=Periodicity;
        row.Term__c=Term;
        if(PGuaranteeId!=null) update row; else insert row;	
        return true;
    }
    
    
    @AuraEnabled public static Boolean saveParticipantDataByProduct(String PParticipantId,String IdOpportunity,String IdProuduct,String Name,String DOI,String N_DOI,String Participation,String Marital_Status){
        Product_Participants__c row;
        if(PParticipantId!=null)		
            row = [SELECT Id,Name,DOI__c, Marital_Status__c, Participation__c,N_DOI__c FROM Product_Participants__c Where Id=:PParticipantId ];
        else row = new Product_Participants__c();
        row.Opportunity__c=IdOpportunity;
        row.Product__c=IdProuduct;
        row.Name=Name;
        row.DOI__c=DOI;
        row.N_DOI__c=N_DOI;
        row.Participation__c=Participation;		
        row.Marital_Status__c=Marital_Status;		
        if(PParticipantId!=null) update row; else insert row;	
        return true;
    }
    
    @AuraEnabled public static String setSanctionPrice(String OpportunityId,String sanAction,String Comments){
        try
        {
            List<Opportunity> itemOpp= [SELECT Id,opportunity_status_type__c FROM Opportunity WHERE Id=: OpportunityId];
            if(!itemOpp.isEmpty())
            {
                List<OpportunityLineItem> itemOppProduct= getIdProductByOpportunity(itemOpp[0].Id);
                if(sanAction=='btnApprove'){//08
                    itemOpp[0].StageName='04';
                    itemOpp[0].opportunity_status_type__c='08';
                }
                else if(sanAction=='btnRaise'){//09
                    itemOpp[0].StageName='04';
                    if(itemOppProduct[0].Product2.Type_of_quote__c =='COTIZA Beta'){
                        itemOpp[0].opportunity_status_type__c='10';
                    }
                    else{
                        itemOpp[0].opportunity_status_type__c='09';
                    }    
                }
                update itemOpp[0];
                //BEGIN Traceability - 2018-06-11
                //Isaías Vellázquez Cortés
                if(sanAction=='btnApprove')	new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),TraceabilityMessage(itemOpp[0].Id,itemOpp[0].opportunity_status_type__c,Comments,''),'Opportunity',itemOpp[0].Id,'approve','TRSP00001',UserInfo.getUserId(),'embedded',1,true);			    
                else if(sanAction=='btnRaise')	new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),TraceabilityMessage(itemOpp[0].Id,itemOpp[0].opportunity_status_type__c,Comments,''),'Opportunity',itemOpp[0].Id,'elevate','TRSP00001',UserInfo.getUserId(),'embedded',1,true);		   	
                //END Traceability
                return 'true';
            }
            else
            {
                return 'Error';
            }
            
        }
        catch(Dmlexception exp)
        {
            return exp.getMessage();
        }
        
    }
    
    @AuraEnabled public static String setFormalization(String OpportunityId,String Action,String Body,String AttachedFiles){
        try
        {
            List<Opportunity> itemOpp= [SELECT Id,opportunity_status_type__c,StageName,OwnerId FROM Opportunity WHERE Id=: OpportunityId];
            if(!itemOpp.isEmpty())
            {
                if(Action=='btnApprove'){
                    id id1 = userinfo.getProfileId();
                    String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;
                    
                    if((prof=='Ejecutivo'&& userinfo.getUserId()==itemOpp[0].OwnerId) || prof=='Administrador del Sistema' || prof=='Migracion'){                                    
                        itemOpp[0].IsProcess__c=true;
                        update itemOpp[0];   
                        itemOpp[0].StageName=label.lblFormalizarEtapa;
                        itemOpp[0].opportunity_status_type__c=label.lblFormalizarStatus;          
                        FeedItem post = new FeedItem();
                        post.ParentId = OpportunityId;
                        post.Body = body;
                        if(!string.isBlank(Body))
                            insert post;
                        else{
                            itemOpp[0].IsProcess__c=false;
                            update itemOpp[0];     
                            return label.lblNoCommentsFormalization;
                        } 
                    }
                }
                update itemOpp[0];
                itemOpp[0].IsProcess__c=false;
                update itemOpp[0]; 
                update itemOpp[0];
                //BEGIN Traceability - 2018-06-11
                //Isaías Vellázquez Cortés
                new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),TraceabilityMessage(itemOpp[0].Id,itemOpp[0].opportunity_status_type__c,Body,AttachedFiles),'Opportunity',itemOpp[0].Id,'approve','TRFO00001',UserInfo.getUserId(),'embedded',1,true);
                //END Traceability
                return 'true';
            }
            else return 'Error';
        }
        catch(Dmlexception exp)
        {
            return exp.getMessage();
        }
    }
    
    @AuraEnabled public static String setLastFormalization(String OpportunityId,String Action,String Body,String ContractNumber){
        id id1 = userinfo.getProfileId();
        id id2 = userinfo.getUserId();
        String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;
        String OUCurrentUser = [SELECT organizational_unit_id__c FROM User WHERE id = :id2 LIMIT 1].organizational_unit_id__c;
        if(prof=='Operativo'|| prof=='Administrador del Sistema' )
        { 
            if(Pattern.matches('[0-9]{4}-[0-9]{4}-[0-9]{10}', ContractNumber) || String.isEmpty(ContractNumber) )
            {
                
                List<Opportunity> itemOpp= [SELECT Id,opportunity_status_type__c,Name,OwnerId FROM Opportunity WHERE Id=: OpportunityId];
                
                
                if(!itemOpp.isEmpty())
                {
                    String OUOppUser = [SELECT organizational_unit_id__c FROM User WHERE id = :itemOpp[0].OwnerId LIMIT 1].organizational_unit_id__c;
                    
                    if(OUCurrentUser!=OUOppUser)
                        return 'Usuario no autorizado.';
                    
                    
                    if(Action=='btnApprove'){//08
                        itemOpp[0].StageName='06';
                        itemOpp[0].opportunity_status_type__c='35';
                    }
                    else if(Action=='btnRaise'){//09
                        itemOpp[0].StageName='05';
                        itemOpp[0].opportunity_status_type__c='34';
                        
                    }
                    else if(Action=='btnBack'){//09
                        itemOpp[0].StageName='05';
                        itemOpp[0].opportunity_status_type__c='33';
                    }
                    itemOpp[0].IsProcess__c=true;
                    update itemOpp[0];
                    itemOpp[0].frm_ContractNumber__c=ContractNumber;
                    update itemOpp[0];
                    itemOpp[0].IsProcess__c=false;
                    update itemOpp[0]; 
                    //BEGIN Traceability - 2018-06-11
                    //Isaías Vellázquez Cortés				
                    if(Action=='btnApprove')	new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),'<b>Número de contrato:</b> '+ContractNumber +'<br/>'+'<b>Comentarios:</b> '+Body,'Opportunity',itemOpp[0].Id,'approve','TRFO00001',UserInfo.getUserId(),'embedded',1,true);
                    else if(Action=='btnRaise')	new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),'<b>Comentarios:</b> '+Body,'Opportunity',itemOpp[0].Id,'elevate','TRFO00001',UserInfo.getUserId(),'embedded',1,true);
                    else if(Action=='btnBack')	new OpportunityTraceability_cls().addOpportunityTraceability(getStatusLabel(itemOpp[0].opportunity_status_type__c),'<b>Comentarios:</b> '+Body,'Opportunity',itemOpp[0].Id,'sendBack','TRFO00001',UserInfo.getUserId(),'embedded',1,true);
                    //END Traceability
                    return 'true';
                }
                return 'Error'; 
                //success
            }
            else
                return 'No Contrato no válido, el formato correcto: 0000-0000-000000000';
        }
        else
            return 'Usuario no autorizado.';
    }
    
    
    @InvocableMethod(label='Delete Master Guarantee' description='Delete the row from Product_Guarantee')
    public static void deleteMasterGuarantee(List<OpportunityLineItem> listRow)
    {
        List<Product_Gurantee__c> row =[SELECT Id FROM Product_Gurantee__c WHERE Product__c=: listRow[0].Product2Id and Opportunity__c=: listRow[0].OpportunityId and  isMaster__c=true LIMIT 1];
        
        if(!row.isEmpty())delete row;
    }
    
    public static string TraceabilityMessage (String OpportunityId,String OppStatus,String Body,String AttachedFiles)
    {
        List<Opportunity> itemOpp= [SELECT Id,opportunity_status_type__c FROM Opportunity WHERE Id=: OpportunityId];
        List<OpportunityLineItem> itemOppProduct= getIdProductByOpportunity(itemOpp[0].Id);
        String HTMLComments='';
        if(OppStatus!='32')
        {
            HTMLComments = '<b>Producto:</b> ' + itemOppProduct[0].Product2.Name + '<br/>' +
                '<b>Importe:</b> '+ String.valueOf(itemOppProduct[0].Opportunity.Amount) +'<br/>' +
                '<b>Plazo:</b> '+itemOppProduct[0].gipr_Plazo__c +' '+ itemOppProduct[0].gipr_Periodicidad__c +'<br/>';  /// EN CASO DE QUE APLIQUE
            if(itemOppProduct[0].Product2.Type_of_quote__c=='COTIZADOR')
            {
                HTMLComments=HTMLComments+'<b>TEA propuesta (%):</b> '+String.valueOf(itemOppProduct[0].PE_POR_TEA_propuesta__c)+ '% <br/>' +
                    '<b>Comisión estructuración:</b> '+String.valueOf(itemOppProduct[0].PE_POR_Comision__c)+'% <br/>'+
                    '<b>Comisión Liquidacion Anticipada(%):</b> '+String.valueOf(itemOppProduct[0].PE_POR_Comision_liquidacion_anticipada__c)+'% <br/>';
                
                
            }else if(itemOppProduct[0].Product2.Type_of_quote__c=='Web')
            {
                HTMLComments=HTMLComments+'<b>TEA propuesta (%):</b> '+String.valueOf(itemOppProduct[0].PE_POR_TEA_propuesta__c)+ '% <br/>';
            }
            else if(itemOppProduct[0].Product2.Type_of_quote__c=='Tarifario')
            {
                HTMLComments=HTMLComments+'<b>Comisión Propuesta:</b> '+String.valueOf(itemOppProduct[0].PE_POR_Comision__c)+'% <br/>';
                
            }
            else if(itemOppProduct[0].Product2.Type_of_quote__c=='COTIZA Beta')
            {
                HTMLComments=HTMLComments+'<b>TEA Propuesta (%):</b> '+String.valueOf(itemOppProduct[0].PE_POR_TEA_propuesta__c)+'% <br/>'
                    +'<b>ID COTIZA:</b> '+String.valueOf(itemOppProduct[0].PE_POR_ID_COTIZA__c)+' <br/>';
                
            }
            HTMLComments =HTMLComments+'<b>Comentarios:</b> ' +Body;
        }
        else
        {			
            HTMLComments = '<b>Producto:</b> ' + itemOppProduct[0].Product2.Name + '<br/>' +
                '<b>Importe:</b> '+ String.valueOf(itemOppProduct[0].Opportunity.Amount) +'<br/>' +
                '<b>Comentarios:</b> ' +Body+ '<br/><br/>'+
                '<b>Archivos adjuntos:</b> <br/>' +AttachedFiles;
            
        }
        return HTMLComments;
    }
    
    public static string getStatusLabel (String OppStatus)
    {
        list<Schema.PicklistEntry> PicklistEntries = Opportunity.opportunity_status_type__c.getDescribe().getPicklistValues();
        map<String,String> ApiToLabel = new map<String,String>();
        for (Schema.PicklistEntry pe : PicklistEntries){
            ApiToLabel.put(pe.getValue(),pe.getLabel());
        }
        return ApiToLabel.get(OppStatus);
    }
    
    /**
        Get BBVA Information Grouped Table
        Object: Account_BBVA_Information__c
    */
    @AuraEnabled public static List<WRP_Table> getAccountBBVAInformation (String AccountId)
    {
        list<AggregateResult> listInfoBBVA = [select account_id__r.Name,product_group_classification_id__c, type__c,SUM(account_id__r.bank_turnover_volume_amount__c)exp1,SUM(average_balance_amount__c)exp2 from Account_BBVA_Information__c where account_id__r.ParentId=:AccountId and (type__c = '01' OR type__c = '02') AND product_group_classification_id__c != '' AND year_month_day_date__c = LAST_MONTH group by account_id__r.Name,product_group_classification_id__c, type__c];
        
        map<String, WRP_Table> mapResult = new map<String, WRP_Table>();
        integer i=0;
        Double dd;
        Double di;
        Double r;
        String aux='';
        for (AggregateResult ar : listInfoBBVA)  {
            dd=0;di=0;r=0;
                for (AggregateResult ar2 : listInfoBBVA)  {
                
                    if((String)ar2.get('Name')==(String)ar.get('Name'))
                        if((String)ar2.get('product_group_classification_id__c')==label.LblDirectDebt && (String)ar2.get('type__c')=='01')
                            dd=(Double)ar2.get('exp2');
                            else if((String)ar2.get('product_group_classification_id__c')==label.LblIndirectDebt && (String)ar2.get('type__c')=='01')
                                di=(Double)ar2.get('exp2');
                                else if((String)ar2.get('product_group_classification_id__c')==label.LblResources && (String)ar2.get('type__c')=='02')
                                    r=(Double)ar2.get('exp2');
                }
                    
            
            if((string)ar.get('Name')!=aux)
            {
                mapResult.put(String.valueOf(i), new WRP_Table((string)ar.get('Name'),(Double)ar.get('exp1'),dd,di,r));
                aux=(string)ar.get('Name');
                i++;
            }
        }

        return mapResult.values();
    }
    /**
        Creation of WRAPER Classs to the Position Grouped Table 
        Object: Account_BBVA_Information__c
    */
    public class WRP_Table{
        @AuraEnabled public String Acc {get; set;}
        @AuraEnabled public Double BusinessVolume  {get; set;}
        @AuraEnabled public Double DirectDebt  {get; set;}
        @AuraEnabled public Double IndirectDebt  {get; set;}
        @AuraEnabled public Double Resources   {get; set;}
        public WRP_Table(String toAcc, Double toBusinessVolume,Double toDirectDebt,Double toIndirectDebt,Double toResources){
            this.Acc = toAcc;
            this.BusinessVolume = toBusinessVolume;
            this.DirectDebt = toDirectDebt;
            this.IndirectDebt = toIndirectDebt;
            this.Resources = toResources;
        }
    }
       
}