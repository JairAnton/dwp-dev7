/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SingleRelatedListSetting_Cls>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description Class to get List of Metadata Options
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
global without sharing class BE_SingleRelatedListSetting_Cls  extends VisualEditor.DynamicPickList{
    
    
    /**
     @Description return a default value of Metadata
     @return a VisualEditor.DataRow with default value NONE.
   */
    global override VisualEditor.DataRow getDefaultValue(){
      return new VisualEditor.DataRow('None', 'NONE');
    }

    /**
     @Description return List of Metadata options
     @return a VisualEditor.DynamicPickListRowsw from information of BE_SingleRelatedList_Setting__mdt
   */
    global override VisualEditor.DynamicPickListRows getValues() {
      VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
      for (BE_SingleRelatedList_Setting__mdt itemMdt : [SELECT MasterLabel, DeveloperName FROM BE_SingleRelatedList_Setting__mdt LIMIT 10000]) {
        myValues.addRow(new VisualEditor.DataRow(itemMdt.MasterLabel, itemMdt.DeveloperName));
      }
      return myValues;
    }
}