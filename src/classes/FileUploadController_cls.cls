/**
*Developed by:       	Indra
*Autor:                 Isaías Velázquez
*Project:               DWP Sales
*Description:           Class to handle The Uploading of Files.
*
*Changes (Version)       
*No.        CreationDate            Autor                      Description
*-------------------------------------------------------------------------------
*------   ----------------   --------------------   ----------------------------
*1.0       	28-05-2018        Isaías Velázquez                   Creation
**/

public without sharing class FileUploadController_cls {
 	@AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        String v_fileId = fileId; //Yulino 06/12/2018 : Se agregó esta variable
        if (fileId == '') {
            v_fileId = saveTheFile(parentId, fileName, base64Data, contentType);//Yulino 06/12/2018 : Se modifico de fileId a v_fileId
        } else {
            appendToFile(v_fileId, base64Data);//Yulino 06/12/2018 : Se modifico de fileId a v_fileId
        }
        return Id.valueOf(v_fileId);//Yulino 06/12/2018 : Se modifico de fileId a v_fileId
    }
 
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        final String v_base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8'); //Yulino 06/12/2018 : Se agrego la variable local
 
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
 
        oAttachment.Body = EncodingUtil.base64Decode(v_base64Data); //Yulino 06/12/2018 : se modificó de base64Data a v_base64Data
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
 
        insert oAttachment;
 
        return oAttachment.Id;
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        final String v_base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8'); //Yulino 06/12/2018 : Se agrego la variable local
 
        Attachment a = [ SELECT Id, Body FROM Attachment WHERE Id =: fileId ];
 
        String existingBody = EncodingUtil.base64Encode(a.Body);
 
        a.Body = EncodingUtil.base64Decode(existingBody + v_base64Data); //Yulino 06/12/2018 : se modificó de base64Data a v_base64Data
 
        update a;
    }
}