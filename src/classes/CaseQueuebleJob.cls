public class CaseQueuebleJob implements Queueable, Database.AllowsCallouts 
{
    private Case ticket;

    public CaseQueuebleJob(Case ticket)
    {
        this.ticket = ticket;
    }
    
    // Interface method. 
    // Creates the map of non-null Case fields, gets the Callout__c object
    // depending on current context JobID.
    // In case of failure, the job is queued again.
    public void execute(QueueableContext context) 
    { 

        //1 - creates the callout payload
        String reqBody = JSON.serialize(this.ticket);

        //4 - tries to make the REST call
        try
        {
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            //change this to another bin @ http://requestb.in
            request.setEndpoint('http://requestb.in/1jfcni01');
            request.setTimeout(60000);
            request.setBody(reqBody);
            HttpResponse response = h.send(request);
    
            system.debug('response-->   '+response.getBody());
        }
        catch(Exception e)
        {
            system.debug(e);
        }    
    }

}