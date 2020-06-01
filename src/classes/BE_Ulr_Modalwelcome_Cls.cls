/**
 * @Name     BE_Ulr_Modalwelcome_Cls
 * @Author   Antony de la rosa guzman
 * @Date     2019-04-12
 * @Group    BHI
 * @Description  Clase orquestadora encargada de llamar a  la configuracion
                personalizada para el modal de bienvenida(BE_WelcomeTabCte_Cmp) para la nueva ficha cliente WL.
 * Clase de pruebas BE_Ulr_Modalwelcome_Test.
 * _________________________________________________________________________________
 * @Changes
 * _________________________________________________________________________________
 */
public with sharing class BE_Ulr_Modalwelcome_Cls {
	/**
	 * @author Global Desktop
	 * @description Constructor de la clase
	 */
	@testVisible private BE_Ulr_Modalwelcome_Cls() {
	}
    
	/**
	 * @author Global Desktop
	 * @description Constructor de la clase
	 */
	@AuraEnabled
	public static List<BE_Urls_Dynamic__c> getlisAllData(string nameConfig) {
		return [select id, BE_Titulo_Url__c, BE_Url__c from BE_Urls_Dynamic__c where Name = : nameConfig];
	}
}
