/**
 * @author          Mindtree
 * @date            15/12/2015
 * @description -   This is the controller class for page ApexLintAnalyzerPage  
 */

public with sharing class ApexLintController{
    
    //wrapperclass
    public static List<WrapperClass> wrapperClassList{get; set;}
    public static List<RulesMaster__c> selectedRules{get;set;}
    public boolean pdfFlag {get;set;}
    
    //classes   
    public transient List<ApexClass> lstApexClasses{get;set;}       
    //pages    
    public transient List<ApexPage> lstApexPages{get;set;}        
    //receipients 
    public transient List<User> lstUsers{get;set;}            
    public List<ClassesParse__c> resultList{get;set;}
    

/**
 * Author       -   Dinesh Girase
 * @date        -   4/12/2015
 * @description -   this is the constructor of the class. Here create the wrapper list of rules, fetch all the apex class, apex pages and user list
 * @return      -   boolean - true - if Data Prcoessing Completed
 */   

    public ApexLintController(){
        system.debug('I am in ApexLintController_1');
		//display rules with checkbox
		if(wrapperClassList== null) {

            wrapperClassList= new List<WrapperClass>();
            
            List<RulesMaster__c> ruleList = new  List<RulesMaster__c>();
            
            if (Schema.sObjectType.RulesMaster__c.fields.Name.isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.RuleKey__c.isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.RuleNameToDisplay__c.isAccessible()  
              && Schema.sObjectType.RulesMaster__c.fields.RuleDescription__c.isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.isActive__c .isAccessible() )
              
            ruleList  = [select Name,RuleKey__c,RuleNameToDisplay__c,RuleDescription__c,isActive__c from RulesMaster__c where isActive__c = true order by Name ASC];
            
              else               
               system.debug('The logged in user does not have access to the field/object');
               
            for(RulesMaster__c rule: ruleList) {
                
                 wrapperClassList.add(new WrapperClass(rule));
            }
        }
                    
        //multiselect picklist classes                  
        lstApexClasses = new List<ApexClass>();
          if (Schema.sObjectType.ApexClass.fields.Name.isAccessible() && Schema.sObjectType.ApexClass.fields.Id.isAccessible())
        lstApexClasses = [SELECT Name, Id FROM ApexClass where status != 'Deleted' order by Name limit 11000];   
             else
          system.debug('The logged in user does not have access to the field/object');   
        lstApexPages = new List<ApexPage>();
          if (Schema.sObjectType.ApexPage.fields.Name.isAccessible() && Schema.sObjectType.ApexPage.fields.Id.isAccessible() )
        lstApexPages = [SELECT Name, Id FROM ApexPage order by Name limit 11000];
        else
          system.debug('The logged in user does not have access to the field/object');
        //multiselect picklist users
        lstUsers = new List<User>();
        Set<Id>ids = new Set<Id>();
      
        List<Profile> profList = new List<Profile>();
           if (Schema.sObjectType.Profile.fields.Name.isAccessible() && Schema.sObjectType.Profile.fields.Id.isAccessible())
         profList  = [select Id,name from Profile where Name = 'System Administrator' limit 1];
          else
          system.debug('The logged in user does not have access to the field/object');
        for(Profile p:profList){
        ids.add(p.Id);
        }
            if (Schema.sObjectType.User.fields.Name.isAccessible() && Schema.sObjectType.User.fields.IsActive.isAccessible() && Schema.sObjectType.User.fields.ProfileId.isAccessible())
        //get the name of user having "System Administrator" Profile
        lstUsers = [SELECT Name FROM User where IsActive = true  AND ProfileId IN :ids order by Name];
         else
          system.debug('The logged in user does not have access to the field/object');
        //result
        resultList = new List<ClassesParse__c>();
       
         List<AsyncApexJob> asyncJobs = new List<AsyncApexJob>();         
          if (Schema.sObjectType.AsyncApexJob.fields.Id.isAccessible() && Schema.sObjectType.AsyncApexJob.fields.Status.isAccessible())          
         asyncJobs  = [SELECT Id FROM AsyncApexJob WHERE Status NOT IN ('Aborted', 'Completed', 'Failed') AND ApexClass.Name = 'CodeAnalyzerBatch' limit 1];
          else
          system.debug('The logged in user does not have access to the field/object');
         if(asyncJobs.size() > 0){
          system.debug('asyncJobs '+asyncJobs);
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Previous request is still being processed. New request may discard old ones');
          apexpages.addmessage(msg);
        }
        pdfFlag =true;
     
}

         
    //pass classes
    public String getMethodToPassClasses(){
       
       String jsonResponse = JSON.serialize(lstApexClasses);
        return jsonResponse;
    }
    //pass pages
    public String getMethodToPassPages(){
        String jsonResponse = JSON.serialize(lstApexPages);
        return jsonResponse;
    }
    //passusers
    public String getMethodToPassUsers(){
       
       String jsonResponse = JSON.serialize(lstUsers);
        return jsonResponse;
    }
    
/**
     * Author       -   Dinesh Girase
     * @date        -   4/12/2015
     * @description -   this method checks whether the Data Prcoessing is Completed or not
     * @return      -   boolean - true - if Data Prcoessing Completed
     */
     
    @RemoteAction
    public static Boolean isDataPrcoessingCompleted() {
   
        List<metaData__c> mD = new List<metaData__c>();
        List<ClassesParse__c> resultList = new List<ClassesParse__c>();
            if (Schema.sObjectType.metaData__c.fields.Id.isAccessible() && Schema.sObjectType.metaData__c.fields.isCompleted__c.isAccessible())
        mD =  [SELECT Id FROM metaData__c where isCompleted__c = false limit 1];
          else
       system.debug('The logged in user does not have access to the field/object');
       
       if(mD.size() > 0) {
            return false;
        }
        return true;
    }
   
/**
     * Author       -   Dinesh Girase
     * @date        -   4/12/2015
     * @description -   1.This method gets the data from Page i.e. selected Rule, class and Page. 
                        2.Display error message accordingly if any element is missing
                        3.Delete the existing records form ClassesParse__c and metaData__c object and insert the new values which are fetch
                        4.Generating Request id for the selected class and Page
                        5.insert all the identified issue in ClassesParse__c object
     * @param       -   classesList - string
     *                  pagesList - string
                        userList - string
                        rules - string
                        quickScan - Boolean
     * @return      -   Popup message of the task completion/failure
     */ 
     
    /*****************************
     * 
     * 
     * 
     * (/\\*([^*]|[\r\n]|(\\*+([^*
     * 
     *******/
     
    @RemoteAction
    public static String getDataFromUI(String classesList,String pagesList,String userList, String rules, Boolean quickScan){
    ApexLintController obj = new ApexLintController();
   // obj.setFullScanEnable(false);
   system.debug('Inside getDataFromUI');
   //boolean fullScanEnable = false;
        List<String> ruleList =(List<String>) System.JSON.deserialize(rules, List<String>.class);
        system.debug('ruleList ' + ruleList);
        List<String> deserializeClassesList = (List<String>)System.JSON.deserialize(classesList, List<String>.class);
        system.debug('After deserializeClassesList ' + deserializeClassesList);
        List<String> deserializePagesList = (List<String>)System.JSON.deserialize(pagesList, List<String>.class);
        system.debug('After deserializePagesList ' + deserializePagesList);
        List<String> deserializeUserList = (List<String>)System.JSON.deserialize(userList, List<String>.class);
        system.debug('After deserializeUserList ' + deserializeUserList);
        
        //Error Messages and get the list of selected rule detail
        selectedRules = getSelectedRules(ruleList, deserializeUserList, deserializeClassesList, deserializePagesList);
        system.debug('selectedRules ' + selectedRules);
        
        //delete existing records
        deleteExistingRecords();
        
        //Generating Request id for the selected class and Page
        String randStr = generateRequestid();
        system.debug('randStr: ' + randStr);
        
        //Inserting meta data values for class and pages in metaData__c object
        insertMetaData(deserializeClassesList,deserializePagesList,randStr);
        
        if(quickScan) {     
            performQuickScan(deserializeClassesList,deserializePagesList,randStr);
            return 'Quick scan completed !!! Please find your results under Preview Report tab';
        }
        ID batchprocessid;
        try{
            System.debug('**********selectedRules*************'+selectedRules+'*********deserializeUserList********'+deserializeUserList+'************randStr*****'+randStr);
            CodeAnalyzerBatch codeAnalyzer = new CodeAnalyzerBatch(selectedRules,deserializeUserList,randStr);
            
            batchprocessid = Database.executeBatch(codeAnalyzer);
            
        }catch(Exception e){
            system.debug('Failed to excecute codeAnalyzer batch: ' + e.getMessage());
        } 
        
        if(batchprocessid != null){
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Confirm,System.Label.Success_Message);
            apexpages.addmessage(msg);
            return System.Label.Success_Message;   
        }else{
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,System.Label.Failure_Message);
            apexpages.addmessage(msg);
            return System.Label.Failure_Message;
        }
        
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   10/12/2015
     * @description -   This method insert all the identified issue in ClassesParse__c object
                        It perform quick scan provide report on same page
     */
   
    private static void performQuickScan(List<String> deserializeClassesList, List<String> deserializePagesList, String randStr){   
       // try{
            system.debug('randStr: '+ randStr);
            RuleAnalyseService.lstRulesToExecute = selectedRules;
            System.debug('Inside performQuickScan');
            List<ClassesParse__c> parseList = new List<ClassesParse__c>();
            List<ApexClass> apexClasses;
            List<ApexPage> apexPages;
            List<metaData__c> apexMethodMetaDatas;
            
            if(deserializeClassesList != null) {
             if (Schema.sObjectType.ApexClass.fields.Name.isAccessible() 
                  && Schema.sObjectType.ApexClass.fields.Id.isAccessible()
                  && Schema.sObjectType.ApexClass.fields.Body.isAccessible()
                  && Schema.sObjectType.ApexClass.fields.CreatedById.isAccessible()
                  && Schema.sObjectType.ApexClass.fields.LastModifiedById.isAccessible())       
              
              {apexClasses = [SELECT Body, Name, Id, CreatedById, LastModifiedById,CreatedBy.Name,LastModifiedBy.Name FROM ApexClass where Name IN :deserializeClassesList];
               system.debug('apexClasses: '+ apexClasses);
              }
                 else
                 system.debug('The logged in user does not have access to the field/object');  
                 system.debug('Looking for apexMethodMetaDatas');               
                apexMethodMetaDatas = ClassHelper.convertClassesToMethods(apexClasses, randStr);
                system.debug('	 '+ apexMethodMetaDatas);
            }
            
            if(deserializePagesList!= null) {
             if (Schema.sObjectType.ApexPage.fields.Name.isAccessible() 
                  && Schema.sObjectType.ApexPage.fields.Id.isAccessible()
                  && Schema.sObjectType.ApexPage.fields.Markup.isAccessible()
                  && Schema.sObjectType.ApexPage.fields.CreatedById.isAccessible()
                  && Schema.sObjectType.ApexPage.fields.LastModifiedById.isAccessible()  )  
                apexPages =  [SELECT Markup, Name, Id, CreatedById, LastModifiedById,CreatedBy.Name,LastModifiedBy.Name FROM ApexPage where Name IN :deserializePagesList];
             else
                 system.debug('The logged in user does not have access to the field/object');
            }
            
            //add the list of identified issue in pages
             Map<String, String> parameterMap = null;
             if(apexPages != null) {
                for(ApexPage pageObj : apexPages ) {
                    parameterMap = new Map<String, String>();
                    parameterMap.put(Constants.APEXBODY, pageObj.Markup);
                    parameterMap.put(Constants.APEXNAME, pageObj.Name);
                    parameterMap.put(Constants.APEXID, pageObj.Id);
                    parameterMap.put(Constants.CREATEDBY, pageObj.CreatedById);
                    parameterMap.put(Constants.MODIFIEDBY, pageObj.LastModifiedById);
                    parameterMap.put('ApexCreatedByName', pageObj.CreatedBy.Name);
                    parameterMap.put('ApexModifiedByName', pageObj.LastModifiedBy.Name);
                    
                    List<ClassesParse__c> prs = RuleAnalyseService.performPageLevelCheck(parameterMap);

                    if(prs != null && prs.size() > 0) {
                        parseList.addAll(prs);
                    }

                }
            }
            //add the list of identified issue in classes
            Map<String, ApexClass> classMap = new Map<String, ApexClass>();
            if(apexClasses != null) {
                System.debug('Inside apexClasses: ' + apexClasses);
                for(ApexClass clsObj : apexClasses) {
                    parameterMap = new Map<String, String>();
                    
                    parameterMap.put(Constants.APEXBODY, clsObj.body);
                    parameterMap.put(Constants.APEXNAME, clsObj.Name);
                    parameterMap.put(Constants.APEXID, clsObj.Id);
                    parameterMap.put(Constants.CREATEDBY, clsObj.CreatedById);
                    parameterMap.put(Constants.MODIFIEDBY, clsObj.LastModifiedById);
                    parameterMap.put('ApexCreatedByName', clsObj.CreatedBy.Name);
                    parameterMap.put('ApexModifiedByName', clsObj.LastModifiedBy.Name);
                    
                    classMap.put(clsObj.Name, clsObj);
                    
                    
                    datetime methodStart = datetime.now();
                    system.debug('Time Taken for ClassName: ' + parameterMap.get(Constants.APEXBODY));
                    List<ClassesParse__c> prs = RuleAnalyseService.performClassLevelCheck(parameterMap, false);
                    datetime methodEnd = datetime.now();
                    //debug number of seconds the query ran
                    system.debug('Time Taken for Class: ' + (methodEnd.getTime() - methodStart.getTime()));  
                    
                    if(prs != null && prs.size() > 0) {
                        parseList.addAll(prs);
                    }
                    
                }
              }
            //add the list of identified issue in respective class method
            if(apexMethodMetaDatas != null) {
                System.debug('Inside apexMethodMetaDatas: '+apexMethodMetaDatas);
                for(metaData__c mD: apexMethodMetaDatas) {
                System.debug('mD>>'+mD);
                    parameterMap = new Map<String, String>();
                    ApexClass apx = classMap.get(mD.EntityName__c);
                                   
                    parameterMap.put(Constants.APEXBODY, mD.EntityBody__c);
                    parameterMap.put(Constants.APEXNAME, apx.Name);
                    parameterMap.put(Constants.APEXID, apx.Id);
                    parameterMap.put(Constants.CREATEDBY, apx.CreatedById);
                    parameterMap.put(Constants.MODIFIEDBY, apx.LastModifiedById);
                    parameterMap.put('ApexCreatedByName', apx.CreatedBy.Name);
                    parameterMap.put('ApexModifiedByName', apx.LastModifiedBy.Name);
                    parameterMap.put('StartLineNumber' ,mD.EntityLineNumber__c);
                    
                    
                    //datetime methodStart = datetime.now();
                    //system.debug('Each MethodName: ' + parameterMap.get(Constants.APEXNAME));
                    //system.debug('Each MethodBody: ' + parameterMap.get(Constants.APEXBODY));
                    List<ClassesParse__c> prs = RuleAnalyseService.performClassLevelCheck(parameterMap, true);
                    //datetime methodEnd = datetime.now();
                    //system.debug('Time Taken for MethodName: ' + parameterMap.get(Constants.APEXNAME) + 'Time Taken in Millisecs: '+  (methodEnd.getTime() - methodStart.getTime()));  
                    
                   system.debug('prs >>>'+prs );
                    if(prs != null && prs.size() > 0) {
                        parseList.addAll(prs);
                    }
                    
                }
            }
            
        //insert all the identified issues in ClassesParse__c object
          if (Schema.sObjectType.ClassesParse__c.isCreateable()) 
        insert parseList;
        else
        system.debug('The logged in user does not have the permission to insert');
        
         if (Schema.sObjectType.metaData__c.isDeletable()) 
        delete [select id from metaData__c]; // clear metadata__c object
        else
               system.debug('The logged in user does not have the permission to delete');
               
        //}catch(Exception e){
       //     system.debug('Failed to insert all the identified issues in ClassesParse__c object ' + e.getMessage());
       // }
       system.debug('***getCpuTime()***1:  '+Limits.getCpuTime());
    }               

