/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SRL_ViewsSettings_Tst>
   @Author Deyby Bazan Villegas (deyby.bazan.contractor@bbva.com)
   @Date 2021-02-23
   @Description test for BE_SRL_ViewsSettings_Cls class
   @Changes
   Date        Author   Email                              Type
   2021-02-23  DBAV     deyby.bazan.contractor@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public without sharing class BE_SRL_ViewsSettings_Tst {
    
    /**
     @Description test BE_SRL_ViewsSettings_Cls.getDefaultValue(), correct scenary
    */
    @IsTest
    static void getDefaultValueTest() {
        final BE_SRL_ViewsSettings_Cls sinRelSet=new BE_SRL_ViewsSettings_Cls();
        final VisualEditor.DataRow defaultValue=sinRelSet.getDefaultValue();
        System.assertEquals('NONE', defaultValue.getValue(), 'Correct Value');
    }
    /**
     @Description test BE_SRL_ViewsSettings_Cls.getValues(), correct scenary
    */
    @IsTest
    static void getValuesTest() {
        final BE_SRL_ViewsSettings_Cls sinRelSet=new BE_SRL_ViewsSettings_Cls();
        final VisualEditor.DynamicPickListRows  myValues=sinRelSet.getValues();
        final Boolean myValuesCheck=(myValues==null)?false:true;
        System.assert(myValuesCheck, 'CORRECT');
    }
}