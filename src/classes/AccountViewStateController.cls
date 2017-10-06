public class AccountViewStateController
{
    public List<Account> accList {get; set;}
    static List<Account> accListNoGetSet;

    public AccountViewStateController()
    {
        accList  = new List<Account>();
        accListNoGetSet = new List<Account>();
        
        accListNoGetSet = [select Id, Name, SIte, BillingCity, BillingCountry, BillingState from Account];
        accList = [select Id, Name, SIte, BillingCity, BillingCountry, BillingState from Account];
        //accListNoGetSet = accList ;
    }
}