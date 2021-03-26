trigger CA_Visit_Relation_Trigger on Commercial_Alert_Visit_Relation__c (before insert) {
    new Visit_Relation_Handler_cls().run();
}