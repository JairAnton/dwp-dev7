@isTest(SeeAllData=true)
public class GetCaseOwnerOrQueueMembers_Test {
	
    @isTest
    public static void setup(){
        List<Group> gList = new List<Group>();
        Group g1 = new Group(Name = 'TestTier1', Type = 'Queue');
        gList.add(g1);
        Group g2 = new Group(Name = 'TestTier2', Type = 'Queue');
        gList.add(g2);
        Group g3 = new Group(Name = 'TestAnalistTier1', Type = 'Regular');
        gList.add(g3);
        Group g4 = new Group(Name = 'TestAnalistTier2', Type = 'Regular');
        gList.add(g4);
        insert gList;
        User testUser1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
        User testUser2 = TestFactory.createUser('TestUser2', 'Ejecutivo');
        User testUser3 = TestFactory.createUser('TestUser3', 'Ejecutivo');
        List<GroupMember> gmList = new List<GroupMember>();
        GroupMember gm1 = new GroupMember(GroupId = g3.Id, UserOrGroupId = testUser1.Id);
        gmList.add(gm1);
        GroupMember gm2 = new GroupMember(GroupId = g3.Id, UserOrGroupId = testUser2.Id);
        gmList.add(gm2);
        GroupMember gm3 = new GroupMember(GroupId = g3.Id, UserOrGroupId = g4.Id);
        gmList.add(gm3);
        GroupMember gm4 = new GroupMember(GroupId = g4.Id, UserOrGroupId = testUser3.Id);
        gmList.add(gm4);
        GroupMember gm5 = new GroupMember(GroupId = g1.Id, UserOrGroupId = g3.Id);
        gmList.add(gm5);
        GroupMember gm6 = new GroupMember(GroupId = g2.Id, UserOrGroupId = g4.Id);
        gmList.add(gm6);
        insert gmList;
    }

    @isTest
    public static void caseA(){
        setup();
        List<Group> groupList = [select Id from Group where Name='TestTier1'];
        List<User> listUser = [select Id, LastName from User where LastName='TestUser1uLast2'];

        QueueSobject mappingObject = new QueueSobject(QueueId = groupList[0].Id, SobjectType = 'Case');
		System.runAs(new User(Id = UserInfo.getUserId()))
		{insert mappingObject;}

        List<Case> caseList = new List<Case>();
        Case case1 = new Case(OwnerId = groupList[0].Id);
        caseList.add(case1);
        insert caseList;
        List<Id> sendInfo = new List<Id>();
        for(Case c: caseList) {
            sendInfo.add(c.Id);
        }
        System.runAs(listUser[0]){
            Map<id,List<Id>> result = GetCaseOwnerOrQueueMembers.getRecipients(sendInfo, 'Case');
            List<Id> resultId = result.get(sendInfo[0]);
            System.assertEquals(2, resultId.size());
        }
    }

    @isTest
    public static void caseB(){
        setup();
        List<Group> groupList = [select Id from Group where Name='TestTier2'];
        List<User> listUser = [select Id, LastName from User where LastName='TestUser1uLast2'];

        QueueSobject mappingObject = new QueueSobject(QueueId = groupList[0].Id, SobjectType = 'Case');
		System.runAs(new User(Id = UserInfo.getUserId()))
		{insert mappingObject;}

        List<Case> caseList = new List<Case>();
        Case case1 = new Case(OwnerId = groupList[0].Id);
        caseList.add(case1);
        insert caseList;
        List<Id> sendInfo = new List<Id>();
        for(Case c: caseList) {
            sendInfo.add(c.Id);
        }
        System.runAs(listUser[0]){
            Map<id,List<Id>> result = GetCaseOwnerOrQueueMembers.getRecipients(sendInfo, 'Case'); 
        	List<Id> resultId = result.get(sendInfo[0]);
            System.assertEquals(1, resultId.size());
        }
    }

    @isTest
    public static void caseC(){
        setup();
        List<Group> groupList = [select Id from Group where Name='TestTier2'];
        List<User> listUser = [select Id, LastName from User where LastName='TestUser1uLast2'];
        System.debug(listUser);
        QueueSobject mappingObject = new QueueSobject(QueueId = groupList[0].Id, SobjectType = 'Case');
		System.runAs(new User(Id = UserInfo.getUserId()))
		{insert mappingObject;}

        List<Case> caseList = new List<Case>();
        Case case1 = new Case(OwnerId = groupList[0].Id);
        caseList.add(case1);
        insert caseList;
        List<Id> sendInfo = new List<Id>();
        for(Case c: caseList) {
            sendInfo.add(c.Id);
        }
        System.runAs(listUser[0]){
            Map<id,List<Id>> result = GetCaseOwnerOrQueueMembers.getRecipients(sendInfo, 'Case'); 
        	List<Id> resultId = result.get(sendInfo[0]);
            System.assertEquals(1, resultId.size());
        }
    }

    @isTest
    public static void caseD(){
        setup();
        List<Group> groupList = [select Id from Group where Name='TestTier2'];
        List<User> listUser = [select Id, LastName from User where LastName='TestUser1uLast2'];
        QueueSobject mappingObject = new QueueSobject(QueueId = groupList[0].Id, SobjectType = 'Case');
		System.runAs(new User(Id = UserInfo.getUserId()))
		{insert mappingObject;}

        List<Case> caseList = new List<Case>();
        Case case1 = new Case(OwnerId = listUser[0].Id);
        caseList.add(case1);
        insert caseList;
        List<Id> sendInfo = new List<Id>();
        for(Case c: caseList) {
            sendInfo.add(c.Id);
        }
        System.runAs(listUser[0]){
            Map<id,List<Id>> result = GetCaseOwnerOrQueueMembers.getRecipients(sendInfo, 'Case');
            System.assertEquals(0, result.size());
        }
    }
}