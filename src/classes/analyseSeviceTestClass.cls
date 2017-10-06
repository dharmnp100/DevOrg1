/**
 * @author Varuna Nikam
 * @date 13/7/2015
 * @description - Test class for RuleAnalyseService
 */
 
@isTest
public class analyseSeviceTestClass   {
    /**
     * Author       -   Varuna Nikam
     * @date        -   13/7/2015
     * @description -   test method for rule1 - check with sharing keyword
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkPublicWithSharing_test() {
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule1',isActive__c = true);
    insert ruleMaster;
    
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','public class dummyClass9999 {');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById);
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);  
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule1');
    RuleAnalyseService.performClassLevelCheck(parameterMap);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule1');
    //RuleAnalyseService.rulesCheckForPages(parameterMap);
    //RuleAnalyseService.checkPublicWithSharing(outputMap);
    
    
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   13/7/2015
     * @description -   test method for rule2 - SOQL without where condition
     * @return      -   void
     * @modifiedby  -
     */
     
    static testMethod void checkWhereClauseInQuery_test()   {
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule3',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','[select name from account];');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule3');
    RuleAnalyseService.performClassLevelCheck(parameterMap, true);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    RuleAnalyseService.checkWhereClauseInQuery(parameterMap);
    system.assertEquals(rule.RuleKey__c,'Rule3');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   13/7/2015
     * @description -   test method for rule3 - SOQL inside loop
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkQueryInLoop_test(){
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule2',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','public class dummyClass9 {public void dummyMethod1() {while(i=10){string query=\'select name from account\';}}}');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById);
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);  
    
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule2');
    RuleAnalyseService.performClassLevelCheck(parameterMap, true);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule2');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   13/7/2015
     * @description -   test method for rule4 - Reflected XSS
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkReflectedXSSInClass_test(){
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule4',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','ApexPages.CurrentPage.getParameter.get(id)');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule4');
    RuleAnalyseService.performClassLevelCheck(parameterMap);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule4');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   13/7/2015
     * @description -   test method for rule6 - SOQL SOSL injection
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkSOQLSOSLInjection_test(){
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule6',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','[select name from account where id is + myId + AND name is +name+];');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule6');
    RuleAnalyseService.performClassLevelCheck(parameterMap, true);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule6');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   13/7/2015
     * @description -   test method for rule7 - Class ,Method level comments
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkClassMethodLevelComments_test(){
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule7',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','/*author - varuna*/public class testClass{int i= 10;}/*author - varuna*/public void testMethod1(){int i= 10;}');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule7');
    RuleAnalyseService.performClassLevelCheck(parameterMap);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule7');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   13/7/2015
     * @description -   test method for rule8 - Debug statements
     * @return      -   void
     * @modifiedby  -
    */
    static testMethod void checkDebugStatements_test(){
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule8',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','system.debug');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule8');
    RuleAnalyseService.performClassLevelCheck(parameterMap);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule8');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   13/7/2015
     * @description -   test method for rule9 - Hard code values
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkConstants_test(){
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule9',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','public class testclass{ name = \'varuna\'');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule9');
    RuleAnalyseService.performClassLevelCheck(parameterMap);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule9');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   13/7/2015
     * @description -   test method for rule10 - Assert statements
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkAssertStatements_test(){
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule10',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','@isTest static testMethod void test{ system.assert()');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule10');
    RuleAnalyseService.performClassLevelCheck(parameterMap);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule10');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   13/7/2015
     * @description -   test method for rule11 - Try catch block
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkTryCatch_test(){
        
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule11',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','public class testClass{ public void testMethod(){try{abc}catch(){ public void testMethod(){try{abc}catch(){');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule11');
    RuleAnalyseService.performClassLevelCheck(parameterMap, true);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule11');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   14/7/2015
     * @description -   test method for rule12 - Object instantiation inside loop
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkObjectInstInLoop_test(){
        
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule12',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','while(i=10){account = new for(i=10){account = new account()');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule12');
    RuleAnalyseService.performClassLevelCheck(parameterMap, true);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule12');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   14/7/2015
     * @description -   test method for rule4 - Reflected XSS for page
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkReflectedXSSInPage_test(){
        
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule4',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','<apex:outputText escape=false {!varuna}>');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule4');
    RuleAnalyseService.performClassLevelCheck(parameterMap);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule4');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   14/7/2015
     * @description -   test method for rule5 - Stored XSS scipt tag
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkStoredXSSScriptTag_test(){
        
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule5',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','<Script>{!varuna}</Script>');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule5');
    RuleAnalyseService.performClassLevelCheck(parameterMap);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule5');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   14/7/2015
     * @description -   test method for rule5 - stored XSS style tag
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkStoredXSSStyleTag_test(){
        
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule5',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','<Style>{!varuna}</Style>');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule5');
    RuleAnalyseService.performClassLevelCheck(parameterMap);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule5');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   14/7/2015
     * @description -   test method for rule5 - stored XSS any HTML tag
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void checkStoredXSSAnyHTMLTag_test(){
        
    ClassesParse__c classParse = new ClassesParse__c(name ='testingClass');
    insert classParse;
    
    RulesMaster__c ruleMaster = new RulesMaster__c(RuleKey__c = 'Rule5',isActive__c = true);
    insert ruleMaster;
    
    RuleAnalyseService obj = new RuleAnalyseService();
    Map<String,String> parameterMap = new Map<String,String>();
    ApexClass apexClass = [select Id,createdById,LastModifiedById,CreatedBy.Name,LastModifiedBy.Name from ApexClass limit 1];   
    String apexId = apexClass.Id;
    String ApexCreatedById = apexClass.createdById;
    String ApexLastModifiedById = apexClass.LastModifiedById;
    String apexCreatedByName = apexClass.CreatedBy.Name;
    String apexModifiedByName = apexClass.LastModifiedBy.Name;
    
    parameterMap.put('ApexBody','<div {!varuna}>');
    parameterMap.put('ApexName','ApexName');
    parameterMap.put('ApexId',apexId);
    parameterMap.put('ApexCreatedById', ApexCreatedById);
    parameterMap.put('ApexLastModifiedById', ApexLastModifiedById); 
    parameterMap.put('ApexCreatedByName', apexCreatedByName);
    parameterMap.put('ApexModifiedByName',apexModifiedByName);
    
    RuleAnalyseService.getName(parameterMap.get('ApexCreatedById'));
    RuleAnalyseService.rulesToExecute('Rule5');
    RuleAnalyseService.performClassLevelCheck(parameterMap);
    RulesMaster__c rule =[select RuleKey__c from RulesMaster__c];
    system.assertEquals(rule.RuleKey__c,'Rule5');
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   15/7/2015
     * @description -   test method for report creation
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void getReportData_test(){
        ClassesParse__c classParse = new ClassesParse__c(ClassName__c ='test1',Result__c='fail',Rule__c='rule1',Severity__c='major');
        insert classParse;
        String str = RuleAnalyseService.getReportData();
        system.assertNotEquals(str,null);
    }
    
    /**
     * Author       -   Varuna Nikam
     * @date        -   15/7/2015
     * @description -   test method for patternmatching
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void patternMaching(){
        String pattern= '[a-z].*';
        String str= 'abc';  
        boolean result= RuleAnalyseService.PatternMatching(pattern,str);
        system.assertEquals(result,true);
    }
    /**
     * Author       -   Varuna Nikam
     * @date        -   15/7/2015
     * @description -   test method total line count
     * @return      -   void
     * @modifiedby  -
     */
    static testMethod void getCount(){
        String pattern1 = 'A B C';
        String str1 ='\\s';     
        Integer totalCount =RuleAnalyseService.getCount(pattern1,str1);
        system.assertEquals(totalCount,1);
    }
    
}