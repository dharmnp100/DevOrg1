/*
Sample demo class created by Nitish for ApexLint package testing
*/
public with sharing class DemoClass1 {
    
    public string mystringvar {get; set;}
    
    
    public DemoClass1()
    {
        mystringvar = 'testNitish'; // default variable value
    }
    
    public void method1()
    {
        //*********NitishTestingComment******
        mystringvar = 'insideMethod';
        for(Integer i=0; i<2;i++){
            List<Account> accList = [Select Id from Account];
        }
        
        for(Integer j=0; j<j;j++){
            List<Contact> conList = [Select Id from Contact];
        }
       
    }
}