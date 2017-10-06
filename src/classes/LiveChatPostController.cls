public class LiveChatPostController
{
    public LiveChatPostController()
    {
        string urlDetails = ApexPages.CurrentPage().getParameters().get('chatDetails');
        
        Map<String, object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(urlDetails);
        
        system.debug('jsonMap>>>>        '+jsonMap);
        
        //Map<String,String> details = (Map<String,String>) jsonMap.get('customDetails');
        
        
    }
}