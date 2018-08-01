@istest
public class FieldForm_ctrl_Test {

    @testSetup
    static void setData() {
        Account acc = TestFactory.createAccount();
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
    }

    @isTest
    static void test_method_one(){
        List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem];
        Map<String,Object> getData = FieldForm_ctrl.getInfo(lstOLI[0].Id,'COTIZA Beta_Proposal');
        System.assertEquals(true, (Boolean)getData.get('isOk'));
        Map<String,Object> getDataError = FieldForm_ctrl.getInfo('skdfjowe23','COTIZA Beta_Proposal');
        System.assertEquals(false, (Boolean)getDataError.get('isOk'));

        List<String> lstFields = new List<String>();
        List<Object> lstData = new List<Object>();
        lstFields.add('price_quote_id__c');
        lstData.add('eeee');
        lstFields.add('minimun_fee_per__c');
        lstData.add(34.5);
        lstFields.add('gipr_Plazo__c');
        lstData.add(435.56);
        lstFields.add('fprd__GBL_Sample_Checkbox__c');
        lstData.add(true);
        lstFields.add('price_quote_date__c');
        lstData.add('2018-12-12');
        Map<String,Object> mapSave = FieldForm_ctrl.doSave(lstOLI[0].Id, 'OpportunityLineItem',lstFields, lstData);

    }
}