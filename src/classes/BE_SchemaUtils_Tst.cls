/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SchemaUtils_Tst
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2021-01-08
   @Description
   @Changes
   Date        Author   Email                  				Type
   2021-01-08  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_SchemaUtils_Tst {
    /*
	 * @Description success method
	 */
    @isTest
    static void unitTest() {
        Final List<Object> fields = new List<Object>();
      	Final Map<Object, Object> subjField = new Map<Object, Object>();
        subjField.put('fieldName','Subject');
        subjField.put('label','Asunto');
        subjField.put('type','text');
        subjField.put('required','true');
		fields.add(subjField);
        Final Map<Object, Object> slmtField = new Map<Object, Object>();
        slmtField.put('fieldName','slmt__management_plan_meeting_id__c');
        slmtField.put('label','Reunión individual');
        slmtField.put('type','search');
        slmtField.put('required','true');
		slmtField.put('disabled','true');
		fields.add(slmtField);
        Final Map<Object, Object> whatIdField = new Map<Object, Object>();
        whatIdField.put('fieldName','WhatId');
        whatIdField.put('label','Relacionado con');
        whatIdField.put('type','search');
        whatIdField.put('required','true');
        fields.add(whatIdField);
        Test.startTest();
        Final List<BE_SchemaUtils_Cls.Values> values = BE_SchemaUtils_Cls.getSObjectFieldsByList('Task', fields);
        Test.stopTest();
        System.assert(!values.isEmpty(), 'success!!!');
    }
}