public class ProfitabilityController_cls {

    @auraenabled
    public  static list<list<String>>  AccountProfit(string recordId){
        list<list<String>> cuenta= new list<list<string>>();

        Map<string,AggregateResult> total = new Map<string,AggregateResult>([SELECT account_id__r.name cuenta,account_id__c Id ,SUM(currenct_mon_amount__c) suma FROM Account_Profitability__c  WHERE account_id__r.ParentID=:recordId AND is_type_3_last_date__c = true  AND profitability_type__c ='03' AND (profitability_category_type__c = 'Comisiones' OR profitability_category_type__c = 'Margen financiero')  GROUP BY Account_id__r.name, Account_id__c]);
        Map<string,AggregateResult> cm = new Map<string,AggregateResult>([SELECT account_id__r.name cuenta,account_id__c Id,SUM(currenct_mon_amount__c) suma FROM Account_Profitability__c  WHERE account_id__r.ParentID=:recordId AND is_type_3_last_date__c = true AND profitability_type__c ='03' AND profitability_category_type__c = 'Comisiones' GROUP BY Account_id__r.name,Account_id__c ]);
        Map<string,AggregateResult> mf = new Map<string,AggregateResult>([SELECT account_id__r.name cuenta,account_id__c Id,SUM(currenct_mon_amount__c) suma FROM Account_Profitability__c  WHERE account_id__r.ParentID=:recordId AND is_type_3_last_date__c = true   AND profitability_type__c ='03' AND profitability_category_type__c = 'Margen financiero' GROUP BY Account_id__r.name,Account_id__c]);
        AggregateResult c;
        AggregateResult m;
        AggregateResult t;
        double nc;
        double nm;
        double tt;
        List<String> args = new String[]{'0','number','###,###,##0.00'};
            for(AggregateResult r :total.values()){
                list<string> a = new list<string>();
                list<string> b = new list<string>();
                nc=0;
                nm=0;
                tt =0;
                c=cm.get(r.Id);
                m=mf.get(r.Id);
                t =total.get(r.Id);
                if(c!=null)nc=Double.valueOf(c.get('suma'));
                if(m!=null)nm=Double.valueOf(m.get('suma'));
                if(t!=null)tt=Double.valueOf(t.get('suma'));
                a.add(String.valueOf(r.get('cuenta')));
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


}
