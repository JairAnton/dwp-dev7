/**
 * Test class for Be_DynamicTablePresentationSettings_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class Be_DynamicTablePresentationSettings_tst {
	/**
	   @Description test Be_DynamicTablePresentationSettings_cls.getDefaultValue(),correct scenary
	 */
	public static testmethod void getDefaultValue() {
		Test.startTest();
		final Be_DynamicTablePresentationSettings_cls tableSet = new Be_DynamicTablePresentationSettings_cls();
		final VisualEditor.DataRow defaultValue = tableSet.getDefaultValue();
		Test.stopTest();
		System.assertEquals('NONE', defaultValue.getValue(), 'Correct Value');
	}

	/**
	   @Description test Be_DynamicTablePresentationSettings_cls.getValues(),correct scenary
	 */
	@IsTest(SeeAllData = 'true')
	static void getValuesTest() {
		Test.startTest();
		final Be_DynamicTablePresentationSettings_cls tableSet = new Be_DynamicTablePresentationSettings_cls();
		final VisualEditor.DynamicPickListRows myValues = tableSet.getValues();
		Test.stopTest();
		final Boolean myValuesCheck = (myValues == null) ? false : true;
		System.assert (myValuesCheck, 'Correct value');
	}
}
