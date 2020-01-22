/**
* @Name     BE_DetailRowBusiness_Cls
* @Author   Antony de la rosa guzman.
* @Date     2019-11-13
* @Group    DWP Perú
* @Description Creación de la clase controladora para el componente lightning
*              BE_DetailRowBusiness_Cmp. Funciona obteniendo los datos del cliente para mostrarlos en el cintillo.
*              *Clase de pruebas BE_DetailRowBusiness_Test.
* @Changes
*/
public with sharing class BE_DetailRowBusiness_Cls {
    /*
* @Description Constructor de la clase
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example BE_DetailRowBusiness_Cls example = new BE_DetailRowBusiness_Cls();
*/
    @testVisible private BE_DetailRowBusiness_Cls () {
    }
    
    /*
* @Description Constructor de la clase
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example BE_DetailRowRisk_Cls example = new BE_DetailRowRisk_Cls();
*/
    @auraEnabled
    public static BE_WRP_Account getDataInfo(String accId) {
        final BE_WRP_Account res = new BE_WRP_Account();
        final List<Account> row = [SELECT Id, bank_turnover_volume_amount__c, margin_ordinary_amount__c, risk_strategy_class_name__c,
                                   alert__c, financial_program_expiry_date__c, net_cash_desc__c FROM Account WHERE Id =: accId];
        res.volBusiness = '0';
        res.marOrdinal = '0';
        res.strategy = '-';
        res.alert = '';
        res.duePF = '-';
        res.netcash = '-';
        res.IconDate = '';
        res.IconNetcash = '';
        if(!row.isEmpty()) {
            res.volBusiness = Dwp_Utils_helper.formatAmount(row[0].bank_turnover_volume_amount__c, 'PEN');
            res.marOrdinal = Dwp_Utils_helper.formatAmount(row[0].margin_ordinary_amount__c, 'PEN');
            res.strategy = String.isEmpty(row[0].risk_strategy_class_name__c) ? '-' : row[0].risk_strategy_class_name__c;
            res.alert = row[0].alert__c;
            res.duePF = row[0].financial_program_expiry_date__c == null ? '-' : formatdate(row[0].financial_program_expiry_date__c);
            res.netcash = row[0].net_cash_desc__c;
            res.IconDate = icoaddDate(row[0].financial_program_expiry_date__c);
            res.IconNetcash = icoaddNetCash(row[0].net_cash_desc__c);
        }
        return res;
    }
    
    /*
* @Description class wrapper
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example BE_WRP_Account;
*/
    public class BE_WRP_Account {
        /*
* Attribute
*/
        @AuraEnabled public string volBusiness {get; set;}
        /*
* Attribute
*/
        @AuraEnabled public string marOrdinal {get; set;}
        /*
* Attribute
*/
        @AuraEnabled public String strategy {get; set;}
        /*
* Attribute
*/
        @AuraEnabled public String alert {get; set;}
        /*
* Attribute
*/
        @AuraEnabled public string duePF {get; set;}
        /*
* Attribute
*/
        @AuraEnabled public String netcash {get; set;}
        /*
* Attribute
*/
        @AuraEnabled public String iconDate {get; set;}
        /*
* Attribute
*/
        @AuraEnabled public String iconNetcash {get; set;}
    }
    
    /*
* @Description Constructor de la clase
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example BE_DetailRowRisk_Cls example = new BE_DetailRowRisk_Cls();
*/
    public static string formatdate(date fecha) {
        return DateTime.newInstance(fecha.year(), fecha.month(), fecha.day(), 0, 0, 0).format('dd/MM/yyyy');
    }
    
    /*
* @Description Constructor de la clase
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example BE_DetailRowRisk_Cls example = new BE_DetailRowRisk_Cls();
*/
    public static string icoaddDate(date fecha) {
        string result='';
        if(fecha.addDays(60)<System.today() && fecha != null) {
            result = '/resource/bbva_icon_alert';
        }
        return result;
    }
    
    /*
* @Description Constructor de la clase
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example BE_DetailRowRisk_Cls example = new BE_DetailRowRisk_Cls();
*/
    public static string icoaddNetCash(string netCash) {
        string result='';
        if(String.isNotEmpty(netCash)) {
            result = '/resource/Green_Flag_Icon';
        }
        return result;
    }
}