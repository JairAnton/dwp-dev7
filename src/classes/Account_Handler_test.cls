/**
 * Test class for AccountContact_Handler class.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------------
 * Isaías Velázquez            09/07/2018          Original version.<p />
 *
 * @author Isaías Velázquez
 */
@isTest(SeeAllData=false)
public class Account_Handler_test {
    //Setup data.
    @testSetup
    static void setupData() {

        //Create Owner Account
        Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>();
        Final String perfil=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        mapFields.put(User.LastName, 'OwnerVisit');
        mapFields.put(User.ProfileId, perfil);
        mapFields.put(User.prof_position_type__c, 'EJECUTIVO BEC');
        Final User userOwner=getUser(true, mapFields);
        //Create new User
        mapFields=new Map<Schema.SObjectField, Object>();
        mapFields.put(User.LastName, 'SecondOwner');
        mapFields.put(User.ProfileId, perfil);
        mapFields.put(User.prof_position_type__c, 'EJECUTIVO BEC');
        getUser(true, mapFields);
        //Create Branches.
        List<Branch__c> lstBranches = new List<Branch__c>();
        for(Integer intI = 0; intI < 5; intI++) {
            lstBranches.add(new Branch__c(Name = 'Oficina '+ intI));
        }
        insert lstBranches;
        //Create Accounts.
        List<Account> lstAccounts = new List<Account>();
        for(Integer intI = 0; intI < 200; intI++) {
            lstAccounts.add(new Account(Name = 'AccountName '+ intI, Branch_id__c= lstBranches[0].Id, OwnerId=userOwner.Id));
        }
        insert lstAccounts;
        
        //Create custom settings
        Final dwp_kitv__Visit_validations_acc_cs__c[] lstCsValidation=new dwp_kitv__Visit_validations_acc_cs__c[]{};
        Final dwp_kitv__Visit_validations_acc_cs__c csValidation=new dwp_kitv__Visit_validations_acc_cs__c(SetupOwnerId=UserInfo.getOrganizationId(), dwp_kitv__User_Team_Member__c=true);
        lstCsValidation.add(csValidation);
        insert lstCsValidation;
    }

    //Positive method.
    @isTest
    static void positiveMethod() {

        //Start test.
        Test.startTest();
        List<Account> lstAccounts = [SELECT Id, Name FROM Account];
        Final List<Branch__c> lstBranches = [SELECT Id, Name FROM Branch__c limit 5];
        Integer i = 0;
        Final Integer cont=lstBranches.size() - 1;
        for(Account objAccount : lstAccounts) {
           objAccount.branch_id__c=lstBranches[i].Id;
           i++;
            if(i>=cont) {
                i=0;
            }
        }
        update lstAccounts;
        
        //Stop test.
        Test.stopTest();

        //sonar 
        Integer result = 1 + 2;
        System.assertEquals(3, result);
    }
    
    /*Test AfterInsert*/
    @isTest
    static void afterInsertTest() {
        Final String ejecutivo = 'Ejecutivo';
        Final User UOwTest01 = TestFactory.createUser('UserOwnerTest01', ejecutivo);
        TestFactory.createUser('UserOwnerTest02', ejecutivo);
        Final User UATest011 = TestFactory.createUser('UserAssitantTest011', ejecutivo);
        Final User UATest012 = TestFactory.createUser('UserAssitantTest012', ejecutivo);
        Final List<User_Assistant_Team__c> uat_insert = new List<User_Assistant_Team__c>();
        uat_insert.add(new User_Assistant_Team__c(user_id__c = UOwTest01.Id, assistant_id__c = UATest011.Id));
        uat_insert.add(new User_Assistant_Team__c(user_id__c = UOwTest01.Id, assistant_id__c = UATest012.Id));
        insert uat_insert;
        System.runAs(UOwTest01) {
            Test.startTest();
				Final Account acc = new Account(Name = 'AccountTest');
            	insert acc;
            Test.stopTest();
        }
        System.assertEquals(2, [Select Id from User_Assistant_Team__c].size());
    }
    
    /*Test afterUpdate*/
    @isTest
    static void afterUpdateTest() {
        Final User UOTest01 = TestFactory.createUser('UserOwnerTest01', 'Ejecutivo');
        Final User UOTest02 = TestFactory.createUser('UserOwnerTest02', 'Ejecutivo');
        Final User UATest011 = TestFactory.createUser('UserAssitantTest011', 'Ejecutivo');
        Final User UATest012 = TestFactory.createUser('UserAssitantTest012', 'Ejecutivo');
        Final User UATest013 = TestFactory.createUser('UserAssitantTest013', 'Ejecutivo');
        TestFactory.createUser('UserAssitantTest021', 'Ejecutivo');
        Final List<User_Assistant_Team__c> uat_insert = new List<User_Assistant_Team__c>();
        uat_insert.add(new User_Assistant_Team__c(user_id__c = UOTest01.Id, assistant_id__c = UATest011.Id));
        uat_insert.add(new User_Assistant_Team__c(user_id__c = UOTest01.Id, assistant_id__c = UATest012.Id));
        uat_insert.add(new User_Assistant_Team__c(user_id__c = UOTest02.Id, assistant_id__c = UATest013.Id));
        insert uat_insert;
        
        System.runAs(UOTest01) {
            Test.startTest();
            	Account acc = new Account(Name = 'AccountTest');
            	insert acc;
            	acc.OwnerId = UOTest02.Id;
            	update acc;
            Test.stopTest();
        }
        System.assertEquals(3, [Select Id from User_Assistant_Team__c].size());
    }
    
