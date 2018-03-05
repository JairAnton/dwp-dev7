/*-------------------------------------------------------------------------
 * Name: Contact_Group_Handler
 * Description : Contact trigger
 * Created date : Feb 14 2018
 * Developer name: Julio Medellín Oliva Indra(México)
--------------------------------------------------------------------------*/
trigger Contact_Tgr on Contact (after insert,after update,before insert) {
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            Contact_Handler.setDefaultCurrency(trigger.new);     
        }
 
         
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            Contact_Handler.createGroupContact(trigger.new);     
        }       
         if(trigger.isUpdate){
            Contact_Handler.updateGroupContact(trigger.new);     
        }
 
         
    }
    

}