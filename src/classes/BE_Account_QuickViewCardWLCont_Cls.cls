/*
 * @Name     BE_Account_QuickViewCardWLCont_Ctrl
 * @Author   Antony de la rosa guzman.
 * @Date     2019-11-08
 * @Group    DWP Perú
 * @Description Creación de la clase controladora para el componente lightning
 *              AccountQuickViewCardWLCont_Cmp. Funciona obteniendo los datos del cliente para mostrarlos en la QuickViewCardWL.
 *              *Clase de pruebas BE_Account_QuickViewCardWLCont_Test.
 * @Changes
    - Actualización oppValues se agregó el filtro de este año a la query de oportunidades y se corrigió el valor 1 Positivo
 *****************************
    Modificaciones:
    Martín Alejandro Mori Chávez  2020-02-25
 */
public with sharing class BE_Account_QuickViewCardWLCont_Cls {
	/*
	 * Attribute
	 */
	private static final String TRUES = 'true';
	/*
	 * Attribute
	 */
	private static final String FALSES = 'false';
	/*
	 * Attribute
	 */
	private static final String QUANTITY = 'quantity';
	/*
	 * Attribute
	 */
	private static final String NAME = 'Name';
	/*
	 * Attribute
	 */
	private static final String CARD1 = 'Card1';
	/*
	 * Attribute
	 */
	private static final String CARD2 = 'Card2';
	/*
	 * Attribute
	 */
	private static final String CARD3 = 'Card3';
	/*
	 * Attribute
	 */
	private static final String CARD4 = 'Card4';
	/*
	 * Attribute
	 */
	private static final String CARD5 = 'Card5';
	/*
	 * Attribute
	 */
	private static final String ISEMPTY = 'NOTHING';

	/*
	 * @Description Constructor de la clase
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-11-08
	 * @example BE_Account_QuickViewCardWLCont_Cls example = new BE_Account_QuickViewCardWLCont_Cls();
	 */
	@testVisible private BE_Account_QuickViewCardWLCont_Cls() {
	}
	/*
	 * @Description funcion que retorna la lista con la configuracion indicada de cada cards.
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-11-08
	 * @example Account example = getData(9098098);
	 */
	@auraEnabled (cacheable = true)
	public static String getData(String accId) {
		string result = '';
		final List<Account> accs = [SELECT Id, bank_turnover_volume_amount__c, margin_ordinary_amount__c, net_cash_desc__c, financial_program_expiry_date__c, bbva_classification_desc__c, banking_system_classification_desc__c, Rating, bureau_classification_type__c, AccountNumber, BillingStreet, BillingCity, economic_activity_sector__c, Parent.Name FROM Account WHERE Id = :accId];
		if(!accs.isEmpty()) {
			string fieldIcon = '';
			final List<Account_variation_information__c> avi = [SELECT Id, validation_color_type__c, indicator_name__c, indicator_update_date__c FROM Account_variation_information__c WHERE Account_Id__c = :accId AND indicator_name__c IN('ACTIVO Directa', 'CUOTA Directa (%)', 'SPREAD (%)', 'MARGEN FINANCIERO')];
			final List<List<wrapperClass> > listCards = new List<List<wrapperClass> >(); final List<wrapperClass> listCard1 = new List<wrapperClass>(); final List<wrapperClass> listCard2 = new List<wrapperClass>();
			final List<wrapperClass> listCard3 = new List<wrapperClass>(); final List<wrapperClass> listCard4 = new List<wrapperClass>(); final List<wrapperClass> listCard5 = new List<wrapperClass>();
			/*----------------------------------Fields Cards1------------------------------------------*/
			listCard1.add(new wrapperClass(NAME, 'Negocio BBVA', '08', CARD1, ISEMPTY, ISEMPTY, ISEMPTY, TRUES));
			listCard1.add(new wrapperClass('Volumen Negocio',  validation(String.valueOf(accs[0].bank_turnover_volume_amount__c), '0'), '02', CARD1, 'PEN ###,###,##0.00', ISEMPTY, ISEMPTY, FALSES));
			listCard1.add(new wrapperClass('Margen Ordinario', validation(String.valueOf(accs[0].margin_ordinary_amount__c), '0'), '02', CARD1, 'PEN ###,###,##0.00', ISEMPTY, ISEMPTY, FALSES));
			listCard1.add(new wrapperClass('Net Cash', validation(String.valueOf(accs[0].net_cash_desc__c), '-'), '08', CARD1, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			if(accs[0].financial_program_expiry_date__c != null && accs[0].financial_program_expiry_date__c.addDays(60) < System.today()) {fieldIcon = '/resource/bbva_icon_alert';}
			listCard1.add(new wrapperClass('Vencimiento PF', (accs[0].financial_program_expiry_date__c == null ? '-' : DateTime.newInstance(accs[0].financial_program_expiry_date__c.year(), accs[0].financial_program_expiry_date__c.month(), accs[0].financial_program_expiry_date__c.day(), 0, 0, 0).format('dd/MM/yyyy')), '08', CARD1, ISEMPTY, fieldIcon, '02', FALSES));
			listCard1.add(new wrapperClass('', '', '08', CARD1, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			/*----------------------------------Fields Cards2------------------------------------------*/
			listCard2.add(new wrapperClass(NAME, 'Actividad Comercial', '08', CARD2, ISEMPTY, ISEMPTY, ISEMPTY, TRUES));
			listCard2.add(new wrapperClass('Oportunidades Abiertas', oppValues(accId, QUANTITY), '08', CARD2, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			listCard2.add(new wrapperClass('Pipeline', oppValues(accId, 'Amount'), '02', CARD2, 'PEN ###,###,##0.00', ISEMPTY, ISEMPTY, FALSES));
			listCard2.add(new wrapperClass('Visitas YTD', String.valueOf(visist(accId, 'Año')), '08', CARD2, '', ISEMPTY, ISEMPTY, FALSES));
			listCard2.add(new wrapperClass('Visitas Trimestre', String.valueOf(visist(accId, 'Trimestre')), '08', CARD2, '', ISEMPTY, ISEMPTY, FALSES));
			listCard2.add(new wrapperClass('', System.now().format('MM-yyyy'), '08', CARD2, '', ISEMPTY, ISEMPTY, FALSES));
			/*----------------------------------Fields Cards3------------------------------------------*/
			listCard3.add(new wrapperClass(NAME, 'Riesgo', '08', CARD3, ISEMPTY, ISEMPTY, ISEMPTY, TRUES));
			listCard3.add(new wrapperClass('Clasificación BBVA', validation(String.valueOf(accs[0].bbva_classification_desc__c), '-'), '08', CARD3, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			listCard3.add(new wrapperClass('Clasificación SBS', validation(String.valueOf(accs[0].banking_system_classification_desc__c), '-'), '08', CARD3, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			listCard3.add(new wrapperClass('Rating', validation(String.valueOf(accs[0].Rating), '-'), '08', CARD3, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			listCard3.add(new wrapperClass('Buro', validation(String.valueOf(accs[0].bureau_classification_type__c), '0'), '08', CARD3, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			listCard3.add(new wrapperClass('', '', '08', CARD3, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			/*----------------------------------Fields Cards4------------------------------------------*/
			listCard4.add(new wrapperClass(NAME, 'Potencial BBVA', '08', CARD4, ISEMPTY, ISEMPTY, ISEMPTY, TRUES));
			listCard4.add(new wrapperClass('Activo Directa', indicador(avi, 'ACTIVO Directa'), '08', CARD4, ISEMPTY, addIcon(indicador(avi, 'ACTIVO Directa')), '02', FALSES));
			listCard4.add(new wrapperClass('CUOTA Directa', indicador(avi, 'CUOTA Directa (%)'), '08', CARD4, ISEMPTY, addIcon(indicador(avi, 'CUOTA Directa (%)')), '02', FALSES));
			listCard4.add(new wrapperClass('Spread', indicador(avi, 'SPREAD (%)'), '08', CARD4, ISEMPTY, addIcon(indicador(avi, 'SPREAD (%)')), '02', FALSES));
			listCard4.add(new wrapperClass('Margen Financiero', indicador(avi, 'MARGEN FINANCIERO'), '08', CARD4, ISEMPTY, addIcon(indicador(avi, 'MARGEN FINANCIERO')), '02', FALSES));
			listCard4.add(new wrapperClass('', periodo(accId), '08', CARD4, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			/*----------------------------------Fields Cards5------------------------------------------*/
			listCard5.add(new wrapperClass(NAME, 'Info Cliente', '08', CARD5, ISEMPTY, ISEMPTY, ISEMPTY, TRUES));
			listCard5.add(new wrapperClass('RUC', validation(String.valueOf(accs[0].AccountNumber), '-'), '08', CARD5, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			listCard5.add(new wrapperClass('Dirección', validationdir(String.valueOf(accs[0].BillingStreet), String.valueOf(accs[0].BillingCity)), '08', CARD5, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			listCard5.add(new wrapperClass('Sector', validation(String.valueOf(accs[0].economic_activity_sector__c), '-'), '08', CARD5, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			listCard5.add(new wrapperClass('Grupo', validation(String.valueOf(accs[0].Parent.Name), '-'), '08', CARD5, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			listCard5.add(new wrapperClass('', '', '08', CARD5, ISEMPTY, ISEMPTY, ISEMPTY, FALSES));
			listCards.add(listCard1); listCards.add(listCard2); listCards.add(listCard3); listCards.add(listCard4); listCards.add(listCard5);
			result = JSON.serialize(listCards);
		}
		return result;
	}

	/*
	 * @Description funcion wrapper que retorna el tipo de icon.
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-11-08
	 * @example field example = addIcon(2 Positivos);
	 */
	public static string addIcon(string values) {
		string field = '';
		switch on values {
			when '2 Positivos' {
				field = '/resource/Green_Flag_Icon';
			}
			when '2 Negativos' {
				field = '/resource/Red_Flag_Icon';
			}
			when '1 Negativo' {
				field = '/resource/Yellow_Flag_Icon';
			}
			when '1 Negativo.' {
				field = '/resource/Red_Flag_Icon';
			}
			when '1 Positivo.' {
				field = '/resource/Green_Flag_Icon';
			}
		}
		return field;
	}

	/*
	 * @Description funcion que consulta el total de visitas ya sea por año o por trimestre.
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-11-08
	 * @example Integer example = Visist(AccountId,Trimestre);
	 */
	Public static Integer visist(Id accountId, String type) {
		final String[] finalizadas = new String[] {'05', '06'};
		Integer quantityVisitYTD = 0;
		Integer quantityVisitTri = 0;
		final Integer quarter = System.today().month() / 3 + 1;
		for(dwp_kitv__Visit__c visit : [SELECT Id, dwp_kitv__visit_start_date__c FROM dwp_kitv__Visit__c WHERE dwp_kitv__account_id__c = :accountId AND dwp_kitv__visit_start_date__c = THIS_YEAR AND dwp_kitv__visit_status_type__c IN :finalizadas ]) {
			quantityVisitYTD++;
			final Integer quaterVisit = visit.dwp_kitv__visit_start_date__c.month() / 3 + 1;
			if(quarter == quaterVisit) {
				quantityVisitTri++;
			}
		}
		return type == 'Año' ? quantityVisitYTD : quantityVisitTri;
	}

	/*
	 * @Description funcion que consulta el total de oportuniodades y monto.
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-11-08
	 * @example String example = OppValues(AccountId,amout);
	 */
	Public static String oppValues(Id accountId, String type) {
		String quantityOpps = '0';
		String resultvalues = '0';
		String amountTotal = '0';
		final List<AggregateResult> Opps = [SELECT count(Id) quantity, sum(Amount) amount FROM Opportunity WHERE AccountId = :accountId AND StageName IN('02', '03', '04', '05') AND CloseDate = THIS_YEAR GROUP BY AccountId];
		if(!Opps.isEmpty()) {
			if(type == QUANTITY) {
				resultvalues = quantityOpps = String.valueOf((Integer)Opps[0].get(QUANTITY));
			} else {
				resultvalues =  amountTotal = String.valueOf((Decimal)Opps[0].get('amount'));
			}
		}
		resultvalues = type == QUANTITY ? quantityOpps : amountTotal;
		return resultvalues;
	}

	/*
	 * @Description funcion que consulta el tipo de indicador.
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-12-13
	 * @example String example = Indicador(AccountId,directa);
	 */
	Public static String indicador(list<Account_variation_information__c> fields, String type) {
		String result = '-';
		if(!fields.isEmpty()) {
			for(Account_variation_information__c avi : fields) {
				if(avi.indicator_name__c == type) {
					result = avi.validation_color_type__c;
				}
			}
		}
		return result;
	}

	/*
	 * @Description funcion que consulta el periodo de actulizacion de los indicadores.
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-12-13
	 * @example String example = periodo(AccountId);
	 */
	Public static String periodo(Id accountId) {
		String result = '-';
		final List<Account_variation_information__c>  periodo = [SELECT Id, validation_color_type__c, indicator_name__c, indicator_update_date__c FROM Account_variation_information__c WHERE Account_Id__c = :accountId AND indicator_name__c IN('ACTIVO Directa', 'CUOTA Directa (%)', 'SPREAD (%)', 'MARGEN FINANCIERO')];
		if(!periodo.isEmpty()) {
			result =  DateTime.newInstance(periodo[0].indicator_update_date__c.year(), periodo[0].indicator_update_date__c.month(), periodo[0].indicator_update_date__c.day(), 0, 0, 0).format('MM-yyyy');
		}
		return result;
	}

	/*
	 * @Description funcion que valida campos nulos.
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-12-13
	 * @example String example = validation(888,'0');
	 */
	Public static String validation(string value, string initvalue) {
		final String result = value;
		if(string.isEmpty(value)) {
			result = initvalue;
		}
		return result;
	}

	/*
	 * @Description funcion que valida direccion.
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-12-13
	 * @example String example = validationdir(mexico,peru,'-');
	 */
	Public static String validationdir(string billingStreet, string billingCity) {
		String result = '-';
		final String dirstreet =  String.isNotEmpty(billingStreet) ? billingStreet : '-';
		final String dircity =  String.isNotEmpty(billingCity) ? billingCity : '-';
		result =  String.isNotEmpty(dircity) && String.isNotEmpty(dirstreet) ? dirstreet + ', ' + dircity : billingCity;
		return result;
	}

	/*
	 * @Description funcion wrapper que retorna la lista de valores para la construccion de las cards.
	 * @Author Antony de la rosa guzman.
	 * @Date 2019-11-08
	 * @example wrapperClass(String label, String value, String type, String idRecord);
	 */
	public class wrapperClass {
		/*
		 * Attribute
		 */
		final String label;
		/*
		 * Attribute
		 */
		final String value;
		/*
		 * Attribute
		 */
		final String type;
		/*
		 * Attribute
		 */
		final String format;
		/*
		 * Attribute
		 */
		final String icon;
		/*
		 * Attribute
		 */
		final String typeIcon;
		/*
		 * Attribute
		 */
		final String idRecord;
		/*
		 * Attribute
		 */
		final String isSubtitle;
		/*
		 * Attribute
		 */
		public wrapperClass(String label, String value, String type, String idRecord, String format, String icon, string typeIcon, string isSubtitle) {
			this.label = label;
			this.value = value;
			this.type = type;
			this.format = format;
			this.icon = icon;
			this.typeIcon = typeIcon;
			this.idRecord = idRecord;
			this.isSubtitle = isSubtitle;
		}
	}
}
