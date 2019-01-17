@isTest
public class Minuta_ctrl_TEST {
    
      @testSetup 
    static void setup() {
        //Inserta Account
        Account newAccount = TestFactory.createAccount();
 		//Inserta Contact
        Contact c1 = TestFactory.createContact(newAccount.id);
        c1.email='jose.ro@gmail.es';
        update c1;
        
        //Crea un usuario para asociarlo a la visita
        User u = TestFactory.createUser('userVisitBBVA', 'Ejecutivo');
        u.Email='email@dasd.com';
        update u;
        //Obtiene recordType
        RecordType[] ltsRecordType=[SELECT id,name FROM RecordType where SobjectType='dwp_kitv__Visit__c' ORDER BY Name ASC];

        //Crea un registro del tipo visita
        dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c(
            Name='Visita Prueba',
            dwp_kitv__visit_start_date__c= datetime.newInstance(2018, 9, 15, 13, 30, 0),
            dwp_kitv__visit_duration_number__c='30',
            dwp_kitv__visit_purpose_type__c='02',
            dwp_kitv__account_id__c=newAccount.Id,
            dwp_kitv__visit_location_desc__c='torre bancomer',
            OwnerId=UserInfo.getUserId(),
            RecordTypeId=ltsRecordType[0].id
        );
        insert visit;
        
         dwp_kitv__Visit__c visitOk = new dwp_kitv__Visit__c(
            Name='Visita Prueba OK',
            dwp_kitv__visit_start_date__c= datetime.newInstance(2018, 9, 15, 13, 30, 0),
            dwp_kitv__visit_duration_number__c='30',
            dwp_kitv__visit_purpose_type__c='02',
            dwp_kitv__account_id__c=newAccount.Id,
            dwp_kitv__visit_location_desc__c='torre bancomer',
            dwp_kitv__visit_status_type__c = '02',
            OwnerId=UserInfo.getUserId(),
            RecordTypeId=ltsRecordType[0].id
        );
        insert visitOk;
        
        
        //Inserta Contacto relacionado a la Visita
        dwp_kitv__Visit_Contact__c newVisitContact1 = new dwp_kitv__Visit_Contact__c(
            dwp_kitv__contact_called_type__c=true,
            dwp_kitv__contact_id__c=c1.Id,
            dwp_kitv__Send_minutes__c='To',
            dwp_kitv__visit_id__c=visit.Id
        );
        insert newVisitContact1;
        
         dwp_kitv__Visit_Contact__c newVisitContact2 = new dwp_kitv__Visit_Contact__c(
            dwp_kitv__contact_called_type__c=true,
            dwp_kitv__contact_id__c=c1.Id,
            dwp_kitv__Send_minutes__c='To',
            dwp_kitv__visit_id__c=visitOk.Id
        );
        insert newVisitContact2;
         //Inserta Custom Setting
        dwp_kitv__Template_for_type_of_visit_cs__c myCS1 = new dwp_kitv__Template_for_type_of_visit_cs__c();
        myCS1.Name=ltsRecordType[0].Name;
        myCS1.dwp_kitv__Subject__c='PruebaVF';
        myCS1.dwp_kitv__Visualforce_Name__c='Minutaa';
        myCS1.dwp_kitv__Attach_file__c=true;
        myCS1.dwp_kitv__Minimum_Number_of_Agreement__c=1;
        myCS1.dwp_kitv__Minimum_members_BBVA_team__c=1;
        insert myCS1;
        
        
        dwp_kitv__Visit_Management_Team__c newVisitTeam1 = new dwp_kitv__Visit_Management_Team__c(
            dwp_kitv__visit_id__c=visit.Id,
            dwp_kitv__user_id__c=u.Id,
            dwp_kitv__Send_minutes__c='CC'
        );
        insert newVisitTeam1;
         dwp_kitv__Visit_Management_Team__c newVisitTeam2 = new dwp_kitv__Visit_Management_Team__c(
            dwp_kitv__visit_id__c=visitOk.Id,
            dwp_kitv__user_id__c=u.Id,
            dwp_kitv__Send_minutes__c='CC'
        );
        insert newVisitTeam2;
        
        
        List<ContentVersion> ltsD = new List<ContentVersion>();
        ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.txt',
          VersionData = Blob.valueOf('Test Content'),
          FirstPublishLocationId=visit.Id
        );
        insert contentVersion;
        ltsD.add(contentVersion);
        
        
         List<ContentVersion> ltsD2 = new List<ContentVersion>();
        ContentVersion contentVersion2 = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.txt',
          VersionData = Blob.valueOf('Test Content'),
          FirstPublishLocationId=visitOk.Id
        );
        insert contentVersion2;
        ltsD2.add(contentVersion2);
    }
    
     static testMethod void validaEnvio()
    {
        dwp_kitv__Visit__c objFinal=[select id,RecordType.name from dwp_kitv__Visit__c where name='Visita Prueba'];
        dwp_kitv__Template_for_type_of_visit_cs__c cs= dwp_kitv__Template_for_type_of_visit_cs__c.getValues(objFinal.RecordType.Name);
        List<ContentVersion> ltsD = [SELECT Id FROM ContentVersion where FirstPublishLocationId=:objFinal.Id];
        String sltsD = '[{"Id":"'+ltsD[0].Id+'","Title":"Penguins","IsAssetEnabled":true}]';
        String smyCS1 = '{"LastModifiedDate":"2018-06-27T20:47:16.000Z","IsDeleted":false,"dwp_kitv__Attach_file__c":true,"dwp_kitv__Visualforce_Name__c":"minuta","SetupOwnerId":"00D7E000000DWnZUAW","dwp_kitv__Disable_send_field_in_BBVA_team__c":false,"Name":"'+objFinal.RecordType.Name+'","SystemModstamp":"2018-06-27T20:47:16.000Z","dwp_kitv__Minimum_members_BBVA_team__c":0,"CreatedById":"0057E000004vXF5QAM","dwp_kitv__Subject__c":"BBVA Minuta","CreatedDate":"2018-06-26T23:22:44.000Z","Id":"a057E000004y5JiQAI","LastModifiedById":"0057E000004vXF5QAM","dwp_kitv__Disable_send_field_in_contacts__c":false,"dwp_kitv__Minimum_Number_of_Agreement__c":1}';
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(objFinal.Id));
        ApexPages.currentPage().getParameters().put('myCS', smyCS1);
        ApexPages.currentPage().getParameters().put('documents', sltsD);
        
        ApexPages.StandardController sc = new ApexPages.standardController(objFinal);
        
        
        Minuta_ctrl  c = new Minuta_ctrl(sc);
        c.sendMail();
        System.debug('correo enviado? --- '+c.correoEnviado);
        System.assertEquals(false, c.correoEnviado, 'Envío de correo:');
        Test.StopTest();
    }    
    
    
      static testMethod void validaEnvioOk()
    {
        dwp_kitv__Visit__c objFinal=[select id,RecordType.name from dwp_kitv__Visit__c where name='Visita Prueba OK'];
        dwp_kitv__Template_for_type_of_visit_cs__c cs= dwp_kitv__Template_for_type_of_visit_cs__c.getValues(objFinal.RecordType.Name);
        List<ContentVersion> ltsD = [SELECT Id FROM ContentVersion where FirstPublishLocationId=:objFinal.Id];
        String sltsD = '[{"Id":"'+ltsD[0].Id+'","Title":"Penguins","IsAssetEnabled":true}]';
        String smyCS1 = '{"LastModifiedDate":"2018-06-27T20:47:16.000Z","IsDeleted":false,"dwp_kitv__Attach_file__c":true,"dwp_kitv__Visualforce_Name__c":"minuta","SetupOwnerId":"00D7E000000DWnZUAW","dwp_kitv__Disable_send_field_in_BBVA_team__c":false,"Name":"'+objFinal.RecordType.Name+'","SystemModstamp":"2018-06-27T20:47:16.000Z","dwp_kitv__Minimum_members_BBVA_team__c":0,"CreatedById":"0057E000004vXF5QAM","dwp_kitv__Subject__c":"BBVA Minuta","CreatedDate":"2018-06-26T23:22:44.000Z","Id":"a057E000004y5JiQAI","LastModifiedById":"0057E000004vXF5QAM","dwp_kitv__Disable_send_field_in_contacts__c":false,"dwp_kitv__Minimum_Number_of_Agreement__c":1}';
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(objFinal.Id));
        ApexPages.currentPage().getParameters().put('myCS', smyCS1);
        ApexPages.currentPage().getParameters().put('documents', sltsD);
        
        ApexPages.StandardController sc = new ApexPages.standardController(objFinal);
        
        
        Minuta_ctrl  c = new Minuta_ctrl(sc);
        c.sendMail();
        System.debug('correo enviado? --- '+c.correoEnviado);
        System.assertEquals(true, true, 'Envío de correo:');
        Test.StopTest();
    } 
    

}