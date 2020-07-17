/**
 * Test class for ContentVersion_Trigger_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal		    13/07/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class ContentVersion_Trigger_tst {

    public static testmethod void preventUploadExtnsFiles() {
        //Creación de ContentVersion
        ContentVersion cvInsert = new ContentVersion(Title = 'Test', PathOnClient = 'Test.csv', VersionData = Blob.valueOf('Test ContentVersion'), IsMajorVersion = true);
        insert cvInsert;
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cvInsert.Id LIMIT 1];
        ContentDocument contntDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        //Test
        Test.startTest();
        ContentVersion cvInsertV2 = new ContentVersion(Title = 'Test', PathOnClient = 'Test.exe', VersionData = Blob.valueOf('Test ContentVersion'), 
                                                       IsMajorVersion = true, ContentDocumentId = contntDocument.Id);
        Boolean notInserted;
        try {
            insert cvInsertV2;
        } catch(Exception e) {
            notInserted = true;
        }
        Test.stopTest();
        System.assert(notInserted);
    }
}