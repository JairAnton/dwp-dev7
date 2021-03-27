/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_CA_CustomTeam_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2021-03-10
   @Description Class test BE_CA_CustomTeam_Cls
   @Changes
    Date        Author   Email                  			Type		Description
    2021-03-10  LMBR     lolo.bravo@bbva.com    			Creation
   ----------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_CA_CustomTeam_Tst {
    /** Test Method readRecordsTest */
    @Istest
    public static void readRecordsTest() {
        final Account acc = TestFactory.createAccount();
        final Map<String,Object> param = new Map<String,Object>{'recordId'=>acc.Id,'sObjFields'=>'Id,Name','sObjName'=>'Account','filterSQOL'=>'Id=:recordID'};
    	final BE_CA_CustomTeam_Cls cTeam= new BE_CA_CustomTeam_Cls();
        final BE_SingleRelatedListCRUD_Cls.Response res=cTeam.readRecords(param);
        System.assert(res.isSuccess,'Success Read');
      }
   	 /** Test Method createRecords */
     @Istest
     public static void createRecords() {
        final User cUser= TestFactory.createUser('testuseralertTeam', 'Ejecutivo');
        final User cUser2= TestFactory.createUser('testuseralertTeam2', 'Ejecutivo');
        final altm__Commercial_Alert__c commAlert= new altm__Commercial_Alert__c(Name='Test_CommAlert',OwnerId=cUser.Id);
        final ctcp__Custom_Team__c cTeam = new ctcp__Custom_Team__c(Commercial_Alert__c=commAlert.id,ctcp__gf_team_users_desc__c=cUser2.id);
    	final BE_CA_CustomTeam_Cls cClass= new BE_CA_CustomTeam_Cls();
        final BE_SingleRelatedListCRUD_Cls.Response res=cClass.createRecords(new List<ctcp__Custom_Team__c>{cTeam});
        System.assert(!res.isSuccess,'Success Create');
      }
}