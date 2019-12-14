/*
* _________________________________________________________________________________
* @Name     BE_Account_QuickViewCardWLCont_Ctrl
* @Author   Antony de la rosa guzman.
* @Date     2019-11-08
* @Group    DWP Perú
* @Description Creación de la clase controladora para el componente lightning 
*              AccountQuickViewCardWLCont_Cmp. Funciona obteniendo los datos del cliente para mostrarlos en la QuickViewCardWL.
*              *Clase de pruebas BE_Account_QuickViewCardWLCont_Test.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
public with sharing class BE_Account_QuickViewCardWLCont_Cls {
/*
* _____________________________________________________________________________
* @Description Constructor de la clase
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example BE_Account_QuickViewCardWLCont_Cls example = new BE_Account_QuickViewCardWLCont_Cls();
* _____________________________________________________________________________
*/
    @testVisible private BE_Account_QuickViewCardWLCont_Cls(){} 
/*
* _____________________________________________________________________________
* @Description Metodo que retorna la lista con la configuracion indicada de cada cards.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example Account example = getData(9098098);
* _____________________________________________________________________________
*/
    @auraEnabled (cacheable=true)
    public static String getData(String accId) {
        
        final List<List<wrapperClass>> listCards = new List<List<wrapperClass>>();
        final List<wrapperClass> listCard1 = new List<wrapperClass>();
        final List<wrapperClass> listCard2 = new List<wrapperClass>();
        final List<wrapperClass> listCard3 = new List<wrapperClass>();
        final List<wrapperClass> listCard4 = new List<wrapperClass>();
        final List<wrapperClass> listCard5 = new List<wrapperClass>();
        final String Name = 'Name';
        final List<Account> accs = [SELECT Id, bank_turnover_volume_amount__c, margin_ordinary_amount__c, net_cash_desc__c, financial_program_expiry_date__c,
                              bbva_classification_desc__c, banking_system_classification_desc__c, Rating, bureau_classification_type__c,
                              AccountNumber, BillingStreet, BillingCity, economic_activity_sector__c, Parent.Name FROM Account WHERE Id = :accId];
       
        if(!accs.isEmpty()){
            
            /*----------------------------------Fields Cards1------------------------------------------*/
            wrapperClass field = new wrapperClass(Name, 'Negocio BBVA', '08', 'Card1');
            field.isSubtitle = 'true';
            listCard1.add(field);
            
            field = new wrapperClass('Volumen Negocio', String.valueOf((accs[0].bank_turnover_volume_amount__c == null  ? 0 : accs[0].bank_turnover_volume_amount__c)), '02', 'Card1');
            field.format = 'PEN ###,###,##0.00';
            listCard1.add(field);
            
            field = new wrapperClass('Margen Ordinario', String.valueOf((accs[0].margin_ordinary_amount__c == null ? 0 : accs[0].margin_ordinary_amount__c)), '02', 'Card1');
            field.format = 'PEN ###,###,##0.00';
            listCard1.add(field);
            
            field = new wrapperClass('Net Cash', (String.isEmpty(accs[0].net_cash_desc__c) ? '-' : accs[0].net_cash_desc__c), '08', 'Card1');
            listCard1.add(field);
            
            field = new wrapperClass('Vencimiento PF', (accs[0].financial_program_expiry_date__c == null ? '-' : DateTime.newInstance(accs[0].financial_program_expiry_date__c.year(), accs[0].financial_program_expiry_date__c.month(), accs[0].financial_program_expiry_date__c.day(), 0, 0, 0).format('dd/MM/yyyy')), '08', 'Card1');
            if(accs[0].financial_program_expiry_date__c != null && accs[0].financial_program_expiry_date__c.addDays(60)<System.today()) {
                field.icon = '/resource/bbva_icon_alert';
                field.typeIcon = '02';
            }
            listCard1.add(field);
            field = new wrapperClass('', '', '08', 'Card1');
            listCard1.add(field);
            
            /*----------------------------------Fields Cards2------------------------------------------*/
            
            field = new wrapperClass(Name, 'Actividad Comercial', '08', 'Card2');
            field.isSubtitle = 'true';
            listCard2.add(field);
            
            field = new wrapperClass('Oportunidades Abiertas', oppValues(accId,'quantity'), '08', 'Card2');
            listCard2.add(field);
            
            field = new wrapperClass('Pipeline', oppValues(accId,'Amount'), '02', 'Card2');
            field.format = 'PEN ###,###,##0.00';
            listCard2.add(field);
            
            field = new wrapperClass('Visitas YTD', String.valueOf(visist(accId,'Año')), '08', 'Card2');
            listCard2.add(field);
            
            field = new wrapperClass('Visitas Trimestre', String.valueOf(visist(accId,'Trimestre')), '08', 'Card2');
            listCard2.add(field);
            
            field = new wrapperClass('', System.now().format('MM-yyyy'), '08', 'Card2');
            listCard2.add(field);
            
            /*----------------------------------Fields Cards3------------------------------------------*/
            field = new wrapperClass(Name, 'Riesgo', '08', 'Card3');
            field.isSubtitle = 'true';
            listCard3.add(field);
            
            field = new wrapperClass('Clasificación BBVA', (String.isEmpty(accs[0].bbva_classification_desc__c) ? '-' : accs[0].bbva_classification_desc__c), '08', 'Card3');
            listCard3.add(field);
            
            field = new wrapperClass('Clasificación SBS', (String.isEmpty(accs[0].banking_system_classification_desc__c) ? '-' : accs[0].banking_system_classification_desc__c), '08', 'Card3');
            listCard3.add(field);
            
            field = new wrapperClass('Rating', (String.isEmpty(accs[0].Rating) ? '-' : accs[0].Rating), '08', 'Card3');
            listCard3.add(field);
            
            field = new wrapperClass('Buro', String.valueOf((accs[0].bureau_classification_type__c == null ? 0 : accs[0].bureau_classification_type__c)), '08', 'Card3');
            listCard3.add(field);
            
            field = new wrapperClass('', '', '08', 'Card3');
            listCard3.add(field);
            
            /*----------------------------------Fields Cards4------------------------------------------*/
            field = new wrapperClass(Name, 'Potencial BBVA', '08', 'Card4');
            field.isSubtitle = 'true';
            listCard4.add(field);
            
            field = new wrapperClass('Activo Directa', indicador(accId,'ACTIVO Directa'), '08', 'Card4');
            field = addIcon(field);
            listCard4.add(field);
            
            field = new wrapperClass('CUOTA Directa', indicador(accId,'CUOTA Directa (%)'), '08', 'Card4');
            field = addIcon(field);
            listCard4.add(field);
            
            field = new wrapperClass('Spread',indicador(accId,'SPREAD (%)') , '08', 'Card4');
            field = addIcon(field);
            listCard4.add(field);
            
            field = new wrapperClass('Margen Financiero', indicador(accId,'MARGEN FINANCIERO'), '08', 'Card4');
            field = addIcon(field);
            listCard4.add(field);
            
            field = new wrapperClass('', periodo(accId), '08', 'Card4');
            listCard4.add(field);
            
            /*----------------------------------Fields Cards5------------------------------------------*/
            field = new wrapperClass(Name, 'Info Cliente', '08', 'Card5');
            field.isSubtitle = 'true';
            listCard5.add(field);
            
            field = new wrapperClass('RUC', (String.isEmpty(accs[0].AccountNumber) ? '-' : accs[0].AccountNumber), '08', 'Card5');
            listCard5.add(field);
            
            String dir = '-';
            final String dirstreet =  String.isNotEmpty(accs[0].BillingStreet) ? accs[0].BillingStreet :'';
            final String dircity =  String.isNotEmpty(accs[0].BillingCity) ? accs[0].BillingCity :'';
            dir =  String.isNotEmpty(dircity) && String.isNotEmpty(dirstreet) ? dirstreet +', '+ dircity: accs[0].BillingCity;
            field = new wrapperClass('Dirección', dir, '08', 'Card5');
            listCard5.add(field);
            
            field = new wrapperClass('Sector', (String.isEmpty(accs[0].economic_activity_sector__c) ? '-' : accs[0].economic_activity_sector__c), '08', 'Card5');
            listCard5.add(field);
            
            field = new wrapperClass('Grupo', (String.isEmpty(accs[0].Parent.Name) ? '-' : accs[0].Parent.Name), '08', 'Card5');
            listCard5.add(field);
            
            field = new wrapperClass('', '', '08', 'Card5');
            listCard5.add(field);
            
            listCards.add(listCard1);
            listCards.add(listCard2);
            listCards.add(listCard3);
            listCards.add(listCard4);
            listCards.add(listCard5);
            return JSON.serialize(listCards);
        }else{
            return null;  
        }
    }
    
