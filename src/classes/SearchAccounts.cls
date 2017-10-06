public class SearchAccounts {
	@AuraEnabled
    public static List<Account> returnAccounts(String accName)
    {
        String accountName = '%' + accName + '%';
        List<Account> accList = new List<Account>();
        accList = [Select Id,Name,Phone,AccountSource,Rating from Account where Name Like: accountName];
        return accList;
    }
}