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

    /** Test Method preventUploadExtnsFiles*/
    public static testmethod void preventUploadExtnsFiles() {
        //Creación de ContentVersion
        insert new ContentVersion(Title = 'Test', PathOnClient = 'Test.csv', VersionData = Blob.valueOf('Test ContentVersion'), IsMajorVersion = true);
        Final ContentDocument contntDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        //Test
        Test.startTest();
        Boolean notInserted;
        try {
            insert new ContentVersion(Title = 'Test', PathOnClient = 'Test.exe', VersionData = Blob.valueOf('Test ContentVersion'), 
                                                       IsMajorVersion = true, ContentDocumentId = contntDocument.Id);
        } catch(Exception e) {
            notInserted = true;
        }
        Test.stopTest();
        System.assert(notInserted, 'Assertion Error');
    }
}