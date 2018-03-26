/*-------------------------------------------------------------------------
 * Name: Contact_Group_Handler
 * Description : Create a relationship between Contact and Account ParentId 
 * Created date : Feb 14 2018
 * Developer name: Julio Medellín Oliva Indra(México)
--------------------------------------------------------------------------*/
public without sharing class Contact_Handler extends TriggerHandler {
   
    
    protected override void beforeInsert(){
      Contact_Group_Handler.setDefaultCurrency((list<Contact>)(Trigger.new));
    }
    
    protected override void afterInsert(){
      Contact_Group_Handler.createGroupContact((list<Contact>)(Trigger.new)); 
    }
    
    protected override void afterUpdate(){
      Contact_Group_Handler.updateGroupContact((list<Contact>)(Trigger.new)); 
    }
    
    protected override void beforeUpdate(){
      Contact_Group_Handler.updateMainContact(((list<Contact>)(Trigger.new)), ((list<Contact>)(Trigger.old))); 
    }
}