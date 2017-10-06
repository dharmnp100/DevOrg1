trigger CaseTrigger on Case (after Insert, after Update) 
{
    //List<FeedItem> feedItems = new List<FeedItem>();
    for(Case cse : Trigger.New)
    {
        /*if(trigger.isAfter)
        {
            ID jobID = System.enqueueJob(new CaseQueuebleJob(cse));
        }*/
        if(trigger.isAfter && trigger.isInsert)
        {
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            mentionSegmentInput.id = '00590000001vaBi';
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            
            textSegmentInput.text = 'This is sample @Mention feed post on Case record!!!!';
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = cse.id;
            
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput, null);
            /*FeedItem fItem = new FeedItem();
            fItem.Body = '@['+ '00590000001vaBi' + ']'+ 'This is sample post!!!';
            fItem.Type = 'TextPost';
            fItem.ParentId= cse.id;
            feedItems.add(fItem);*/
        }
        /*if(feedItems.size() > 0)
        {
            insert feedItems;
        }*/
    }
}