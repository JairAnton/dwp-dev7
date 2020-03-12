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

    /** private constructor */
    BE_General_Utils() {}
    /**
    @Description get RecordType of different sObject
    @param  sObjName list of sObjectName
    @return  return a Map<String,Schema.RecordTypeInfo>
    */
    public static  Map<String,Schema.RecordTypeInfo> getRecordTypeInfo(List<String> sObjName) {
        Map<String,Schema.RecordTypeInfo> recordTypeInfo;
        final Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(sObjName);
        for(Schema.DescribeSObjectResult schRes: descResult){
            recordTypeInfo=schRes.getRecordTypeInfosByDeveloperName();
        }
        return recordTypeInfo;
    }
}