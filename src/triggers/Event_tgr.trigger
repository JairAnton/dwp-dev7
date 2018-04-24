/*-------------------------------------------------------------------------
 * Name: Event_tgr
 * Description : Event trigger
 * Created date : Apr 19 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/
trigger Event_tgr on Event (after insert,before insert,before update,after update, after delete, before delete, after undelete) {
	new Event_Handler().run();
}