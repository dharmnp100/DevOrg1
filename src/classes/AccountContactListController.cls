public class AccountContactListController
{
    public Id accountId {get; set;}
    
    public AccountContactListController (ApexPages.StandardController con)
    {
        accountId = ApexPages.CurrentPage().getParameters().get('Id');    
    }
    
    public List<Contact> getActiveContacts()
    {
        List<Contact> conList = new List<Contact>();
        if(accountId != null)
        {
            conList = [select Id, FirstName, LastName, Title, Email, HasOptedOutOfEmail, Phone
                        from Contact
                        where AccountId =: accountId
                        order by FirstName, LastName];
        }
        return conList;
    }
}