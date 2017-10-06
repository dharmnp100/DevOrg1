trigger ChatterFeedTesting on Contact (before update,after update) {
    
    /*List<FeedItem> feeds = new List<FeedItem>();
    for(Contact con : Trigger.new)
    {
         Contact oldRec = Trigger.oldMap.get(con.id);
         for(Schema.FieldSetMember f : SObjectType.Contact.FieldSets.Test_Field_Set.getFields())
         {
             //if(con.Status__c != oldRec.Status__c)
             if(con.get(f.getFieldPath()) != oldRec.get(f.getFieldPath()))
             {
                FeedItem post = new FeedItem();
                post.ParentId = con.AccountId;
                post.type = 'TextPost';
                post.Visibility = 'AllUsers';
                //post.Body = 'Contact status is changed from ' + oldRec.Status__c + ' to ' + con.Status__c;
                post.Body = 'Contact status is changed from ' + oldRec.get(f.getFieldPath()) + ' to ' + con.get(f.getFieldPath());
                feeds.add(post);
             } 
         }           
    }
    if(feeds.size() > 0)
    {
        insert feeds;
    }
    List<Sample_Contact_Testing__c> settingList = Sample_Contact_Testing__c.getall().values();
    for(Contact con : Trigger.new)
    {
        for(Sample_Contact_Testing__c settingRec : settingList)
        {
            con.put(settingRec.Value1__c,con.get(settingRec.Value2__c));
        }
    }
    for(Contact con : Trigger.new)
    {
        if(Trigger.isBefore)
        {
            system.debug('--------CurrentBefore-----'+con.FirstName);
            Contact con1 = [Select Id,FirstName from Contact where Id =: con.id];
            system.debug('--------BEFORE-----'+con1.FirstName);
        }
        if(Trigger.isAfter)
        {
            system.debug('--------CurrentAfter-----'+con.FirstName);
            Contact con1 = [Select Id,FirstName from Contact where Id =: con.id];
            system.debug('--------AFTER-----'+con1.FirstName);
        }
    }*/
}