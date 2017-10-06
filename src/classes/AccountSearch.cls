global with sharing class AccountSearch
{
    @RemoteAction
    global static List<Account> searchAccounts(Integer cnt)
    {
        List<Account> accList = new List<Account>();
        accList = [Select Id,Name,Account__c,Owner.Name from Account limit 5 OFFSET :cnt];
        return accList;
    }
    @RemoteAction
    global static Integer getAllAccountsCount()
    {
        return [Select COUNT() from Account];
    }
}