/**
* _________________________________________________________________________________
* @Name     BE_OppCommercialActivChart_Cls
* @Author   Antony de la rosa guzman.
* @Date     2019-11-15
* @Group    DWP Perú
* @Description Creación de la clase controladora para el componente lightning 
*              BE_OppCommercialActivChart_Cmp. Funciona obteniendo los datos de las oportunidades abiertas para graficar.
*              *Clase de pruebas BE_OppCommercialActivChart_Test.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
public with sharing class BE_OppCommercialActivChart_Cls {
    /*
    * Attribute
    */
    private static date myDate = system.Date.today();
    /*
    * Attribute
    */
    private static list<string> stageName01 = new  string[4];
    /*
    * Attribute
    */
    private static list<string> stageName02 = new  string[4];
    /*
    * Attribute
    */
    private static list<string> stageName03 = new  string[4];
    /*
    * Attribute
    */
    private static list<string> stageName04 = new  string[4];
    /*
    * Attribute
    */
    private static list<string> stageName05 = new  string[4];
    /*
    * Attribute
    */
    private static list<string> hitOpp = new  string[4];
    /*
    * Attribute
    */
    private static list<string> oppsHits = new  string[4];
    /*
    * Attribute
    */
    private static list<string> labels = new  string[4];
    /*
	* Attribute
	*/
	private static final String LABELTOTAL = 'Total';
	/*
	* Attribute
	*/
	private static final String LABELAMOU = 'TotalAmount';
	/*
	* Attribute
	*/
	private static final String STAGEFIELD = 'StageName';
    /*
	* Attribute
	*/
	private static final Integer QCUATRO = 4;
    
    
/**
* _____________________________________________________________________________
* @Description Constructor de la clase
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example BE_OppCommercialActivChart_Cls example = new BE_OppCommercialActivChart_Cls();
* _____________________________________________________________________________
*/
    @testVisible private BE_OppCommercialActivChart_Cls() {}
    
