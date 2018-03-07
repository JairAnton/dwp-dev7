/*-------------------------------------------------------------------------
 * Name: Contact_Group_Handler
 * Description : Contact trigger
 * Created date : Feb 14 2018
 * Developer name: Julio Medellín Oliva Indra(México)
--------------------------------------------------------------------------*/
trigger Contact_Tgr on Contact (after insert,before insert,after update) {
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            Contact_Group_Handler.setDefaultCurrency(trigger.new);     
        }
         
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            Contact_Group_Handler.createGroupContact(trigger.new);     
        }
 
        if(trigger.isUpdate){
            system.debug('XSDD');
            Contact_Group_Handler.updateGroupContact(trigger.new);     
        }
         
    }
    

}