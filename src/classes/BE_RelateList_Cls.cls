/**
* _________________________________________________________________________________
* @Name     BE_RelateList_Cls
* @Author   Antony de la rosa guzman.
* @Date     2019-11-13
* @Group    DWP Perú
* @Description Creación de la clase controladora para el componente lightning 
*              BE_relateListVisit_Cmp y BE_relateList_Cmp. Funciona obteniendo los datos de las vistas relacionadas con el cliente.
*              *Clase de pruebas BE_RelateList_Test.
* _________________________________________________________________________________
* @Changes
* _________________________________________________________________________________
*/
public with sharing class BE_RelateList_Cls {
       /**
* _____________________________________________________________________________
* @Description Constructor de la clase
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* @example BE_RelateList_Cls example = new BE_RelateList_Cls();
* _____________________________________________________________________________
*/
    @testVisible private BE_RelateList_Cls() {}
    
    /**
* _____________________________________________________________________________
* @Description funcion que retorna la lista con la configuracion indicada de cada lista relacionada de visitas.
* _____________________________________________________________________________
* @Author Antony de la rosa guzman.
* @Date 2019-11-13
* _____________________________________________________________________________
*/
    @auraEnabled
    public static string getRelatedVisit(String accId, String objectName,String FieldNameRelation, String fields, String filters, String orderRow, String limitRow) {
        String query = 'SELECT Id,OwnerId, ' +String.escapeSingleQuotes(fields)+ ' FROM ' +String.escapeSingleQuotes(objectName)+ ' WHERE '+String.escapeSingleQuotes(FieldNameRelation)+' = :accId'+ (filters!='' && filters!=null?' AND ' + filters : '');
        if(orderRow!=null && orderRow!='') {
            query += ' ORDER BY ' + String.escapeSingleQuotes(orderRow);
        }
        if(limitRow!=null && limitRow!='') {
            query += ' LIMIT ' + String.escapeSingleQuotes(limitRow);
        }
        final List<sObject> sobjList = Database.query(query);
        return JSON.serialize(sobjList);
    }
}
