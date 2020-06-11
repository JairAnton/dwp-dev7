/**
 * ------------------------------------------------------------------------------------------------
 * @Name Be_DynamicTablePresentationSettings_cls
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-05-01
 * @Group
 * @Description Controller class Be_DynamicTablePresentationSettings_cls
 *
 */
global with sharing class Be_DynamicTablePresentationSettings_cls extends VisualEditor.DynamicPickList {
	/**
	   @Description return a default value of Metadata
	   @return a VisualEditor.DataRow with default value NONE.
	 */
	global override VisualEditor.DataRow getDefaultValue() {
		return new VisualEditor.DataRow('None', 'NONE');
	}

	/**
	   @Description return List of Metadata options
	   @return a VisualEditor.DynamicPickListRowsw from information of Be_Dynamic_Table_Presentation__mdt
	 */
	global override VisualEditor.DynamicPickListRows getValues() {
		VisualEditor.DynamicPickListRows myValues = new VisualEditor.DynamicPickListRows();
		for(Be_Dynamic_Table_Presentation__mdt itemMdt : [SELECT MasterLabel, DeveloperName FROM Be_Dynamic_Table_Presentation__mdt LIMIT 10000]) {
			myValues.addRow(new VisualEditor.DataRow(itemMdt.MasterLabel, itemMdt.DeveloperName));
		}
		return myValues;
	}
}
