/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_ForecastPlanGroupingManager_Qs>
   @Author Lolo Michel Bravo Ruiz (lolo.bravo@bbva.com)
   @Date 2019-11-22
   @Description Schedule Queueable Class for create grouping plans to manager.
   @Changes
   Date        Author   Email                  Type
   2019-11-22  LMBR     lolo.bravo@bbva.com    Created
   -------------------------------------------------------------------------------------------------
 */
public with sharing class BE_ForecastPlanGroupingManager_Qs implements Schedulable {
/**
   @Description privet constructor.
 */
public BE_ForecastPlanGroupingManager_Qs () {
}
/**
    @Description create grouping plan for manager.
    @param SchedulableContext.
    @return void
 */
public void execute(SchedulableContext sc) {
	System.enqueueJob(new BE_ForecastPlanGroupingManager_Queue());
}
}
