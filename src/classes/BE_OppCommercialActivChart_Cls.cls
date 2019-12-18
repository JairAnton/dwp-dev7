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
    /*
	* Attribute
	*/
    private static Map<Integer,Integer> yearsMap= new Map<Integer,Integer>();
    /*
	* Attribute
	*/
  	private static Map<Integer,Integer> quarters= new Map<Integer,Integer>();
    /*
	* Attribute
	*/
	static {
        final integer index = myDate.month();
        integer index2 =0 ;
        for(integer i=0;i< QCUATRO;i++) {
            if(index+i < QCUATRO) {
                quarters.put(index+i,i);
                yearsMap.put(i,MyDate.year()-1);
            } else {
                quarters.put(index2,i);
                index2++;
                yearsMap.put(i,MyDate.year());
            }
        }
	}  
    
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
        final List<WPR_Clasifica_QsOpps> lWrapClassAux = new List<WPR_Clasifica_QsOpps>();
        final List<AggregateResult>  oppList =  [SELECT COUNT(Id) Total,SUM(Amount) TotalAmount,CALENDAR_QUARTER(opportunity_planning_date__c) Q,CALENDAR_YEAR(opportunity_planning_date__c) AA,StageName FROM Opportunity where AccountId=:accId  AND (opportunity_planning_date__c>= LAST_N_QUARTERS:3 and opportunity_planning_date__c<= THIS_QUARTER ) AND StageName IN('01','02','03','04','05') AND Opportunity_of_campaign_type__c =:Camping  GROUP BY CALENDAR_QUARTER(opportunity_planning_date__c),CALENDAR_YEAR(opportunity_planning_date__c),StageName order by CALENDAR_YEAR(opportunity_planning_date__c)];
        stageName01 = countOppOpen(oppList ,'01');
        stageName02 = countOppOpen(oppList ,'02');
        stageName03 = countOppOpen(oppList ,'03');
        stageName04 = countOppOpen(oppList ,'04');
        stageName05 = countOppOpen(oppList ,'05');
        labels = sortQs();
        lWrapClassAux.add(new WPR_Clasifica_QsOpps(labels,stageName01,stageName02,stageName03,stageName04,stageName05));
        return JSON.serialize(lWrapClassAux);
    } 
    
     /**
* _____________________________________________________________________________
* @Description funcion que realiza conteo de opotunidades ganadas y perdidas
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example Integer example = formulaHits(won,lost);
* _____________________________________________________________________________
*/
    public static list<string> countOppOpen(List<AggregateResult> oppList ,string etapa) {
        list<string> listvalues = new  string[4];
        for(AggregateResult opp : oppList) {
            final Integer quarterRec = (Integer)(opp.get('Q')) -1;
            if(opp.get(STAGEFIELD)==etapa && yearsMap.get(quarters.get(quarterRec)) == (Integer)(opp.get('AA'))) {
                listvalues[quarters.get(quarterRec)]=string.valueOf(opp.get(LABELAMOU));
            }
        }
        return listvalues;
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
        final List<WPR_HitsOPP> lWrapClassHits = new List<WPR_HitsOPP>();
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
        public WPR_Clasifica_QsOpps(List<string>labelsList,List<string> stageName01List, List<string>stageName02List, List<string> stageName03List, List<string> stageName04List,List<string> stageName05List) {
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
        final List<string> histsOrder = new List<string>();
        Integer q1oppWonNumber = 0; Integer q1=0;Integer q2=0; Integer q3=0;Integer Q4=0;
        Integer q2oppWonNumber = 0; Integer q3oppWonNumber = 0;Integer q4oppWonNumber = 0;Integer q1oppLostNumber = 0;
        Integer q2oppLostNumber = 0;Integer q3oppLostNumber = 0;Integer q4oppLostNumber = 0;
        final List<AggregateResult> oppWon =[SELECT COUNT(Id) Total,CALENDAR_QUARTER(opportunity_planning_date__c) Q,CALENDAR_YEAR(opportunity_planning_date__c) AA,StageName FROM Opportunity where AccountId=:accountId  AND (opportunity_planning_date__c>= LAST_N_QUARTERS:3 and opportunity_planning_date__c<= THIS_QUARTER ) AND StageName = '06' AND Opportunity_of_campaign_type__c =:Camping  GROUP BY CALENDAR_QUARTER(opportunity_planning_date__c),CALENDAR_YEAR(opportunity_planning_date__c),StageName order by CALENDAR_YEAR(opportunity_planning_date__c)];
        final List<AggregateResult> oppLost =[SELECT COUNT(Id) Total,CALENDAR_QUARTER(opportunity_planning_date__c) Q,CALENDAR_YEAR(opportunity_planning_date__c) AA,StageName FROM Opportunity where AccountId=:accountId  AND (opportunity_planning_date__c>= LAST_N_QUARTERS:3 and opportunity_planning_date__c<= THIS_QUARTER ) AND StageName = '07' AND Opportunity_of_campaign_type__c =:Camping  GROUP BY CALENDAR_QUARTER(opportunity_planning_date__c),CALENDAR_YEAR(opportunity_planning_date__c),StageName order by CALENDAR_YEAR(opportunity_planning_date__c)];
        
        q1oppWonNumber = countOpp(oppWon,1);
        q2oppWonNumber = countOpp(oppWon,2);
        q3oppWonNumber = countOpp(oppWon,3);
        q4oppWonNumber = countOpp(oppWon,4);
        q1oppLostNumber = countOpp(oppLost,1);
        q2oppLostNumber = countOpp(oppLost,2);
        q3oppLostNumber = countOpp(oppLost,3);
        q4oppLostNumber = countOpp(oppLost,4);
        q1= formulaHits(q1oppWonNumber,q1oppLostNumber);
        q2= formulaHits(q2oppWonNumber,q2oppLostNumber);
        q3= formulaHits(q3oppWonNumber,q3oppLostNumber);
        q4= formulaHits(q4oppWonNumber,q4oppLostNumber);
        histsOrder.add(string.valueOf(q1));histsOrder.add(string.valueOf(q2));histsOrder.add(string.valueOf(q3));histsOrder.add(string.valueOf(q4));
        hists = histsOrder(histsOrder);
        return hists;
    }
  
 /**
* _____________________________________________________________________________
* @Description funcion que realiza conteo de opotunidades ganadas y perdidas
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example Integer example = formulaHits(won,lost);
* _____________________________________________________________________________
*/
    public static Integer countOpp(List<AggregateResult> oppList ,Integer quarter) {
        Integer resultOpp = 0;
        for(AggregateResult opp : oppList) {
            final Integer quarterRec = (Integer)(opp.get('Q'));
            if(quarterRec == quarter) {resultOpp = (Integer)(opp.get(LABELTOTAL));}
        }
        return resultOpp;
    } 
    
 /**
* _____________________________________________________________________________
* @Description funcion que realiza el calulo de hits
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example Integer example = formulaHits(won,lost);
* _____________________________________________________________________________
*/
    public static Integer formulaHits(Integer won , Integer lost) {
        Integer result = 0;
        if(won > 0 && won != null ) {
            result= (won*100)/(won+lost);
        }
        return result;
    } 
    
    /**
* _____________________________________________________________________________
* @Description funcion que ordena los trimestres
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example Integer example = hits(AccountId,Camping);
* _____________________________________________________________________________
*/
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