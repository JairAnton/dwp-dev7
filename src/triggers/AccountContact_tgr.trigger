trigger AccountContact_tgr on AccountContactRelation (after insert) {
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            AccountContact_Handler.setValuesRelation(trigger.new);     
        }
    }
}