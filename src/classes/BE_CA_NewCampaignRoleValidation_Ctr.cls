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
      final User currentUser = [Select Id, prof_position_id__c, UserRole.Name From User Where Id = :UserInfo.getUserId() LIMIT 1];
      final string gBECentral = 'OS8';
      final string gBInstitucional = 'GERENTE BANCA INSTITUCIONAL';
      final string gLTransBanking = 'GERENTE LOCAL TRANSACTIONAL BANKING';
      mapReturn.put('isExcecutiveUser',false);

      Final Boolean isExcecutiveUser = label.lblEjecutivoCode.split(',').contains(currentUser.prof_position_id__c);
      if( isExcecutiveUser ) {
          mapReturn.put('isExcecutiveUser',isExcecutiveUser);
      }

      Final Boolean isgBECentral = gBECentral.contains(currentUser.prof_position_id__c);
      if(isgBECentral) {
          mapReturn.put('isExcecutiveUser',isgBECentral);
      }
      
      Final Boolean isgBInstitucional = gBInstitucional.contains(currentUser.UserRole.Name);
      if(isgBInstitucional) {
          mapReturn.put('isExcecutiveUser',isgBInstitucional);
      }
      
      Final Boolean isgLTransBanking = gLTransBanking.contains(currentUser.UserRole.Name);
      if(isgLTransBanking) {
          mapReturn.put('isExcecutiveUser',isgLTransBanking);
      }
      return mapReturn;
  }
     
}