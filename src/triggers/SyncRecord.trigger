trigger SyncRecord on Sync_Object__c (after insert,after update) {
    List<PartnerNetworkRecordConnection> myConList = new List<PartnerNetworkRecordConnection>();
    for(Sync_Object__c rec : trigger.new)
    {
        if(rec.Status__c == 'Complete')
        {
            PartnerNetworkRecordConnection newConnection =
                    new PartnerNetworkRecordConnection(
                        ConnectionId = '04P900000000BAA',
                        LocalRecordId = rec.Id,
                        SendClosedTasks = false,
                        SendOpenTasks = false,
                        SendEmails = false);
            myConList.add(newConnection);
        }
    }
    if(myConList.size() > 0)
    {
        insert myConList;
    }
}