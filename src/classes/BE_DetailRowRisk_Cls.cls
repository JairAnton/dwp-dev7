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
**/
    @testVisible private BE_DetailRowRisk_Cls() {}
    
    /**
* _____________________________________________________________________________
* @Description Metodo que retorna la lista con la informacion para el cintillo Riesgos BBVA.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example Account example = getDataInfo(9098098);
* _____________________________________________________________________________
**/ 
    @auraEnabled
    public static String getDataInfo(String accId) {
        String strategy ='';String bbvaClassification=''; String sbsClassification ='';String watchlist=''; String statusPE25='';
        Integer bureau=0;
        final List<wrapperClass> lWrapClassAux = new List<wrapperClass>();
        List<Account> row = [SELECT Id, risk_strategy_class_name__c, bbva_classification_desc__c, banking_system_classification_desc__c, bureau_classification_type__c, watchlist_calif_id__c, Estado_PE25__c FROM Account WHERE Id =: accId];
        if(row.size()>0 && !row.isEmpty()) {
            strategy = String.isNotEmpty(row[0].risk_strategy_class_name__c)?row[0].risk_strategy_class_name__c :'';
            bbvaClassification = String.isNotEmpty(row[0].bbva_classification_desc__c) ? row[0].bbva_classification_desc__c :'';
            sbsClassification = String.isNotEmpty(row[0].banking_system_classification_desc__c) ? row[0].banking_system_classification_desc__c : '';
            bureau = row[0].bureau_classification_type__c != null ? Integer.valueOf(row[0].bureau_classification_type__c) : 0;
            watchlist = String.isNotEmpty(row[0].watchlist_calif_id__c) ? row[0].watchlist_calif_id__c : '';
            statusPE25 = String.isNotEmpty(row[0].Estado_PE25__c) ? row[0].Estado_PE25__c : '';
            lWrapClassAux.add(new wrapperClass(strategy, bbvaClassification,sbsClassification,bureau,watchlist,statusPE25));
        }else{
            lWrapClassAux.add(new wrapperClass(strategy, bbvaClassification,sbsClassification,bureau,watchlist,statusPE25));
        }
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
        private String bbvaClassification; //NOSONAR
        private String sbsClassification; //NOSONAR
        private Integer bureau; //NOSONAR
        private String watchlist; //NOSONAR
        private String statusPE25; //NOSONAR
        /**
* @author Global Desktop
* @description Contruye la lista wrapper
*/
        public wrapperClass(String strategy, String bbvaClassification, String sbsClassification, Integer bureau, String watchlist, String statusPE25) {
            this.strategy = strategy;
            this.bbvaClassification = bbvaClassification;
            this.sbsClassification = sbsClassification;
            this.bureau = bureau;
            this.watchlist = watchlist;
            this.statusPE25 = statusPE25;
        }
    }
}