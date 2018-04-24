/*-------------------------------------------------------------------------
 * Name: EmailMessage_tgr
 * Description : EmailMessage trigger
 * Created date : Apr 19 2018
 * Developer name: Isaías Velázquez Cortés Indra(México)
--------------------------------------------------------------------------*/
trigger EmailMessage_tgr on EmailMessage (after insert,before insert,before update,after update, after delete, before delete, after undelete) {
	new EmailMessage_Handler().run();
}