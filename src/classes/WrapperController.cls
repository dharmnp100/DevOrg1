public class WrapperController {

@AuraEnabled
public static List<accountSelectClass> returnAccounts()
{
    List<accountSelectClass> accList = new List<accountSelectClass>();
	for(Account accountObj : [Select Id,Name from Account limit 20])
    {
       accountSelectClass accWrap = new accountSelectClass();
       accWrap.acc = accountObj;
       accList.add(accWrap);
    }
    return accList;
}
public class accountSelectClass
{
    @AuraEnabled public Account acc {get; set;}
    @AuraEnabled public boolean selected {get; set;}
    public accountSelectClass()
    {
    	this.acc = new Account();
        this.selected = false;
    }
}
}