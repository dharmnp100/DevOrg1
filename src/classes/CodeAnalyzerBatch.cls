/*
BatchName: CodeAnalyzer Batch
Date: 26-Aug-2015
Description: This batch will be used to run analyzing rules for the pending items inside meta data object
*/

global with sharing class CodeAnalyzerBatch implements Database.Batchable<sObject>, Database.Stateful {
    //Data Variables
     public static List<ClassesParse__c> parseList {get; set;}
    Boolean callAgain = false;
    Boolean fullScanEnable = false;
    List<RulesMaster__c> rules {get; set;}
    global List<string> userListNew;
    String requestID = '';
    //Constructor    
    global CodeAnalyzerBatch() {
        rules = new List<RulesMaster__c>();
        parseList=new List<ClassesParse__c>();
        
    }

    //Parameterized Constructor
    global CodeAnalyzerBatch(List<RulesMaster__c> selectedRules,List<String> userList, String requestIdentifier) {
        rules = selectedRules;
        userListNew = userList;
        requestID = requestIdentifier;
        parseList=new List<ClassesParse__c>();
    }

/**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method is a Start Method, get the  data from metaData__c object
     */  
    global Database.QueryLocator start(Database.BatchableContext BC) {
         
         String query = 'SELECT EntityBody__c,EntityId__c,EntityName__c,EntityType__c,isCompleted__c, Id FROM metaData__c where isCompleted__c = false AND EntityId__c = :requestID limit 1';
          if (Schema.sObjectType.metaData__c.fields.EntityBody__c.isAccessible() 
          && Schema.sObjectType.metaData__c.fields.EntityId__c.isAccessible()
          && Schema.sObjectType.metaData__c.fields.EntityName__c.isAccessible()
          && Schema.sObjectType.metaData__c.fields.EntityType__c.isAccessible()
          && Schema.sObjectType.metaData__c.fields.isCompleted__c.isAccessible()
          && Schema.sObjectType.metaData__c.fields.Id .isAccessible())
          Database.getQueryLocator(query);
           system.debug('sakshi this is the query in batch class'+query);
          return Database.getQueryLocator(query);
         
        
    }

/**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method is a Excecute Method , it create the List of identified issues in respective classes   
     */   
    global void execute(Database.BatchableContext BC, List<metaData__c> metaDatas) {
        try{
         List<metaData__c> apexMethodMetaDatas;
          Map<String, ApexClass> classMap = new Map<String, ApexClass>();
             if(metaDatas.size() > 0) {
                RuleAnalyseService.lstRulesToExecute = rules;
            Map<String, String> parameterMap = new Map<String, String>();
            if(metaDatas[0].EntityType__c == 'ApexPage') {
                //Run Page Based Rules (Only requested Ones)
                List<ApexPage> apexPage = new List<ApexPage>();
                 if (Schema.sObjectType.ApexPage.fields.Name.isAccessible() 
                  && Schema.sObjectType.ApexPage.fields.Id.isAccessible()
                  && Schema.sObjectType.ApexPage.fields.Markup.isAccessible()
                  && Schema.sObjectType.ApexPage.fields.CreatedById.isAccessible()
                  && Schema.sObjectType.ApexPage.fields.LastModifiedById.isAccessible()  )  
                
               apexPage =  [SELECT Markup, Name, Id, CreatedById, LastModifiedById,CreatedBy.Name,LastModifiedBy.Name FROM ApexPage where Name = :metaDatas[0].EntityName__c limit 1];
                else
                 system.debug('The logged in user does not have access to the field/object');
           
                if(apexPage.size() > 0) {
                    parameterMap.put(Constants.APEXBODY, apexPage[0].Markup);
                    parameterMap.put(Constants.APEXNAME, apexPage[0].Name);
                    parameterMap.put(Constants.APEXID, apexPage[0].Id);
                    parameterMap.put(Constants.CREATEDBY, apexPage[0].CreatedById);
                    parameterMap.put(Constants.MODIFIEDBY, apexPage[0].LastModifiedById);
                    parameterMap.put('ApexCreatedByName', apexPage[0].CreatedBy.Name);
                    parameterMap.put('ApexModifiedByName', apexPage[0].LastModifiedBy.Name);

                    parseList =  RuleAnalyseService.performPageLevelCheck(parameterMap);
                }
            }else if(metaDatas[0].EntityType__c == 'ApexClass') {
                //Run Class Based Rules (Only requested ones and which are class level);
                List<ApexClass> apexClasses = new List<ApexClass>();
                   if (Schema.sObjectType.ApexClass.fields.Name.isAccessible() 
                  && Schema.sObjectType.ApexClass.fields.Id.isAccessible()
                  && Schema.sObjectType.ApexClass.fields.Body.isAccessible()
                  && Schema.sObjectType.ApexClass.fields.CreatedById.isAccessible()
                  && Schema.sObjectType.ApexClass.fields.LastModifiedById.isAccessible())       
              
                apexClasses = [SELECT Body, Name, Id, CreatedById, LastModifiedById,CreatedBy.Name,LastModifiedBy.Name FROM ApexClass where name = :metaDatas[0].EntityName__c limit 1];
                   else
                 system.debug('The logged in user does not have access to the field/object');
                if(apexClasses.size() > 0) {    
                    parameterMap.put(Constants.APEXBODY, apexClasses[0].body);
                    parameterMap.put(Constants.APEXNAME, apexClasses[0].Name);
                    parameterMap.put(Constants.APEXID, apexClasses[0].Id);
                    parameterMap.put(Constants.CREATEDBY, apexClasses[0].CreatedById);
                    parameterMap.put(Constants.MODIFIEDBY, apexClasses[0].LastModifiedById);
                    parameterMap.put('ApexCreatedByName', apexClasses[0].CreatedBy.Name);
                    parameterMap.put('ApexModifiedByName', apexClasses[0].LastModifiedBy.Name);
                    
                    classMap.put(apexClasses[0].Name, apexClasses[0]);
                    parseList =  RuleAnalyseService.performClassLevelCheck(parameterMap, false);
                   
           
           //To convert class into methods and create meta data records for same.
                    apexMethodMetaDatas = ClassHelper.convertClassesToMethods(apexClasses, requestID);
                }
            }else if(metaDatas[0].EntityType__c == 'ApexMethod') {
                //Run Method Based Rules (Only requested Ones and which are method level)
                List<ApexClass> apexClasses = new List<ApexClass>();
                 if (Schema.sObjectType.ApexClass.fields.Name.isAccessible() 
                  && Schema.sObjectType.ApexClass.fields.Id.isAccessible()
                  && Schema.sObjectType.ApexClass.fields.Body.isAccessible()
                  && Schema.sObjectType.ApexClass.fields.CreatedById.isAccessible()
                  && Schema.sObjectType.ApexClass.fields.LastModifiedById.isAccessible())   
                apexClasses = [SELECT Body, Name, Id, CreatedById, LastModifiedById,CreatedBy.Name,LastModifiedBy.Name FROM ApexClass where name = :metaDatas[0].EntityName__c limit 1];
                  else
                 system.debug('The logged in user does not have access to the field/object');
                if(apexClasses.size() > 0) {    
                    parameterMap.put(Constants.APEXBODY, metaDatas[0].EntityBody__c);
                    parameterMap.put(Constants.APEXNAME, apexClasses[0].Name);
                    parameterMap.put(Constants.APEXID, apexClasses[0].Id);
                    parameterMap.put(Constants.CREATEDBY, apexClasses[0].CreatedById);
                    parameterMap.put(Constants.MODIFIEDBY, apexClasses[0].LastModifiedById);
                    parameterMap.put('ApexCreatedByName', apexClasses[0].CreatedBy.Name);
                    parameterMap.put('ApexModifiedByName', apexClasses[0].LastModifiedBy.Name);  
                   
            parseList =   RuleAnalyseService.performClassLevelCheck(parameterMap, true);
                }
            }
             if(apexMethodMetaDatas != null) {
                System.debug('Inside apexMethodMetaDatas');
                for(metaData__c mD: apexMethodMetaDatas) {
                  //  parameterMap = new Map<String, String>();
                    ApexClass apx = classMap.get(mD.EntityName__c);
                                   
                    parameterMap.put(Constants.APEXBODY, mD.EntityBody__c);
                    parameterMap.put(Constants.APEXNAME, apx.Name);
                    parameterMap.put(Constants.APEXID, apx.Id);
                    parameterMap.put(Constants.CREATEDBY, apx.CreatedById);
                    parameterMap.put(Constants.MODIFIEDBY, apx.LastModifiedById);
                    parameterMap.put('ApexCreatedByName', apx.CreatedBy.Name);
                    parameterMap.put('ApexModifiedByName', apx.LastModifiedBy.Name);
                    parameterMap.put('StartLineNumber' ,mD.EntityLineNumber__c);

                    List<ClassesParse__c> prs = RuleAnalyseService.performClassLevelCheck(parameterMap, true);
                   
                    if(prs != null && prs.size() > 0) {
                        parseList.addAll(prs);
                        system.debug('sakshi'+prs);
                    }
                    
                }
            }
            metaDatas[0].isCompleted__c = true;
            if (Schema.sObjectType.metaData__c.isUpdateable())
            update metaDatas;
            else
            system.debug('The logged in user does not have access to the field/object');
            callAgain = true;
           
             if (Schema.sObjectType.ClassesParse__c.isUpdateable())
            upsert parseList;
            else
            system.debug('The logged in user does not have access to the field/object');
        }
        }catch(Exception e){
            system.debug('Failed to create the List of identified issues in respective classes: ' + e.getMessage());
        }
    }
   /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method is a Finish Method
     */ 
   
    global void finish(Database.BatchableContext BC) {
        try{
        if(callAgain) {
            CodeAnalyzerBatch  codeAnalyzer = new CodeAnalyzerBatch(rules,userListNew, requestID);
            Database.executeBatch(codeAnalyzer);
        }else{
            if(System.Label.Email_Report.toLowerCase() == 'true'){
               List<metaData__c> metaD = new List<metaData__c>();
                  if (Schema.sObjectType.metaData__c.fields.Id.isAccessible() 
                   && Schema.sObjectType.metaData__c.fields.EntityId__c.isAccessible()
                   && Schema.sObjectType.metaData__c.fields.isCompleted__c.isAccessible() )
               metaD  = [SELECT Id FROM metaData__c where EntityId__c = :requestId AND isCompleted__c = true limit 1];
                 else
          system.debug('The logged in user does not have access to the field/object');
               if(metaD.size() > 0) {
                   //email csv
                   sendEmail();
                   //run report
                }
            }
        }
        }catch(Exception e){
            system.debug('Failed to get the report and email to the user: ' + e.getMessage());
        }
    }

/**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method email the report to the user
     * @param       -   
     * @return      -   
     */    
    
    public void sendEmail(){
        
        try{
            String strBody = RuleAnalyseService.getReportData();   //This method will fetch data of identified issues and will generate CSV. @return-String 

            //attach the report
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment(); 
            attachment.setFileName(Constants.FILENAME);
            attachment.setContentType(Constants.CONTENT);
            attachment.setBody(Blob.valueof(strBody));
            
            List<User> userList = new List<User>();
             if (Schema.sObjectType.User.fields.Name.isAccessible()
              && Schema.sObjectType.User.fields.FirstName.isAccessible()
              && Schema.sObjectType.User.fields.LastName.isAccessible()
              && Schema.sObjectType.User.fields.email.isAccessible() ) 
             userList  = [select name,FirstName,LastName,email from User where id != null];
              else
        	system.debug('The logged in user does not have acess to the field/object');    
            String[]emailAddress = new String[]{};
            
            //create the mail 
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment } );
            message.setSubject(Constants.SUBJECT);
            String strBodyText = Constants.HITEXT + getUserNameAndEmail(userListNew,userList) + ',' + Constants.NEWLINE2;
            //strBodyText = strBodyText + Constants.TEXT;
            String helpPageURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ReportPage';
            String helptext = 'Should you have any questions/suggestions/feedback, please feel free to get in touch via our ';
            String htmlURL = '<a href="'+helpPageURL +'">help page</a>';
            strBodyText = strBodyText + Constants.TEXT1 + helptext + htmlURL + Constants.TEXT2;
            
            strBodyText = strBodyText + + Constants.NEWLINE2 + Constants.SALUTATION;           
            message.setHtmlBody(strBodyText);
            
            //get the email address of the user
            if(userListNew !=null && userList !=null){
                for(User usr:userList){
                    for(String str:userListNew){
                        if(str == usr.name){
                            emailAddress.add(usr.email);
                            
                        }
                    }
                    
                }
            }  
            message.setToAddresses(emailAddress);
            String displayName ='ApexLint Admin';
            message.setSenderDisplayName(displayName);
            
            //send email with report attach to the user
            Messaging.sendEmail( new Messaging.SingleEmailMessage[] { message } );
            List<metaData__c> mD = new List<metaData__c>();
            if (Schema.sObjectType.metaData__c.fields.Id.isAccessible() && Schema.sObjectType.metaData__c.fields.isCompleted__c.isAccessible())
            mD =  [SELECT Id FROM metaData__c where isCompleted__c = false];
          else
           system.debug('The logged in user does not have access to the field/object');	
            if(mD.size() > 0) {
           for(metaData__c m:mD)
           {
           m.isCompleted__c=true;
           
           }
            }
            }catch(Exception e){
                System.debug('Failed to generate CSV or create the mail or send email with report attach to the user:' +e.getMessage());
        }
    }  
    
    public string getUserNameAndEmail(List<string> userListNew, List<User> userList){
	 //get the email address of the user
	  String firstName = '';
        if(userListNew !=null && userList !=null){
            for(User usr:userList){
                for(String str:userListNew){
                    if(str == usr.name){
                       firstName = usr.FirstName;
                    }
                }
            }
        } 
        return firstName;
        
    } 
}