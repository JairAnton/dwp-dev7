/**BBVA_SBS_Classification
 *  object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Julio Medellin               21/03/2018          Original version.<p />
 *
 * @author Julio Medellin
 */
public with sharing class BBVA_SBS_Classification_cls {

private static list<string> BBVA = new string[12];  
private static list<string> Nor = new  string[12]; 
private static list<string> CPP = new  string[12];
private static list<string> Def = new  string[12]; 
private static list<string> Dud = new  string[12]; 
private static list<string> Per = new  string[12];     
private static list<string> SBS = new  string[12];    
private static date myDate = system.Date.today();     
    
    private static void fillArray(list<string> zeroList,string value){ 
        for(integer i =0;i<12;i++){
          zeroList[i]=value;  
        }      
    }
    
    
    
    @AuraEnabled
    public static list<list<String>> getJSON(Id recordId){ 
     List<List<String>> MonthSBS = new List<List<String>>();         
     fillArray(BBVA,'0');
     fillArray(Nor,'0');
     fillArray(CPP,'0');
     fillArray(Def,'0');
     fillArray(Dud,'0');
     fillArray(Per,'0');
     fillArray(SBS,'0');   
     list<list<string>> json = new list<list<string>>(); 
     list<Account_Banking_System_Classification__c>   ABSC = new list<Account_Banking_System_Classification__c>(); 
     list<Account_BBVA_Classification__c>  ABBVAC = new list<Account_BBVA_Classification__c>();  
     date myDate = system.Date.today();
     integer index = myDate.month();
     integer index2 =0 ;    
     Integer currentMonth = myDate.month();
        Map<Integer,Integer> MonthsMap= new Map<Integer,Integer>();
        ABBVAC =[SELECT bbva_classification_type__c,year_month_day_date__c 
                 FROM Account_BBVA_Classification__c 
                 WHERE account_id__c  =: recordId 
                 AND year_month_day_date__c = LAST_N_DAYS:365
                 ORDER BY year_month_day_date__c 
                 LIMIT 12];
        
        ABSC = [SELECT ID,
                    account_id__c,
                    banking_system_classification_desc__c,
                    banking_system_classification_quota_per__c,
                    banking_system_classification_type__c,
                    Name,Unique_Id__c,year_month_day_date__c 
               FROM Account_Banking_System_Classification__c 
               WHERE account_id__c  =: recordId 
               AND year_month_day_date__c = LAST_N_DAYS:365
               ORDER BY year_month_day_date__c LIMIT 12];
     
        
        for(integer i=0;i<12;i++){
            if((index+i)<12){    
           MonthsMap.put(Index+i,i);
            }else{     
            MonthsMap.put(Index2,i);
             index2++;  
            }    
        }  
        
        for(Account_Banking_System_Classification__c abc : ABSC ){          
         Integer MonthRec = abc.year_month_day_date__c.Month()-1;
          
            
            If(abc.banking_system_classification_type__c=='0'){              
               Nor[MonthsMap.get(MonthRec)]='100';         
               
            }
            If(abc.banking_system_classification_type__c=='10'){
               CPP[MonthsMap.get(MonthRec)]=string.valueOf(decimal.valueOf(CPP[abc.year_month_day_date__c.Month()-1])+abc.banking_system_classification_quota_per__c); 
               Nor[MonthsMap.get(MonthRec)]=String.valueOf(100-Decimal.valueOf(CPP[MonthsMap.get(MonthRec)]));
            }
            If(abc.banking_system_classification_type__c=='20'){
               Def[MonthsMap.get(MonthRec)]=string.valueOf(decimal.valueOf(Def[abc.year_month_day_date__c.Month()-1])+abc.banking_system_classification_quota_per__c); 
               CPP[MonthsMap.get(MonthRec)]=String.valueOf(100-Decimal.valueOf(Def[MonthsMap.get(MonthRec)]));
            }
            If(abc.banking_system_classification_type__c=='30'){
               Dud[MonthsMap.get(MonthRec)]=string.valueOf(decimal.valueOf(Dud[abc.year_month_day_date__c.Month()-1])+abc.banking_system_classification_quota_per__c);
               Def[MonthsMap.get(MonthRec)]=String.valueOf(100-Decimal.valueOf(Dud[MonthsMap.get(MonthRec)]));
            }
            If(abc.banking_system_classification_type__c=='40'){ 
               Per[MonthsMap.get(MonthRec)]=string.valueOf(decimal.valueOf(Per[abc.year_month_day_date__c.Month()-1])+abc.banking_system_classification_quota_per__c);    
               Dud[MonthsMap.get(MonthRec)]=String.valueOf(100-Decimal.valueOf(Per[MonthsMap.get(MonthRec)]));    
            }
           
        }
            
        for(Account_BBVA_Classification__c  abc : ABBVAC ){ 
          Integer MonthRec = abc.year_month_day_date__c.Month()-1;
          if(abc.bbva_classification_type__c==0)   BBVA[MonthsMap.get(MonthRec)]= '100';
          if(abc.bbva_classification_type__c==10)  BBVA[MonthsMap.get(MonthRec)]= '80';
          if(abc.bbva_classification_type__c==20)  BBVA[MonthsMap.get(MonthRec)]= '60';
          if(abc.bbva_classification_type__c==30)  BBVA[MonthsMap.get(MonthRec)]= '40';
          if(abc.bbva_classification_type__c==40)  BBVA[MonthsMap.get(MonthRec)]= '20';                      
         }      
        
              
     //Set Labels Months in Order 
     json.add(sortMonths());
     json.add(Nor);
     json.add(CPP);  
     json.add(DEF);
     json.add(Dud); 
     json.add(Per);
     json.add(BBVA);
     json.add(SBS);   
     
    
     return json;   
    }
 

   private static list<String> sortMonths(){
        string mes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre';
        list<string> Months = Mes.split(',');
        list<string> MonthsOrder= new list<String>();
        integer index = myDate.month();
        integer index2 =0 ;
        for(integer i=0;i<12;i++){
            if((index+i)<12){    
            MonthsOrder.add(Months[(index+i)]+' '+String.valueof(myDate.year()-1));
            }else{     
            MonthsOrder.add(Months[index2]+' '+String.valueof(myDate.year()));
             index2++;  
            }    
        }     
              
     return MonthsOrder;   
    }
     
   

}