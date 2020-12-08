/**
 * ------------------------------------------------------------------------------------------------
 * @Name BE_SyncAttendees_Cls
 * @Author Martin Mori martin.mori.contractor@bbva.com
 * @Date Created: 2020-10-14
 * @Group
 * @Description Clase que permite sincronizar los participantes a un evento específico
 */
public with sharing class BE_SM_SyncAttendees_Cls {
    /*Constructor Method*/
    private BE_SM_SyncAttendees_Cls() {
    }
    
    /**
    @Description sync attendees method
	*/
    @InvocableMethod
    public static void syncAttendees(List<String> smIds) {
        final Set<Id> evtIds = new Set<Id>();
        final Set<String> setSMIds = new Set<String>();
        setSMIds.addAll(smIds); 
        for(Event evt : [SELECT Id FROM Event WHERE slmt__management_plan_meeting_id__c IN :setSMIds AND IsChild = FALSE]) {
            evtIds.add(evt.Id);
        }
        final String hour = String.valueOf(Datetime.now().hour());
        final String min = String.valueOf(Datetime.now().minute() + 2); 
        final String second = String.valueOf(Datetime.now().second());
        final String nextFireTime = second + ' ' + min + ' ' + hour + ' * * ?';
        
        final BE_SyncEventAttendees_BS sch = new BE_SyncEventAttendees_BS(evtIds);
        System.schedule('Sync attendees started at ' + Math.random() + '-' + Datetime.now(), nextFireTime, sch);
    }
}