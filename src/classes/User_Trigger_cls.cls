/*
 * @Name: User_Trigger_cls
 * @Description: Calss User Trigger de Ejecucion
 * @Create by: Jose Erasmo Rodriguez Paredes
 * 
*/
public without sharing class  User_Trigger_cls {
    public void AsignBeforeInsert(List<User> User_new, Map<id,User>User_NewMap) {
 		setEquivalentValues(User_new);             
    }
    public void AsignBeforeUpdate(List<User>User_new, Map<id,User>User_NewMap,
                                  list<User>User_Old, Map<id,User>User_OldMap){
       setEquivalentValues(User_new);                    
    }
    public void  setEquivalentValues(List<User>User_new){
        List<Organizational_Unit_Equivalence__c>  orgEquivalent =  new List<Organizational_Unit_Equivalence__c>();
        List<User_Position_equivalence__c>  userPositionEquivalent =  new List<User_Position_equivalence__c>();
        orgEquivalent = [select Organizational_unit__c,Organizational_unit_code__c,Organizational_unit_code_equivalence__c, Organizational_unit_equivalence__c from Organizational_Unit_Equivalence__c];
        userPositionEquivalent = [select Organizational_unit__c,Organizational_unit_code__c,User_position__c,User_position_code__c,User_position_equivalence__c from User_Position_equivalence__c];
        Map<String,Organizational_Unit_Equivalence__c> orgEquivalentMap = new Map<String,Organizational_Unit_Equivalence__c>();
        Map<String,User_Position_equivalence__c> userPositionEquivalentMap = new Map<String,User_Position_equivalence__c>();
        for(Organizational_Unit_Equivalence__c o:orgEquivalent){
            orgEquivalentMap.put(o.Organizational_unit__c+o.Organizational_unit_code__c,o);
        }
        System.debug('orgEquivalentMap:  ' +orgEquivalentMap);
        for(User_Position_equivalence__c p:userPositionEquivalent){
            userPositionEquivalentMap.put(p.Organizational_unit__c+p.Organizational_unit_code__c+p.User_position__c,p);
        }
        System.debug('userPositionEquivalentMap:  ' +userPositionEquivalentMap);

        for(User u : User_new) {
            if(orgEquivalentMap.get(u.organizational_unit_name__c+u.organizational_unit_id__c)!=null){
                u.Organizational_unit_code_equivalence__c = orgEquivalentMap.get(u.organizational_unit_name__c+u.organizational_unit_id__c).Organizational_unit_code_equivalence__c;
                u.Organizational_unit_equivalence__c = orgEquivalentMap.get(u.organizational_unit_name__c+u.organizational_unit_id__c).Organizational_unit_equivalence__c;
            }else{
                u.Organizational_unit_code_equivalence__c = u.organizational_unit_id__c;
                u.Organizational_unit_equivalence__c = u.organizational_unit_name__c; 
            }
            
            if(userPositionEquivalentMap.get(u.organizational_unit_name__c+u.organizational_unit_id__c+u.prof_position_type__c)!=null){
                u.User_position_equivalence__c = userPositionEquivalentMap.get(u.organizational_unit_name__c+u.organizational_unit_id__c+u.prof_position_type__c).User_position_equivalence__c;
            }else{
                u.User_position_equivalence__c = u.prof_position_type__c; 
            }
            System.debug('Cambios aplicados: unidad: ' +u.Organizational_unit_equivalence__c + ' posicion ' + u.User_position_equivalence__c);
        }
    }
}