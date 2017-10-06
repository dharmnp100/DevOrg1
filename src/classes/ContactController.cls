public with sharing class ContactController {
	@AuraEnabled
    public static List<Contact> getMyContacts()
    {
        return [Select Id,Name,Email from Contact Limit 10];
    }
}