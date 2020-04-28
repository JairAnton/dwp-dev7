/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_TableHomeSetting_Cls>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-03-23
   @Description Class to get List of Report Options
   @Changes
   Date        Author   Email                               Type
   2020-03-23  MAMC     martin.mori.contractor@bbva.com     Creation
   -------------------------------------------------------------------------------------------------
 */
global without sharing class BE_TableHomeSetting_Cls extends VisualEditor.DynamicPickList {
    /**
     @Description return a default value of Metadata
     @return a VisualEditor.DataRow with default value NONE.
   */
    global override VisualEditor.DataRow getDefaultValue() {
      return new VisualEditor.DataRow('None', 'NONE');
    }

    /**
     @Description return List of Metadata options
     @return a VisualEditor.DynamicPickListRowsw from information of Reports
   */
    global override VisualEditor.DynamicPickListRows getValues() {
        final VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        for (Report rep : [SELECT DeveloperName, Name FROM Report WHERE Format='Tabular' LIMIT 10000]) {
            myValues.addRow(new VisualEditor.DataRow(rep.Name, rep.DeveloperName));
        }
        return myValues;
    }
}