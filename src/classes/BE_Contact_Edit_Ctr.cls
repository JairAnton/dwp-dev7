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
    /** Response */
    static BE_CustomQuickActionCRUD_Cls.Response res ;
    /**
    @Description updateRecord
    @param  sObject sObj
    @return BE_CustomQuickActionCRUD_Cls.Response response
    */
    public override BE_CustomQuickActionCRUD_Cls.Response updateRecord(sObject sObj) {
        res=new BE_CustomQuickActionCRUD_Cls.Response();
        final Contact conNew=(Contact)sObj;
        final Contact conOld=[SELECT ID,contact_code__c, AccountId,Account.RecordType.DeveloperName FROM Contact WHERE Id=:(Id)sObj.get('Id')];
		final String rtAccDevNameNew = [SELECT Id, RecordType.DeveloperName FROM Account WHERE Id=:(Id)sObj.get('AccountId')].RecordType.DeveloperName;
        String mixRecordType=conOld.Account.RecordType.DeveloperName+rtAccDevNameNew;
        switch on mixRecordType {
            when 'Record_Type_Non_ClientRecord_Type_Non_Client'  {
                if( conOld.AccountId==conNew.AccountId) {
                    res = modifyContact(conNew, conOld, sObj);
                } else {
                    res = deleteCreateContact(conOld, conNew, sObj);
                }
            }
            when 'Record_Type_Non_ClientRecord_Type_Client'{
                /**DELETE CONTACT RELATIONSHIP */
                res = deleteContact(conOld, sObj);
            }
            when 'Record_Type_ClientRecord_Type_Non_Client'{
                /**CREATE CONTACT RELATIONSHIP */
                res = createContact(conNew, sObj); 
            }
            when else {
                res.isSuccess=true;
                res.message='Contacto Modificado Satisfactoriamente';
                res.data=sObj;  
            }
        }
        if(res.isSuccess) {
            update sObj;
        }
        return res;
    }

    /** deleteCreateContact */
    public BE_CustomQuickActionCRUD_Cls.Response deleteCreateContact(Contact conOld, Contact conNew, SObject sObj) {
        /**DELETE AND CREATE CONTACT RELATIONSHIP */
        res=new BE_CustomQuickActionCRUD_Cls.Response();
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
        res=new BE_CustomQuickActionCRUD_Cls.Response();
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
        res=new BE_CustomQuickActionCRUD_Cls.Response();
        final BE_SingleRelatedListCRUD_Cls.Response resService=BE_NonClient_CreateContact_Helper.createNonClientContact(conNew,conNew.AccountId, false);
        res.isSuccess=resService.isSuccess;
        res.message=resService.message;
        res.data=sObj;
        return res;
    }
    /** modifyContact */
    public BE_CustomQuickActionCRUD_Cls.Response modifyContact(Contact conNew, Contact conOld,SObject sObj) {
        /**MODIFY CONTACT RELATIONSHIP */
        res=new BE_CustomQuickActionCRUD_Cls.Response();
        conNew.contact_code__c=conOld.contact_code__c;
        final BE_SingleRelatedListCRUD_Cls.Response resService=BE_NonClient_ModifyContact_Helper.modifyNonClientContact(conNew, false,'Contact');
        res.isSuccess=resService.isSuccess;
        res.message=resService.message;
        res.data=sObj;
        return res;
    }

}