/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Contact_Edit_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date  2020-09-02
   @Description BE_Contact_Edit_Ctr class to call
   @Changes
   Date        Author   Email                  Type
   2020-09-02  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_Contact_Edit_Ctr extends BE_CustomQuickActionCRUD_Cls {
    /** Lang Code */
    private static final List<String> RECORD_TYPE = new List<String> {'Record_Type_Non_Client','Record_Type_Client'};
    /**
    @Description updateRecord
    @param  sObject sObj
    @return BE_CustomQuickActionCRUD_Cls.Response response
    */
    public override BE_CustomQuickActionCRUD_Cls.Response updateRecord(sObject sObj) {
            final BE_CustomQuickActionCRUD_Cls.Response res=new BE_CustomQuickActionCRUD_Cls.Response();
            final Contact conNew=(Contact)sObj;
            final Contact conOld=[SELECT ID,contact_code__c, AccountId,Account.RecordType.DeveloperName FROM Contact WHERE Id=:(Id)sObj.get('Id')];
		    final String rtAccDevNameNew = [SELECT Id, RecordType.DeveloperName FROM Account WHERE Id=:(Id)sObj.get('AccountId')].RecordType.DeveloperName;
            if (conOld.Account.RecordType.DeveloperName==RECORD_TYPE[0] && rtAccDevNameNew==RECORD_TYPE[0] && conOld.AccountId!=conNew.AccountId) {
                return deleteCreateContact(conOld, conNew, sObj);
            } else if (conOld.Account.RecordType.DeveloperName==RECORD_TYPE[0] && rtAccDevNameNew==RECORD_TYPE[1]) {
                /**DELETE CONTACT RELATIONSHIP */
                return deleteContact(conOld, sObj);
            } else if (conOld.Account.RecordType.DeveloperName==RECORD_TYPE[1] && rtAccDevNameNew==RECORD_TYPE[0]) {
                /**CREATE CONTACT RELATIONSHIP */
                return createContact(conNew, sObj);
            } else if (conOld.Account.RecordType.DeveloperName==RECORD_TYPE[0] && rtAccDevNameNew==RECORD_TYPE[0] && conOld.AccountId==conNew.AccountId) {
                /**MODIFY CONTACT RELATIONSHIP */
                return modifyContact(conNew, conOld, sObj);
            } else {
                res.isSuccess=true;
                res.message='Successfull';
                res.data=sObj;
            }
            if(res.isSuccess) {
                update sObj;
            }
            return res;
    }

    /** deleteCreateContact */
    public BE_CustomQuickActionCRUD_Cls.Response deleteCreateContact(Contact conOld, Contact conNew, SObject sObj) {
        /**DELETE AND CREATE CONTACT RELATIONSHIP */
        final BE_CustomQuickActionCRUD_Cls.Response res=new BE_CustomQuickActionCRUD_Cls.Response();
        final Id accConRelId=[SELECT Id FROM  AccountContactRelation WHERE AccountId=:conOld.AccountId AND ContactId=:conOld.Id].Id;
        final BE_SingleRelatedListCRUD_Cls.Response resSrvDelete=BE_NonClient_DeleteContact_Helper.deleteNonClientContact(accConRelId,false);
        res.isSuccess=resSrvDelete.isSuccess;
        res.message=resSrvDelete.message;
        if(res.isSuccess) {
            final BE_SingleRelatedListCRUD_Cls.Response resSrvCreate=BE_NonClient_CreateContact_Helper.createNonClientContact(conNew,conNew.AccountId, false);
            res.isSuccess=resSrvCreate.isSuccess;
            res.message=resSrvCreate.message;
            res.data=sObj;
        }
        return res;
    }
    /** deleteContact */
    public BE_CustomQuickActionCRUD_Cls.Response deleteContact(Contact conOld,SObject sObj) {
        /**DELETE CONTACT RELATIONSHIP */
        final BE_CustomQuickActionCRUD_Cls.Response res=new BE_CustomQuickActionCRUD_Cls.Response();
        final Id accConRelId=[SELECT Id FROM  AccountContactRelation WHERE AccountId=:conOld.AccountId AND ContactId=:conOld.Id].Id;
        final BE_SingleRelatedListCRUD_Cls.Response resService=BE_NonClient_DeleteContact_Helper.deleteNonClientContact(accConRelId,false);
        res.isSuccess=resService.isSuccess;
        res.message=resService.message;
        res.data=sObj;
        return res;
    }
    /** createContact */
    public BE_CustomQuickActionCRUD_Cls.Response createContact(Contact conNew,SObject sObj) {
        /**CREATE CONTACT RELATIONSHIP */
        final BE_CustomQuickActionCRUD_Cls.Response res=new BE_CustomQuickActionCRUD_Cls.Response();
        final BE_SingleRelatedListCRUD_Cls.Response resService=BE_NonClient_CreateContact_Helper.createNonClientContact(conNew,conNew.AccountId, false);
        res.isSuccess=resService.isSuccess;
        res.message=resService.message;
        res.data=sObj;
        return res;
    }
    /** modifyContact */
    public BE_CustomQuickActionCRUD_Cls.Response modifyContact(Contact conNew, Contact conOld,SObject sObj) {
        /**MODIFY CONTACT RELATIONSHIP */
        final BE_CustomQuickActionCRUD_Cls.Response res=new BE_CustomQuickActionCRUD_Cls.Response();
        conNew.contact_code__c=conOld.contact_code__c;
        final BE_SingleRelatedListCRUD_Cls.Response resService=BE_NonClient_ModifyContact_Helper.modifyNonClientContact(conNew, false,'Contact');
        res.isSuccess=resService.isSuccess;
        res.message=resService.message;
        res.data=sObj;
        return res;
    }

}
