public class GetCaseOwnerOrQueueMembers implements DynamicNotificationMessageRecipent{
    public static Map<Id,List<Id>> getRecipients(List<Id> lstrecord, String sObjectName) {
        Map<Id,List<Id>> returnValues = new Map<Id,List<Id>>();
        //Retrieve context User info
        Id contextUserId = UserInfo.getUserId();
        //Retrieve Cases info 
        List<Case> cases = [select Id, OwnerId, Owner.Type from Case where Id=:lstrecord];
        //Check Case Queue
        List<Id> queueId = new List<Id>();
        for(Case c: cases) {
            if(c.Owner.Type == 'Queue') {
                queueId.add(c.OwnerId);
            }
        }

        //Retrieve Queue members
        Map<Id,List<Id>> queueMembers = getGroupMembers(queueId);
        Set<Id> queueMembersId = queueMembers.keySet();
        for(Id qmId : queueMembersId) {
            Integer positionIndex = queueMembers.get(qmId).indexOf(contextUserId);
            if(positionIndex != -1) {
                queueMembers.get(qmId).remove(positionIndex);
            }            
        }
        
        for(Case c: cases) {
            List<Id> recipients = new List<Id>();
            if(c.Owner.Type == 'User') {
                if(contextUserId != c.OwnerId) {
                    recipients.add(c.OwnerId);                    
                }                
            } else if(c.Owner.Type == 'Queue') {
                if(queueMembers.containsKey(c.OwnerId)) {
                    recipients.addAll(queueMembers.get(c.OwnerId));
                }
            }
            if(!recipients.isEmpty()) {
                returnValues.put(c.Id, recipients);
            }
        }
        return returnValues;
    }
    
    public static Map<Id,List<Id>> getGroupMembers(List<Id> publicGroupIds) {
        Map<Id,List<Id>> publicGroupUsersMap = new  Map<Id,List<Id>>();
        
        // Retrieve input public groups members
        List<GroupMember> gm = [select UserOrGroupId, GroupId from GroupMember where GroupId=:publicGroupIds];
        List<Id> gmId = new List<Id>();
        for(GroupMember g : gm) {
            gmId.add(g.UserOrGroupId);
        }
        // Retrieve imput public groups members of type user
       	Map<Id, User> userMember = new Map<Id,User>([select Id from User where Id=:gmId]);
        
        // Retrieve imput public groups members of type group
        List<Group> groupMemberGroups = [select Id from Group where Id=:gmId and type='Regular'];
        List<Id> gmId2 = new List<Id>();
        for(Group g : groupMemberGroups) {
            gmId2.add(g.Id);
        }
        // For the groups members of type group retrieve their group members
        Map<Id,List<Id>> gruopMembersGroupMembers = new Map<Id,List<Id>>();
        if(!gmId2.isEmpty()){
            gruopMembersGroupMembers = getGroupMembers(gmId2);
        }
        
        for(GroupMember g : gm) {
            if(userMember.containsKey(g.UserOrGroupId)){
                if(publicGroupUsersMap.containsKey(g.GroupId)) {
                    publicGroupUsersMap.get(g.GroupId).add(g.UserOrGroupId);
                }
                else {
                    List<Id> users = new List<Id>();
                    users.add(g.UserOrGroupId);
                    publicGroupUsersMap.put(g.GroupId, users);
                }
            }
            if(gruopMembersGroupMembers.containsKey(g.UserOrGroupId)) {
                if(publicGroupUsersMap.containsKey(g.GroupId)) {
                    publicGroupUsersMap.get(g.GroupId).addAll(gruopMembersGroupMembers.get(g.UserOrGroupId));
                }
                else {
                    List<Id> users = new List<Id>();
                    users.addAll(gruopMembersGroupMembers.get(g.UserOrGroupId));
                    publicGroupUsersMap.put(g.GroupId, users);
                }
            }
        }        
        
        return publicGroupUsersMap;
    }
}