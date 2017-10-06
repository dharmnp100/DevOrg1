public class SystemUtilities
{
    @InvocableMethod
      public static void processChildContacts(List<Id> AccountId) 
      {
          for(Contact con : [select id, Name from Contact where Accountid = :AccountId])
          {
              system.debug('Contact Record --->    '+con);
          }
        }
  
}