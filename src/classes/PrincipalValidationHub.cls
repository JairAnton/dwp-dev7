/**
* @author bbva.com developers
* @date 2018
*
* @group global_hub
*
* @description This class contains the methods for the Validations logic of the main button panel
**/
global class PrincipalValidationHub {
    
    static final String admin = 'Administrador del sistema';
    static final String sysAdmin = 'System Administrator';
    static final String executive = 'Ejecutivo';
    static final String assistant = 'Assistant';
    static final String operative = 'Operativo';
    
    // User with administrator profile or opportunity owner user
    global static Boolean Condition1(String recordId) {
 		Final List<Opportunity> opps = [Select Id,OwnerId,Owner.Name,Branch_id__c from Opportunity where Id=:recordId];
        Final List<Profile> profiles = [Select Id, Name from profile where Id=:UserInfo.getProfileId()];
        Boolean result = true;
        if((profiles[0].Name == admin )||(profiles[0].Name == sysAdmin)||(opps[0].OwnerId == UserInfo.getUserId())) {        
            result = false;
        }
        return result;
    }
    
    /* User with administrator or opportunity owner profile or user with Executive profile 
     * and assistant position who is in the same office as the opportunity office.*/
    global static Boolean Condition2(String recordId) {
        Final List<Opportunity> opps = [Select Id,OwnerId,Owner.Name,Branch_id__c from Opportunity where Id=:recordId];
       	Final List<User> users = [select Id, prof_position_id__c, prof_position_type__c, Profile.Name, (Select branch_name__c  from Users_Branches__r ) from user where Id=:UserInfo.getUserId()];
        Final List<User_Position_Mapping__mdt> codigos = [select prof_position_id__c, dwp_role__c, profile__c from User_Position_Mapping__mdt where prof_position_id__c=:users[0].prof_position_id__c];
        if((users[0].profile.Name == admin )||(users[0].profile.Name == sysAdmin)||(opps[0].OwnerId == UserInfo.getUserId())) {   
            return false;
        } else if(!codigos.isEmpty()) {
            if((codigos[0].profile__c == executive)&&(codigos[0].dwp_role__c == assistant)) {
                for(User_Branch__c ub : users[0].Users_Branches__r) {
                    if(ub.branch_name__c == opps[0].Branch_id__c) {
                        return false;
                    }
                }
            }  
        }
        return true;
    }
    
    /* All the fields of the product filled in (dynamic according to the configuration of the product's 
     * fields - indicate in the error message which are still to be filled in), at least one participant
     *  and if the product has guarantees (type garnatía != No guarantees), at least one guarantee. */
    global static List<String> Condition3(String recordId) {
		List<String> lstErrorMessage = new List<String>();
        Boolean error = false;
        String tempLabel = '';
       	Final List<OpportunityLineItem> oli = [SELECT Id,ProductCode,product2id, gipr_Tipo_Garantia__c FROM OpportunityLineItem WHERE OpportunityId = :recordId];
        Final List<fprd__GBL_Product_Configuration__c> mdtList = [select Id, fprd__Values_control_field__c, fprd__LoV_labels__c, fprd__LoV_values__c, fprd__Visibility_control_field__c, 
                                                       fprd__map_field__c, fprd__Visibility_control_value__c, fprd__product__c, fprd__DeveloperName__c, fprd__Label__c
                                                       from fprd__GBL_Product_Configuration__c WHERE fprd__product__c = :oli[0].product2id];
        Map<String,fprd__GBL_Product_Configuration__c> mapProductConfig = new Map<String,fprd__GBL_Product_Configuration__c>();
        Set<String> setFields = new Set<String>();
        for(fprd__GBL_Product_Configuration__c mdt : mdtList) {
            mapProductConfig.put(mdt.fprd__DeveloperName__c,mdt);
            if(mdt.fprd__map_field__c != null && mdt.fprd__map_field__c != '') {
                setFields.add(mdt.fprd__map_field__c);
            }
        }
        List<String> lstFields = new List<String>(setFields);      
        List<OpportunityLineItem> oliInfo = Database.query('Select Id, '+String.join(lstFields, ',')+' FROM OpportunityLineItem WHERE OpportunityId = \''+recordId+'\'');
        for(fprd__GBL_Product_Configuration__c mdt : mdtList) {
            if(mdt.fprd__Visibility_control_field__c != null && mdt.fprd__Visibility_control_field__c != '' && mdt.fprd__map_field__c != null) {
                if( mapProductConfig.get(mdt.fprd__Visibility_control_field__c) != null &&oliInfo[0].get(mapProductConfig.get(mdt.fprd__Visibility_control_field__c).fprd__map_field__c)!=null && 
                  oliInfo[0].get(mapProductConfig.get(mdt.fprd__Visibility_control_field__c).fprd__map_field__c)!='') {
                      List<String> childParentValues = mapProductConfig.get(mdt.fprd__DeveloperName__c).fprd__Visibility_control_value__c.split(',');
                      List<String> values = mapProductConfig.get(mdt.fprd__Visibility_control_field__c).fprd__LoV_values__c.split(',');
                      List<String> labels = mapProductConfig.get(mdt.fprd__Visibility_control_field__c).fprd__LoV_labels__c.split(',');
                      for(Integer i = 0; i<values.size();i++) {
                          if(values[i] == oliInfo[0].get(mapProductConfig.get(mdt.fprd__Visibility_control_field__c).fprd__map_field__c)) {
                              tempLabel = labels.get(i);
                          }
                      }                      
                      for(String s : childParentValues) {
                          if(s==tempLabel) {
                              if(oliInfo[0].get(mdt.fprd__map_field__c) == null) {
                              	lstErrorMessage.add(Label.Error_validation_031 +' '+ mdt.fprd__Label__c);
                          	  }
                          }
                      }
                }
            } else if(mdt.fprd__map_field__c!=null && mdt.fprd__map_field__c!='') {
                if(oliInfo[0].get(mdt.fprd__map_field__c)==null) {
                    lstErrorMessage.add(Label.Error_validation_031 +' '+ mdt.fprd__Label__c);
                }               
            }
        }        
		Final List<fprd__GBL_Guarantee__c> guaranteeList = [select id from fprd__GBL_Guarantee__c where fprd__GBL_Opportunity_product__c = :recordId];
        Final List<fprd__GBL_Intervener__c> intervenerList = [select id, fprd__GBL_Opportunity_product__c from fprd__GBL_Intervener__c where fprd__GBL_Opportunity_product__c = :recordId];
        if(intervenerList.size() == 0) lstErrorMessage.add(Label.Error_validation_032);
        // listOli[0].gipr_Tipo_Garantia__c = 03. 03 = Sin garantía
        if((oli[0].gipr_Tipo_Garantia__c == '01' || oli[0].gipr_Tipo_Garantia__c == '02') && (guaranteeList.size() == 0)) lstErrorMessage.add(Label.Error_validation_033);
		return lstErrorMessage;
    }
    
	/* All fields in the'General product information' section filled in (dynamic according to the configuration of the product
	 *  fields - indicate in the error message which fields are still to be filled in). */
    global static list<String> Condition4(String recordId) {
        List<String> lstErrorMessage = new List<String>();
        Boolean error = false;
        String tempLabel = '';
       	Final List<OpportunityLineItem> oli = [SELECT Id,ProductCode,product2id, gipr_Tipo_Garantia__c FROM OpportunityLineItem WHERE OpportunityId = :recordId];
        Final List<fprd__GBL_Product_Configuration__c> mdtList = [select Id, fprd__Values_control_field__c, fprd__LoV_labels__c, fprd__LoV_values__c, fprd__Visibility_control_field__c, 
                                                       fprd__map_field__c, fprd__Visibility_control_value__c, fprd__product__c, fprd__DeveloperName__c,fprd__Label__c,
                                                       fprd__Section_name__c, fprd__Section_order__c from fprd__GBL_Product_Configuration__c
                                                       WHERE fprd__product__c = :oli[0].product2id];
        Map<String,fprd__GBL_Product_Configuration__c> mapProductConfig = new Map<String,fprd__GBL_Product_Configuration__c>();
        Set<String> setFields = new Set<String>();
        for(fprd__GBL_Product_Configuration__c mdt : mdtList) {
            mapProductConfig.put(mdt.fprd__DeveloperName__c,mdt);
            if(mdt.fprd__map_field__c != null && mdt.fprd__map_field__c != '') {
                setFields.add(mdt.fprd__map_field__c);
            }
        }
        List<String> lstFields = new List<String>(setFields);      
        final List<OpportunityLineItem> oliInfo = Database.query('Select Id, Product2.ProductCode, ' + String.escapeSingleQuotes(String.join(lstFields, ',')) + ' FROM OpportunityLineItem WHERE OpportunityId = :recordId');
        for(fprd__GBL_Product_Configuration__c mdt : mdtList) {
            if(mdt.fprd__Visibility_control_field__c != null && mdt.fprd__Visibility_control_field__c != '' && mdt.fprd__map_field__c != null) {
                if( mapProductConfig.get(mdt.fprd__Visibility_control_field__c) != null && oliInfo[0].get(mapProductConfig.get(mdt.fprd__Visibility_control_field__c).fprd__map_field__c)!=null && 
                  oliInfo[0].get(mapProductConfig.get(mdt.fprd__Visibility_control_field__c).fprd__map_field__c)!='') {
                      List<String> childParentValues = mapProductConfig.get(mdt.fprd__DeveloperName__c).fprd__Visibility_control_value__c.split(',');
                      List<String> values = mapProductConfig.get(mdt.fprd__Visibility_control_field__c).fprd__LoV_values__c.split(',');
                      List<String> labels = mapProductConfig.get(mdt.fprd__Visibility_control_field__c).fprd__LoV_labels__c.split(',');
                      for(Integer i = 0; i<values.size();i++) {
                          if(values[i] == oliInfo[0].get(mapProductConfig.get(mdt.fprd__Visibility_control_field__c).fprd__map_field__c)) {
                              tempLabel = labels.get(i);
                          }
                      }                      
                      for(String s : childParentValues) {
                          if(s==tempLabel) {
                              if((oliInfo[0].get(mdt.fprd__map_field__c) == null)&&(mdt.fprd__Section_order__c == 1)) {
                              	lstErrorMessage.add(Label.Error_validation_031 +' '+ mdt.fprd__Label__c);
                          	  }
                          }
                      }
                }
            } else if((mdt.fprd__map_field__c!=null && mdt.fprd__map_field__c!='')&&(mdt.fprd__Section_order__c== 1)) {
                if(oliInfo[0].get(mdt.fprd__map_field__c)==null && !((oliInfo[0].Product2.ProductCode=='PC00011' || oliInfo[0].Product2.ProductCode=='PC00012') && (mdt.fprd__map_field__c=='tcf_beneficiary__c' || mdt.fprd__map_field__c=='tcf_Legal_VB_text__c'))) {
                    lstErrorMessage.add(Label.Error_validation_031 +' '+ mdt.fprd__Label__c);
                }               
            }
        }        
		return lstErrorMessage;
    }
    
    // User with administrator profile or with operational profile in the same office as the office of the opportunity. 
    global static Boolean Condition5(String recordId) {
       	Final List<User> users = [select Id, prof_position_id__c, prof_position_type__c, Profile.Name, (Select branch_name__c  from Users_Branches__r ) from user where Id=:UserInfo.getUserId()];
		return !(users[0].profile.Name == admin || users[0].profile.Name == sysAdmin || users[0].profile.Name == operative);
	}
    
    /* Method to validate Formalization Process*/
    global static Boolean condition6(String recordId) {
        Final Set<String> rolAsis = Formalization_helper.getRolTeam('Asistentes_Operativos');
        Final User usuario = [SELECT Id, Profile.Name, prof_position_id__c FROM User WHERE Id=:UserInfo.getUserId()];
        Final List<Group> grupo = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName='Asistentes_Operativos'];
        Final List<GroupMember> members = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId=:grupo[0].Id AND UserOrGroupId=:UserInfo.getUserId()];
        Final Integer memberSize = members.size();
        Boolean result = false;
        if(!((memberSize > 0 && rolAsis.contains(usuario.prof_position_id__c) && usuario.profile.Name==operative) || 
           (usuario.Profile.Name == admin || usuario.Profile.Name == sysAdmin )) ) {
            result = true;
        }
        return result;
    }
    
    /* Method to validate Formalization Process*/
    global static Boolean condition7(String recordId) {
        Final Set<String> rolAsis = Formalization_helper.getRolTeam('Asistentes_Operativos');
        Final Set<String> rolSubg = Formalization_helper.getRolTeam('Subgerentes_Operativos');
        Final User usuario = [SELECT Id, Profile.Name, prof_position_id__c FROM User WHERE Id=:UserInfo.getUserId()];
        Final Case caso = [SELECT Id, status, Dwp_assistantOwner__c, Dwp_SgofOwner__c FROM Case WHERE Id=:recordId];
        Final List<Group> grupo = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN ('Asistentes_Operativos','Subgerentes_Operativos')];
        Final Map<String, String> mapGroup = Formalization_helper.getGroup(grupo, 'Asistentes_Operativos');
        Final List<GroupMember> members = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId=:mapGroup.values() AND UserOrGroupId=:UserInfo.getUserId()];
        Final Integer memberSize = members.size();
        Boolean result = false;
        //Usuario asistente en el grupo "Asistentes_Operativos", con rol Asistente, con perfil Operativo, 
        //con caso en estado "Nuevo", o caso en estado "Asignado AAC"/"Devuelto AAC" y sin asistente asignado.
        //Usuario subgerente en el grupo "Subgerentes_Operativos", con rol subgerente, con perfil Operativo, 
        //con caso en estado "Elevado", o caso en estado "Asignado Sgof" y sin subgerente asignado.
        if(!((memberSize > 0 && rolAsis.contains(usuario.prof_position_id__c) && usuario.profile.Name==operative && 
            (caso.status == '01' || (caso.status == '05' || caso.status == '09' && String.isEmpty(caso.Dwp_assistantOwner__c)) ) ) ||
           (memberSize > 0 && rolSubg.contains(usuario.prof_position_id__c) && usuario.profile.Name==operative && 
             (caso.status == '07' || (caso.status == '08' && String.isEmpty(caso.Dwp_SgofOwner__c)) )) || 
            (usuario.Profile.Name == admin || usuario.Profile.Name == sysAdmin ) ) ) {
                 result = true;
             }
        return result;
    }
}