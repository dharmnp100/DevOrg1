trigger primaryContact on Contact(after insert , after update , before update)
{
    List<Contact> conList = new List<Contact>();
    Set<Id> accIds = new Set<Id>();
    Set<Id> conIds = new Set<Id>();
    Map<Id,List<Contact>> accContactMap = new Map<Id,List<Contact>>();
    for(Contact con : Trigger.new)
    {
        if(trigger.isBefore && con.Primary_Contact__c && Trigger.oldMap.get(con.Id).Primary_Contact__c == false)
        {
            List<Contact> contacts = new List<Contact>();
            if(accContactMap.containsKey(con.AccountId))
            {
                contacts = accContactMap.get(con.AccountId);
            }
            contacts.add(con);
            accContactMap.put(con.AccountId,contacts);
        }
        if(trigger.isAfter)
        {
            if(trigger.isInsert && con.Primary_Contact__c)
            {
                conIds.add(con.id);
                accIds.add(con.AccountId);
            }
            if(trigger.isUpdate && con.Primary_Contact__c && Trigger.oldMap.get(con.Id).Primary_Contact__c == false)
            {
                conIds.add(con.id);
                accIds.add(con.AccountId);
            }
        }
    }
    for(Contact conRec : [select Id,Primary_Contact__c from Contact where Primary_Contact__c = true AND AccountId IN: accIds AND Id NOT IN: conIds])
    {
        conRec.Primary_Contact__c = false;
        conList.add(conRec);
    }
    if(conList.size() > 0)
    {
        update conList;
    }
    if(accContactMap.size() > 0)
    {
        for(Id accId : accContactMap.keySet())
        {
            List<Contact> multiplePrimary = new List<Contact>();
            multiplePrimary = accContactMap.get(accId);
            if(multiplePrimary.size() > 1)
            {
                for(Integer i=0; i<multiplePrimary.size() ; i++)
                {
                    if(i == 0)
                    {
                        multiplePrimary[i].Primary_Contact__c = true;
                    }
                    else
                    {
                        multiplePrimary[i].Primary_Contact__c = false;
                    }
                }
            }
            
        }
    }
}