/**
* _____________________________________________________________________________
* @Description funcion que retorna la lista con la configuracion indicada de cada cards.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example Account example = getOppAbierInfo(9098098);
* _____________________________________________________________________________
*/
    @auraEnabled
    public static string getOppAbierInfo(String accId,Boolean Camping) {
        final integer index = myDate.month();
        integer index2 =0 ;
        final Map<Integer,Integer> quarters= new Map<Integer,Integer>();
        final Map<Integer,Integer> yearsMap= new Map<Integer,Integer>();
        final List<WPR_Clasifica_QsOpps> lWrapClassAux = new List<WPR_Clasifica_QsOpps>();
        for(integer i=0;i< QCUATRO;i++) {
            if(index+i < QCUATRO) {
                quarters.put(index+i,i);
                yearsMap.put(i,MyDate.year()-1);
            }else {
                quarters.put(index2,i);
                index2++;
                yearsMap.put(i,MyDate.year());
            }
        }
        for(AggregateResult opps : [SELECT COUNT(Id) Total,SUM(Amount) TotalAmount,CALENDAR_QUARTER(opportunity_planning_date__c) Q,CALENDAR_YEAR(opportunity_planning_date__c) AA,StageName FROM Opportunity where AccountId=:accId  AND (opportunity_planning_date__c>= LAST_N_QUARTERS:3 and opportunity_planning_date__c<= THIS_QUARTER ) AND StageName IN('01','02','03','04','05') AND Opportunity_of_campaign_type__c =:Camping  GROUP BY CALENDAR_QUARTER(opportunity_planning_date__c),CALENDAR_YEAR(opportunity_planning_date__c),StageName order by CALENDAR_YEAR(opportunity_planning_date__c)] ) {
            final Integer quarterRec = (Integer)(opps.get('Q')) -1;
            If(opps.get(STAGEFIELD)=='01' && yearsMap.get(quarters.get(quarterRec)) == (Integer)(opps.get('AA'))) {stageName01[quarters.get(quarterRec)]=string.valueOf(Opps.get(LABELAMOU));}
                If(opps.get(STAGEFIELD)=='02' && yearsMap.get(quarters.get(quarterRec)) == (Integer)(opps.get('AA'))) {stageName02[quarters.get(quarterRec)]=string.valueOf(Opps.get(LABELAMOU));}
                    If(opps.get(STAGEFIELD)=='03' && yearsMap.get(quarters.get(quarterRec)) == (Integer)(opps.get('AA'))) {stageName03[quarters.get(quarterRec)]=string.valueOf(Opps.get(LABELAMOU));}
                        If(opps.get(STAGEFIELD)=='04' && yearsMap.get(quarters.get(quarterRec)) == (Integer)(opps.get('AA'))) {stageName04[quarters.get(quarterRec)]=string.valueOf(Opps.get(LABELAMOU));}
                            If(opps.get(STAGEFIELD)=='05' && yearsMap.get(quarters.get(quarterRec)) == (Integer)(opps.get('AA'))) {stageName05[quarters.get(quarterRec)]=string.valueOf(Opps.get(LABELAMOU));}
        }
            labels = sortQs();
            lWrapClassAux.add(new WPR_Clasifica_QsOpps(labels,stageName01,stageName02,stageName03,stageName04,stageName05));
        return JSON.serialize(lWrapClassAux);
    } 
    
       /**
* _____________________________________________________________________________
* @Description funcion que retorna la lista con la configuracion indicada de cada cards.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example Account example = getOppAbierInfo(9098098);
* _____________________________________________________________________________
*/
    @auraEnabled
    public static string getOppInfoHits(String accId,Boolean Camping) {
        final integer index = myDate.month();
        integer index2 =0 ;
        final Map<Integer,Integer> quarters= new Map<Integer,Integer>();
        final Map<Integer,Integer> yearsMap= new Map<Integer,Integer>();
        final List<WPR_HitsOPP> lWrapClassHits = new List<WPR_HitsOPP>();
        for(integer i=0;i< QCUATRO;i++) {
            if( index + i < QCUATRO) {
                quarters.put(index+i,i);
                yearsMap.put(i,MyDate.year()-1);
            } else {
                quarters.put(index2,i);
                index2++;
                yearsMap.put(i,MyDate.year());
            }
        }
        
        for(AggregateResult opps :[SELECT COUNT(Id) Total,CALENDAR_QUARTER(opportunity_planning_date__c) Q,CALENDAR_YEAR(opportunity_planning_date__c) AA FROM Opportunity where AccountId=:accId  AND (opportunity_planning_date__c>= LAST_N_QUARTERS:3 and opportunity_planning_date__c<= THIS_QUARTER ) AND Opportunity_of_campaign_type__c =:Camping  GROUP BY CALENDAR_QUARTER(opportunity_planning_date__c),CALENDAR_YEAR(opportunity_planning_date__c) order by CALENDAR_YEAR(opportunity_planning_date__c)]) {
            final Integer quarterRec = (Integer)(opps.get('Q')) -1;
            If(yearsMap.get(quarters.get(quarterRec)) == (Integer)(opps.get('AA'))) {
              oppsHits[quarters.get(quarterRec)]=string.valueOf(opps.get(LABELTOTAL));  
            }     
        }
        labels = sortQs();
        hitOpp = hits(accId,Camping); 
        lWrapClassHits.add(new WPR_HitsOPP(labels,oppsHits,hitOpp));
        return JSON.serialize(lWrapClassHits);
    }
    
    /* wRAPPER CLASS FOR "Q oportunidades" GRAPH */
    public class WPR_Clasifica_QsOpps {
         /*
        * Attribute
        */
        public list<string> StageName01 {get;set;}
         /*
        * Attribute
        */
        public list<string> StageName02 {get;set;}
         /*
        * Attribute
        */
        public list<string> StageName03 {get;set;}
         /*
        * Attribute
        */
        public list<string> StageName04 {get;set;}
         /*
        * Attribute
        */
        public list<string> StageName05 {get;set;}
         /*
        * Attribute
        */
         public list<string> Labels {get;set;}
         /*
        * Attribute
        */
        public WPR_Clasifica_QsOpps(List<string>labelsList,List<string> stageName01List, List<string>stageName02List, List<string> stageName03List, List<string> stageName04List,List<string> stageName05List){
            this.Labels = labelsList;
            this.StageName01 = stageName01List;
            this.StageName02 = stageName02List;
            this.StageName03 = stageName03List;
            this.StageName04 = stageName04List;
            this.StageName05 = stageName05List;
        }  
    }
    
    /* wRAPPER CLASS FOR "Q oportunidades" GRAPH */
    public class WPR_HitsOPP {
         /*
        * Attribute
        */
        public list<string> Opps {get;set;}
         /*
        * Attribute
        */
         public list<string> Labels {get;set;}
         /*
        * Attribute
        */
        public list<string> Hits {get;set;}
        public WPR_HitsOPP(List<string> labelsList,list<string> oppList,List<string> hitList) {
            this.Labels = labelsList;
            this.Opps = oppList;
            this.Hits = hitList;
        }  
    }
     /*
        * Attribute
        */
    public static list<String> sortQs() {
        string q = 'Q1,Q2,Q3,Q4';
        final list<string> qs = q.split(',');
        final list<string> qsOrder= new list<String>();
        final Integer quarter = System.today().month() / 3 + 1;
        integer quarter2 =0 ;
        for(integer i=0;i< QCUATRO;i++) {
            if(quarter+i < QCUATRO) {
                qsOrder.add(qs[(quarter+i)]+' '+String.valueof(myDate.year()-1));
            } else {
                qsOrder.add(qs[quarter2]+' '+String.valueof(myDate.year()));
                quarter2++;
            }
        }
        return qsOrder;
    } 
    
    
       /**
* _____________________________________________________________________________
* @Description funcion que consulta el total de oportunidades ganadas y destimadas
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example Integer example = hits(AccountId,Camping);
* _____________________________________________________________________________
*/
    Public static list<string> hits(Id accountId,Boolean Camping) {
          List<string> hists = new List<string>();
          List<string> histsOrder = new List<string>();
          Integer q1oppWonNumber = 0; Integer q1=0;Integer q2=0; Integer q3=0;Integer Q4=0;
          Integer q2oppWonNumber = 0; Integer q3oppWonNumber = 0;Integer q4oppWonNumber = 0;Integer q1oppLostNumber = 0;
          Integer q2oppLostNumber = 0;Integer q3oppLostNumber = 0;Integer q4oppLostNumber = 0;
          final List<AggregateResult> oppListHit =[SELECT COUNT(Id) Total,CALENDAR_QUARTER(opportunity_planning_date__c) Q,CALENDAR_YEAR(opportunity_planning_date__c) AA,StageName FROM Opportunity where AccountId=:accountId  AND (opportunity_planning_date__c>= LAST_N_QUARTERS:3 and opportunity_planning_date__c<= THIS_QUARTER ) AND StageName IN('07','06') AND Opportunity_of_campaign_type__c =:Camping  GROUP BY CALENDAR_QUARTER(opportunity_planning_date__c),CALENDAR_YEAR(opportunity_planning_date__c),StageName order by CALENDAR_YEAR(opportunity_planning_date__c)];
          for(AggregateResult listHit : oppListHit) {
            final Integer quarterRec = (Integer)(listHit.get('Q'));
           if(listHit.get(STAGEFIELD)=='06') {
            if(quarterRec == 1) {q1oppWonNumber = (Integer)(listHit.get(LABELTOTAL));}
            if(quarterRec == 2) {q2oppWonNumber = (Integer)(listHit.get(LABELTOTAL));}
            if(quarterRec == 3) {q3oppWonNumber = (Integer)(listHit.get(LABELTOTAL));}
            if(quarterRec == 4) {q4oppWonNumber = (Integer)(listHit.get(LABELTOTAL));}
              } else {
            if(quarterRec == 1) {q1oppLostNumber = (Integer)(listHit.get(LABELTOTAL));}
            if(quarterRec == 2) {q2oppLostNumber = (Integer)(listHit.get(LABELTOTAL));}
            if(quarterRec == 3) {q3oppLostNumber = (Integer)(listHit.get(LABELTOTAL));}
            if(quarterRec == 4) {q4oppLostNumber = (Integer)(listHit.get(LABELTOTAL));}
              }
        }
        if(q1oppWonNumber > 0 && q1oppWonNumber != null ) {q1= (q1oppWonNumber*100)/(q1oppWonNumber+q1oppLostNumber);}
        if(q2oppWonNumber > 0 && q2oppWonNumber != null ) {q2 = (q2oppWonNumber*100)/(q2oppWonNumber+q2oppLostNumber);}  
        if(q3oppWonNumber > 0 && q3oppWonNumber != null ) {q3= (q3oppWonNumber*100)/(q3oppWonNumber+q3oppLostNumber);}
        if(q4oppWonNumber > 0 && q4oppWonNumber != null ) {q4 = (q4oppWonNumber*100)/(q4oppWonNumber+q4oppLostNumber);}
        histsOrder.add(string.valueOf(q1));histsOrder.add(string.valueOf(q2));histsOrder.add(string.valueOf(q3));histsOrder.add(string.valueOf(q4));
        hists = histsOrder(histsOrder);
        return hists;
    }
    
    public static list<String> histsOrder(list<string> values) {
        final list<string> qsOrder= new list<String>();
        final Integer quarter = System.today().month() / 3 + 1;
        integer quarter2 =0 ;
        for(integer i=0;i< QCUATRO;i++) {
            if(quarter + i < QCUATRO ) {
                qsOrder.add(values[(quarter+i)]);
            } else {
                qsOrder.add(values[quarter2]);
                quarter2++;
            }
        }
        return qsOrder;
    } 
    
}