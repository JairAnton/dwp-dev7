public interface DynamicNotificationMessageRecipent {
    Map<Id,List<Id>> getRecipients(List<Id> lstrecord, String sObjectName);
}