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
    @AuraEnabled public Static List<String> getObtieneValores(String sConcepto, String sFiltro, String sFiltroRango,String sNombreReporte,String sId){    
        List<String> valores = new List<String>();
        List<AggregateResult> registrosReporte = new List<AggregateResult>();
        integer mes=1;
        if(sNombreReporte.equals('EVOLUCION_CUOTA_SBS')){
 			if(sFiltro=='Total')
 			{ 				
 				registrosReporte = [SELECT sum(debt_quote_amount__c),entity_name__c,calendar_month(year_month_day_date__c)
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and CALENDAR_YEAR(year_month_day_date__c) =:Integer.valueOf(sFiltroRango)//:Integer.valueOf(sFiltroRango)
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)  
	                                                                order by calendar_month(year_month_day_date__c) ];	           
        	}
        	else if(sFiltro=='Indirecta' || sFiltro=='Directa')
 			{
        		registrosReporte = [SELECT entity_name__c,calendar_month(year_month_day_date__c)
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and CALENDAR_YEAR(year_month_day_date__c) =:Integer.valueOf(sFiltroRango) and product_group_classification_id__c=:sFiltro
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_month(year_month_day_date__c) ];
 			}
 			else if(sFiltro=='Otros indirectas')
 			{
        		registrosReporte = [SELECT sum(debt_quote_amount__c),entity_name__c,calendar_month(year_month_day_date__c)
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and CALENDAR_YEAR(year_month_day_date__c) =:Integer.valueOf(sFiltroRango) and product_group_classification_id__c='Indirecta' and product_desc__c='Otros'
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_month(year_month_day_date__c) ];
 			}
 			else if(sFiltro=='Otros directas')
 			{
        		registrosReporte = [SELECT sum(debt_quote_amount__c),entity_name__c,calendar_month(year_month_day_date__c)
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and CALENDAR_YEAR(year_month_day_date__c) =:Integer.valueOf(sFiltroRango) and product_group_classification_id__c='Directa' and product_desc__c='Otros'
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_month(year_month_day_date__c) ];
 			}
 			
 			else
        	{

        		registrosReporte = [SELECT sum(debt_quote_amount__c),entity_name__c,calendar_month(year_month_day_date__c)
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and CALENDAR_YEAR(year_month_day_date__c) =:Integer.valueOf(sFiltroRango) and product_desc__c=:sFiltro
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_month(year_month_day_date__c) ];
        	}

        	for(AggregateResult tab: registrosReporte){

	            if(String.isEmpty(String.valueOf(tab.get('expr0')))) valores.add('0');
	            else
	            {
	            	if(tab.get('expr1')!=mes){for(Integer i=mes; i<Integer.valueOf(tab.get('expr1'));i++){valores.add('0'); mes++;
	            		}
	            	}

	            	if(tab.get('expr1')==mes)	            		
	            	{
	            		valores.add(String.valueOf(tab.get('expr0')));
	            		if(mes<=12)
	            			mes++;
	            	}

	            }
	        }

        }
        return valores;
    }

    @AuraEnabled public Static List<String> getAgrupadores( String sNombreReporte){
        List<String> agrupadores= new List<String>();         
        if(sNombreReporte.equals('EVOLUCION_CUOTA_SBS')){
            agrupadores.add('Ene');
            agrupadores.add('Feb');
        	agrupadores.add('Mar');
        	agrupadores.add('Apr');
        	agrupadores.add('May');
        	agrupadores.add('Jun');
        	agrupadores.add('Jul');
        	agrupadores.add('Ago');
        	agrupadores.add('Sep');
        	agrupadores.add('Oct');
        	agrupadores.add('Nov');
        	agrupadores.add('Dic');
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
           		conjunto.add(new List<String>(getObtieneValores(concepto.get(i),sFiltro,sFiltroRango,sNombreReporte,sId)));
            }
        }
        return conjunto;

    }
}