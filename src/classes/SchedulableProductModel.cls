global without sharing class SchedulableProductModel implements Schedulable {
    global void execute(SchedulableContext SC) {
        List<Product_Model__c> lstProductModel = [SELECT Name FROM Product_Model__c];
        for(Product_Model__c prodModel : lstProductModel){
            Database.executeBatch(new Commitments_batch(prodModel.Name));           
        }
    }
}