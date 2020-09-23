/**
 * _________________________________________________________________________________
 * @Name     BE_VisitComercialActivity_Cls
 * @Author   Antony de la rosa guzman.
 * @Date     2019-11-13
 * @Group    DWP Perú
 * @Description Creación de la clase controladora para el componente lightning
 *              BE_VisitComercialActivity_Cmp. Funciona obteniendo los datos del cliente para mostrarlos en el cintillo.
 *              *Clase de pruebas BE_VisitComercialActivity_Test.
 * _________________________________________________________________________________
 * @Changes
    - Actualización de la formula de la variable numVisitsTRYOY
 *****************************
    Modificaciones:
    Martín Alejandro Mori Chávez  2020-02-25
 * _________________________________________________________________________________
 */
public with sharing class BE_VisitComercialActivity_Cls {
	/*
	 * Attribute
	 */
	private static final string AANT = 'AnoAnt';
	/*
	 * Attribute
	 */
	private static final string TRIMES = 'trimestre';
	/**
	 * @author Global Desktop
	 * @description Constructor de la clase
	 */
	@testVisible private BE_VisitComercialActivity_Cls() {
	}
	/**
	 * @author Global Desktop
	 * @description Recupera las visitas relacionadas con la cuenta
	 */
	@auraEnabled
	public static String getVisitInfo(String accId) {
		Integer totalVisitsYTD = 0;
		Integer totalVisitsYF = 0;
		Integer numVisitsCQ = 0;
		totalVisitsYTD = visist(accId, 'AnoAct');
		totalVisitsYF = visist(accId, 'AnoAnt');
		numVisitsCQ = visist(accId, 'trimestre');
		final List<wrapperClass> listWrapperClass = new List<wrapperClass>();
		listWrapperClass.add(new wrapperClass(totalVisitsYTD, totalVisitsYF, numVisitsCQ));
		return JSON.serialize(listWrapperClass);
	}

	/**
	 * @author Global Desktop
	 * @description Clase que construye la clase wrapper
	 */
	public class wrapperClass {
		/*
		 * Attribute
		 */
		final Integer TotalVisitsYTD;
		/*
		 * Attribute
		 */
		final Integer TotalVisitsYF;
		/*
		 * Attribute
		 */
		final Decimal TotalVisitsYOY;
		/*
		 * Attribute
		 */
		final Integer TotalVisitsCQ;
		/**
		 * @author Global Desktop
		 * @description Method que construye la clase wrapper
		 */
		public wrapperClass(Integer totalVisitsYTD, Integer totalVisitsYF, Integer totalVisitsCQ) {
			this.TotalVisitsYTD = totalVisitsYTD;
			this.TotalVisitsYF = totalVisitsYF;
			this.TotalVisitsCQ = totalVisitsCQ;
			if(TotalVisitsYTD > 0 && TotalVisitsYTD != null) {
				Decimal numVisitsTRYOY =  0;
				if(TotalVisitsYF!=0) {
					numVisitsTRYOY =  (((Decimal) TotalVisitsYTD - (Decimal) TotalVisitsYF) / TotalVisitsYF) * 100;
				}
				TotalVisitsYOY = numVisitsTRYOY.setScale(2);
			}
		}
	}

	/**
	 * _____________________________________________________________________________
	 * @Description funcion que consulta el total de visitas ya sea por año o por trimestre.
	 * _____________________________________________________________________________
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-11-08
	 * @example Integer example = Visist(AccountId,Trimestre);
	 * _____________________________________________________________________________
	 **/
	Public static Integer visist(Id accountId, String type) {
		datetime dateOfYear;
		datetime dateOfActu;
		if(type == AANT) {
			dateOfYear = datetime.newInstance(System.today().year() - 1, 1, 1);
			dateOfActu = datetime.newInstance(System.today().year() - 1, System.today().month(), System.today().day() + 1);
		} else {
			dateOfYear = datetime.newInstance(System.today().year(), 1, 1);
			dateOfActu = datetime.newInstance(System.today().year(), System.today().month(), System.today().day() + 1);
		}
		final String[] finalizadas = new String[] {'05', '06'};
		Integer quantityVisitTri = 0;
		Integer quantityyear = 0;
		final Integer quarter = System.today().month() / 3 + 1;
		for(dwp_kitv__Visit__c visit : [SELECT Id, dwp_kitv__visit_start_date__c FROM dwp_kitv__Visit__c WHERE dwp_kitv__account_id__c = :accountId AND dwp_kitv__visit_start_date__c >=: (dateOfYear) AND dwp_kitv__visit_start_date__c <=: (dateOfActu) AND dwp_kitv__visit_status_type__c IN :finalizadas ]) {
			quantityyear++;
			final Integer quaterVisit = visit.dwp_kitv__visit_start_date__c.month() / 3 + 1;
			if(quarter == quaterVisit && Type == TRIMES) {
				quantityVisitTri++;
			}
		}
		return type == TRIMES ? quantityVisitTri : quantityyear;
	}
}
