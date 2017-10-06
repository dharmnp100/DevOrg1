public with sharing class TableController {

public List<Contact> conList {get;set;}

public TableController()
{
    conList = new List<Contact>();
    conList = [Select Id,FirstName,LastName,Phone,Email from Contact where FirstName != null Order By Name limit 5];
}
}