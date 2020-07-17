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
public without sharing class ContentVersion_Trigger_cls {

    public static void preventUploadExtnsFiles(List<ContentVersion> newLstCV) {
        Final List<String> setExtAllowed = System.Label.Extensions_Allowed.split(',');
        for(ContentVersion cVersion:newLstCV) {
            Final Integer indexDot = cVersion.PathOnClient.lastIndexOf('.');
            if(indexDot > 0 && !String.isEmpty(cVersion.ContentDocumentId)) {
                if(!setExtAllowed.contains(cVersion.PathOnClient.mid(indexDot+1,cVersion.PathOnClient.length()-1))) {
                    cVersion.addError('No puede agregar este tipo de archivo.');
                }
            }
        }
    }
    
}