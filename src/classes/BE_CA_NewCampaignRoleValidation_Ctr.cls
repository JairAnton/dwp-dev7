/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CustomQuickAction_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description BE_CustomQuickAction_Ctr class
   @Changes
   Date        Author   Email                                       Type
   2020-03-03  LMBR     luis.vargas.matute.contractor@bbva.com      Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_CA_NewCampaignRoleValidation_Ctr {
  /** mapReturn */
  static Map<String,Object> mapReturn = new Map<String,Object>();
  /** Private Constructor */
  private BE_CA_NewCampaignRoleValidation_Ctr () {} 
     
  /**
     @Description get Metadata Config
     @param  nameMetadata DeveloperName of Metadata for QuickAction
     @return Map<String,Object>
  */
  @AuraEnabled(cacheable=true)
  public static Map<String,Object> validateUser() {
     System.debug('######## VALIDATE USER START ###########');
    final User currentUser = [Select prof_position_id__c From User Where Id = :UserInfo.getUserId() LIMIT 1];
    Boolean isExcecutiveUser = label.lblEjecutivoCode.split(',').contains(currentUser.prof_position_id__c);

    mapReturn.put('isExcecutiveUser',isExcecutiveUser);
    return mapReturn;
  }
     
}