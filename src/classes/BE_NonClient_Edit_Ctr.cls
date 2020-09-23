/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_EditNonClient_Ctr>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-03-13
   @Description constructor for BE_EditNonClient_Cmp component
   @Changes
   Date        Author   Email                  				Type
   2020-03-13  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_NonClient_Edit_Ctr extends BE_CustomQuickActionCRUD_Cls {
  /**
     @Description update Non Client
     @param  sObjs Account sObject
     @return Object type BE_CustomQuickActionCRUD_Cls.Response Class
   */
  public override BE_CustomQuickActionCRUD_Cls.Response updateRecord(sObject sObj) {
    return BE_NonClient_Modify_Helper.modifyNonClient((Account)sObj);
  }
}