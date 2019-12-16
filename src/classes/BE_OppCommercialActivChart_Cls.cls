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
        fillArrayInit(stageName01,'0');
        fillArrayInit(stageName02,'0');
        fillArrayInit(stageName03,'0');
        fillArrayInit(stageName04,'0');
        fillArrayInit(stageName05,'0');
        fillArrayInit(labels,'0');
        final integer index = myDate.month();
        integer index2 =0 ;
        final Map<Integer,Integer> quarters= new Map<Integer,Integer>();
        final Map<Integer,Integer> yearsMap= new Map<Integer,Integer>();
        final List<WPR_Clasifica_QsOpps> lWrapClassAux = new List<WPR_Clasifica_QsOpps>();
        for(integer i=0;i<4;i++) {
            if(index+i <4) {
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
        fillArrayInit(oppsHits,'0');
        fillArrayInit(labels,'0');
        fillArrayInit(hitOpp,'0');
        final integer index = myDate.month();
        integer index2 =0 ;
        final Map<Integer,Integer> quarters= new Map<Integer,Integer>();
        final Map<Integer,Integer> yearsMap= new Map<Integer,Integer>();
        final List<WPR_HitsOPP> lWrapClassHits = new List<WPR_HitsOPP>();
        for(integer i=0;i<4;i++) {
            if( index + i < 4) {
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
        public WPR_Clasifica_QsOpps(List<string> LabelsList,List<string> StageName01List, List<string>StageName02List, List<string> StageName03List, List<string> StageName04List,List<string> StageName05List){
            this.Labels = LabelsList;
            this.StageName01 = StageName01List;
            this.StageName02 = StageName02List;
            this.StageName03 = StageName03List;
            this.StageName04 = StageName04List;
            this.StageName05 = StageName05List;
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
        public WPR_HitsOPP(List<string> LabelsList,list<string> OppList,List<string> HitList) {
            this.Labels = LabelsList;
            this.Opps = OppList;
            this.Hits = HitList;
        }  
    }
     /*
        * Attribute
        */
    public static list<String> sortQs() {
        string Q = 'Q1,Q2,Q3,Q4';
        final list<string> Qs = Q.split(',');
        final list<string> QsOrder= new list<String>();
        final Integer quarter = System.today().month() / 3 + 1;
        integer quarter2 =0 ;
        for(integer i=0;i<4;i++) {
            if(quarter+i < 4) {
                QsOrder.add(Qs[(quarter+i)]+' '+String.valueof(myDate.year()-1));
            } else {
                QsOrder.add(Qs[quarter2]+' '+String.valueof(myDate.year()));
                quarter2++;
            }
        }
        return QsOrder;
    } 
    
    private static void fillArrayInit(list<string> listInit,string value) {
        for(integer i =0;i<listInit.size();i++) {
          listInit[i]=value;
        }
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
    Public static list<string> hits(Id AccountId,Boolean Camping) {
          List<string> Hists = new List<string>();
          List<string> HistsOrder = new List<string>();
          Integer Q1oppWonNumber = 0; Integer Q1=0;Integer Q2=0; Integer Q3=0;Integer Q4=0;
          Integer Q2oppWonNumber = 0; Integer Q3oppWonNumber = 0;Integer Q4oppWonNumber = 0;Integer Q1oppLostNumber = 0;
          Integer Q2oppLostNumber = 0;Integer Q3oppLostNumber = 0;Integer Q4oppLostNumber = 0;
          List<AggregateResult> OppListHit =[SELECT COUNT(Id) Total,CALENDAR_QUARTER(opportunity_planning_date__c) Q,CALENDAR_YEAR(opportunity_planning_date__c) AA,StageName FROM Opportunity where AccountId=:AccountId  AND (opportunity_planning_date__c>= LAST_N_QUARTERS:3 and opportunity_planning_date__c<= THIS_QUARTER ) AND StageName IN('07','06') AND Opportunity_of_campaign_type__c =:Camping  GROUP BY CALENDAR_QUARTER(opportunity_planning_date__c),CALENDAR_YEAR(opportunity_planning_date__c),StageName order by CALENDAR_YEAR(opportunity_planning_date__c)];
          for(AggregateResult ListHit : OppListHit) {
            final Integer QuarterRec = (Integer)(ListHit.get('Q'));
           if(ListHit.get(STAGEFIELD)=='06') {
            if(QuarterRec == 1) {Q1oppWonNumber = (Integer)(ListHit.get(LABELTOTAL));}
            if(QuarterRec == 2) {Q2oppWonNumber = (Integer)(ListHit.get(LABELTOTAL));}
            if(QuarterRec == 3) {Q3oppWonNumber = (Integer)(ListHit.get(LABELTOTAL));}
            if(QuarterRec == 4) {Q4oppWonNumber = (Integer)(ListHit.get(LABELTOTAL));}
              }else{
            if(QuarterRec == 1) {Q1oppLostNumber = (Integer)(ListHit.get(LABELTOTAL));}
            if(QuarterRec == 2) {Q2oppLostNumber = (Integer)(ListHit.get(LABELTOTAL));}
            if(QuarterRec == 3) {Q3oppLostNumber = (Integer)(ListHit.get(LABELTOTAL));}
            if(QuarterRec == 4) {Q4oppLostNumber = (Integer)(ListHit.get(LABELTOTAL));}
              }
        }
        if(Q1oppWonNumber > 0 && Q1oppWonNumber != null ) {Q1= (Q1oppWonNumber*100)/(Q1oppWonNumber+Q1oppLostNumber);}
        if(Q2oppWonNumber > 0 && Q2oppWonNumber != null ) {Q2 = (Q2oppWonNumber*100)/(Q2oppWonNumber+Q2oppLostNumber);}  
        if(Q3oppWonNumber > 0 && Q3oppWonNumber != null ) {Q3= (Q3oppWonNumber*100)/(Q3oppWonNumber+Q1oppLostNumber);}
        if(Q4oppWonNumber > 0 && Q4oppWonNumber != null ) {Q4 = (Q4oppWonNumber*100)/(Q4oppWonNumber+Q2oppLostNumber);}
        HistsOrder.add(string.valueOf(Q1));HistsOrder.add(string.valueOf(Q2));HistsOrder.add(string.valueOf(Q3));HistsOrder.add(string.valueOf(Q4));
        Hists = HistsOrder(HistsOrder);
        return Hists;
    }
    
    public static list<String> HistsOrder(list<string> values) {
        final list<string> QsOrder= new list<String>();
        final Integer quarter = System.today().month() / 3 + 1;
        integer quarter2 =0 ;
        for(integer i=0;i<4;i++) {
            if(quarter + i <4 ) {
                QsOrder.add(values[(quarter+i)]);
            } else {
                QsOrder.add(values[quarter2]);
                quarter2++;
            }
        }
        return QsOrder;
    } 
    
}