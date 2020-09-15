/**
   ----------------------------------------------------------------------------------------------------
   @Name <BE_NonClient_Ctr>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-02-24
   @Description Class Controller for Validate and create NonClient with global Cmp NonClient
   @Changes
    Date        Author   Email                  Type
    2020-02-24  LMBR     lolo.bravo@bbva.com    Creation
   ----------------------------------------------------------------------------------------------------
 */
global without sharing class BE_NonClient_Ctr implements nonc.NonClient_interface_prospect {
    /** StatusCode Code */
    private static final List<String> VISIT_LANGUAGE = new List<String> {'es','en_US'};
    /** messages */
    static Map<String,String> messages;
    /**
    @Description search NonClient in Salesforce (DWP-PE) with similar RUC
    @param  strSearchName is Non Client Name
    @param  strFieldNameCode is ApiName of Extrafield Validation (AccountNumber=RUC)
    @param  strFielValueCode is Value of Extrafield Validation (RUC)
    @return String  with List<WrapperAccount>
    */
    global static String checkDuplicateNonClients(String strSearchName,String strFieldNameCode,String strFielValueCode) {
        final Boolean isRucValid=BE_Client_Search_Helper.validateRUC(strFielValueCode);
        List<WrapperAccount> lWrapper = new List<WrapperAccount>();
        if(String.isNotBlank(strSearchName) && String.isNotBlank(strFielValueCode) && isRucValid) {
        	final BE_Client_Search_Helper.Response resClient=BE_Client_Search_Helper.searchClienteSF(strFielValueCode);
        	WrapperAccount wrpAcc=new WrapperAccount();    
        		if(resClient.isSuccess) {
            		wrpAcc=new WrapperAccount((String)resClient.acc.Id, resClient.acc.Name,(String)resClient.acc.OwnerId);
            		wrpAcc.code=resClient.acc.AccountNumber;
            		wrpAcc.ownerName=resClient.acc.Owner.Name;
                    wrpAcc.clientType=resClient.acc.RecordType.Name;
            		lWrapper.add(wrpAcc);
        		} else {
        			final BE_Client_Search_Helper.Response resClientSrv=BE_Client_Search_Helper.searchCliente(new Account(AccountNumber=strFielValueCode));
            		if (resClientSrv.isExistNonClient==true && resClientSrv.isSuccess) {
              			wrpAcc.clientName=resClientSrv.acc.Name;
                        wrpAcc.clientType=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Record_Type_Client').getName();
                        wrpAcc.code=resClientSrv.acc.AccountNumber;
              			lWrapper.add(wrpAcc);
                	}
        	   }
        } else {
            throw new AuraHandledException(System.Label.BE_NonClient_ErrorMessage);
        }
        return JSON.serialize(lWrapper);
    }
    
    /**
    -------------------------------------------------------------------------------------------------
    @Name <WrapperAccount>
    @Description Wrapper Class for duplicate NonClients
    -------------------------------------------------------------------------------------------------
    */
    public without sharing class  WrapperAccount {
       /** ownerName */
       public String ownerName {set;get;}
       /** ownerLink */
       public String ownerLink {set;get;}
       /** clientName */
       public String clientName {set;get;}
       /** clientLink */
       public String clientLink {set;get;}
       /** clientType */
       public String clientType {set;get;}
       /** country */
       public String country {set;get;}
       /** code */
       public String code {set;get;}
		/* Constructor whith params */
		public WrapperAccount (String clientID, String clientName, String ownerID) {
			this.clientLink   = '/lightning/r/Account/' + clientID + '/view';
			this.ownerLink    = '/lightning/r/User/' + ownerID + '/view';
			this.clientName   = clientName;
		}
	}

	/**
	   @Description validate non client before save in Alpha DB and Salesforce.
	   call API REST: ListBusiness,ListNonBusiness and CreateNonBusiness
	   @param client sObject type Account wich contains the minimum information of NonClient
	   @return  String type objRespuesta Class
	 */
	@AuraEnabled
	global static String validateNonCliente(Account client) {
		final Boolean isRucValid = BE_SearchClient_Helper.validateRUC(client.AccountNumber);
		final ResultValidation objRespuesta = new ResultValidation();
		if(isRucValid) {
			objRespuesta.status = 'success';
			objRespuesta.message = 'The Non Client create successfull';
		} else {
			objRespuesta.status = 'error';
			objRespuesta.message = 'Please input a correct RUC format';
		}
		System.debug('JSON.serialize(objRespuesta)');
		System.debug(JSON.serialize(objRespuesta));
		return JSON.serialize(objRespuesta);
	}

    /**
    @Description validate non client before save in Alpha DB and Salesforce.
    call API REST: ListNonBusiness and CreateNonBusiness
    @param client sObject type Account wich contains the minimum information of NonClient
    @return  String type objRespuesta Class
    */
    @AuraEnabled
    global static String validateNonCliente(Account client) {
    final ResultValidation objRespuesta =new ResultValidation();
    try {
        messages = new Map<String,String>();
        final Boolean isValidPhone=validatePhone(client);
        if(isValidPhone==true) {
        	final BE_NonClient_Search_Helper.Response nonClientRes= BE_NonClient_Search_Helper.searchNonClient(client);
        	if(nonClientRes.isSuccess && nonClientRes.isExistNonClient) {
           	objRespuesta.status='success';
         	objRespuesta.message=nonClientRes.message;
            objRespuesta.nonClientCode=nonClientRes.acc.non_client_code__c;
       } else if (nonClientRes.isSuccess && nonClientRes.isExistNonClient==false) {
            	final BE_NonClient_Create_REST.Params param=new BE_NonClient_Create_REST.Params();
           		param.acc=client;
         		final BE_NonClient_Create_Helper.Response res=BE_NonClient_Create_Helper.createNonClient(param);
           		if (res.isSuccess) {
           			objRespuesta.status='success';
         			objRespuesta.message=res.message;
                    objRespuesta.nonClientCode=res.codeTrx;
     		} else {
              		objRespuesta.status='error';
               		objRespuesta.message=res.message;
            	}
        	}  else {
            messages.put(VISIT_LANGUAGE[0], 'Servicio no disponible, porfavor intentar mas tarde.');
            messages.put(VISIT_LANGUAGE[1], 'Service not available, please try later.');
            objRespuesta.status='error';
            objRespuesta.message=messages.get(UserInfo.getLanguage());
        }
        } else {
            messages.put(VISIT_LANGUAGE[0], 'Ingresar código y número de telefono correcto.');
            messages.put(VISIT_LANGUAGE[1], 'Put correct code and phone number.');
            objRespuesta.status='error';
            objRespuesta.message=messages.get(UserInfo.getLanguage());
        }
    } catch (DMLException ex) {
            objRespuesta.status='error';
            objRespuesta.message=ex.getDmlMessage(0);
         	System.debug('####ex.getDmlMessage(0)##'+ex.getDmlMessage(0));
    }
       System.debug('####objRespuesta##'+JSON.serialize(objRespuesta));
       return JSON.serialize(objRespuesta);
    }
    /** wrapper to validate to validateNonCliente method and send response */
    public class ResultValidation {
       /**Indicates status of the transaction*/
       @AuraEnabled
       public String status { get; set; }
       @AuraEnabled
       /**Message to show in the front to final user*/
       public String message { get; set; }
       /**Non Client Code */
       @AuraEnabled
       public String nonClientCode {set;get;}
       /**Non Client Code */
       @AuraEnabled
       public String branchId {set;get;}
       /** public Validation */
       public ResultValidation () {
        final Integer sizeLst=0;
        final List<User_Branch__c> userBranchLst=[SELECT ID,branch_name__c FROM User_Branch__c WHERE User__c=:UserInfo.getUserId()];
        if(userBranchLst.size()>sizeLst){
            this.branchId=userBranchLst[0].branch_name__c;
        }
       }
     }
     /** Don't use this method */
    @AuraEnabled
    public static String checkConvertedClients(List<Account> lProspect, Map<String, Account> mapAccs) {
       return '';
    }
    /** Validate Phone Number */
    private static Boolean validatePhone(Account acc) {
        Boolean isValid=false;
        if(String.isNotBlank(acc.phone_area_code__c) && String.isNotBlank(acc.other_phone_number__c)) {
            final String currentNumber = acc.other_phone_number__c;
            switch on acc.phone_area_code__c {
				when '01' {
                   isValid = currentNumber.length() == 7 && currentNumber.isNumeric() ? true : false;
                }
                when else {
                   isValid = currentNumber.length() == 6 && currentNumber.isNumeric() ? true : false;  
                }
            }
        }
       return isValid;
    }
}
