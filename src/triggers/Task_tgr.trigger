/*-------------------------------------------------------------------------
 * Name: Task_tgr
 * Description : Task trigger
 * Created date : Apr 19 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/
trigger Task_tgr on Task (after insert,before insert,before update,after update, after delete, before delete, after undelete) {
	new Task_Handler().run();
}