/**
* _________________________________________________________________________________
* @Name     BE_DetailRowBusiness_Cls
* @Author   Antony de la rosa guzman.
* @Date     2019-11-13
* @Group    DWP Perú
* @Description Creación de la clase controladora para el componente lightning 
*              BE_DetailRowBusiness_Cmp. Funciona obteniendo los datos del cliente para mostrarlos en el cintillo.
*              *Clase de pruebas BE_DetailRowBusiness_Test.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
public with sharing class BE_DetailRowBusiness_Cls {
     /**
* _____________________________________________________________________________
* @Description Constructor de la clase
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example BE_DetailRowBusiness_Cls example = new BE_DetailRowBusiness_Cls();
* _____________________________________________________________________________
**/
     @testVisible private BE_DetailRowBusiness_Cls() {}
    
    /**
* _____________________________________________________________________________
* @Description Metodo que retorna la lista con la informacion para el cintillo negocio BBVA.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example Account example = getDataInfo(9098098);
* _____________________________________________________________________________
**/
    @auraEnabled
    public static BE_WRP_Account getDataInfo(String accId) {
            BE_WRP_Account res = new BE_WRP_Account();
            List<Account> row = [SELECT Id, bank_turnover_volume_amount__c, margin_ordinary_amount__c, risk_strategy_class_name__c,
                                 alert__c, financial_program_expiry_date__c, net_cash_desc__c FROM Account WHERE Id =: accId];
            if(row.size()>0 && !row.isEmpty()) {
                res.volBusiness = row[0].bank_turnover_volume_amount__c != null ? Dwp_Utils_helper.formatAmount(row[0].bank_turnover_volume_amount__c , 'PEN') : '0';
                res.marOrdinal = row[0].margin_ordinary_amount__c != null ? Dwp_Utils_helper.formatAmount(row[0].margin_ordinary_amount__c , 'PEN') : '0';
                res.strategy = String.isEmpty(row[0].risk_strategy_class_name__c) ? '-' :row[0].risk_strategy_class_name__c;
                res.alert = String.isEmpty(row[0].alert__c) ? '' : row[0].alert__c;
                res.duePF = row[0].financial_program_expiry_date__c== null ? '-':formatdate(row[0].financial_program_expiry_date__c);
                res.netcash =  String.isEmpty(row[0].net_cash_desc__c) ? '' : row[0].net_cash_desc__c;
                res.IconDate = row[0].financial_program_expiry_date__c== null ? '':icoaddDate(row[0].financial_program_expiry_date__c);
                res.IconNetcash = icoaddNetCash(row[0].net_cash_desc__c);
            }else{
                res.volBusiness = '0';
                res.marOrdinal = '0';
                res.strategy = '-';
                res.alert = '';
                res.duePF = '-';
                res.netcash = '-';
                res.IconDate = '';
                res.IconNetcash = '';
            }
        return res;
        }

 public class BE_WRP_Account{
        @AuraEnabled public string volBusiness {get; set;}
        @AuraEnabled public string marOrdinal {get; set;} 
        @AuraEnabled public String strategy {get; set;} 
        @AuraEnabled public String alert {get; set;}
        @AuraEnabled public string duePF {get; set;}
        @AuraEnabled public String netcash {get; set;}
        @AuraEnabled public String IconDate {get; set;}
        @AuraEnabled public String IconNetcash {get; set;}
        public BE_WRP_Account(){}
    }
    
    public static string formatdate(date Fecha){
        string result = DateTime.newInstance(Fecha.year(), Fecha.month(), Fecha.day(), 0, 0, 0).format('dd/MM/yyyy');
        return result;
    }
    public static string icoaddDate(date Fecha){
        string result='';
        if(Fecha.addDays(60)<System.today() && Fecha != null) {
                result = '/resource/bbva_icon_alert';
            }
        return result;
    }
    public static string icoaddNetCash(string net_cash){
        string result='';
        if(String.isNotEmpty(net_cash)){
            result = '/resource/Green_Flag_Icon';
        }
        return result;
    }
}