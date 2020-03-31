/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_TableHome_Ctr>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-03-23
   @Description Class to get data of report
   @Changes
   Date        Author   Email                               Type
   2020-03-23  MAMC     martin.mori.contractor@bbva.com     Creation
   -------------------------------------------------------------------------------------------------
 */
 public without sharing class BE_TableHome_Ctr {
    /**
     @Description constructor of class
    */
    private BE_TableHome_Ctr() {
    }

    /**
     @Description return a data of report
     @return a List<List<String>> with data of report.
    */
    @AuraEnabled(cacheable=true)
    public static List<List<String>> getData(String reportId, Integer limitRows) {
        final List<List<String>> data = new List<List<String>>();
        List<String> row = new List<String>();
    
        final Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);
        final Reports.ReportExtendedMetadata rmd =   results.getReportExtendedMetadata();
        final Map<String,Reports.DetailColumn> colMap = rmd.getDetailColumnInfo();
        for(String key : colMap.KeySet()) {
            row.add(colMap.get(key).getLabel());
        }
        data.add(row);

        final Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');
        for(Reports.ReportDetailRow detailRow : factDetails.getRows()) {
            if(data.size()>limitRows) {
                break;
            }
            row = new List<String>();
            for(Reports.ReportDataCell detailCell : detailRow.getDataCells()) {
                row.add(detailCell.getLabel());
            }
            data.add(row);
        }
        return data;
    }
}