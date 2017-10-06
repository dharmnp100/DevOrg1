/*
Helper class contains method used in Informatica integration activities
*/

public class InformaticaHelper 
{
    // This method return tag value from xml string based on tag name
    private static string getValueFromXMLString(string xmlString, string keyField)
    {
        string valueFound = '';
        /*if(xmlString.contains('<' + keyField + '>') && xmlString.contains('</' + keyField + '>'))
        {
            try{
                valueFound = xmlString.substring(xmlString.indexOf('<' + keyField + '>') + keyField.length() + 2, xmlString.indexOf('</' + keyField + '>'));   
            }catch (exception e){
                system.debug('Error in getValueFromXMLString.  Details: ' + e.getMessage() + ' keyfield: ' + keyfield);
            }           
        }*/
        return valueFound;
    }
    
    /*
    This method performs informatica http callouts
    Parameters : String --> objectName , Integer --> jobs (how many jobs will be called)
    */
    @future (callout=true)
    public static void syncObjectToInformatica(String objectName , Integer jobs )
    {
        /*String userName = system.label.InformaticaUserName;
        String passWord = system.label.InformaticaPassword; 
        String jobName = '';
        string jobType = '' ;
        string icSessionID = '';
        String icServerURL = '';
        try
        {
            HttpRequest logreq = new HttpRequest();
            logreq.setEndpoint('https://app.informaticaondemand.com/ma/api/v2/user/login');
            logreq.setMethod('POST');
            logreq.setHeader('HTTP', '1.0');
            logreq.setHeader('Content-Type', 'application/xml');
            logreq.setHeader('Accept', 'application/xml');
            logreq.setBody('<login><username>' + userName + '</username><password>' + passWord + '</password></login>');
            Http http1 = new Http();
            HTTPResponse res1 = http1.send(logreq);
            if(res1.getBody().contains('<icSessionId>'))
            {
                icSessionID = getValueFromXMLString(res1.getBody(), 'icSessionId');
                icServerURL = getValueFromXMLString(res1.getBody(), 'serverUrl');
            }
            system.debug('------icSessionID------'+icSessionID);
            system.debug('------icServerURL------'+icServerURL);
            
            for(Integer i=1; i<=jobs ;i++)
            {
                string recName = objectName + '_' + i;
                if(JB_Informatica_Details__c.getInstance(recName) != null)
                {
                    jobType = JB_Informatica_Details__c.getInstance(recName).JobType__c;
                    jobName = JB_Informatica_Details__c.getInstance(recName).JobName__c;
                }
                HttpRequest req = new HttpRequest();
                req.setEndpoint(icServerURL+'/api/v2/job');
                req.setBody('<job>' + '<taskName>' + jobName + '</taskName>' + '<taskType>' + jobType + '</taskType>' + '</job>');
                req.setHeader('HTTP', '1.0');
                req.setHeader('Content-Type', 'application/xml');
                req.setHeader('Accept', 'application/xml');
                req.setHeader('icSessionId', icSessionID);
                req.setMethod('POST');
                Http http2 = new Http();
                HTTPResponse res2 = http2.send(req);
                system.debug('------res2.getBody()-------'+res2.getBody());
                system.debug('------res2-------'+res2.toString());
            }
            
                       
        }
        catch(Exception ex)
        {
            system.debug('----------ex---------'+ex);
        }*/
    }
    
    
    @future (callout=true)
    public static void syncObjectToInformatica1(String taskName , String taskType)
    {
        /*String userName = system.label.InformaticaUserName;
        String passWord = system.label.InformaticaPassword; 
        String jobName = taskName;
        string jobType = taskType ;
        string icSessionID = '';
        String icServerURL = '';
        try
        {
            HttpRequest logreq = new HttpRequest();
            logreq.setEndpoint('https://app.informaticaondemand.com/ma/api/v2/user/login');
            logreq.setMethod('POST');
            logreq.setHeader('HTTP', '1.0');
            logreq.setHeader('Content-Type', 'application/xml');
            logreq.setHeader('Accept', 'application/xml');
            logreq.setBody('<login><username>' + userName + '</username><password>' + passWord + '</password></login>');
            Http http1 = new Http();
            HTTPResponse res1 = http1.send(logreq);
            if(res1.getBody().contains('<icSessionId>'))
            {
                icSessionID = getValueFromXMLString(res1.getBody(), 'icSessionId');
                icServerURL = getValueFromXMLString(res1.getBody(), 'serverUrl');
            }
            system.debug('------icSessionID------'+icSessionID);
            system.debug('------icServerURL------'+icServerURL);
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(icServerURL+'/api/v2/job');
            req.setBody('<job>' + '<taskName>' + jobName + '</taskName>' + '<taskType>' + jobType + '</taskType>' + '</job>');
            req.setHeader('HTTP', '1.0');
            req.setHeader('Content-Type', 'application/xml');
            req.setHeader('Accept', 'application/xml');
            req.setHeader('icSessionId', icSessionID);
            req.setMethod('POST');
            Http http2 = new Http();
            HTTPResponse res2 = http2.send(req);
            system.debug('------res2.getBody()-------'+res2.getBody());
            system.debug('------res2-------'+res2.toString());
           
            
                       
        }
        catch(Exception ex)
        {
            system.debug('----------ex---------'+ex);
        }*/
    }
}