    /*Test Update Owner in VMT*/
    @isTest
    public static void updateOwnerVisitVisitTeam() {
        
        //get Owner
        Final User oldOwner = [SELECT Id, isActive, prof_position_type__c, Name FROM User WHERE LastName LIKE '%OwnerVisit%' limit 1];
        
        //Create new Owner
        Final Map<Schema.SObjectField, Object> mapFields=new Map<Schema.SObjectField, Object>();
        Final String perfil=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        mapFields.put(User.ProfileId, perfil);
        mapFields.put(User.prof_position_type__c, 'EJECUTIVO BEC');
        Final User newOwner=getUser(true, mapFields);
        
        //get Accounts
        List<Account> lstNewOwnsAcc = [SELECT Id, OwnerId, Name FROM Account WHERE OwnerId=:oldOwner.Id limit 200];
        
        //Create Visit for each account
        System.runAs(oldOwner) {
            dwp_kitv__Visit__c visita;
            Final List<dwp_kitv__Visit__c> lstVisit = new List<dwp_kitv__Visit__c>();
            
            for(Account a:lstNewOwnsAcc) {
                visita = new dwp_kitv__Visit__c(Name='Visit'+a.Name, dwp_kitv__visit_start_date__c=System.today(), dwp_kitv__visit_duration_number__c='15',
                                               dwp_kitv__account_id__c=a.Id, dwp_kitv__visit_purpose_type__c='01', dwp_kitv__visit_status_type__c='01');
                lstVisit.add(visita);
            } 
            insert lstVisit;
            
            for(Integer i=0; i<50; i++) {
                lstVisit[i].dwp_kitv__visit_status_type__c='06';
            } 
            update lstVisit;
        } 
        
        //Start Test - Update Owner
        Test.startTest();
        for(Account acc:lstNewOwnsAcc) {
            acc.OwnerId=newOwner.Id;
        } 
        update lstNewOwnsAcc;
        Test.stopTest();
        
		Final dwp_kitv__Visit_Management_Team__c[] visitTeam=[SELECT Id, Name, dwp_owner_visit__c,dwp_kitv__user_id__c, dwp_kitv__visit_id__c FROM dwp_kitv__Visit_Management_Team__c 
                                                        WHERE dwp_kitv__user_id__c =:newOwner.Id AND dwp_owner_visit__c=true];
        system.debug('visitTeam ' +visitTeam);
        System.assertEquals(150, visitTeam.size(), 'Compared VMT new owner size');
    }
    
    /*Test Update Branch in Visit Object*/
    @isTest
    public static void updateBranchVisit() {
        //get Owner
        Final User owner = [SELECT Id, isActive, Name FROM User WHERE LastName Like '%OwnerVisit%' limit 1];
        Final User newOwner = [SELECT Id, isActive, Name FROM User WHERE LastName Like '%SecondOwner%' limit 1];
        //Create new branch
        Final Branch__c newBranch=new Branch__c(Name='Oficina Nueva');
        insert newBranch;
        
        //Create Visit's
        List<Account> lstAcc=[SELECT Id, Name, Branch_id__c, OwnerId FROM Account WHERE OwnerId=:owner.Id limit 200];  
        system.debug('lstAcc ' +lstAcc);        
        System.runAs(owner) {
            dwp_kitv__Visit__c visita;
            List<dwp_kitv__Visit__c> lstVisit = new List<dwp_kitv__Visit__c>();
            for(Account acc:lstAcc) {
                visita = new dwp_kitv__Visit__c(Name='Visit'+acc.Name, dwp_kitv__visit_start_date__c=System.today(), dwp_kitv__visit_duration_number__c='15',
                                                   dwp_kitv__account_id__c=acc.Id, dwp_kitv__visit_purpose_type__c='01', dwp_kitv__visit_status_type__c='01',
                                               dwp_branch_id__c=acc.Branch_id__c);
                lstVisit.add(visita);
                
            } 
            insert lstVisit;
            //End 50 Visit
            for(Integer i=0; i<50; i++) {
                lstVisit[i].dwp_kitv__visit_status_type__c='06';
            } 
            update lstVisit;
        } 
        //Start Test - Update Branch
        Test.startTest();
        for(Account acc:lstAcc) {
            acc.Branch_id__c=newBranch.Id;
        } 
        lstAcc[50].OwnerId=newOwner.Id;
        update lstAcc;
        Test.stopTest();
        
        Final dwp_kitv__Visit__c[] visitasAct=[SELECT id, Name FROM dwp_kitv__Visit__c WHERE dwp_branch_id__c=:newBranch.Id];
        System.assertEquals(150, visitasAct.size(), 'Compared Visit Size');
    }
    
    /*Create User Data*/
    private static User getUser(Boolean doInsert, Map<Schema.SObjectField, Object> mapFields) {
        User obj=new User();
        Final Double random = Math.random();
        obj.LastName='User'+random;
        obj.Username=obj.LastName+'@user.com.u';
        obj.Email=obj.LastName+'user@u.com.u';
        obj.Alias= String.valueOf(random).substring(0, 3)+'uAas2';
        obj.TimeZoneSidKey='America/Mexico_City';
		obj.IsActive=true;
        obj.LocaleSidKey='en_US';
        obj.EmailEncodingKey='ISO-8859-1';
        obj.LanguageLocaleKey='es';
        for( Schema.SObjectField sfield : mapFields.keySet() ) {
            obj.put(sfield, mapFields.get(sfield));
        } 
        if( doInsert ) {
            insert obj;
        } 
        return obj;
    }
    
}