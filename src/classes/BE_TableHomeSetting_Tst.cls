/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_TableHomeSetting_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-03-26
   @Description test for BE_TableHomeSetting_Cls class
   @Changes
   Date        Author   Email                               Type
   2019-09-13  MAMC     martin.mori.contractor@bbva.com     Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_TableHomeSetting_Tst {
    /**
     @Description test BE_TableHomeSetting_Cls.getDefaultValueTest(), correct scenary
    */
    @IsTest
    static void getDefaultValueTest() {
        final BE_TableHomeSetting_Cls tableSet = new BE_TableHomeSetting_Cls();
        final VisualEditor.DataRow defaultValue = tableSet.getDefaultValue();
        System.assertEquals('NONE', defaultValue.getValue(), 'Correct Value');
    }
    
    /**
     @Description test BE_TableHomeSetting_Cls.getValues(),correct scenary
    */
    @IsTest(SeeAllData='true')
    static void getValuesTest() {
        final BE_TableHomeSetting_Cls tableSet = new BE_TableHomeSetting_Cls();
        final VisualEditor.DynamicPickListRows  myValues = tableSet.getValues();
        final Boolean myValuesCheck = (myValues!=null) ? true : false;
        System.assertEquals(true, myValuesCheck);
    }
}