/**
     * Author       -   Dinesh Girase
     * @date        -   4/12/2015
     * @description -   This method will get the data from ClassesParse__c object and return it to the page 
     * @return      -   sting result
     */ 
     
    public PageReference getResult(){
    pdfFlag = true;
     PageReference PageRef = new PageReference('/apex/ApexLintResult');
    try{
        
        if (Schema.sObjectType.ClassesParse__c.fields.ClassName__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.LineNumber__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.Rule__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.Severity__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.Result__c.isAccessible() )
              
        resultList = [SELECT ClassName__c,LineNumber__c,Result__c,Rule__c,Severity__c FROM ClassesParse__c where id != null];
         else
         system.debug('The logged in user does not have access to the field/object');
        if(resultList.size()>0 && resultList !=null){
             return PageRef;
        }else{
            pdfFlag = false;
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Confirm,System.Label.No_issues_found);
            apexpages.addmessage(msg);
            return PageRef;
        }
        }catch(Exception e){return PageRef;}
    }
    
    public PageReference getData(){
    PageReference PageRef = new PageReference('/apex/ReportPage');
    return PageRef;
    }
 
    public String getChooserender() {
        if (ApexPages.currentPage().getParameters().get('p') != null)
        return 'pdf';
        else
        return null;
    }
    
    // Go grab the page and pass parameter 'p'


    public PageReference deliverAsPDF() {
        pdfFlag = false;
        PageReference pdf =  Page.ApexLintResult;
        String pdfFileName = 'ApexLint Report.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachemnt; filename=\"'+pdfFileName+'\"');
        pdf.getParameters().put('p','p');
        
        try{
             if (Schema.sObjectType.ClassesParse__c.fields.ClassName__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.LineNumber__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.Rule__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.Severity__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.Result__c.isAccessible() )
              
            resultList = [SELECT ClassName__c,LineNumber__c,Result__c,Rule__c,Severity__c FROM ClassesParse__c  where id != null];
            if(resultList.size()>0 && resultList !=null){
            	 return pdf;
            }else{
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Confirm,System.Label.No_issues_found);
                apexpages.addmessage(msg);
                return pdf;
            }
            }catch(Exception e){return pdf;}
        return pdf;
    }
    
    /**
     * Author       -   Dinesh Girase
     * @date        -   10/12/2015
     * @description -   This method Display error message accordingly if any element is missing also return the list of rule detail from RulesMaster__c object                        
     * @param       -   classesList - string
     *                  pagesList - string
                        userList - string
                        rules - string
     * @return      -   List of elected list values
     */ 
    @TestVisible
    private static List<RulesMaster__c> getSelectedRules(List<String> ruleList,List<String> deserializeUserList,List<String> deserializeClassesList, List<String> deserializePagesList){
        if(ruleList.size() == 0){
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,System.Label.Select_Rules);
                apexpages.addmessage(msg);
                return null;
        }else if(deserializeUserList == null ){
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,System.Label.Select_Receipient);
                apexpages.addmessage(msg);
                return null; 
        }else if(deserializeClassesList == null && deserializePagesList == null){
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,System.Label.Select_Classes_Pages);
                apexpages.addmessage(msg);
                return null;
        } 
         if (Schema.sObjectType.RulesMaster__c.fields.Id.isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.RuleKey__c.isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.RuleDescription__c.isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.RuleNameToDisplay__c .isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.isActive__c .isAccessible() )
              
        selectedRules = [select Name,RuleKey__c,RuleNameToDisplay__c,RuleDescription__c,isActive__c from RulesMaster__c where isActive__c = true AND ID IN :ruleList order by Name ASC];
         else              
               system.debug('The logged in user does not have access to the field/object');               
               return selectedRules;
    }
    /**
     * Author       -   Dinesh Girase
     * @date        -   10/12/2015
     * @description -   This method delete already existing records                        
     */ 
    private static void deleteExistingRecords(){
      List<ClassesParse__c> DeleteList = new  List<ClassesParse__c>();
          if (Schema.sObjectType.ClassesParse__c.fields.Name.isAccessible() )
        DeleteList  = [SELECT Name from ClassesParse__c  where id != null];
         else
          system.debug('The logged in user does not have access to the field/object');
        List<metaData__c> metaDataList = new  List<metaData__c>();
          if (Schema.sObjectType.metaData__c.fields.EntityName__c.isAccessible() )
        metaDataList  = [SELECT EntityName__c from metaData__c  where id != null];
         else
          system.debug('The logged in user does not have access to the field/object');
        try{
             if(DeleteList!= null){
                if (Schema.sObjectType.ClassesParse__c.isDeletable()) 
                 delete DeleteList; 
                else
                  system.debug('The logged in user does not have access to delete the field/object');     
                 }   //delete already existing records
              if(metaDataList!= null){    
               if (Schema.sObjectType.metaData__c.isDeletable()) 
                delete metaDataList;  
                else
              system.debug('The logged in user does not have access to delete the field/object');      
              }  
            
           }
        catch(Exception e){
            system.debug('Failed to delete the Record: ' + e.getMessage());
        }
    }
    /**
     * Author       -   Dinesh Girase
     * @date        -   10/12/2015
     * @description -   This method Generate Request id for the selected class and Page             
     * @return      -   String - ramdStr
     */ 
    private static String generateRequestid(){
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStrId = '';
        while (randStrId.length() < 6) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStrId += chars.substring(idx, idx+1);
        }
        return randStrId;
    }
    /**
     * Author       -   Dinesh Girase
     * @date        -   10/12/2015
     * @description -   This method insert all class method with respective id in metaData__c object                    
     * @param       -   classesList - string
     *                  pagesList - string
                        randStr - string
     */ 
    public static void insertMetaData(List<String> deserializeClassesList, List<String> deserializePagesList,String randStr){
        List<metaData__c> metaDatas = new List<metaData__c>();
        try{
        if(deserializeClassesList != null) {
            for(String className: deserializeClassesList) {
                metaData__c metaD = new metaData__c();
                metaD.EntityName__c = className;
                metaD.EntityType__c = 'ApexClass';
                metaD.EntityId__c = randStr;
                metaDatas.add(metaD);
            }
            }
        
        if(deserializePagesList != null) {
            for(String pageName: deserializePagesList) {
                metaData__c metaD = new metaData__c();
                metaD.EntityName__c = pageName;
                metaD.EntityType__c = 'ApexPage';
                metaD.EntityId__c = randStr;
                metaDatas.add(metaD);
            }
        }
           if (Schema.sObjectType.metaData__c.fields.EntityName__c.isCreateable() 
          &&  Schema.sObjectType.metaData__c.fields.EntityType__c.isCreateable()
          &&  Schema.sObjectType.metaData__c.fields.EntityId__c.isCreateable())
        //Inserting meta data values for class and pages
        insert metaDatas; 
          else
        system.debug('The logged in user does not have access to insert the field/object');
        }catch(Exception e){
            system.debug('Failed to insert the Record: ' + e.getMessage());
        }
    }
    
    
    
    
 /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/2015
     * @description -   this wrapper class 
     */     
    public class WrapperClass{
        public RulesMaster__c ruleMaster{get;set;}
        public Boolean selected{get;set;}
        
        public WrapperClass(RulesMaster__c r){
        this.ruleMaster = r;
        this.selected = false;
        } 
        
    } 
  

}