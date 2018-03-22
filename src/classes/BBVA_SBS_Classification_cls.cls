public with sharing class BBVA_SBS_Classification_cls {

private static list<string> BBVA = new string[12];  
private static list<string> Nor = new  string[12]; 
private static list<string> CPP = new  string[12];
private static list<string> Def = new  string[12]; 
private static list<string> Dud = new  string[12]; 
private static list<string> Per = new  string[12];     
    
    
    
    private static void fillArray(list<string> zeroList){ 
        for(integer i =0;i<12;i++){
          zeroList[i]='0';  
        }
            
    }
    
    
    @AuraEnabled
    public static list<list<String>> getJSON(){ 
     fillArray(BBVA);
     fillArray(Nor);
     fillArray(CPP);
     fillArray(Def);
     fillArray(Dud);
     fillArray(Per); 
     list<list<string>> json = new list<list<string>>(); 
     list<Account_Banking_System_Classification__c>   ABSC = new list<Account_Banking_System_Classification__c>(); 
        ABSC = [SELECT ID,
                    account_id__c,
                    banking_system_classification_desc__c,
                    banking_system_classification_quota_per__c,
                    banking_system_classification_type__c,
                    Name,Unique_Id__c,year_month_day_date__c 
               FROM Account_Banking_System_Classification__c WHERE isDeleted = false
               ORDER BY banking_system_classification_type__c,year_month_day_date__c];
        
        for(Account_Banking_System_Classification__c abc : ABSC ){ 
            if(abc.banking_system_classification_type__c == '1'){     
             Nor[abc.year_month_day_date__c.Month()]=(Nor[abc.year_month_day_date__c.Month()]!=null)?string.valueOf(decimal.valueOf(Nor[abc.year_month_day_date__c.Month()])+abc.banking_system_classification_quota_per__c):string.valueOf(abc.banking_system_classification_quota_per__c);        
            }
            if(abc.banking_system_classification_type__c == '2'){ 
             CPP[abc.year_month_day_date__c.Month()]=(CPP[abc.year_month_day_date__c.Month()]!=null)?string.valueOf(decimal.valueOf(CPP[abc.year_month_day_date__c.Month()])+abc.banking_system_classification_quota_per__c):string.valueOf(abc.banking_system_classification_quota_per__c); 
      
            } 
            if(abc.banking_system_classification_type__c == '3') {
             Def[abc.year_month_day_date__c.Month()]=(Def[abc.year_month_day_date__c.Month()]!=null)?string.valueOf(decimal.valueOf(Def[abc.year_month_day_date__c.Month()])+abc.banking_system_classification_quota_per__c):string.valueOf(abc.banking_system_classification_quota_per__c); 
            }
            if(abc.banking_system_classification_type__c == '4') {
             Dud[abc.year_month_day_date__c.Month()]=(dud[abc.year_month_day_date__c.Month()]!=null)?string.valueOf(decimal.valueOf(Dud[abc.year_month_day_date__c.Month()])+abc.banking_system_classification_quota_per__c):string.valueOf(abc.banking_system_classification_quota_per__c);
            }
            if(abc.banking_system_classification_type__c == '5'){
             Per[abc.year_month_day_date__c.Month()]=(Per[abc.year_month_day_date__c.Month()]!=null)?string.valueOf(decimal.valueOf(Per[abc.year_month_day_date__c.Month()])+abc.banking_system_classification_quota_per__c):string.valueOf(abc.banking_system_classification_quota_per__c); 
            }
                     }     
        
              
     //Set Labels Months in Order 
     json.add(sortMonths());
     json.add(Nor);
     json.add(CPP);  
     json.add(DEF);
     json.add(Dud); 
     json.add(Per);
     json.add(BBVA);   
    
    
     return json;   
    }
  
    
    private static list<string> colors(){
     list<string> colors = new list<string>();   
     colors.add('rgba(223,123,11,1)');//Naranja;
     colors.add('rgba(5,5,127,1)');//AzulOscuro;  
     colors.add('rgba(0,91,58,1)');//rojo;   
     colors.add('rgba(0,172,35,1)');//verde;
     colors.add('rgba(223,123,11,1)');//Morado;
     colors.add('rgba(102,207,34,1)');//AzulClaro;    
     return colors;   
    }
   

    
    private static list<String> sortMonths(){
        string mes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre';
        date myDate = system.Date.today();
        list<string> Months = Mes.split(',');
        list<string> MonthsOrder= new list<String>();
        integer index = myDate.month();
        integer index2 =0 ;
        for(integer i=0;i<12;i++){
        if(i+index<=12){    
            MonthsOrder.add(Months[(index+i)-1]+' '+String.valueof(myDate.year()));
        }else{
            MonthsOrder.add(Months[index2]+' '+String.valueof(myDate.year()+1));
            index2++;
        }     
        }
        
        
     return MonthsOrder;   
    }
     
   

}