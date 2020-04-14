/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Document_GetImage_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-04-14
   @Description test for BE_Document_GetImage_Ctrl class
   @Changes
   Date        Author   Email                               Type
   2020-04-14  MAMC     martin.mori.contractor@bbva.com     Creation
   -------------------------------------------------------------------------------------------------
 */
@IsTest
public with sharing class BE_Document_GetImage_Tst {
    /**
     @Description test BE_Document_GetImage_Ctrl.getStringUrl(), correct scenary
    */
    @IsTest
    static void getStringUrl() {
        final Document doc = new Document();
        doc.Body = Blob.valueOf('Some Text');
        doc.ContentType = 'application/pdf';
        doc.DeveloperName = 'Document_GetImage_Tst';
        doc.IsPublic = true;
        doc.Name = 'Document_GetImage_Tst';
        doc.FolderId = [SELECT Id FROM Folder WHERE Type = 'Document' LIMIT 1].Id;
        insert doc;
        
        final BE_Document_GetImage_Ctrl getImage = new BE_Document_GetImage_Ctrl();
        getImage.developerName = 'Document_GetImage_Tst2';
        String urlString = getImage.stringUrl;
        getImage.developerName = 'Document_GetImage_Tst';
        urlString = getImage.stringUrl;
        System.assert(String.isNotEmpty(urlString), 'Correct Value');
    }
}