/*
 * @Name: User_Trigger_cls
 * @Description: Calss User Trigger de Ejecucion
 * @Create by: Jose Erasmo Rodriguez Paredes
 * 
*/
public without sharing class  User_Trigger_cls {
    
    final Map<String,Organizational_Unit_Equivalence__c> orgEquivalentMap = new Map<String,Organizational_Unit_Equivalence__c>();
    final Map<String,User_Position_equivalence__c> positionEquivMap = new Map<String,User_Position_equivalence__c>();
    
    /**
    * @Name: AsignBeforeInsert
    * @Description: Invoca al metodo setEquivalentValues.
    * @author Jose Rodriguez
    */
    public void AsignBeforeInsert(List<User> userNew, Map<id,User>userNewMap){
     setEquivalentValues(userNew);             
    }
    /**
    * @Name: AsignBeforeUpdate
    * @Description: Invoca al metodo setEquivalentValues.
    * @author Jose Rodriguez
    */
    public void AsignBeforeUpdate(List<User> userNew, Map<id,User>userNewMap, list<User>UserOld, Map<id,User>UserOldMap){
     setEquivalentValues(userNew);                    
    } 
    /**
    * @Name: setEquivalentValues
    * @Description: Ejecuta la logica para la asignacion de unidad organizativa y cargo equivalente de un usuario.
    * @author Jose Rodriguez
    */
    public void setEquivalentValues(List<User>userNew){
     List<Organizational_Unit_Equivalence__c>  orgEquivalent =  new List<Organizational_Unit_Equivalence__c>();
     List<User_Position_equivalence__c>  userPosEquiv =  new List<User_Position_equivalence__c>();
     orgEquivalent = [select Organizational_unit__c,Organizational_unit_code__c,Organizational_unit_code_equivalence__c, Organizational_unit_equivalence__c from Organizational_Unit_Equivalence__c limit 200];
     userPosEquiv = [select Organizational_unit__c,Organizational_unit_code__c,User_position__c,User_position_code__c,User_position_equivalence__c from User_Position_equivalence__c limit 200];

     for(Organizational_Unit_Equivalence__c o:orgEquivalent){
      orgEquivalentMap.put(o.Organizational_unit__c+o.Organizational_unit_code__c,o);
     }
     System.debug('orgEquivalentMap:  ' +orgEquivalentMap);
     for(User_Position_equivalence__c p:userPosEquiv){
      positionEquivMap.put(p.Organizational_unit__c+p.Organizational_unit_code__c+p.User_position__c,p);
     }
     System.debug('positionEquivMap: ' +positionEquivMap);
     for(User u : userNew){
      if(orgEquivalentMap.get(u.organizational_unit_name__c+u.organizational_unit_id__c)==null){
       u.Organizational_unit_code_equivalence__c = u.organizational_unit_id__c;
       u.Organizational_unit_equivalence__c = u.organizational_unit_name__c; 
      }else{
       u.Organizational_unit_code_equivalence__c = orgEquivalentMap.get(u.organizational_unit_name__c+u.organizational_unit_id__c).Organizational_unit_code_equivalence__c;
       u.Organizational_unit_equivalence__c = orgEquivalentMap.get(u.organizational_unit_name__c+u.organizational_unit_id__c).Organizational_unit_equivalence__c;   
      }
      if(positionEquivMap.get(u.organizational_unit_name__c+u.organizational_unit_id__c+u.prof_position_type__c)==null){
       u.User_position_equivalence__c = u.prof_position_type__c;     
      }else{
       u.User_position_equivalence__c = positionEquivMap.get(u.organizational_unit_name__c+u.organizational_unit_id__c+u.prof_position_type__c).User_position_equivalence__c;
      }
      System.debug('Cambios aplicados: unidad: ' +u.Organizational_unit_equivalence__c + ' posicion ' + u.User_position_equivalence__c);
     }
    }
}