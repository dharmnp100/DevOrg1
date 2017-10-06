public with sharing class insertContact
{
    @RemoteAction
    public static void insertContacts1(List<Contact> contacts){
        insert contacts;
    }
    @RemoteAction
    public static void insertContacts(String contacts){
        system.debug('----------------'+contacts);
        Contact[] conRecs = (Contact[])JSON.deserialize(contacts, List<Contact>.class);
        system.debug('-------------------'+conRecs);
        insert conRecs;
    }
}