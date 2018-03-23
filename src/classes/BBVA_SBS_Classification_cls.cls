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
    
    
    private static void fillArray(list<string> zeroList,string value){ 
        for(integer i =0;i<12;i++){
          zeroList[i]=value;  
        }      
    }
    
    
    
    @AuraEnabled
    public static list<list<String>> getJSON(Id recordId){ 
     List<List<String>> MonthSBS = new List<List<String>>();         
     fillArray(BBVA,'0');
     fillArray(Nor,'100');
     fillArray(CPP,'0');
     fillArray(Def,'0');
     fillArray(Dud,'0');
     fillArray(Per,'0');
     fillArray(SBS,'0');   
     list<list<string>> json = new list<list<string>>(); 
     list<Account_Banking_System_Classification__c>   ABSC = new list<Account_Banking_System_Classification__c>(); 
     list<Account_BBVA_Classification__c>  ABBVAC = new list<Account_BBVA_Classification__c>();  
         
        ABBVAC =[SELECT bbva_classification_type__c 
                 FROM Account_BBVA_Classification__c 
                 WHERE account_id__c  =: recordId 
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
               ORDER BY year_month_day_date__c LIMIT 12];
        Integer index =0;
        for(Account_Banking_System_Classification__c abc : ABSC ){
          system.debug('Index : '+ index +' : '+abc.banking_system_classification_quota_per__c);  
           if(abc.banking_system_classification_type__c == '0'){     
             Nor[Index]=(Nor[Index]!=null)?string.valueOf(decimal.valueOf(Nor[Index])+abc.banking_system_classification_quota_per__c):string.valueOf(abc.banking_system_classification_quota_per__c);        
            }
            if(abc.banking_system_classification_type__c == '10'){   
             CPP[index]=(CPP[index]!=null)?string.valueOf(decimal.valueOf(CPP[index])+abc.banking_system_classification_quota_per__c):string.valueOf(abc.banking_system_classification_quota_per__c); 
             Nor[Index]=string.valueOf(decimal.valueOf(Nor[index])-decimal.valueOf(CPP[index]));
            } 
            if(abc.banking_system_classification_type__c == '20') {
             Def[index]=(Def[index]!=null)?string.valueOf(decimal.valueOf(Def[index])+abc.banking_system_classification_quota_per__c):string.valueOf(abc.banking_system_classification_quota_per__c); 
             CPP[index]=string.valueOf(100-decimal.valueOf(Def[index]));
             Nor[Index]='0';   
            }
            if(abc.banking_system_classification_type__c == '30') {
             Dud[index]=(dud[index]!=null)?string.valueOf(decimal.valueOf(Dud[index])+abc.banking_system_classification_quota_per__c):string.valueOf(abc.banking_system_classification_quota_per__c);
             Def[index]=string.valueOf(100-decimal.valueOf(Dud[index]));
             CPP[index]='0';
             Nor[Index]='0';
            }
            if(abc.banking_system_classification_type__c == '40'){
             Per[index]=(Per[index]!=null)?string.valueOf(decimal.valueOf(Per[index])+abc.banking_system_classification_quota_per__c):string.valueOf(abc.banking_system_classification_quota_per__c); 
             Dud[Index]=string.valueOf(100-decimal.valueOf(Per[index]));
             CPP[index]='0';
             Nor[Index]='0';
             Def[Index]='0';    
            }
            index++;
               } 
      
         for(integer i =0;i<12;i++){
             try{   
          if(ABBVAC[i].bbva_classification_type__c==0)  BBVA[i]= '100';
          if(ABBVAC[i].bbva_classification_type__c==10)  BBVA[i]= '80';
          if(ABBVAC[i].bbva_classification_type__c==20)  BBVA[i]= '60';
          if(ABBVAC[i].bbva_classification_type__c==30)  BBVA[i]= '40';
          if(ABBVAC[i].bbva_classification_type__c==40)  BBVA[i]= '20'; 
             }catch(Exception e){
               system.debug('Exception :'+ e.getMessage());  
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
     json.add(SBS);   
     
    
     return json;   
    }
  

   private static list<String> sortMonths(){
        string mes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre';
        date myDate = system.Date.today();
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