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
            - Actualización getOppInfo se cambio el filtro de fecha de opportunity_planning_date__c por CloseDate y se elimino la etapa 01
 *****************************
            Modificaciones:
            Martín Alejandro Mori Chávez  2020-02-25
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
	private static Map<Integer, Integer> quarters = new Map<Integer, Integer>();
	/*
	 * Attribute
	 */
	private static final string QSVALUES = 'Q1,Q2,Q3,Q4';
	/*
	 * Attribute
	 */

	static {
		quarters.put(System.today().addMonths(-9).month() / 3, 0);
		quarters.put(System.today().addMonths(-6).month() / 3, 1);
		quarters.put(System.today().addMonths(-3).month() / 3, 2);
		quarters.put(System.today().month() / 3, 3);
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
	@testVisible private BE_OppCommercialActivChart_Cls() {
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
	public static string getOppAbierInfo(String accId, Boolean camping) {
		final List<WPR_Clasifica_QsOpps> lWrapClassAux = new List<WPR_Clasifica_QsOpps>();
		final List<AggregateResult>  oppList =  [SELECT COUNT(Id) Total, SUM(Amount) TotalAmount, CALENDAR_QUARTER(CloseDate) Q, CALENDAR_YEAR(CloseDate) AA, StageName FROM Opportunity WHERE AccountId =:accId AND(CloseDate >= LAST_N_QUARTERS:3 AND CloseDate <= THIS_QUARTER) AND StageName IN('03', '04', '05') AND Type = '01' AND Opportunity_of_campaign_type__c =:camping GROUP BY CALENDAR_QUARTER(CloseDate), CALENDAR_YEAR(CloseDate), StageName ORDER BY CALENDAR_YEAR(CloseDate)];
		stageName03 = countOppOpen(oppList, '03');
		stageName04 = countOppOpen(oppList, '04');
		stageName05 = countOppOpen(oppList, '05');
		labels = sortQs();
		lWrapClassAux.add(new WPR_Clasifica_QsOpps(labels, stageName03, stageName04, stageName05));
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
	public static list<string> countOppOpen(List<AggregateResult> oppList, string etapa) {
		list<string> listvalues = new  string[4];
		for(AggregateResult opp : oppList) {
			final Integer quarterRec = (Integer)(opp.get('Q'));
			if(opp.get(STAGEFIELD) == etapa) {
				listvalues[quarters.get(quarterRec)] = string.valueOf(opp.get(LABELAMOU));
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
	public static string getOppInfoHits(String accId, Boolean camping) {
		final List<WPR_HitsOPP> lWrapClassHits = new List<WPR_HitsOPP>();
		for(AggregateResult opps :[SELECT COUNT(Id) Total, CALENDAR_QUARTER(CloseDate) Q, CALENDAR_YEAR(CloseDate) AA FROM Opportunity WHERE AccountId =:accId AND StageName IN('03', '04', '05') AND Type = '01' AND(CloseDate >= LAST_N_QUARTERS:3 and CloseDate <= THIS_QUARTER) AND Opportunity_of_campaign_type__c =:camping GROUP BY CALENDAR_QUARTER(CloseDate), CALENDAR_YEAR(CloseDate) ORDER BY CALENDAR_YEAR(CloseDate)]) {
			final Integer quarterRec = (Integer)(opps.get('Q'));
			oppsHits[quarters.get(quarterRec)] = string.valueOf(opps.get(LABELTOTAL));
		}
		labels = sortQs();
		hitOpp = hits(accId, camping);
		lWrapClassHits.add(new WPR_HitsOPP(labels, oppsHits, hitOpp));
		return JSON.serialize(lWrapClassHits);
	}

	/* wRAPPER CLASS FOR "Q oportunidades" GRAPH */
	public class WPR_Clasifica_QsOpps {
		/*
		 * Attribute
		 */
		public list<string> stage03 {get; set;}
		/*
		 * Attribute
		 */
		public list<string> stage04 {get; set;}
		/*
		 * Attribute
		 */
		public list<string> stage05 {get; set;}
		/*
		 * Attribute
		 */
		public list<string> labels {get; set;}
		/*
		 * Attribute
		 */
		public WPR_Clasifica_QsOpps(List<string>labelsList, List<string> stageName03List, List<string> stageName04List, List<string> stageName05List) {
			this.labels = labelsList;
			this.stage03 = stageName03List;
			this.stage04 = stageName04List;
			this.stage05 = stageName05List;
		}
	}

	/* wRAPPER CLASS FOR "Q oportunidades" GRAPH */
	public class WPR_HitsOPP {
		/*
		 * Attribute
		 */
		public list<string> opps {get; set;}
		/*
		 * Attribute
		 */
		public list<string> labels {get; set;}
		/*
		 * Attribute
		 */
		public list<string> hits {get; set;}
		/*
		 * Attribute
		 */
		public WPR_HitsOPP(List<string> labelsList, list<string> oppList, List<string> hitList) {
			this.labels = labelsList;
			this.opps = oppList;
			this.hits = hitList;
		}
	}
	
    /*
	 * Attribute
	 */
	public static list<String> sortQs() {
		final list<string> quartersv = QSVALUES.split(',');
		final list<string> qsOrder = new list<String>();
		final Integer quarter = System.today().month() / 3;
		Integer quarter2 = 0;
		for(integer i = 0; i < QCUATRO; i++) {
			if(quarter + i < QCUATRO) {
				qsOrder.add(quartersv[(quarter + i)] + ' ' + String.valueof(myDate.year() - 1));
			} else {
				qsOrder.add(quartersv[quarter2] + ' ' + myDate.year());
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
	Public static list<string> hits(Id accountId, Boolean camping) {
		List<string> hists = new List<string>();
		final List<string> histsOrder = new List<string>();
		Integer q1oppWonNumber = 0;
		Integer q2oppWonNumber = 0; Integer q3oppWonNumber = 0; Integer q4oppWonNumber = 0; Integer q1oppLostNumber = 0;
		Integer q2oppLostNumber = 0; Integer q3oppLostNumber = 0; Integer q4oppLostNumber = 0;
		final List<AggregateResult> oppWon = [SELECT COUNT(Id) Total, CALENDAR_QUARTER(CloseDate) Q, CALENDAR_YEAR(CloseDate) AA, StageName FROM Opportunity WHERE AccountId =:accountId AND(CloseDate >= LAST_N_QUARTERS:3 AND CloseDate <= THIS_QUARTER) AND StageName = '06' AND Type = '01' AND Opportunity_of_campaign_type__c =:camping GROUP BY CALENDAR_QUARTER(CloseDate), CALENDAR_YEAR(CloseDate), StageName ORDER BY CALENDAR_YEAR(CloseDate)];
		final List<AggregateResult> oppLost = [SELECT COUNT(Id) Total, CALENDAR_QUARTER(CloseDate) Q, CALENDAR_YEAR(CloseDate) AA, StageName FROM Opportunity WHERE AccountId =:accountId AND(CloseDate >= LAST_N_QUARTERS:3 AND CloseDate <= THIS_QUARTER) AND StageName = '07' AND Type = '01' AND Opportunity_of_campaign_type__c =:camping GROUP BY CALENDAR_QUARTER(CloseDate), CALENDAR_YEAR(CloseDate), StageName ORDER BY CALENDAR_YEAR(CloseDate)];

		q1oppWonNumber = countOpp(oppWon, 1);
		q2oppWonNumber = countOpp(oppWon, 2);
		q3oppWonNumber = countOpp(oppWon, 3);
		q4oppWonNumber = countOpp(oppWon, 4);
		q1oppLostNumber = countOpp(oppLost, 1);
		q2oppLostNumber = countOpp(oppLost, 2);
		q3oppLostNumber = countOpp(oppLost, 3);
		q4oppLostNumber = countOpp(oppLost, 4);

		final Map<Integer, Integer> mapQs = new Map<Integer, Integer>();
		mapQs.put(1, formulaHits(q1oppWonNumber, q1oppLostNumber));
		mapQs.put(2, formulaHits(q2oppWonNumber, q2oppLostNumber));
		mapQs.put(3, formulaHits(q3oppWonNumber, q3oppLostNumber));
		mapQs.put(4, formulaHits(q4oppWonNumber, q4oppLostNumber));
		for(Integer key : quarters.keySet()) {
			histsOrder.add(String.valueOf(mapQs.get(key)));
		}

		hists = histsOrder;
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
	public static Integer countOpp(List<AggregateResult> oppList, Integer quarter) {
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
	public static Integer formulaHits(Integer won, Integer lost) {
		Integer result = 0;
		if(won > 0 && won != null) {
			result = (won * 100) / (won + lost);
		}
		return result;
	}
}
