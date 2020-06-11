/**
 * @author bbva.com developers
 * @date 2018
 *
 * @group global_hub
 *
 * @description Batch of notification
 **/
global without sharing class NotificationBatch implements Database.Batchable<Object> {
	global List<Object> lstobjs;

	global NotificationBatch(List<object> lstobj) {
		this.lstobjs = lstobj;
	}

	global Iterable <Object> start(Database.BatchableContext BC) {
		List<Object> lstobj = new List<Object>(lstobjs);
		return lstobj;
	}

	global void execute(Database.BatchableContext BC, List<Object> lstobj) {
		//List with the feedItems/ chatter notifications
		List<ConnectApi.BatchInput> lstFeedInputInsert = new List<ConnectApi.BatchInput>();
		for(Object obj :lstobj) {
			DynamicNotificationInformation.NotificationInformation_wrapper mwrap = (DynamicNotificationInformation.NotificationInformation_wrapper)obj;
			String recordId = mwrap.recordId;
			List<Id> lstuser = mwrap.recipientList;
			String message = mwrap.message;
			//looping type of messages
			for(String user : lstuser) {
				ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
				ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
				ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
				ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

				messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
				mentionSegmentInput.Id = user;
				messageBodyInput.messageSegments.add(mentionSegmentInput);

				//Apex escape new lines '\n' so we use unescapeJava
				textSegmentInput.text = message.unescapeJava();
				messageBodyInput.messageSegments.add(textSegmentInput);

				feedItemInput.body = messageBodyInput;
				feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
				feedItemInput.subjectId = recordId;

				ConnectApi.BatchInput cb = new ConnectApi.BatchInput(feedItemInput);
				lstFeedInputInsert.add(cb);
			}
		}

		ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), lstFeedInputInsert);
	}
    
	public void finish(Database.BatchableContext BC) {
	}
}
