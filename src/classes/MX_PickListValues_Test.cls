/**
 * Desarrollado por:       Indra
 * Autor:                  Isaías Velázquez Cortés
 * Proyecto:               DWP Perú
 * Descripción:            Clase TEST para PickList Personalizado (Reutilizable)
 *
 * Cambios (Versiones)
 *************************************************************************************
 * No.    |     Fecha      |     Autor                |          Descripción
 *************************************************************************************
 * 1.0    | 27-07-2018     |    Isaías Velázquez      |           Creación
 **/
@isTest
private class MX_PickListValues_Test {
	@isTest static void TestPickList() {
		test.startTest();
		MX_PickListValues_cls.getPickListValuesIntoList('Opportunity', 'Loss_Reason__c', '');
		System.assert (true, 'This Works!');
		test.stopTest();
	}
}
