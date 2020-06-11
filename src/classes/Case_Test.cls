/*
 * @Name: Case_Test
 * @Description: Trigger of case
 * @Create by: Yulino Cordova
 * 
 @Changes
   Date        Author   Email                  				Type
   2018-12-07  YUCO     yulino.cordova.contractor@bbva.com	Create
   2020-06-04  MAMC     martin.mori.contractor@bbva.com		Update (add recordtype of case)
*/
@isTest
public class Case_Test {
    /*
    * @Name: static var
    * @Description: user to test.
    * @author Yulino
    */
    static User usertest;
    
    /*Setup Data*/
    @testSetup //Yulino 07/12/2018 : se cambio a testSetup
    static void setData() {     
        usertest = TestFactory.createUser('caseTest', Label.profAdministrator);
    }
    
    /*
    * @Name: AfterInsertUpdate
    * @Description: call method to after insert or update case
    * @author Martin Mori
    */
    @isTest
    static void AfterInsertUpdate() {
        final List<String> sObjNames=new List<String>{'Case'};
        final Map<String,Schema.RecordTypeInfo> recordType=BE_General_Utils.getRecordTypeInfo(sObjNames);
        
        usertest = [select ID from User where id!=null limit 1];
        //setData(); //Yulino 07/12/2018 : se cambio a testSetup
        Test.startTest();
        Case casetest = new Case();
        casetest.recordTypeId = recordType.get('Sanction_Price').getRecordTypeId();
        casetest.Status = 'New';
        casetest.OwnerId = UserInfo.getUserId();
        insert casetest;
        casetest.OwnerId = usertest.Id;
        update casetest;
        Test.stopTest();
        System.assertEquals('New', casetest.Status);
    }
}
