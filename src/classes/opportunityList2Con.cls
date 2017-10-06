public class opportunityList2Con {
    // ApexPages.StandardSetController must be instantiated
    // for standard list controllers
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name, County__c FROM Exam__c]));
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<Exam__c> getOpportunities() {
        return (List<Exam__c>) setCon.getRecords();
    }
}