/*
* _____________________________________________________________________________
* @Description Metodo wrapper que retorna el tipo de icon.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example field example = addIcon(2 Positivos);
* _____________________________________________________________________________
*/
    
    public static wrapperClass addIcon(wrapperClass field) {
        switch on field.value {
            when '2 Positivos' {
                field.icon = '/resource/Green_Flag_Icon';
                field.typeIcon = '02';
            }	
            when '2 Negativos' {
                field.icon = '/resource/Red_Flag_Icon';
                field.typeIcon = '02';
            }
            when '1 Negativo' {
                field.icon = '/resource/Yellow_Flag_Icon';
                field.typeIcon = '02';
            }
            when '1 Negativo.' {
                field.icon = '/resource/Red_Flag_Icon';
                field.typeIcon = '02';
            }
            when '1 Positivo' {
                field.icon = '/resource/Green_Flag_Icon';
                field.typeIcon = '02';
            }
        }
        return field;
    }
/*
* _____________________________________________________________________________
* @Description Metodo que consulta el total de visitas ya sea por año o por trimestre.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example Integer example = Visist(AccountId,Trimestre);
* _____________________________________________________________________________
*/
    Public static Integer visist(Id accountId,String type){
        final String[] finalizadas = new String[]{'05','06'}; 
        Integer quantityVisitYTD = 0;
        Integer quantityVisitTri = 0;
        final Integer quarter = (System.today().month() / 3) + 1;
        for(dwp_kitv__Visit__c visit : [SELECT Id, dwp_kitv__visit_start_date__c FROM dwp_kitv__Visit__c WHERE dwp_kitv__account_id__c = :accountId AND dwp_kitv__visit_start_date__c = THIS_YEAR  AND dwp_kitv__visit_status_type__c IN :finalizadas ]) {
            quantityVisitYTD++;
            final Integer quaterVisit = (visit.dwp_kitv__visit_start_date__c.month() / 3) + 1;
            if(quarter == quaterVisit) {
                quantityVisitTri++;
            }
        }
        return type == 'Año' ? quantityVisitYTD : quantityVisitTri;
    }
    
