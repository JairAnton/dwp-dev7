/**
* _________________________________________________________________________________
* @Name     BE_DetailRowRisk_Cls
* @Author   Antony de la rosa guzman.
* @Date     2019-11-13
* @Group    DWP Perú
* @Description Creación de la clase controladora para el componente lightning 
*              BE_DetailRowRisk_Cmp. Funciona obteniendo los datos del cliente para mostrarlos en el cintillo.
*              *Clase de pruebas BE_DetailRowRisk_Test.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
public with sharing class BE_DetailRowRisk_Cls {
/**
* _____________________________________________________________________________
* @Description Constructor de la clase
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example BE_DetailRowRisk_Cls example = new BE_DetailRowRisk_Cls();
* _____________________________________________________________________________
*/
    @testVisible private BE_DetailRowRisk_Cls() {}
    
    /**
* _____________________________________________________________________________
* @Description funcion que retorna la lista con la informacion para el cintillo Riesgos BBVA.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example Account example = getDataInfo(9098098);
* _____________________________________________________________________________
**/ 
    @auraEnabled
    public static String getDataInfo(String accId) {
        String strategy ='';String bbvaCla=''; String sbsClas ='';String watchlist=''; String statusPE25='';
        Integer bureau=0;
        final List<wrapperClass> lWrapClassAux = new List<wrapperClass>();
        final List<Account> row = [SELECT Id, risk_strategy_class_name__c, bbva_classification_desc__c, banking_system_classification_desc__c, bureau_classification_type__c, watchlist_calif_id__c, Estado_PE25__c FROM Account WHERE Id =: accId];
        if(!row.isEmpty()) {
            strategy = String.isNotEmpty(row[0].risk_strategy_class_name__c)?row[0].risk_strategy_class_name__c :'';
            bbvaCla = String.isNotEmpty(row[0].bbva_classification_desc__c) ? row[0].bbva_classification_desc__c :'';
            sbsClas = String.isNotEmpty(row[0].banking_system_classification_desc__c) ? row[0].banking_system_classification_desc__c : '';
            bureau = row[0].bureau_classification_type__c == null ? 0 : Integer.valueOf(row[0].bureau_classification_type__c);
            watchlist = String.isNotEmpty(row[0].watchlist_calif_id__c) ? row[0].watchlist_calif_id__c : '';
            statusPE25 = String.isNotEmpty(row[0].Estado_PE25__c) ? row[0].Estado_PE25__c : ''; 
        }
        lWrapClassAux.add(new wrapperClass(strategy, bbvaCla,sbsClas,bureau,watchlist,statusPE25));
        return JSON.serialize(lWrapClassAux);
    }
    
    /*
* @author Global Desktop
* @description Construye la clase wrapper que devolvera al componente
*/
    public class wrapperClass {
        /**
* @author Global Desktop
* @description Declaracion de variables de la lista wrapper
*/
        private String strategy; //NOSONAR
        /*
        * Attribute
        */
        private String bbvaClassif; //NOSONAR
        /*
        * Attribute
        */
        private String sbsClassifi; //NOSONAR
        /*
        * Attribute
        */
        private Integer bureau; //NOSONAR
        /*
        * Attribute
        */
        private String watchlist; //NOSONAR
        /*
        * Attribute
        */
        private String statusPE25; //NOSONAR
        /**
* @author Global Desktop
* @description Contruye la lista wrapper
*/
        public wrapperClass(String strategy, String listbbvaCla, String LstsbsCl, Integer bureau, String watchlist, String statusPE25) {
            this.strategy = strategy;
            this.bbvaClassif = listbbvaCla;
            this.sbsClassifi = LstsbsCl;
            this.bureau = bureau;
            this.watchlist = watchlist;
            this.statusPE25 = statusPE25;
        }
    }
}