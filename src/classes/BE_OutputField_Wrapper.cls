/**
* @author Martín Mori
* @date 10-12-2019
* @group DWP Perú
* @description class used to create output field object
**/
public class BE_OutputField_Wrapper {
    /* Attribute */
    public String apiName {get; set;}
    /* Attribute */
    public String labelField {get; set;}
    /* Attribute */
    public String typeField {get; set;}
    /* Attribute */
    public String valueField {get; set;}
    /**
    * @description constructor class
    */
    public BE_OutputField_Wrapper(String apiName, String labelField, String typeField, String valueField) {
        this.apiName = apiName;
        this.labelField = labelField;
        this.typeField = typeField;
        this.valueField = valueField;
    }
    
    /**
    * @description constructor class
    */
    public BE_OutputField_Wrapper() {
        
    }
}