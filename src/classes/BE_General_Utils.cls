/**
----------------------------------------------------------------------------------------------------
@Name <BE_General_Utils>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2019-09-13
@Description Class  contains generic logic to use in differents classes.
@Changes
    Date        Author   Email                  Type        
    2020-02-21  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
 */
public without sharing class BE_General_Utils {
    public BE_General_Utils() {

    }
    public static  Map<String,Schema.RecordTypeInfo> getRecordTypeInfo(List<String> sObjName){
        //Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new String[]{sObjName});
        Map<String,Schema.RecordTypeInfo> recordTypeInfo;
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(sObjName);
        for(Schema.DescribeSObjectResult schRes: descResult){
            recordTypeInfo=schRes.getRecordTypeInfosByDeveloperName();
        }
        return recordTypeInfo;
    }
}