public with sharing class BBVA_SBS_Classification_cls {
    
    
    @AuraEnabled
    public static list<Account_Banking_System_Classification__c>  fecthBBVA_SBS(){ 
        list<Account_Banking_System_Classification__c>   ABSC = new list<Account_Banking_System_Classification__c>(); 
        ABSC = [SELECT ID,account_id__c,banking_system_classification_desc__c,banking_system_classification_quota_per__c,banking_system_classification_type__c,Name,Unique_Id__c,year_month_day_date__c FROM Account_Banking_System_Classification__c];
        return ABSC;
        
    }
    
   @AuraEnabled
    public static list<String> OrderMonths(){
        string mes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre';
        date myDate = system.Date.today();
        list<string> Months = Mes.split(',');
        list<string> MonthsOrder= new list<String>();
        integer index = myDate.month();
        integer index2 =0 ;
        for(integer i=0;i<12;i++){
        if(i+index<12){    
            MonthsOrder.add(Months[index+i]);
        }else{
            MonthsOrder.add(Months[index2]);
            index2++;
        }     
        }
        
     return MonthsOrder;   
    }
     
   

}