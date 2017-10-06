global class Account_Sync
{
    @future (callout=true)
    webservice static void syncAccount(Id accountId)
    {
        String userName = 'integrationaa@aa.com.jbhubpoc';
        String passWord = 'jbhubpocaa1!';
        Account accRec = [Select Id,BillingCountry from Account where Id =: accountId];
        
        try
        {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://www.webservicex.net/globalweather.asmx/GetCitiesByCountry?CountryName='+EncodingUtil.urlEncode(accRec.BillingCountry, 'UTF-8'));
            //req.setEndpoint('http://www.webservicex.net/globalweather.asmx/GetCitiesByCountry');
            req.setMethod('GET');
            /*
            req.setMethod('POST');
            req.setHeader('Content-Length', '1000');
            req.setBody('CountryName='+EncodingUtil.urlEncode(accRec.BillingCountry, 'UTF-8'));
            req.setTimeOut(5000);
            req.setHeader('Charset', 'UTF-8');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');*/
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('------res.getBody()-------'+res.getBody());
            system.debug('------res-------'+res.toString());
            system.debug('------res---as it is----'+res);
            
            //update accRec;
            //return 'Sucess';
        }
        catch(Exception ex)
        {
            //return string.valueOf(ex.getMessage());
            system.debug('----------ex---------'+ex);
        }
    }
}