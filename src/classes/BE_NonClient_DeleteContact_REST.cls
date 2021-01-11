/**
----------------------------------------------------------------------------------------------------
@Name <BE_DeleteNonClientContact_REST>
@Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
@Date 2020-05-12
@Description Class BE_DeleteNonClientContact_REST 
@Changes
    Date        Author   Email                  Type        
    2020-05-12  LMBR     lolo.bravo@bbva.com    Creation   
----------------------------------------------------------------------------------------------------
*/
public without sharing class BE_NonClient_DeleteContact_REST {

    /**
    @Description call REST API to detele contact of Non CLient
    @param  Map<String, Object> placeholderMap 
    @return System.HttpResponse response
    */
    public System.HttpResponse invoke(Map<String, Object> placeholderMap) {
        return iaso.GBL_Integration_GenericService.invoke('DeleteNonBusinessContact', placeholderMap);
    }
}