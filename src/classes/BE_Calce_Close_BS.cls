/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_Calce_Close_BS>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-06-21
   @Description Schedulable class from BE_Calce_Close_Batch
   @Changes
   Date        Author   Email                  				Type
   2020-06-21  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class BE_Calce_Close_BS implements Schedulable {
    /**
    @Description execute method
    */
    public void execute(SchedulableContext context) {
        Database.executeBatch(new BE_Calce_Close_Batch());
    }
}