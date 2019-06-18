/*
 * @Name: User_Trigger_Test
 * @Description: Trigger de Ejecucion User
 * @Create by: Jose Rodriguez
 * 
 * V0-Creacion
*/
@isTest(seeAllData=true)
private class User_Trigger_Test {
    static List<User> users;
    static{
        users = new List<User> ([SELECT Id, Name , unique_id__c, organizational_unit_id__c,
                                 organizational_unit_name__c, prof_position_type__c, isactive FROM User where isactive = true limit 50]);
    } 

    @isTest
    static void AsignBeforeInsert() {
       String userName = 'usuario.salesforce';
        User userToInsert = new User();
        Double random = Math.random();
        userToInsert.Username=userName+'u2@u.com.u'+random;
		userToInsert.LastName=userName+'uLast2';
        userToInsert.Email=userName+'u2@u.com';
        userToInsert.Alias= String.valueOf(random).substring(0, 3)+'uAas2';
        userToInsert.TimeZoneSidKey='America/Mexico_City';
		userToInsert.IsActive=true;
        userToInsert.LocaleSidKey='en_US';
        userToInsert.EmailEncodingKey='ISO-8859-1';
        List<Profile> prof=new List<Profile>([SELECT Id, Name FROM Profile where Name='Migracion']);
        userToInsert.ProfileId=  prof[0].Id;
        userToInsert.LanguageLocaleKey='es';
        userToInsert.Unique_id__c = 'p088888';
        userToInsert.organizational_unit_id__c = '00027902';
        userToInsert.organizational_unit_name__c = 'BIBEC PERU';
        userToInsert.prof_position_type__c = 'LEVEL C';
        boolean exito = false;
        Test.startTest();
        insert userToInsert;
        exito=true;
        System.assertEquals(true, exito, 'Se creo correctamente el usuario');
        Test.stopTest(); 
    }
    
    @isTest
    static void AsignBeforeUpdate() {
        boolean exito = false;
        Test.startTest();
        update(users);
        exito=true;
        System.assertEquals(true, exito, 'Se actualizarón correctamente el usuario');
        Test.stopTest();
    }
}