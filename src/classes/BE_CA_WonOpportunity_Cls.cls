/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CA_WonOpportunity_Cls>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description BE_CA_WonOpportunity_Cls class
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_CA_WonOpportunity_Cls {
    /** class Name */ 
  	final static String WON_STAGE='03';
    
    /* constructor */
    private BE_CA_WonOpportunity_Cls() {
        
    }
	/**
     @Description get Metadata Config
     @param  nameMetadata DeveloperName of Metadata for QuickAction
     @return Map<String,Object>
  	*/
	public static void updateToWonCommAlert(Map<id, Opportunity> oppsNewMap,Map<id, Opportunity> oppsOldMap) {
        List<altm__Commercial_Alert__c> commAlerts = new List<altm__Commercial_Alert__c>();
		for(Opportunity opNew : oppsNewMap.values()) {
            if(String.isNotBlank(opNew.commercial_alert_id__c)&& opNew.IsWon==true && oppsOldMap.get(opNew.Id).IsWon==false) {
                commAlerts.add(new altm__Commercial_Alert__c(Id=opNew.commercial_alert_id__c,altm__alert_stage_type__c=WON_STAGE));
            }
        }
        if(!commAlerts.isEmpty()) {
           update commAlerts;
        }
    }
}