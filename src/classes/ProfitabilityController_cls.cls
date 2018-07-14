public class ProfitabilityController_cls {
    
    @auraenabled
    public  static list<list<String>>  AccountProfit(string recordId){
     list<list<String>> cuenta= new list<list<string>>();

        Map<string,AggregateResult> total = new Map<string,AggregateResult>([SELECT account_id__r.name cuenta,account_id__c Id ,SUM(currenct_mon_amount__c) suma FROM Account_Profitability__c  WHERE account_id__r.ParentID=:recordId AND year_month_day_date__c <= YESTERDAY  AND profitability_type__c ='03'  GROUP BY Account_id__r.name, Account_id__c]);        
        Map<string,AggregateResult> cm = new Map<string,AggregateResult>([SELECT account_id__r.name cuenta,account_id__c Id,SUM(currenct_mon_amount__c) suma FROM Account_Profitability__c  WHERE account_id__r.ParentID=:recordId AND year_month_day_date__c <= YESTERDAY  AND profitability_type__c ='03' AND profitability_category_type__c = 'Comisiones' GROUP BY Account_id__r.name,Account_id__c ]);    
        Map<string,AggregateResult> mf = new Map<string,AggregateResult>([SELECT account_id__r.name cuenta,account_id__c Id,SUM(currenct_mon_amount__c) suma FROM Account_Profitability__c  WHERE account_id__r.ParentID=:recordId AND year_month_day_date__c <= YESTERDAY  AND profitability_type__c ='03' AND profitability_category_type__c = 'Margen financiero' GROUP BY Account_id__r.name,Account_id__c]);    
        AggregateResult c;
        AggregateResult m;
        double nc;
        double nm;
        for(AggregateResult r :total.values()){
            list<string> a = new list<string>();
            list<string> b = new list<string>();
            nc=0;
            nm=0;
            c=cm.get(r.Id);
            m=mf.get(r.Id);
           if(c!=null)nc=Double.valueOf(c.get('suma'));
           if(m!=null)nm=Double.valueOf(m.get('suma')); 
            a.add(String.valueOf(r.get('cuenta')));
            a.add(r.Id);
            a.add(String.valueOf(nc));
            a.add(String.valueOf(nm));
            a.add(String.valueOf(r.get('suma')));
            cuenta.add(a);
        }   
               
        
        return cuenta;
    }
    

}