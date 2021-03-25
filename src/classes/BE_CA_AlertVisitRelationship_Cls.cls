public with sharing class BE_CA_AlertVisitRelationship_Cls extends BE_SingleRelatedListCRUD_Cls {
/**
	   @Description readRecords
	   @param  List<SObject> sObjs
	   @return BE_SingleRelatedListCRUD_Cls.Response response
	 */
	public override BE_SingleRelatedListCRUD_Cls.Response readRecords(Map<String,Object>param) {
		final BE_SingleRelatedListCRUD_Cls.Response res=new BE_SingleRelatedListCRUD_Cls.Response();
		final Map<String,String> messages = new Map<String,String>();
		try {
            System.debug((String)param.get('recordId'));
            List<classVistRelation> listVisit= new List<classVistRelation>();
            for (Commercial_Alert_Visit_Relation__c itemRelation : [SELECT commercial_id__c,visit_id__r.dwp_kitv__visit_start_date__c,visit_id__r.dwp_kitv__visit_status_type__c,visit_id__r.Name,visit_id__r.dwp_kitv__visit_end_date__c FROM Commercial_Alert_Visit_Relation__c WHERE commercial_id__c=:(String)param.get('recordId')]) {
                classVistRelation visitRel= new classVistRelation(itemRelation.visit_id__r.Name);
                listVisit.add(visitRel);
            }
            //res.data=listVisit;
            res.isSuccess=true;
		} catch (DMLException ex) {
			res.isSuccess=false;
			res.message=ex.getDmlMessage(0);
		}
		return res;
	}

    public class classVistRelation {
        public String Name {set;get;}
        public classVistRelation (String Name) {
            this.Name=Name;
        }
    }
}