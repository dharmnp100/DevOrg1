public class AnalyticsAPIConnector{
   
    public String reportData {get; set;}
    public AnalyticsAPIConnector()
    {
        reportData = '';
    }
    //public static string runReportSync(string reportId){
    public void runReportSync(){
        //for testing purpose
        String reportId = '00O90000008vFRo';
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
       
        httpReq.setMethod('GET');
        httpReq.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        httpReq.setEndpoint(
            /*URL.getSalesforceBaseUrl().toExternalForm()+
            '/services/data/v36.0/analytics/reports/' + reportId +
            '?includeDetails=true'*/
            URL.getSalesforceBaseUrl().toExternalForm()+
            '/services/data/v36.0/analytics/reports/' + reportId+ '?includeDetails=true'
        );
       
        httpRes = http.send(httpReq);
       
        //return httpRes.getBody();
        reportData = httpRes.getBody();
        
        //Reports.ReportResults n = (Reports.ReportResults)JSON.deserialize(httpRes.getBody(), Reports.ReportResults.class);
        
        //system.debug('-------'+n);
        
   
    }
    
    public void getReportData()
    {
        String reportId = '00O90000008vFRo';
        Reports.reportResults reportResults = Reports.ReportManager.runReport(reportId, true);
        Reports.ReportFactWithDetails factWithDetails = (Reports.ReportFactWithDetails)reportResults.getFactMap().get('T!T');
        for (Reports.ReportDetailRow row : factWithDetails.getRows()) 
        {
            for (Reports.ReportDataCell cell : row.getDataCells()) 
            {
                reportData = reportData + cell.getLabel();
                System.debug('The cell data: ' + cell.getLabel());
            }
        }  
    }
    
    @RemoteAction
    public static String getReportJSONData()
    {
        String reportId = '00O90000008vFRo';
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
       
        httpReq.setMethod('GET');
        httpReq.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        httpReq.setEndpoint(
            /*URL.getSalesforceBaseUrl().toExternalForm()+
            '/services/data/v36.0/analytics/reports/' + reportId +
            '?includeDetails=true'*/
            URL.getSalesforceBaseUrl().toExternalForm()+
            '/services/data/v36.0/analytics/reports/' + reportId+ '?includeDetails=true'
        );
       
        httpRes = http.send(httpReq);
        //return JSON.createParser(httpRes.getBody());
        system.debug('----------'+httpRes.getBody().unescapeHtml4());
        String resBody = httpRes.getBody().unescapeHtml4();
        system.debug('-----resBody---'+resBody);
        return resBody;
        /*JSON myVar = httpRes.getBody();
        return myVar;*/
    }
}