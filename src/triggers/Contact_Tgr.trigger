/*-------------------------------------------------------------------------
 * Name: Contact_Group_Handler
 * Description : Contact trigger
 * Created date : Feb 14 2018
 * Developer name: Julio Medellín Oliva Indra(México)
--------------------------------------------------------------------------*/
trigger Contact_Tgr on Contact (after insert) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            Contact_Group_Handler.createGroupContact(trigger.new);     
        }
 
         
    }
    

}