/*
* _____________________________________________________________________________
* @Description Metodo que consulta el total de oportuniodades y monto.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example String example = OppValues(AccountId,amout);
* _____________________________________________________________________________
*/
    Public static String oppValues(Id accountId,String type){
        String quantityOpps = '0';
        String resultvalues = '0';
        String amountTotal = '0';
        final List<AggregateResult> Opps = [SELECT count(Id) quantity, sum(Amount) amount FROM Opportunity WHERE AccountId = :accountId AND StageName IN('02','03','04','05') GROUP BY AccountId];{}
        if(!Opps.isEmpty()){
            if(type =='quantity'){
                resultvalues = quantityOpps = String.valueOf((Integer)Opps[0].get('quantity'));
            }else{
                resultvalues =  amountTotal = String.valueOf((Decimal)Opps[0].get('amount'));
            } 
            return resultvalues;
        }else{
            resultvalues = type =='quantity' ? quantityOpps : amountTotal;
            return resultvalues;
        }
    }
    
/*
* _____________________________________________________________________________
* @Description Metodo que consulta el tipo de indicador.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-12-13
* @example String example = Indicador(AccountId,directa);
* _____________________________________________________________________________
*/
    Public static String indicador(Id accountId,String type){
        String result = '-';        
        final List<Account_variation_information__c>  avi = [SELECT Id, validation_color_type__c, indicator_name__c, indicator_update_date__c FROM Account_variation_information__c WHERE Account_Id__c = :accountId AND indicator_name__c = :type];
        if(!avi.isEmpty()){
            return result = avi[0].validation_color_type__c;
        }else{
            return result; 
        }
    }
/*
* _____________________________________________________________________________
* @Description Metodo que consulta el periodo de actulizacion de los indicadores.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-12-13
* @example String example = periodo(AccountId);
* _____________________________________________________________________________
*/
    Public static String periodo(Id accountId){
        String result = '-';        
        final List<Account_variation_information__c>  periodo = [SELECT Id, validation_color_type__c, indicator_name__c, indicator_update_date__c FROM Account_variation_information__c WHERE Account_Id__c = :accountId AND indicator_name__c IN ('ACTIVO Directa', 'CUOTA Directa (%)', 'SPREAD (%)', 'MARGEN FINANCIERO')];
        if(!periodo.isEmpty()){
            return result =  DateTime.newInstance(periodo[0].indicator_update_date__c.year(), periodo[0].indicator_update_date__c.month(), periodo[0].indicator_update_date__c.day(), 0, 0, 0).format('MM-yyyy');
        }else{
            return result; 
        }
    }
/*
* _____________________________________________________________________________
* @Description Metodo wrapper que retorna la lista de valores para la construccion de las cards.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-08
* @example wrapperClass(String label, String value, String type, String idRecord);
* _____________________________________________________________________________
*/
    public class wrapperClass {
        private String label;
        private String value;
        private String type;
        private String format;
        private String icon; 
        private String typeIcon;
        private String idRecord;
        private String isSubtitle; 
        public wrapperClass(String label, String value, String type, String idRecord) {
            this.label = label;
            this.value = value;
            this.type = type;
            this.format = 'NOTHING';
            this.icon = 'NOTHING';
            this.typeIcon = 'NOTHING';
            this.idRecord = idRecord;
            this.isSubtitle = 'false';
        }
    }
}