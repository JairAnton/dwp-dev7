/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CustomQuickAction_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description BE_CustomQuickAction_Ctr class
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_CustomQuickAction_Ctr  {
  private BE_CustomQuickAction_Ctr() {}
  /** mapReturn */
  static Map<String,Object> mapReturn = new Map<String,Object>();
  /** Response variable */
  static BE_CustomQuickActionCRUD_Cls.Response res;
  /**
     @Description get Metadata Config
     @param  nameMetadata DeveloperName of Metadata for QuickAction
     @return Map<String,Object>
  */
  @AuraEnabled
  public static Map<String,Object> getSettings(String nameMetadata) {
  	for(BE_SingleRelatedList_QuickAction__mdt mdt : [SELECT Id, Title__c,CustomFields__c, sObjectType__c, ClassName__c, ModeAction__c FROM BE_SingleRelatedList_QuickAction__mdt WHERE DeveloperName = :nameMetadata]) {
  		mapReturn.put('title', mdt.Title__c);
  		mapReturn.put('sObjectFields', JSON.deserializeUntyped(mdt.CustomFields__c));
  		mapReturn.put('sObjectType', mdt.sObjectType__c);
  		mapReturn.put('className', mdt.ClassName__c);
  		mapReturn.put('modeAction', mdt.ModeAction__c);
  	}
  	return mapReturn;
  }

  /**
   @Description get Account
   @param  accId Id of the Account
   @param  sObjFields fields to Query
   @return Account
 */
  @AuraEnabled
  public static SObject getsObjFields(String accId,String sObjectType,  List<String> sObjFields) {
  	final String query= 'SELECT '+ String.join(sObjFields, ',') + ' FROM '+ sObjectType +' WHERE Id=:accId';
  	return Database.query(String.escapeSingleQuotes(query));
  }
  /**
   @Description update records with standard or custom Class Extends
   @param sObj SObject to update
   @param className custom claseName
   @return a Object type BE_CustomQuickActionCRUD_Cls.Response
  */
  @AuraEnabled
  public static Object createRecord(sObject sObj,String className) {
          res=new BE_CustomQuickActionCRUD_Cls.Response();
          if(String.isNotBlank(className)) {
              BE_CustomQuickActionCRUD_Cls singleClas=(BE_CustomQuickActionCRUD_Cls)Type.forName(className).newInstance();
              res=singleClas.createRecord(sObj);
          } else if(sObj!=null) {
              res = returnResponse(sObj, 'insert');
          } else {
              res.isSuccess=false;
              res.message='Error null object';
          }
          return res;
  }
  
  /**
   @Description delete records with standard or custom Class Extends
   @param sObj SObject to update
   @param className custom claseName
   @return a Object type BE_CustomQuickActionCRUD_Cls.Response
  */
  @AuraEnabled
  public static Object updateRecord(sObject sObj,String className) {
          res=new BE_CustomQuickActionCRUD_Cls.Response();
          if(String.isNotBlank(className)) {
              BE_CustomQuickActionCRUD_Cls singleClas=(BE_CustomQuickActionCRUD_Cls)Type.forName(className).newInstance();
              res=singleClas.updateRecord(sObj);
          } else if(sObj!=null) {
              res = returnResponse(sObj, 'update');
          } else {
              res.isSuccess=false;
              res.message='Error null object';
          }
          return res;
  }

  /**
   @Description update records with standard or custom Class Extends
   @param sObj SObject to delete
   @param className custom claseName
   @return a Object type BE_CustomQuickActionCRUD_Cls.Response
  */
  @AuraEnabled
  public static Object deleteRecord(sObject sObj,String className) {
          res=new BE_CustomQuickActionCRUD_Cls.Response();
          if(String.isNotBlank(className)) {
              BE_CustomQuickActionCRUD_Cls singleClas=(BE_CustomQuickActionCRUD_Cls)Type.forName(className).newInstance();
              res=singleClas.deleteRecord(sObj);
          } else if(sObj!=null) {
              res = returnResponse(sObj, 'delete');
          } else {
              res.isSuccess=false;
              res.message='Error null object';
          }
          return res;
  }

  /**
   @Description update records with standard or custom Class Extends
   @param sObj SObject
   @param action type "update","delete"
   @return a Object type BE_CustomQuickActionCRUD_Cls.Response
  */
  public static BE_CustomQuickActionCRUD_Cls.Response returnResponse(sObject sObj , String action) {
          res = new BE_CustomQuickActionCRUD_Cls.Response(true, 'Successful');
          try {
              switch on action {
                  when 'insert' {
                      insert sObj;
                  }
                  when 'update' {
                      update sObj;
                  }
                  when 'delete' {
                      delete sObj;
                  }
              }
              res.data=sObj;
          } catch (DMLException ex) {
              res.isSuccess=false;
              res.message=ex.getDmlMessage(0);
          }
          return res;
  }
}