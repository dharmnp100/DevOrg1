public class RecordDetailController {

    @AuraEnabled
    public static Account getRecordDetails(Id accId)
    {
        Account accRec = new Account();
        accRec = [Select id,Name from Account where Id =: accId];
        return accRec;
    }
}