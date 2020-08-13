/**
 * Trigger of ContentVersion object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal		    13/07/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
trigger ContentVersion_tgr on ContentVersion (before insert) {
    new ContentVersion_Handler_cls().run();
}