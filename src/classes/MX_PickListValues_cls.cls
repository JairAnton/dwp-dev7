/**
*Desarrollado por:       Indra
*Autor:                  Isaías Velázquez Cortés
*Proyecto:               DWP Perú
*Descripción:            Clase para PickList Personalizado (Reutilizable)
* 
*Cambios (Versiones)  
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 26-07-2018     |    Isaías Velázquez      |           Creación      
**/
public class MX_PickListValues_cls {
    @AuraEnabled        
    public static List<WRP_PickList> getPickListValuesIntoList(String objectType, String selectedField,String recordType){
        map<String, WRP_PickList> pickListValuesList = new map<String, WRP_PickList>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
       
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.put(pickListVal.getValue(),new WRP_PickList(pickListVal.getValue(),pickListVal.getLabel()));
        }     
        return pickListValuesList.values();
    }
    /*Wrapper class to include translation to the picklist*/
    public class WRP_PickList{
        @AuraEnabled public String Value {get; set;}
        @AuraEnabled public String Label {get; set;}
        public WRP_PickList(String toValue, String toLabel){
            this.Value = toValue;
            this.Label = toLabel;
        }
    }
    //Yulino 11/12/2018 : Se agrego el contructor
    public MX_PickListValues_cls(){  
    }
}