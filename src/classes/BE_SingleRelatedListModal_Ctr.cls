/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SingleRelatedListModal_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-11
   @Description Controller Class for BE_SingleRelatedListModal_Lwc
   @Changes
   Date        Author   Email                  Type
   2020-03-11  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SingleRelatedListModal_Ctr {
    /** Response variable */
    static BE_SingleRelatedListCRUD_Cls.Response res;
    /** private constructor */
    private BE_SingleRelatedListModal_Ctr() {}
    /**
     @Description insert records with standard or custom Class Extends
     @param sObjs List<SObject> to insert
     @param className custom claseName
     @return a Object type BE_SingleRelatedListCRUD_Cls.Response
   */
    @AuraEnabled
    public static Object createRecords(List<SObject> sObjs,String className) {
        res=new BE_SingleRelatedListCRUD_Cls.Response();
        if(String.isNotBlank(className)) {
            final BE_SingleRelatedListCRUD_Cls singleClas=(BE_SingleRelatedListCRUD_Cls)Type.forName(className).newInstance();
            res=singleClas.createRecords(sObjs);
        } else {
            try {
                insert sObjs;
                res.isSuccess=true;
                res.message='Successful';
                res.data=sObjs;
            } catch (Exception ex) {
                res.isSuccess=false;
                res.message=ex.getMessage();
            }
        }
        return res;
    }
    
    /**
     @Description update records with standard or custom Class Extends
     @param sObjs List<SObject> to update
     @param className custom claseName
     @return a Object type BE_SingleRelatedListCRUD_Cls.Response
    */
    @AuraEnabled
    public static Object updateRecords(List<SObject> sObjs,String className) {
        res=new BE_SingleRelatedListCRUD_Cls.Response();
        if(String.isNotBlank(className)) {
            final BE_SingleRelatedListCRUD_Cls singleClas=(BE_SingleRelatedListCRUD_Cls)Type.forName(className).newInstance();
            res=singleClas.updateRecords(sObjs);
        } else {
            try {
                update sObjs;
                res.isSuccess=true;
                res.message='Successfull';
                res.data=sObjs;
            } catch (Exception ex) {
                res.isSuccess=false;
                res.message=ex.getMessage();
            }
        }
        return res;
    }
    
    /**
     @Description delete records with standard or custom Class Extends
     @param sObjs List<SObject> to update
     @param className custom claseName
     @return a Object type BE_SingleRelatedListCRUD_Cls.Response
    */
    @AuraEnabled
    public static Object deleteRecords(List<SObject> sObjs,String className) {
        res=new BE_SingleRelatedListCRUD_Cls.Response();
        if(String.isNotBlank(className)) {
            final BE_SingleRelatedListCRUD_Cls singleClas=(BE_SingleRelatedListCRUD_Cls)Type.forName(className).newInstance();
            res=singleClas.deleteRecords(sObjs);
        } else {
            try {
                delete sObjs;
                res.isSuccess=true;
                res.message='Successfull';
            } catch (Exception ex) {
                res.isSuccess=false;
                res.message=ex.getMessage();
            }
        }
        return res;
    }
}
