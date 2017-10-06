public class LiveChatWindowController
{
    
    public integer sequence {get; set;}
    Map<String, Object> respMap;
    
    public LiveChatWindowController()
    {
        system.debug('sequence>>>> in constructor     '+sequence);
        if(sequence == null)
        {
            sequence = 0;
        }
        respMap = new Map<String, Object> ();
    }
    
    public PageReference doCall()
    {
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        
        if(sequence == 0)
        {           
            req.setEndpoint('https://d.la1t1.salesforceliveagent.com/chat/rest/System/SessionId');
            req.setHeader('X-LIVEAGENT-API-VERSION','37');
            req.setHeader('X-LIVEAGENT-AFFINITY','null');
            req.setMethod('GET');
            //req.setBody(payLoad);
            HttpResponse res = h.send(req);
            system.debug('response>>>>      '+res.getBody());        
            respMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        }
        
        system.debug('response>>>>      '+respMap);
        system.debug('sequence>>>>      '+sequence);
       
        req = new HttpRequest();
        req.setEndpoint('https://d.la1t1.salesforceliveagent.com/chat/rest/System/Messages?ack='+ sequence);
        sequence = sequence + 1;
        req.setHeader('X-LIVEAGENT-API-VERSION','37');
        req.setHeader('X-LIVEAGENT-AFFINITY',String.valueOf(respMap.get('affinityToken')));
        req.setHeader('X-LIVEAGENT-SESSION-KEY',String.valueOf(respMap.get('key')));        
        //req.setHeader('ack','-1');        
        
        req.setMethod('GET');
        req.setTimeout(39000);
        HttpResponse res2 = h.send(req);
        system.debug('response>>>>   body   '+res2.getBody());
        system.debug('response>>>>  header Keys    '+res2.getHeaderKeys());
        system.debug('response>>>>      '+res2);

        
        
        return null;
    }
    
    
    public PageReference fetchVisitorId()
    {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        
        req.setEndpoint('https://d.la1t1.salesforceliveagent.com/chat/rest/Visitor/VisitorId?org_id=00D90000000pYmX&deployment_id=572900000008bnd');
        req.setHeader('X-LIVEAGENT-API-VERSION','37');      
        req.setMethod('GET');
        //req.setBody(payLoad);
        HttpResponse res = h.send(req);
        system.debug('response>>>>      '+res.getBody());               
        return null;
    }
}