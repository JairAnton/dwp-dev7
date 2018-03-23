/**
*Developed by:       	Indra
*Autor:                 Isaías Velázquez
*Project:               DWP Sales
*Description:           Class to handle GraphicsGenerator_comp Component.
*
*Changes (Version)       
*No.        CreationDate            Autor                      Description
*-------------------------------------------------------------------------------
*------   ----------------   --------------------   ----------------------------
*1.0       	16-03-2018        Isaías Velázquez                   Creation
**/
public class GraphicsGenerator_cls {
	
    @AuraEnabled public Static List<String> getValores(String sConcepto, String sFiltro, String sFiltroRango,String sNombreReporte,String sId){    
    	
        List<String> valores = new List<String>();
        List<String> agrupadores = new List<String>();        
        List<AggregateResult> registrosReporte = new List<AggregateResult>();
        Date fInicial=Date.today().toStartofMonth().addMonths(-11);
        Date fActual=Date.today().toStartofMonth().addMonths(1);
        
        Integer mes=0;
        if(sNombreReporte.equals('EVOLUCION_CUOTA_SBS')){

 			if(sFiltro=='Total')
 			{ 				
 				registrosReporte = [SELECT sum(debt_quote_amount__c),calendar_month(year_month_day_date__c),entity_name__c
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and   (year_month_day_date__c > :fInicial and year_month_day_date__c<=:fActual)
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)  
	                                                                order by calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c) ];
        	}
        	else if(sFiltro=='Indirecta' || sFiltro=='Directa')
 			{
        		registrosReporte = [SELECT sum(debt_quote_amount__c),calendar_month(year_month_day_date__c),entity_name__c
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and (year_month_day_date__c > :fInicial and year_month_day_date__c<:fActual) and product_group_classification_id__c=:sFiltro
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c) ];
 			}
 			else if(sFiltro=='Otros indirectas')
 			{
        		registrosReporte = [SELECT sum(debt_quote_amount__c),calendar_month(year_month_day_date__c),entity_name__c
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and (year_month_day_date__c > :fInicial and year_month_day_date__c<:fActual) and product_group_classification_id__c='Indirecta' and product_desc__c='Otros'
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c) ];
 			}
 			else if(sFiltro=='Otros directas')
 			{
        		registrosReporte = [SELECT sum(debt_quote_amount__c),calendar_month(year_month_day_date__c),entity_name__c
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and (year_month_day_date__c > :fInicial and year_month_day_date__c<:fActual) and product_group_classification_id__c='Directa' and product_desc__c='Otros'
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c) ];
 			}
 			
 			else
        	{

        		registrosReporte = [SELECT sum(debt_quote_amount__c),calendar_month(year_month_day_date__c),entity_name__c
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and (year_month_day_date__c > :fInicial and year_month_day_date__c<:fActual) and product_desc__c=:sFiltro
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c) ];
        	}
        	List<Integer> agrupador = new List<Integer>();
			for(Integer i=0;i<12 ;i++)
        	{
        		agrupador.add(fInicial.addMonths(i).month());	
        	}
        	for(AggregateResult tab: registrosReporte){

	            if(String.isEmpty(String.valueOf(tab.get('expr0')))) valores.add('0');
	            else
	            {
	            	if(tab.get('expr1')!=agrupador.get(mes)){
	            		for(Integer i=mes; i<agrupador.size()-1;i++){
	            			if(tab.get('expr1')==agrupador.get(mes))i =agrupador.size();
	            			else
	            			{
	            				valores.add('0'); 
	            				mes++;
	            			}
	            		}	            		
	            	}

	            	if(tab.get('expr1')==agrupador.get(mes))
	            	{
	            		valores.add(String.valueOf(tab.get('expr0')));	            		
	            		mes++;
	            	}

	            }
	        }
	        if(mes<12)
	        {
	        	for(Integer j=mes; mes<=12;mes++)
	        		valores.add('0');
	        }
	 

        }
        
        return valores;
    }

    @AuraEnabled public Static List<String> getAgrupadores( String sNombreReporte){
        List<String> agrupadores= new List<String>();         
        if(sNombreReporte.equals('EVOLUCION_CUOTA_SBS')){
        	Date fInicial=Date.today().toStartofMonth().addMonths(-11);
        	String [] sMes= new String[]{'Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'};
        	for(Integer i=0;i<12 ;i++)
        	{
        		agrupadores.add(sMes[fInicial.addMonths(i).month()-1]);	
        	}
            
        }
        return agrupadores;
    }

     @AuraEnabled public Static List<String> getConceptos(String sNombreReporte){
        List<String> concepto = new List<String>(); 
        if(sNombreReporte.equals('EVOLUCION_CUOTA_SBS')){
            concepto.add('BBVA');
			concepto.add('BCP');
			concepto.add('SCOTIA');
			concepto.add('IBK');
			concepto.add('OTROS');
        }        
        return concepto;
    }

    @AuraEnabled public Static List<List<String>> getGeneraJSONReporte(String sNombreReporte,String sFiltro,String sFiltroRango,String sId){
        
        List<List<String>> conjunto = new List<List<String>>();
        List<String> agrupador = new List<String>(); 
        List<String> indicadores = new List<String>(); 
        List<String> concepto = new List<String>(); 
        List<String> val1 = new List<String>(); 

        
        if(sNombreReporte.equals('EVOLUCION_CUOTA_SBS')){
   			agrupador = getAgrupadores(sNombreReporte);
            concepto = getConceptos(sNombreReporte);
            conjunto.add(concepto);
			conjunto.add(agrupador);        	
            for(Integer i=0; i< concepto.size(); i++)
            {            

           		conjunto.add(new List<String>(getValores(concepto.get(i),sFiltro,sFiltroRango,sNombreReporte,sId)));
            }
        }
        return conjunto;

    }
}