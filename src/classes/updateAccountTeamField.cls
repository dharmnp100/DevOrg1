public class updateAccountTeamField
{
    
    @InvocableMethod(label='Set Exam to Null' description='Sets exam lookup field to NULL when Type = Prospect')
    public static void setAccountSource(List<Id> accIds)
    {
    List<Account_Team__c> teamsToBeUpdated = new List<Account_Team__c>();
        for(Account acc : [Select Id,AccountSource,(Select Id,Account_Source__c from Account_Teams__r) from Account where Id IN: accIds])
        {
            for(Account_Team__c team : acc.Account_Teams__r)
            {
                team.Account_Source__c = acc.AccountSource;
                teamsToBeUpdated.add(team);
            }
        }
        if(teamsToBeUpdated.size() > 0)
        {
            update teamsToBeUpdated;
        }
    }
    
  
}