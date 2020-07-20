/**
 * Helper of Handler Trigger for ContentVersion
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal		    13/07/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BE_ContentVersion_Trigger_cls {

    /* Private Constructor*/
    private BE_ContentVersion_Trigger_cls() {}
    
    /**
	*Method preventUploadExtnsFiles for prevent determinate extensions file*/
    public static void preventUploadExtnsFiles(List<ContentVersion> newLstCV) {
        for(ContentVersion cVersion:newLstCV) {
            Final Integer indexDot = cVersion.PathOnClient.lastIndexOf('.');
            if(indexDot > 0 && !String.isEmpty(cVersion.ContentDocumentId) && 
               !System.Label.Extensions_Allowed.split(',').contains(cVersion.PathOnClient.mid(indexDot+1,cVersion.PathOnClient.length()-1))) {
                cVersion.addError(System.Label.Error_InvalidExtensionType);
            }
        }
    }
    
}