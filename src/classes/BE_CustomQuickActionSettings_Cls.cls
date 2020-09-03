global with sharing class BE_CustomQuickActionSettings_Cls extends VisualEditor.DynamicPickList {
        global BE_CustomQuickActionSettings_Cls() {}
        /**
         @Description return a default value of Metadata
         @return a VisualEditor.DataRow with default value NONE.
       */
        global override VisualEditor.DataRow getDefaultValue() {
            return new VisualEditor.DataRow('None', 'NONE');
        }
    
        /**
         @Description return List of Metadata options
         @return a VisualEditor.DynamicPickListRowsw from information of BE_SingleRelatedList_QuickAction__mdt
       */
       global override VisualEditor.DynamicPickListRows getValues() {
            VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
            for (BE_SingleRelatedList_QuickAction__mdt itemMdt : [SELECT MasterLabel, DeveloperName FROM BE_SingleRelatedList_QuickAction__mdt LIMIT 10000]) {
                myValues.addRow(new VisualEditor.DataRow(itemMdt.MasterLabel, itemMdt.DeveloperName));
            }
           return myValues;
      }

}