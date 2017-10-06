public class HiddenComponentController
{
    public HiddenComponentController()
    {}
    
    
    @RemoteAction
    public static String updateLCT(String uniqueId, string urlToUpdate) 
    {
        LiveChatTranscript lct = [SELECT Id FROM LiveChatTranscript WHERE Unique_Id__c = :uniqueId];
        lct.Chat_initiating_page__c = urlToUpdate;
        update lct;
        return 'done';
    }
}