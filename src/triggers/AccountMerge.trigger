trigger AccountMerge on Account (before insert, before Update) {
    Set<Id> accIds = new Set<Id>();
    List<Contact> conList = new List<Contact>();
    /*for(Account acc : trigger.old)
    {
        //system.debug('------------------'+acc.MasterRecordId);
        accIds.add(acc.MasterRecordId);
    }
    if(accIds.size() > 0)
    {
        for(Contact con : [Select Id,AccountId from Contact where AccountId IN: accIds])
        {
            con.Email = 'nitish.dharm@gmail.com';
            conList.add(con);
        }
    }
    if(conList.size() > 0)
    {
        update conList;
    }*/
    for(Account acc : trigger.new)
    {
        system.debug('-------acc.RecType__c---------'+acc.RecType__c);
        
        acc.AccountNumberUnique__c = acc.AccountNumber__c;
    }
}