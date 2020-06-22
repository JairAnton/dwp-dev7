/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Calce_Create_BS>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Schedulable class from BE_Calce_Create_Batch
   @Changes
   Date        Author   Email                  				Type
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
global without sharing class BE_Calce_Create_BS implements Schedulable {
    /**
    @Description execute method
    */
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new BE_Calce_Create_Batch());
    }
}