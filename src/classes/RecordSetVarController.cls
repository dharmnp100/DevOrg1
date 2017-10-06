public class RecordSetVarController
{
    public List<Account> accList {get; set;}
    
    public RecordSetVarController()
    {
        accList = new List<Account>();
        
        accList = fetchAccounts();
    }
    
    public static List<Account> fetchAccounts()
    {
        return [select id,name,Modified_By_User_Field__c,AccountId__c from Account order by CreatedDate limit 50];
    }
    
    @RemoteAction
    public static List<Account> getAccountData() 
    {
       return fetchAccounts(); 
    }
    
    
}