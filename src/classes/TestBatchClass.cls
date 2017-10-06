global class TestBatchClass implements Database.Batchable<sObject>
{
   global final String Query;
   global final String Entity;
   global final String Field;
   global final String Value;

   global TestBatchClass ()
   {

   }

   global Iterable<sObject> start(Database.BatchableContext BC)
   {
       List<Case> cseList = new List<Case>();
       Case c = New Case();
       c.Subject = 'Test Subject';    
       cseList.add(c);
      return cseList;
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope)
   {
     for(sobject s : scope)
     {
        system.debug(s);         
     }

   }

   global void finish(Database.BatchableContext BC)
   {
   }
}