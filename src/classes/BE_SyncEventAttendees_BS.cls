/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SyncEventAttendees_BS>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-10-14
   @Description Batchable class for sync attendees event
   @Changes
   Date        Author   Email                  				Type		Description
   2020-10-14  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_SyncEventAttendees_BS implements Schedulable {
    /**
	   @Description evtIds
	 */
    public Set<Id> evtIds {get; set;}
	/**
	   @Description BE_SyncEventAttendees_BS
	 */
	public BE_SyncEventAttendees_BS(Set<Id> ids) {
		this.evtIds = ids;
	}
    
    /**
    @Description execute method
    */
    public void execute(SchedulableContext context) {
        Database.executeBatch(new BE_SyncEventAttendees_Batch(evtIds));
    }
}