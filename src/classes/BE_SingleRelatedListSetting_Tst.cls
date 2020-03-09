/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SingleRelatedListSetting_Tst>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2020-03-03
   @Description test for BE_SingleRelatedList_Ctr class
   @Changes
   Date        Author   Email                  Type
   2020-03-03  LMBR     lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_SingleRelatedListSetting_Tst {
    /**
     @Description test BE_SingleRelatedListSetting_Cls.getDefaultValueTest(), correct scenary
    */
    @IsTest
    static void getDefaultValueTest() {
        final BE_SingleRelatedListSetting_Cls sinRelSet=new BE_SingleRelatedListSetting_Cls();
        final VisualEditor.DataRow defaultValue=sinRelSet.getDefaultValue();
        System.assertEquals('NONE', defaultValue.getValue(), 'Correct Value');
    }
    
    /**
     @Description test BE_SingleRelatedListSetting_Cls.getValues(),correct scenary
    */
    @IsTest
    static void getValuesTest() {
        final BE_SingleRelatedListSetting_Cls sinRelSet=new BE_SingleRelatedListSetting_Cls();
        final VisualEditor.DynamicPickListRows  myValues=sinRelSet.getValues();
        final Boolean myValuesCheck=(myValues==null)?false:true;
        System.assert(myValuesCheck, 'CORRECT');
    }
}
