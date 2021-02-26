/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SRL_Views_Tst>
   @Author Deyby Bazan Villegas (deyby.bazan.contractor@bbva.com)
   @Date 2021-02-23
   @Description test for BE_SRL_Views_Ctr class
   @Changes
   Date        Author   Email                  			   Type
   2021-02-23  DBAV     deyby.bazan.contractor@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest

public class BE_SRL_Views_Tst {
    /** Variable Metadata */
	private static final String LABEL = 'Test View';
    /** Variable Metadata */
   	private static final String VALUE = 'TEST_VIEW';

    /**
     @Description test BE_SRL_Views_Ctr.getConfigMeta(), correct scenary
    */
    @isTest 
    static void getConfiMetadataTest() {
    final BE_SRL_Views_Ctr.ViewOptions cView = new BE_SRL_Views_Ctr.ViewOptions(label,value);
   	BE_SRL_Views_Ctr.getConfigMeta(value);
    System.assertEquals('Test View', cView.label,'Value Correct');
    }
    /**
     @Description test BE_SRL_Views_Ctr.ViewOptions, correct scenary
    */
    @isTest
    static void getOptionsTest() {
    final BE_SRL_Views_Ctr.ViewOptions cViews = new BE_SRL_Views_Ctr.ViewOptions(label,value);    
    System.assertEquals('Test View',cViews.label, 'VALUE OK');
    }

    
    
    
}