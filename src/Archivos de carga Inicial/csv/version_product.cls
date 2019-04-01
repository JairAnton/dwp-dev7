List <Product2> lst_products = [SELECT Id, (SELECT Id FROM fprd__Product_versions__r) FROM Product2];
List <fprd__GBL_Product_version__c> lst_versionsToInsert = new List <fprd__GBL_Product_version__c>();
for (Product2 product : lst_products) {
    if (product.fprd__Product_versions__r.isEmpty()) {
        fprd__GBL_Product_version__c version = new fprd__GBL_Product_version__c(
            fprd__Version_number__c = 1,
            fprd__Active__c = true,
            fprd__Product__c = product.Id
        );
        lst_versionsToInsert.add(version);
    }
}
if (!lst_versionsToInsert.isEmpty()) {
    insert lst_versionsToInsert;
}