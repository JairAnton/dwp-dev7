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
        Date fInicial;
        Date fActual;
        
        Integer mes=0;
        if(sNombreReporte.equals('EVOLUCION_CUOTA_SBS') || sNombreReporte.equals('EVOLUCION_DEUDA_SBS')){
            list<AggregateResult> lasDateD = [SELECT MAX(year_month_day_date__c)dateP FROM Account_Banking_System_Debt__c ];
            System.debug(lasDateD[0].get('dateP'));
            if(!lasDateD.isEmpty() && lasDateD[0].get('dateP')!=null)
            {
                fInicial=((Date)lasDateD[0].get('dateP')).toStartofMonth().addMonths(-12);
                fActual=((Date)lasDateD[0].get('dateP')).toStartofMonth().addMonths(0);

 			if(sFiltro=='Total')
 			{ 				
 				registrosReporte = [SELECT sum(debt_quote_amount__c),calendar_month(year_month_day_date__c),entity_name__c,sum(debt_current_balance_amount__c) 
	                                                                FROM Account_Banking_System_Debt__c 
    	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and   (year_month_day_date__c > :fInicial and year_month_day_date__c<=:fActual) and product_group_classification_id__c='Total' and product_desc__c=''
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)  
	                                                                order by calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c) ];
        	}
        	else if(sFiltro=='Indirecta' || sFiltro=='Directa')
 			{
        		              registrosReporte = [SELECT max(debt_quote_amount__c),calendar_month(year_month_day_date__c),entity_name__c,sum(debt_current_balance_amount__c)
	                                                                FROM Account_Banking_System_Debt__c 
    	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and (year_month_day_date__c > :fInicial and year_month_day_date__c<:fActual) and product_group_classification_id__c=:sFiltro AND  product_desc__c =''
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c) ];
 			}
 			else if(sFiltro=='Otros indirectas')
 			{
        		registrosReporte = [SELECT sum(debt_quote_amount__c),calendar_month(year_month_day_date__c),entity_name__c,sum(debt_current_balance_amount__c)
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and (year_month_day_date__c > :fInicial and year_month_day_date__c<:fActual) and product_group_classification_id__c='Indirecta' and product_desc__c='OTROS'
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c) ];
 			}
 			else if(sFiltro=='Otros directas')
 			{
        		registrosReporte = [SELECT sum(debt_quote_amount__c),calendar_month(year_month_day_date__c),entity_name__c,sum(debt_current_balance_amount__c)
	                                                                FROM Account_Banking_System_Debt__c 
	                                                                where account_id__c=:sId and entity_name__c =:sConcepto and (year_month_day_date__c > :fInicial and year_month_day_date__c<:fActual) and product_group_classification_id__c='Directa' and product_desc__c='ACEPTACIONES BANCARIAS'
	                                                                group by entity_name__c, calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c)
	                                                                order by calendar_year(year_month_day_date__c), calendar_month(year_month_day_date__c) ];
 			}
 			
 			else
        	{

        		registrosReporte = [SELECT sum(debt_quote_amount__c),calendar_month(year_month_day_date__c),entity_name__c,sum(debt_current_balance_amount__c)
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
	            		if(sNombreReporte.equals('EVOLUCION_DEUDA_SBS')) valores.add(String.valueOf(tab.get('expr2')));
	            		else valores.add(String.valueOf(tab.get('expr0')));	            		
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
        }

        if(sNombreReporte.equals('VINCULACION') )
        {
            list<AggregateResult>  lasDateData = [SELECT MAX(year_month_day_date__c)dateP FROM Account_Indicator__C where indicator_name__c in ('Estrella','Transaccional','Potencial','Básico') ];
            if(!lasDateData.isEmpty() && lasDateData[0].get('dateP')!=null)
            {
            	fInicial=((Date)lasDateData[0].get('dateP')).toStartofMonth().addMonths(-6);
            	fActual=((Date)lasDateData[0].get('dateP')).toStartofMonth().addMonths(1);
                
    			List<Account_Indicator__C > auxTab = [SELECT indicator_num__c,year_month_day_date__c
    	                                                                FROM Account_Indicator__C 
    	                                                                where account_id__c=:sId  and (year_month_day_date__c > :fInicial and year_month_day_date__c<:fActual) and indicator_name__c=: sConcepto
    	                                                                order by year_month_day_date__c ];
     			
     			List<Integer> agrupador = new List<Integer>();
    			for(Integer i=0;i<6 ;i++)
            	{
            		agrupador.add(fInicial.addMonths(i).month());	
            	}
            	for(Account_Indicator__c tab: auxtab){

	            if(String.isEmpty(String.valueOf(tab.year_month_day_date__c))) valores.add('0');
	            else
	            {
	            	if(tab.year_month_day_date__c.month()!=agrupador.get(mes)){
	            		for(Integer i=mes; i<agrupador.size()-1;i++){
	            			if(tab.year_month_day_date__c.month()==agrupador.get(mes))i =agrupador.size();
	            			else
	            			{
	            				valores.add('0'); 
	            				mes++;
	            			}
	            		}	            		
	            	}

	            	if(tab.year_month_day_date__c.month()==agrupador.get(mes))
	            	{	            	
	            		valores.add(String.valueOf(tab.indicator_num__c));
	            		mes++;
	            	}

	            }
	        }
	        if(mes<6)
	        {
	        	for(Integer j=mes; mes<=6;mes++)
	        		valores.add('0');
	        }
	 
            }
        }
        
        return valores;
    }

    @AuraEnabled public Static List<String> getAgrupadores( String sNombreReporte){
        List<String> agrupadores= new List<String>();         
        if(sNombreReporte.equals('EVOLUCION_CUOTA_SBS') || sNombreReporte.equals('EVOLUCION_DEUDA_SBS')){
            list<AggregateResult>  lasDateData = [SELECT MAX(year_month_day_date__c)dateP FROM Account_Banking_System_Debt__c ];
            if(!lasDateData.isEmpty() && lasDateData[0].get('dateP')!=null)
            {
                Date fInicial=((Date)lasDateData[0].get('dateP')).toStartofMonth().addMonths(-12);        
        	String [] sMes= new String[]{'Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'};
        	for(Integer i=0;i<12 ;i++)
        	{
        		agrupadores.add(sMes[fInicial.addMonths(i).month()-1]);	
        	}
            }
        }

        if(sNombreReporte.equals('VINCULACION')){
            list<AggregateResult>  lasDateData = [SELECT MAX(year_month_day_date__c)dateP FROM Account_Indicator__C where indicator_name__c in ('Estrella','Transaccional','Potencial','Básico') ];
            if(!lasDateData.isEmpty() && lasDateData[0].get('dateP')!=null)
            {
                Date fInicial=((Date)lasDateData[0].get('dateP')).toStartofMonth().addMonths(-6);
        	String [] sMes= new String[]{'Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'};
        	for(Integer i=0;i<6 ;i++)
        	{
        		agrupadores.add(sMes[fInicial.addMonths(i).month()-1] +' '+fInicial.addMonths(i).year());	
            	}
        	}
            
        }
        return agrupadores;
    }

     @AuraEnabled public Static List<String> getConceptos(String sNombreReporte){
        List<String> concepto = new List<String>(); 
        if(sNombreReporte.equals('EVOLUCION_CUOTA_SBS') || sNombreReporte.equals('EVOLUCION_DEUDA_SBS')){
            concepto.add('BBVA');
			concepto.add('BCP');
			concepto.add('SCOTIA');
			concepto.add('IBK');
			concepto.add('OTROS');
        }        

        if(sNombreReporte.equals('VINCULACION')){
            concepto.add('Estrella');
            concepto.add('Transaccional');
            concepto.add('Potencial');
            concepto.add('Básico'); 	
        }      
        return concepto;
    }

    @AuraEnabled public Static List<List<String>> getGeneraJSONReporte(String sNombreReporte,String sFiltro,String sFiltroRango,String sId){
        
        List<List<String>> conjunto = new List<List<String>>();
        List<String> agrupador = new List<String>(); 
        List<String> indicadores = new List<String>(); 
        List<String> concepto = new List<String>(); 
        List<String> val1 = new List<String>(); 

        
        if(sNombreReporte.equals('EVOLUCION_CUOTA_SBS') || sNombreReporte.equals('EVOLUCION_DEUDA_SBS')){
   			agrupador = getAgrupadores(sNombreReporte);
            concepto = getConceptos(sNombreReporte);
            conjunto.add(concepto);
			conjunto.add(agrupador);        	
            for(Integer i=0; i< concepto.size(); i++)
            {            

           		conjunto.add(new List<String>(getValores(concepto.get(i),sFiltro,sFiltroRango,sNombreReporte,sId)));
            }
        }
        if(sNombreReporte.equals('VINCULACION'))
        {
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
