/*
* @Class Using into a developer for a lithgning component
* 
* 
* */
public without sharing class ProfitabilityController_cls {
    
    @auraenabled
    public static list<list<String>> AccountProfit(string recordId) {
        list<list<String>> cuenta= new list<list<string>>();
        Map<string,AggregateResult> total = new Map<string,AggregateResult>([SELECT Account_id__c cuenta,account_id__c Id ,SUM(current_ydt_amount__c ) suma FROM Account_Profitability__c  WHERE account_id__r.ParentID=:recordId AND is_type_3_last_date__c = true  AND profitability_type__c ='03' AND (profitability_category_type__c = 'Comisiones' OR profitability_category_type__c = 'Margen financiero')  GROUP BY Account_id__c]);
        Map<string,AggregateResult> cm = new Map<string,AggregateResult>([SELECT Account_id__c cuenta,account_id__c Id,SUM(current_ydt_amount__c ) suma FROM Account_Profitability__c  WHERE account_id__r.ParentID=:recordId AND is_type_3_last_date__c = true AND profitability_type__c ='03' AND profitability_category_type__c = 'Comisiones' GROUP BY Account_id__c ]);
        Map<string,AggregateResult> mf = new Map<string,AggregateResult>([SELECT Account_id__c cuenta,account_id__c Id,SUM(current_ydt_amount__c ) suma FROM Account_Profitability__c  WHERE account_id__r.ParentID=:recordId AND is_type_3_last_date__c = true   AND profitability_type__c ='03' AND profitability_category_type__c = 'Margen financiero' GROUP BY Account_id__c]);
        set<id> Ids= new set<id>();
        for(AggregateResult item : total.values()){ Ids.add((id)item.get('cuenta'));}
        list<Account> listAccNames= [select id,Name from Account where id in : Ids];
        string NameById='';
        AggregateResult c;
        AggregateResult m;
        AggregateResult t;
        double nc;
        double nm;
        double tt;
        List<String> args = new String[]{'0','number','###,###,##0.00'};
            for(AggregateResult r :total.values()){
                list<string> a = new list<string>();
                nc=0;
                nm=0;
                tt =0;
                c=cm.get(r.Id);
                m=mf.get(r.Id);
                t =total.get(r.Id);
                if(c!=null)nc=Double.valueOf(c.get('suma'));
                if(m!=null)nm=Double.valueOf(m.get('suma'));
                if(t!=null)tt=Double.valueOf(t.get('suma'));
                for(Account itemacc: listAccNames)
                {
                    if(r.get('cuenta')==itemacc.id)            
                        NameById=itemacc.Name;
                }
                a.add(String.valueOf(NameById));
                a.add(r.Id);
                String s1 = String.format(nm.format(), args);
                String s2 = String.format(nc.format(), args);
                String s3 = String.format(tt.format(), args);
                a.add(String.valueOf(s1));
                a.add(String.valueOf(s2));
                a.add(String.valueOf(s3));
                cuenta.add(a);
            }
        return cuenta;
    }
    public ProfitabilityController_cls(){
    }
}