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
public without sharing class BE_CustomQuickAction_Ctr {
  /** class Name */ 
  final static String CLASS_NAME='className';
  /** mapReturn */
  static Map<String,Object> mapReturn = new Map<String,Object>();
  /** Response variable */
  static BE_CustomQuickActionCRUD_Cls.Response res;
  /** Private Constructor */
  private BE_CustomQuickAction_Ctr() {} 
  /**
     @Description get Metadata Config
     @param  nameMetadata DeveloperName of Metadata for QuickAction
     @return Map<String,Object>
  */
  @AuraEnabled (cacheable=true)
  public static Map<String,Object> getSettings(String nameMetadata, String recordId) {
    final BE_SingleRelatedList_QuickAction__mdt mdt = [SELECT Id, Title__c ,CustomFields__c, sObjectType__c, ClassName__c, ModeAction__c, Redirect__c FROM BE_SingleRelatedList_QuickAction__mdt WHERE DeveloperName = :nameMetadata LIMIT 1];
    mdt.CustomFields__c = mdt.CustomFields__c.replaceAll(': "UserId"', ': "'+System.UserInfo.getUserId()+'"');
    mdt.CustomFields__c = mdt.CustomFields__c.replaceAll(': "recordId"', ': "'+recordId+'"');
    final List<String> replaceFields= new List<String>();
    final User currentUser = [Select prof_position_id__c From User Where Id = :UserInfo.getUserId() LIMIT 1];
    //boolean isExcecutiveUser = false; 
    Boolean isExcecutiveUser = label.lblEjecutivoCode.split(',').contains(currentUser.prof_position_id__c);

    
    /*for( string label :  label.lblEjecutivoCode.split(',')) {
        if( label.equals(currentUser.prof_position_id__c) ) {
        	isExcecutiveUser = true;
            break;
        }
        system.debug('s');
    }*/
      
    for (Fields fieldItem : (List<Fields>)JSON.deserialize(mdt.CustomFields__c,List<Fields>.class)) {
        if(String.isNotEmpty(fieldItem.replaced)) {
            replaceFields.add((String)fieldItem.replaced);
        }
    }
      
    final Integer sizeFields=0;
    if(replaceFields.size()>sizeFields) {
        final Id sObjId = recordId;
        final String sObjectType = sObjId.getSObjectType().getDescribe().getName();
        final String query= 'SELECT '+ String.join(replaceFields, ',') + ' FROM '+sObjectType+' WHERE Id=:recordId';
        final SObject sObj= Database.query(String.escapeSingleQuotes(query));
        for (String fieldReplace : replaceFields) {
             mdt.CustomFields__c =mdt.CustomFields__c.replaceAll('"replaced": "'+fieldReplace+'"', '"value": "'+sObj.get(fieldReplace)+'"');
        }
    }
    mapReturn.put('title', mdt.Title__c);
    mapReturn.put('sObjectFields', JSON.deserializeUntyped(mdt.CustomFields__c));
  	mapReturn.put('sObjectType', mdt.sObjectType__c);
  	mapReturn.put('className', mdt.ClassName__c);
  	mapReturn.put('modeAction', mdt.ModeAction__c);
    mapReturn.put('redirect',mdt.redirect__c);
    mapReturn.put('isExcecutiveUser',isExcecutiveUser);
    return mapReturn;
  }

  /**
   @Description get Account
   @param   params Map<String,Object>
   @param  sObjFields fields to Query
   @return Account
 */
  @AuraEnabled(cacheable=false)
  public static SObject getsObjFields(Map<String,Object> params,List<String> sObjFields) {
    SObject returnObj;
      if(String.isEmpty((String)params.get('Id')) || (String)params.get('action')=='create') {
          final Map<String, Schema.SObjectType> schemaDesc = Schema.getGlobalDescribe(); 
          final Schema.SObjectType schemaType = schemaDesc.get((String)params.get('sObjectType'));
          returnObj = schemaType.newSobject();
      } else {
          final String query= 'SELECT '+ String.join(sObjFields, ',') + 
          ' FROM '+ (String)params.get('sObjectType') +' WHERE Id=@@'+(String)params.get('Id')+'@@';
          System.debug('##QUERY#'+String.escapeSingleQuotes(query).replace('@@','\''));
          System.debug('###QUERY##'+query);
          returnObj = Database.query(String.escapeSingleQuotes(query).replace('@@','\''));
      }
      System.debug('returnObj');
      return returnObj;
  }
  /**
   @Description update records with standard or custom Class Extends
   @param sObj SObject to update
   @param className custom claseName
   @return a Object type BE_CustomQuickActionCRUD_Cls.Response
  */
  @AuraEnabled
  public static Object createRecord(sObject sObj,Map<String,Object> params) {
      res=new BE_CustomQuickActionCRUD_Cls.Response();
      if(String.isNotBlank((String)params.get(CLASS_NAME))) {
          final BE_CustomQuickActionCRUD_Cls singleClas=(BE_CustomQuickActionCRUD_Cls)Type.forName((String)params.get(CLASS_NAME)).newInstance();
          res=singleClas.createRecord(sObj,params);
      } else {
          res = returnResponse(sObj, 'insert');
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
  public static Object updateRecord(sObject sObj,Map<String,Object> params) {
          res=new BE_CustomQuickActionCRUD_Cls.Response();
          if(String.isNotBlank((String)params.get(CLASS_NAME))) {
              final BE_CustomQuickActionCRUD_Cls singleClas=(BE_CustomQuickActionCRUD_Cls)Type.forName((String)params.get(CLASS_NAME)).newInstance();
              res=singleClas.updateRecord(sObj,params);
          } else {
            res = returnResponse(sObj, 'update');
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
  public static Object deleteRecord(sObject sObj,Map<String,Object> params) {
          res=new BE_CustomQuickActionCRUD_Cls.Response();
          if(String.isNotBlank((String)params.get(CLASS_NAME))) {
              final BE_CustomQuickActionCRUD_Cls singleClas=(BE_CustomQuickActionCRUD_Cls)Type.forName((String)params.get(CLASS_NAME)).newInstance();
              res=singleClas.deleteRecord(sObj,params);
          } else {
              res = returnResponse(sObj, 'delete');
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
          res = new BE_CustomQuickActionCRUD_Cls.Response(true, 'Successfull');
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

  /** Class Fields */
  public class Fields {
    /** fieldName */
    public String  fieldName {set;get;}
    /** replaced */
    public String  replaced {set;get;}
  }
 
}