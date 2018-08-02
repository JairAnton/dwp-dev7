/**
* @author bbva.com developers
* @date 2018
*
* @group global_hub
*
* @description execute a chatter batch
**/
public class DynamicBatchChatterNotification {
    public static void getDynamicBatchChatterNotification(List<String> recordId, String sObjectName, String messageId){
        List <DynamicNotificationInformation.NotificationInformation_wrapper> lstmwrap = DynamicNotificationInformation.getDynamicNotificationInformation(recordId, sObjectName, messageId);
        Database.executeBatch(new NotificationBatch(lstmwrap), 50);
    }

}