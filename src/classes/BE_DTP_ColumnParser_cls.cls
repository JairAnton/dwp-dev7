/**
 * ------------------------------------------------------------------------------------------------
 * @Name BE_DTP_ColumnParser_cls
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-09-03
 * @Group
 * @Description Controller class BE_DTP_ColumnParser_cls
 */
public with sharing class BE_DTP_ColumnParser_cls {
    
    /*
	 * @Description  BE_DTP_ColumnParser_cls Constructor
	 */
    private BE_DTP_ColumnParser_cls() {}

    /*
	 * @Description  get Columns for a specific filter
	 */
	public static List<Column> getColumnsType(String filter, String mdtColumns) {
		Final Object objColumns = (Object) JSON.deserializeUntyped(mdtColumns);
		Final Map<String, Object> mapColumns = (Map<String, Object>) objColumns;
		Final List<Object> lstColumn = (List<Object>) mapColumns.get(filter);
		return (List<Column>) parseObject(JSON.serialize(lstColumn));
    }

    /*
	 * @Description  parse Columns type
	 */
    public static List<Column> parseObject(String body) {
        return (List<Column>) JSON.deserialize(body, List<Column>.class);
    }
    
    /*
	 * @Description  Column Class
	 */
	public with sharing class Column {
		
		/**Indicate if the transaction is Success*/
		@AuraEnabled
		public String label {set; get;}
		/**Message to show in the front to final user*/
		@AuraEnabled
		public String fieldName {set; get;}
		/**type*/
		@AuraEnabled
		public String type {set; get;}
        /**TypeAttributes*/
		@AuraEnabled
		public TypeAttributes typeAttributes {set; get;}
        
        /*
		* @Description  Column Constructor
		*/
		private Column() {}
	}

	/*
	 * @Description  TypeAttributes
	 */
	public with sharing class TypeAttributes {

        /**label*/
		@AuraEnabled
		public Label label {set; get;}
        /**formatStyle*/
		@AuraEnabled
		public String formatStyle {set; get;}
        /**currencyCode*/
		@AuraEnabled
		public String currencyCode {set; get;}
		/**currencyDisplayAs*/
		@AuraEnabled
		public String currencyDisplayAs {set; get;}
        
        /*
		* @Description  TypeAttributes Constructor
		*/
		private TypeAttributes() {}
	}

    /*
	 * @Description  Label Class
	 */
	public with sharing class Label {

        /**fieldName*/
		@AuraEnabled
		public String fieldName {set; get;}
        
        /*
		* @Description  Label Constructor
		*/
		private Label() {}
	}
}