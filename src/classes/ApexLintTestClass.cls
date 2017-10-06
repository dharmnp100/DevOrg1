/**
 * @author Dinesh Girase
 * @date 15/12/2015
 * @description - Test class for ApexLint Class
 */
@isTest
    public class ApexLintTestClass{
    
    static testMethod void startMethod() {
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule1',isActive__c = true);
    insert ruleMaster;
    
    ClassesParse__c classParse = new ClassesParse__c(name ='ApexLintController');
    insert classParse;
    
    ApexClass cls = [Select Id,Name from ApexClass limit 1];               
                metaData__c metaD = new metaData__c();
                metaD.EntityName__c = cls.Name;
                metaD.EntityType__c = 'ApexClass';
                metaD.EntityId__c = cls.Id;
                insert metaD;
    
    
    
    PageReference ref = new PageReference('/apex/UserInterfaceResult'); 
    Test.setCurrentPage(ref);
         ApexLintController ApexLintController1 =new ApexLintController();
    
     Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
     User u = new User(Alias = 'standt',
                         LastName='Testing',
                         LanguageLocaleKey='en_US',
                         LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com', Email='standarduser@testorg.com', FirstName='HelloWorld');
    
     ApexLintController1.getMethodToPassClasses();
     ApexLintController1.getMethodToPassPages();
     ApexLintController1.getMethodToPassUsers();
     String classesList ='["ApexLintController"]';
     String pagesList ='["UserInterfacePage"]';
     String userList = '["Testing"]';
     String rules ='["Rule1"]';
     ApexLintController1.getResult();
     ApexLintController1.getData();
     ApexLintController1.getChooserender();   
     ApexLintController.getDataFromUI(classesList, pagesList, userList, rules, false);
     //to cover quick scan code 
     ApexLintController.getDataFromUI(classesList, pagesList, userList, rules, true);

     RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
     system.assertEquals(rule.RuleKey__c,'Rule1');
    }
    
    static testMethod void batchMethod() {
           List<ClassesParse__c> DeleteList = [SELECT Name from ClassesParse__c];
            List<metaData__c> metaDataList = [SELECT EntityName__c from metaData__c ];
            try{
                 if(DeleteList!= null){ delete DeleteList; }   //delete already existing records
                  if(metaDataList!= null){ delete metaDataList; }  
                
               }
            catch(Exception e){
                
            }
            
               String randStr = 'ABC';
                List<metaData__c> metaDatas = new List<metaData__c>();
                List<ApexClass> apxCls = [Select Id, Name from ApexClass limit 1];
                metaData__c metaD = new metaData__c();
                metaD.EntityName__c = apxCls[0].Name;
                metaD.EntityType__c = 'ApexClass';
                metaD.EntityId__c = randStr;
                metaDatas.add(metaD);
                
                List<ApexPage> apxPg = [Select Id, Name from ApexPage limit 1];
                metaData__c metaD1 = new metaData__c();
                metaD1.EntityName__c = apxPg[0].Name;
                metaD1.EntityType__c = 'ApexPage';
                metaD1.EntityId__c = randStr;
                metaDatas.add(metaD1);
        
                insert metaDatas;
                
               List<RulesMaster__c>  selectedRules = [select Name,RuleKey__c,RuleNameToDisplay__c,RuleDescription__c,isActive__c from RulesMaster__c where isActive__c = true limit 1];  
               
               List<User> userList = [Select Id, Name from User limit 1];
               List<String> usrList = new List<String>();
               usrList.add(userList[0].Name);
               
                 CodeAnalyzerBatch codeAnalyzer = new CodeAnalyzerBatch(selectedRules,usrList,randStr);
                 
        ID batchprocessid = Database.executeBatch(codeAnalyzer);
           system.assert(batchprocessid  != null);
    }
        
        static testMethod void isDataPrcoessingCompleted_Test() {
          //  Test.startTest();
            Boolean flag = ApexLintController.isDataPrcoessingCompleted();
           // Test.stopTest();
            System.assert(flag);
        }
        
        static testMethod void deliverAsPDF_Test() {
            ApexLintController con = new ApexLintController();
            PageReference p = con.deliverAsPDF();
            System.assertNotEquals(null, p);
        }
        static testMethod void getSelectedRulesWithNoRules_Test() {
            List<String> ruleList = new List<String>();
            List<String> deserializeUserList = new List<String>();
            List<String> deserializeClassesList = new List<String>();
            List<String> deserializePagesList = new List<String>();
            List<RulesMaster__c> outputList = ApexLintController.getSelectedRules
                (ruleList, deserializeUserList, deserializeClassesList, deserializePagesList);
            System.assertEquals(null, outputList);
        }
        
        static testMethod void getSelectedRulesWithNoUsers_Test() {
            List<String> ruleList = new List<String>();
            ruleList.add('testData');
            List<String> deserializeUserList = null;
            List<String> deserializeClassesList = new List<String>();
            List<String> deserializePagesList = new List<String>();
            List<RulesMaster__c> outputList = ApexLintController.getSelectedRules
                (ruleList, deserializeUserList, deserializeClassesList, deserializePagesList);
            System.assertEquals(null, outputList);
        }
        
        static testMethod void getSelectedRulesWithNoClassesAndPages_Test() {
            List<String> ruleList = new List<String>();
            ruleList.add('testData');
            List<String> deserializeUserList = new List<String>();
            deserializeUserList.add('testData');
            List<String> deserializeClassesList = null;
            List<String> deserializePagesList = null;
            List<RulesMaster__c> outputList = ApexLintController.getSelectedRules
                (ruleList, deserializeUserList, deserializeClassesList, deserializePagesList);
            System.assertEquals(null, outputList);
        }
     
    }