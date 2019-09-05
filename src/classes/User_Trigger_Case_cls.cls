/**
* ------------------------------------------------------------------------------------------------
* @Name User_Trigger_Case_cls
* @Author Diego Carbajal diego.carbajal.contractor@bbva.com
* @Date Created: 2019-08-23
* @Group 
* @Description Esta clase controla la gestión de los equipos de Formalización de casos y la gestión de sus usuarios.
* Contiene la lógica para gestionar los equipos
*/
public without sharing class User_Trigger_Case_cls {

    /*Roles de Asistentes*/
    public static Final Set<String> ROL_ASIS = Formalization_helper.getRolTeam('Asistentes_Operativos');
    /*Roles de Subgerentes*/
    public static Final Set<String> ROL_SG = Formalization_helper.getRolTeam('Subgerentes_Operativos');

    /*Private Constructor Class*/
    private User_Trigger_Case_cls() {}
    /**
    * --------------------------------------------------------------------------------------
    * @Description 	AfterInsert
    * Metodo que agrega usuarios nuevos al Grupo "Asistentes_Operativos" o "Subgerentes_Operativos"
    * si su rol se encuentra en los especificados para cada grupo
    **/
    public static void newMembersFormalization(List<User> userNew) {
        Final Set<Id> idAsistSgof = new Set<Id>();
        for(User u:userNew) {//Usuarios nuevos con los roles Asistentes y Subgerentes
            if(ROL_ASIS.contains(u.prof_position_id__c) || ROL_SG.contains(u.prof_position_id__c)) {
                idAsistSgof.add(u.Id);
            }
        }
        Final Integer idAsistSgofSize = idAsistSgof.size();
        if(idAsistSgofSize > 0) insertNewMembersFormalization(idAsistSgof);
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description 	AfterUpdate
    * Metodo que actualiza los casos y oportunidades en las que estan involucrados los usuarios
    * en los equipos de formalización y, son desactivados o cambiados de rol de Asistente/Subgerente a Otro
    **/
    
    public static void updFormalizationDeactiveOwners(Map<id,User> userNewMap, Map<id,User> userOldMap) {
        Final Set<Id> inactiveAsist = new Set<Id>();
        Final Set<Id> inactiveSgof = new Set<Id>();
        for(User u:userNewMap.values()) {//Id's usuarios existentes con los roles Asistentes y Subgerentes desactivados o cambiados de rol
            if((ROL_ASIS.contains(u.prof_position_id__c) && (userOldMap.get(u.Id).isActive && !u.isActive)) || 
              (ROL_ASIS.contains(u.prof_position_id__c) && !ROL_ASIS.contains(userNewMap.get(u.Id).prof_position_id__c))) {
                inactiveAsist.add(u.Id);
            } else if((ROL_SG.contains(u.prof_position_id__c) && (userOldMap.get(u.Id).isActive && !u.isActive)) ||
                    (ROL_SG.contains(u.prof_position_id__c) && ROL_SG.contains(userNewMap.get(u.Id).prof_position_id__c))) {
                inactiveSgof.add(u.Id);
            }
        }
        Final Integer inactiveAsistSize = inactiveAsist.size();
        Final Integer inactiveSgofSize = inactiveSgof.size();
        if(inactiveAsistSize > 0 || inactiveSgofSize > 0) {
            processDeactiveOwners(inactiveAsist, inactiveSgof);
        }
    }
    
    @future 
    public static void processDeactiveOwners(Set<Id> inactiveAsist, Set<Id> inactiveSgof) {
        Map<Id,Case> mapCasos = new Map<Id, Case>([SELECT Id, status, DWP_AssistantOwner__c, bypass__c, OwnerId, opportunity_id__c, DWP_SGofOwner__c,
                                                       opportunity_id__r.Dwp_DevolutionUser__c FROM Case WHERE RecordType.DeveloperName = 'Formalization' AND 
                                                       (DWP_AssistantOwner__c IN: inactiveAsist OR DWP_SGofOwner__c IN: inactiveSgof) AND status NOT IN ('10','11')]);
        Final List<Group> lstQueue = [SELECT Id, developerName FROM Group WHERE developerName IN ('Tier_1_Formalization', 'Tier_2_Formalization') limit 2];
        Final Integer mapCasoSize = mapCasos.size();
        Final Integer lstQueueSize = lstQueue.size();
        //Si existen casos con usuarios con nuevo rol y que existan las colas de formalización
            if(mapCasoSize > 0 && lstQueueSize == 2) {
                //Id de colas
                Final Map<String, String> grupos = Formalization_helper.getGroup(lstQueue, 'Tier_1_Formalization');
                Final Id idTier1 = grupos.get('grp1');
                Final Id idTier2 = grupos.get('grp2');
                //Obtener las Opp de los casos
                Final Set<Id> idsOpp = new Set<Id>();
                for(Case caso:mapCasos.values()) {
                    idsOpp.add(caso.opportunity_id__c);
                }
                Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>([SELECT Id, Dwp_DevolutionUser__c, opportunity_status_type__c, isProcess__c FROM Opportunity 
                                                                                WHERE ID IN:idsOpp]);
                List<Opportunity> lstUpdOpp = new List<Opportunity>();
                for(Id caseId:mapCasos.keySet()) {
                    mapCasos.get(caseId).bypass__c = true;
                    //Si el asistente del caso esta en la lista de usuarios desactivados
                    if(inactiveAsist.contains(mapCasos.get(caseId).DWP_AssistantOwner__c)) {
                        if(mapCasos.get(caseId).opportunity_id__r.Dwp_DevolutionUser__c == mapCasos.get(caseId).DWP_AssistantOwner__c) {
                            mapOpportunity.get(mapCasos.get(caseId).opportunity_id__c).Dwp_DevolutionUser__c = null;
                            mapOpportunity.get(mapCasos.get(caseId).opportunity_id__c).isProcess__c = true;
                            lstUpdOpp.add(mapOpportunity.get(mapCasos.get(caseId).opportunity_id__c));
                        }
                        if(mapCasos.get(caseId).status == '05' || mapCasos.get(caseId).status == '09') {
                            mapCasos.get(caseId).status = '01';
                        }
                        //Cambios generales cuando el usuario asistente es desactivado
                        mapCasos.get(caseId).OwnerId = (mapCasos.get(caseId).OwnerId == mapCasos.get(caseId).DWP_AssistantOwner__c ? idTier1 : mapCasos.get(caseId).OwnerId);
                        mapCasos.get(caseId).DWP_AssistantOwner__c = null;
                    }
                    //Si el subgerente del caso esta en la lista de usuarios desactivados
                    if(inactiveSgof.contains(mapCasos.get(caseId).DWP_SGofOwner__c)) {
                        if(mapCasos.get(caseId).opportunity_id__r.Dwp_DevolutionUser__c == mapCasos.get(caseId).DWP_SGofOwner__c) {
                            mapOpportunity.get(mapCasos.get(caseId).opportunity_id__c).Dwp_DevolutionUser__c = null;
                            mapOpportunity.get(mapCasos.get(caseId).opportunity_id__c).isProcess__c = true;
                            lstUpdOpp.add(mapOpportunity.get(mapCasos.get(caseId).opportunity_id__c));
                        }
                        if(mapCasos.get(caseId).status == '08') {
                            mapCasos.get(caseId).status = '07';
                        }
                        //Cambios generales cuando el usuario subgerente es desactivado
                        mapCasos.get(caseId).OwnerId = (mapCasos.get(caseId).OwnerId == mapCasos.get(caseId).DWP_SGofOwner__c ? idTier2 : mapCasos.get(caseId).OwnerId);
                        mapCasos.get(caseId).DWP_SGofOwner__c = null;
                    }
                }
                Final Integer lstUpdOppSize = lstUpdOpp.size();
                if(lstUpdOppSize > 0) {
                 	update lstUpdOpp;
                    for(Opportunity opp:lstUpdOpp) {
                        opp.isProcess__c = false;
                    }
                    update lstUpdOpp;
                }
                update mapCasos.values();
                
                for(Id caseId:mapCasos.keySet()) {
                    mapCasos.get(caseId).bypass__c = false;
                }
                update mapCasos.values();
            }
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description 	AfterUpdate
    * Metodo que actualiza los casos y oportunidades de los usuarios que estaban involucrados
    * en los equipos de formalización y son cambiados de rol
    **/
    public static void changeRolAssis_Sgof(Map<id,User> userNewMap, List<User> userOld) {
        Final Set<Id> asistChange = new Set<Id>();
        Final Set<Id> sgofChange = new Set<Id>();
        for(User u:userOld) {//Usuario Asistente cambia de rol
            if(ROL_ASIS.contains(u.prof_position_id__c) && !ROL_ASIS.contains(userNewMap.get(u.Id).prof_position_id__c)) {
                asistChange.add(u.Id);
            } else if(ROL_SG.contains(u.prof_position_id__c) && !ROL_SG.contains(userNewMap.get(u.Id).prof_position_id__c)) {//Usuario Subgerente cambia de rol
                sgofChange.add(u.Id);
            }
        }
        Final Integer asistChangeSize = asistChange.size();
        Final Integer sgofChangeSize = sgofChange.size();
        if(asistChangeSize > 0 || sgofChangeSize > 0) processChangeRolAssis_Sgof(asistChange, sgofChange);
    }
    
    @future
    public static void processChangeRolAssis_Sgof(Set<Id> asistChange, Set<Id> sgofChange) {
        //Eliminar usuarios de los grupos de Asistente y Subgerente
        Final List<Group> lstGroup = [SELECT ID, developerName FROM Group WHERE developerName IN ('Asistentes_Operativos', 'Subgerentes_Operativos') limit 2];
        Final Map<String, String> mapGroup = Formalization_helper.getGroup(lstGroup, 'Asistentes_Operativos');
        delete [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId=:mapGroup.values() AND (UserOrGroupId IN: asistChange OR UserOrGroupId IN: sgofChange)];
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description 	AfterUpdate
    * Metodo que agrega usuarios con rol Asistente o Subgerente a los Grupos "Asistentes_Operativos" o "Subgerentes_Operativos"
    **/
    public static void addUserToFormalizationGroup(Map<id,User> userNewMap, List<User> userOld) {
        Final Set<Id> idAsist_Sgof = new Set<Id>();
        for(User u:userOld) {
            if((!ROL_ASIS.contains(u.prof_position_id__c) && ROL_ASIS.contains(userNewMap.get(u.Id).prof_position_id__c)) ||
               (!ROL_SG.contains(u.prof_position_id__c) && ROL_SG.contains(userNewMap.get(u.Id).prof_position_id__c))) {
                idAsist_Sgof.add(u.Id);
               }
        }
        Final Integer idAsist_SgofSize = idAsist_Sgof.size();
        if(idAsist_SgofSize > 0) insertNewMembersFormalization(idAsist_Sgof);
    }
    
    /**
    * --------------------------------------------------------------------------------------
    * @Description 
    * Metodo reutilizable para insertar usuarios con nuevo rol de Asistentes/Subgerentes a grupos de formalización
    **/
    @future
    private static void insertNewMembersFormalization(Set<Id> idAsist_Sgof) {
        Final User[] newAsist_Sgof = [SELECT Id, prof_position_id__c FROM User WHERE ID IN: idAsist_Sgof];
        Final List<Group> lstGroup= [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN ('Subgerentes_Operativos', 'Asistentes_Operativos') limit 2];
        Final Integer lstGroupSize = lstGroup.size();
        if(lstGroupSize == 2) {
            Map<String, String> grupos = Formalization_helper.getGroup(lstGroup, 'Subgerentes_Operativos');
            Final Id idSgofGroup = grupos.get('grp1');
            Final Id idAssistantGroup = grupos.get('grp2');
            Final List<GroupMember> newMembers = new List<GroupMember>();
            GroupMember member;
            for(User u:newAsist_Sgof) {
                //Nuevos Asistentes
                if(ROL_ASIS.contains(u.prof_position_id__c)) {
                    member = new GroupMember(GroupId=idAssistantGroup, UserOrGroupId=u.Id);
                } else {//Nuevos Subgerentes
                    member = new GroupMember(GroupId=idSgofGroup, UserOrGroupId=u.Id);
                }
                newMembers.add(member);
            }
            insert newMembers;
        }
    }
      
}