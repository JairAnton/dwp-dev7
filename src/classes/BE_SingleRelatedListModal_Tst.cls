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
        final List<Account> accs = new List<Account>{new Account(Name='Test')};
        final BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.createRecords(accs, '');
        System.assert(resp.isSuccess, 'success!');
    }
    
    /**
     @Description test updateRecords method, correct scenary
    */
    @IsTest
    static void updateSuccessMethodsTest() {
        final List<Account> accs = new List<Account>{new Account(Name='Test_Success')};
        insert accs;
        final BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.updateRecords(accs, '');
        System.assert(resp.isSuccess, 'successUpdate!');
    }
    
    /**
     @Description test deleteRecords method, correct scenary
    */
    @IsTest
    static void deleteSuccessMethodsTest() {
        final List<Account> accs = new List<Account>{new Account(Name='Test_Delete_Success')};
        insert accs;
        final BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.deleteRecords(accs, '');
        System.assert(resp.isSuccess, 'successDeleteSucess!');
    }
    
    /**
     @Description test createRecords method, incorrect scenary
    */
    @IsTest
    static void createErrorMethodsTest() {
    	final BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.createRecords(null, '');
        System.assert(!resp.isSuccess, 'errorCreate!');
    }
    
    /**
     @Description test updateRecords method, incorrect scenary
    */
    @IsTest
    static void updateErrorMethodsTest() {
    	final BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.updateRecords(null, '');
        System.assert(!resp.isSuccess, 'errorUpdate!');
    }
    
    /**
     @Description test deleteRecords method, incorrect scenary
    */
    @IsTest
    static void deleteErrorMethodsTest() {
    	final BE_SingleRelatedListCRUD_Cls.Response resp = (BE_SingleRelatedListCRUD_Cls.Response)BE_SingleRelatedListModal_Ctr.deleteRecords(null, '');
        System.assert(!resp.isSuccess, 'errorDelete!');
    }

    /**
     @Description test BE_SingleRelatedListCRUD_Cls, correct scenary
    */
    @IsTest
    static void allCRUDsTest() {
    	final BE_SingleRelatedListCRUD_Cls srl = new BE_SingleRelatedListCRUD_Cls();
        srl.createRecords(null);
        srl.updateRecords(null);
        srl.deleteRecords(null);
        Boolean isNull = false;
        final BE_SingleRelatedListCRUD_Cls.Response resp = srl.readRecords(null);
        if(resp==null) {
            isNull = true;
        }
        System.assert(!isNull, 'successAll!');
    }
}