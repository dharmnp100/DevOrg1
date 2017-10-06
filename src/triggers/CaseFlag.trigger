trigger CaseFlag on EmailMessage (after insert , after update) {
    Set<Id> caseId = new Set<Id>();
    for(EmailMessage email1 : trigger.new)
    {
        //system.debug('------------'+email1.Incoming);
        //system.debug('------------'+email1.Status);
        /*if(email1.Incoming && email1.Status == '0')
        {
            caseId.add(email1.ParentId);
        }*/
        if(email1.Status != '0')
        {
            system.debug('------------'+email1.Status);
        }
    }
    if(caseId.size() > 0)
    {
        for(Case caseRec : [Select Id,New_email__c,(Select Incoming, Status From EmailMessages) From Case where Id IN: caseId])
        {
            
        }
    }
}