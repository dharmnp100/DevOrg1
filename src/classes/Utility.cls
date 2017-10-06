public class Utility
{
    public static List<SObject> createTestRecords(Account accRec)
    {
        List<SObject> myList = new List<SObject>();
        /*List<Custom2__c> customList2 = new List<Custom2__c>();
        List<Custom1__c> customList1 = new List<Custom1__c>();
        if(accRec.Name != null)
        {
            customList1.add(new Custom1__c(Name = accRec.Name));
            customList2.add(new Custom2__c(Name = accRec.Name));
            
        }
        List<SObject> tmp1 = new List<>
        myList.addAll(customList1);
        myList.addAll(customList2);*/
        return myList;
    }
}