/**
 * @author Global_HUB developers
 * @date 11-07-2018
 *
 * @group Global_HUB
 *
 * @description Class tcreate Audit records throw a email
 **/
global class Email_SIO implements Messaging.InboundEmailHandler {
	Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env) {
		// Create an inboundEmailResult object for returning
		// the result of the email service.
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
		String mySubject = email.subject;
		String SioCode = '';
		String SioStatus = '';
		String myPlainText = '';
		myPlainText = email.htmlBody;
		// Capture the record ID from the subject line
		list<String> subl = mySubject.split('##');
		Task task = new Task();

		List <Account> acclist = new List <Account>();
		List <Opportunity> opplst = new List<Opportunity>();
		List <dwp_cvad__Action_Audit__c> lstaction = new List <dwp_cvad__Action_Audit__c>();
		List <dwp_cvad__Action_Audit_Detail__c> lstactdetail = new List <dwp_cvad__Action_Audit_Detail__c>();
		List <SIO_Status_Mapping__mdt> lstsiomapping = [Select Id, sio_status__c, sio_status_type__c from SIO_Status_Mapping__mdt];

		try {
			//email with subject ClientCode##date
			if(subl.size() == 2) {
				updateClientGroup(subl);
				//email with subject SIOCode##SIOStatus##??##??##ClientCode
			} else if(subl.size() == 5) {
				acclist = [Select id from Account where main_code_id__c =:subl[4]];
				if(!acclist.isEmpty()) {
					opplst = [Select Id, opportunity_status_type__c, isClosed from Opportunity where AccountId IN :acclist and sio_code__c =: subl[0]];
				}
				//Account without opportunities open and without sio code of email
				if(opplst.isEmpty()) {
					for(Account acc: acclist) {
						lstaction.add(Action_Audit_Helper.getAudit(subl[1], 'Account', acc.Id, DateTime.now(), label.AuditRiskApproval, UserInfo.getUserId(), label.quickText, subl[0], true));
					}
					insert lstaction;
					for(dwp_cvad__Action_Audit__c audit: lstaction) {
						lstactdetail.add(Action_Audit_Helper.getAuditDetail(audit.Id, myPlainText, 1, label.displayTitleAuditDetail, Label.Embedded));
					}
					insert lstactdetail;
					//Account with opportunities open and with sio code of email
				} else {
					for(Opportunity opp: opplst) {
						if(!opp.IsClosed) {
							lstaction.add(Action_Audit_Helper.getAudit(subl[1], 'Opportunity', opp.Id, DateTime.now(), label.AuditRiskApproval, UserInfo.getUserId(), label.quickText, subl[0], true));
							opp.sio_status_type__c = subl[1];
							//Opportunity is Send for risk approval
							if(opp.opportunity_status_type__c == '14') {
								for(SIO_Status_Mapping__mdt siomap: lstsiomapping) {
									//Opportunity with status equal to sio status in metadata and sio status type Authorized
									if((siomap.sio_status__c == opp.sio_status_type__c) && (siomap.sio_status_type__c == label.Authorized)) {
										opp.opportunity_status_type__c = '15';
										opp.isProcess__c = true;
										lstaction.add(Action_Audit_Helper.getAudit(label.RiskAuthorized, 'Opportunity', opp.Id, DateTime.now(), label.AuditRiskApproval, UserInfo.getUserId(), label.approve, subl[0], false));
										//Opportunity with status equal to sio status in metadata and sio status type Denied
									} else if((siomap.sio_status__c == opp.sio_status_type__c) && (siomap.sio_status_type__c == label.Denied)) {
										opp.opportunity_status_type__c = '16';
										opp.isProcess__c = true;
										lstaction.add(Action_Audit_Helper.getAudit(label.RiskDenied, 'Opportunity', opp.Id, DateTime.now(), label.AuditRiskApproval, UserInfo.getUserId(), label.deny, subl[0], false));
									}
								}
							}
						}
					}
					if(!lstaction.isEmpty()) {
						insert lstaction;
						update opplst;
						for(dwp_cvad__Action_Audit__c audit: lstaction) {
							//Audits from emails will create a AuditDetail
							if(audit.action_audit_email__c == true) {
								lstactdetail.add(Action_Audit_Helper.getAuditDetail(audit.Id, myPlainText, 1, label.displayTitleAuditDetail, Label.Embedded));
							}
						}
						insert lstactdetail;
					}
				}
			}
		} catch(Exception e) {
			System.debug('ERROR: ' + e.getMessage());
		}

		return result;
	}
    
	//method that updates a financial program expiry date with date of email
	//Account parent and son, parent if had
	public void updateClientGroup(List<String> reg) {
		List <Account> acclist = new List<Account>();
		LIST<Account> acclistSP = new LIST<Account>();
		acclist = [select Id from Account where main_code_id__c =:reg[0]];
		acclistSP = [Select id, financial_program_expiry_date__c from Account where ParentId IN :acclist or Id IN :acclist];
		if(!acclistSP.isEmpty()) {
			for(Account acc: acclistSP) {
				acc.financial_program_expiry_date__c = date.parse(reg[1]);
			}
			update acclistSP;
		}
	}
}
