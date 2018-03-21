/*-------------------------------------------------------------------------
 * Name: Contact_Group_Handler
 * Description : Contact trigger
 * Created date : Feb 14 2018
 * Developer name: Julio Medellín Oliva Indra(México)
--------------------------------------------------------------------------*/
trigger Contact_Tgr on Contact (after insert,before insert,before update,after update, after delete, before delete, after undelete) {
    new Contact_Handler().run();
}