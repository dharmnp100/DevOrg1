@RestResource(urlMapping='/yourservicename') 
global class yourservicename 
{ 
    @HttpGet global static void insertTestContact()
    { 
        Contact conRec = new Contact(FirstName = 'REST' , LastName = 'Contact');
        insert conrec;
    } 
}