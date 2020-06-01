Global without sharing class formalizationButtonClass implements dwp_dbpn.DynamicFlowValidationInterface {
	global static List<String> getErrorMessagesList(String recordId, String source, String validationClass) {
		List<String> lstErrorMessage = new List<String>();

		return lstErrorMessage;
	}

	@auraenabled
	public static void updateOpp(String Idopp) {
		id id1 = userinfo.getProfileId();
		String prof = [SELECT Name FROM profile WHERE id = :id1 LIMIT 1].Name;
		Opportunity opp = [SELECT Id, StageName, OwnerID FROM Opportunity WHERE Id =:  Idopp LIMIT 1];

		if((prof == 'Ejecutivo' && userinfo.getUserId() == opp.OwnerId) || prof == 'Administrador del Sistema' || prof == 'Migracion') {
			opp.StageName = label.lblSanctionStage;
			opp.opportunity_status_type__c = label.LblStatusResultbtnSanctionRisk;
			update opp;
		}
	}
}
