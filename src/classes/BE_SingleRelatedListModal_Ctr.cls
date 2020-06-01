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
    static BE_SingleRelatedListCRUD_Cls.Response res;
    BE_SingleRelatedListModal_Ctr() {}
    @AuraEnabled
    public static Object createRecords(List<SObject> sObjs,String className) {
        res=new BE_SingleRelatedListCRUD_Cls.Response();
        if(String.isNotBlank(className)) {
            BE_SingleRelatedListCRUD_Cls singleClas=(BE_SingleRelatedListCRUD_Cls)Type.forName(className).newInstance();
            res=singleClas.createRecords(sObjs);
        } else if(sObjs!=null) {
            res = returnResponse(sObjs, 'insert');
        } else {
            res.isSuccess=false;
            res.message='Error null object';
        }
        return res;
    }

    @AuraEnabled
    public static Object updateRecords(List<SObject> sObjs,String className) {
        res=new BE_SingleRelatedListCRUD_Cls.Response();
        if(String.isNotBlank(className)) {
            BE_SingleRelatedListCRUD_Cls singleClas=(BE_SingleRelatedListCRUD_Cls)Type.forName(className).newInstance();
            res=singleClas.updateRecords(sObjs);
        } else if(sObjs!=null) {
            res = returnResponse(sObjs, 'update');
        } else {
            res.isSuccess=false;
            res.message='Error null object';
        }
        return res;
    }

    @AuraEnabled
    public static Object deleteRecords(List<SObject> sObjs,String className) {
        res=new BE_SingleRelatedListCRUD_Cls.Response();
        if(String.isNotBlank(className)) {
            BE_SingleRelatedListCRUD_Cls singleClas=(BE_SingleRelatedListCRUD_Cls)Type.forName(className).newInstance();
            res=singleClas.deleteRecords(sObjs);
        } else if(sObjs!=null) {
            res = returnResponse(sObjs, 'delete');
        } else {
            res.isSuccess=false;
            res.message='Error null object';
        }
        return res;
    }

    public static BE_SingleRelatedListCRUD_Cls.Response returnResponse(List<SObject> sObjs , String action) {
        res = new BE_SingleRelatedListCRUD_Cls.Response(true, 'Successful');
        try {
            switch on action {
                when 'insert' {
                    insert sObjs;
                }
                when 'update' {
                    update sObjs;
                }
                when 'delete' {
                    delete sObjs;
                }
            }
            res.data=sObjs;
        } catch (DMLException ex) {
            res.isSuccess=false;
            res.message=ex.getDmlMessage(0);
        }
        return res;
    }

}