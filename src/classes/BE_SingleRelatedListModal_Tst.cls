/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_SingleRelatedListModal_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-03-10
   @Description test for BE_SingleRelatedListModal_Cls class
   @Changes
   Date        Author   Email                  				Type
   2020-03-10  MAMC     martin.mori.contractor@bbva.com		Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public without sharing class BE_SingleRelatedListModal_Tst {
    /**
     @Description test createRecords method, correct scenary
    */
    @IsTest
    static void createSuccessMethodsTest() {
    	List<Account> accs = new List<Account>();
        accs.add(new Account(Name='Test'));
        BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.createRecords(accs, '');
        System.assert(resp.isSuccess, 'success!');
    }
    
    /**
     @Description test updateRecords method, correct scenary
    */
    @IsTest
    static void updateSuccessMethodsTest() {
    	List<Account> accs = new List<Account>();
        accs.add(new Account(Name='Test'));
        insert accs;
        BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.updateRecords(accs, '');
        System.assert(resp.isSuccess, 'success!');
    }
    
    /**
     @Description test deleteRecords method, correct scenary
    */
    @IsTest
    static void deleteSuccessMethodsTest() {
    	List<Account> accs = new List<Account>();
        accs.add(new Account(Name='Test'));
        insert accs;
        BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.deleteRecords(accs, '');
        System.assert(resp.isSuccess, 'success!');
    }
    
    /**
     @Description test createRecords method, incorrect scenary
    */
    @IsTest
    static void createErrorMethodsTest() {
    	BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.createRecords(null, '');
        System.assert(!resp.isSuccess, 'error!');
    }
    
    /**
     @Description test updateRecords method, incorrect scenary
    */
    @IsTest
    static void updateErrorMethodsTest() {
    	BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.updateRecords(null, '');
        System.assert(!resp.isSuccess, 'error!');
    }
    
    /**
     @Description test deleteRecords method, incorrect scenary
    */
    @IsTest
    static void deleteErrorMethodsTest() {
    	BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.deleteRecords(null, '');
        System.assert(!resp.isSuccess, 'error!');
    }

    /**
     @Description test BE_SingleRelatedListCRUD_Cls, correct scenary
    */
    @IsTest
    static void allCRUDsTest() {
    	BE_SingleRelatedListCRUD_Cls srl = new BE_SingleRelatedListCRUD_Cls();
        srl.createRecords(null);
        srl.updateRecords(null);
        srl.deleteRecords(null);
        Boolean isNull = false;
        BE_SingleRelatedListCRUD_Cls.Response resp = srl.readRecords();
        if(resp==null) {
            isNull = true;
        }
        System.assert(!isNull, 'success!');
    }
}