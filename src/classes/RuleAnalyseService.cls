/**
 * @author Dinesh Girase
 * @date 15/12/2015
 * @description - Service class containing various rules. Add new rule in this class.
 */ 

public with sharing class RuleAnalyseService {

    public static String ruleResult = Constants.FAIL;
    public static List<RulesMaster__c> lstRulesToExecute {get;set;}
    public static integer LinecountforRule3;
    public static integer catchLineNumber;
    public static Map<String, String> outputMap;
    public static String apexClassName;
    public static Boolean isTestClass = false;
    public static Boolean globalClass =  false;
    //Constructor        
    public RuleAnalyseService(){  
    }
    
    public static List<ClassesParse__c> performClassLevelCheck(Map<String, String> parameterMap){
        return performClassLevelCheck(parameterMap, false);
    }

    /**
       Author       -   Dinesh Girase
     * @date        -   4/12/15 
     * @description -   this method is used to check how many rules are active and call those rules
     * @param       -   parameterMap - Map with all apex classes related data
     * @return      -   List<ClassesParse__c> - List of identified issues in respective classes
     * @modifiedby  -
     */
    public static List<ClassesParse__c> performClassLevelCheck(Map<String, String> parameterMap, Boolean isMethod) {
        System.debug('isMethod: ' +isMethod);
        System.debug('parameterMap: ' +parameterMap);
        resultList = new List<ClassesParse__c>();
        apexClassName = '';
        String apexBody;
        String apexID;
        String apexCreatedById;
        String apexLastModifiedById;
        String apexCreatedByName;
        String apexModifiedByName;
        String apexStartLineNumber;
        
        if(parameterMap.get(Constants.APEXBODY)!=null)
        	apexBody = parameterMap.get(Constants.APEXBODY); 
        	System.debug('apexBody: ' +apexBody);
        if(parameterMap.get(Constants.APEXNAME)!=null)     
        	apexClassName = parameterMap.get(Constants.APEXNAME);
        if(parameterMap.get(Constants.APEXID)!=null)
        	apexID = parameterMap.get(Constants.APEXID);
        if(parameterMap.get(Constants.CREATEDBY)!=null)
        	apexCreatedById = parameterMap.get(Constants.CREATEDBY);
        if(parameterMap.get(Constants.MODIFIEDBY)!=null)
        	apexLastModifiedById = parameterMap.get(Constants.MODIFIEDBY);
        if(parameterMap.get(Constants.CREATEDBYNAME)!=null)
        	apexCreatedByName = parameterMap.get(Constants.CREATEDBYNAME);
        if(parameterMap.get(Constants.MODIFIEDBYNAME)!=null)
        	apexModifiedByName = parameterMap.get(Constants.MODIFIEDBYNAME);
        if(isMethod && parameterMap.get(Constants.STARTLINENUMBER)!=null){
            apexStartLineNumber =  parameterMap.get(Constants.STARTLINENUMBER);         
        }
        
        outputMap = new Map<String, String>();
        outputMap.put(Constants.APEXBODY,apexBody);
        System.debug('outputMap: ' +outputMap);       
        outputMap.put(Constants.RULERESULT,ruleResult);
        outputMap.put(Constants.APEXID,apexID);
        outputMap.put(Constants.CREATEDBY,apexCreatedById);
        outputMap.put(Constants.MODIFIEDBY,apexLastModifiedById);
        outputMap.put(Constants.CREATEDBYNAME,apexCreatedByName);
        outputMap.put(Constants.MODIFIEDBYNAME,apexModifiedByName);
        outputMap.put(Constants.STARTLINENUMBER,apexStartLineNumber);
        
        Boolean result = false;
       
        if(lstRulesToExecute != null && lstRulesToExecute.size()>0){
            classTypeCheck();            
            for(RulesMaster__c lstRuleVal : lstRulesToExecute){
                	System.debug('lstRuleVal.RuleKey__c: ' +lstRuleVal.RuleKey__c);
                
	              if(lstRuleVal.RuleKey__c == 'Rule1' && (!isMethod)){        //Rule 1 Run on Class
	              	System.debug('Runing rule 1: ');
	              	publicWithSharingCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod,result);
	              	system.debug(Logginglevel.Debug,'getCpuTime() Rule 1: '+Limits.getCpuTime());
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule2' && isMethod){      //Rule 2 Run on Method
	              	
	              	datetime methodStart = datetime.now();
	              	system.debug('Runing rule 2: ');
	              	system.debug('Rule 2 MethodName: ' + parameterMap.get(Constants.APEXNAME));
                    system.debug('Rule 2 MethodBody: ' + parameterMap.get(Constants.APEXBODY));
                    queryInLoopCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod);
                    datetime methodEnd = datetime.now();
                    system.debug(Logginglevel.Debug,'Time Taken for MethodName Rule 2: ' + parameterMap.get(Constants.APEXNAME) + 'Time Taken in Millisecs Rule 2: '+  (methodEnd.getTime() - methodStart.getTime()));  
	              	system.debug(Logginglevel.Debug,'getCpuTime() Rule 2: '+Limits.getCpuTime());
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule3' && (!isMethod)){   //Rule 3 Run on Class
	              	System.debug('Runing rule 3: ');
	              	whereClauseCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod);
	              	system.debug(Logginglevel.Debug,'getCpuTime() Rule 3: '+Limits.getCpuTime());
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule4' && (!isMethod)){   //Rule 4 Run on Class
	              	System.debug('Runing rule 4: ');
	              	reflectedXSSCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod);
	              	system.debug(Logginglevel.Info,'getCpuTime() Rule 4: '+Limits.getCpuTime());
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule5' && isMethod){      //Rule 5 Run on Method
	              	
	              	datetime methodStart = datetime.now();
	                system.debug('Runing rule 5: ');
	              	system.debug('Rule 5 MethodName: ' + parameterMap.get(Constants.APEXNAME));
                    system.debug('Rule 5 MethodBody: ' + parameterMap.get(Constants.APEXBODY));
                    objectInstInLoopCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod);  
                    datetime methodEnd = datetime.now();
                    system.debug(Logginglevel.Info,'Time Taken for MethodName Rule 5: ' + parameterMap.get(Constants.APEXNAME) + 'Time Taken in Millisecs Rule 5: '+  (methodEnd.getTime() - methodStart.getTime()));  
                    system.debug(Logginglevel.Info,'getCpuTime() Rule 5: '+Limits.getCpuTime()); 
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule6' && isMethod){      //Rule 6 Run on Method 

	              	datetime methodStart = datetime.now();
	               	system.debug('Runing rule 6: ');
	              	system.debug('Rule 6 MethodName: ' + parameterMap.get(Constants.APEXNAME));
                    system.debug('Rule 6 MethodBody: ' + parameterMap.get(Constants.APEXBODY));
                    soqlOrSoslInjectionCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod);
                    datetime methodEnd = datetime.now();
                    system.debug(Logginglevel.Info,'Time Taken for MethodName Rule 6: ' + parameterMap.get(Constants.APEXNAME) + 'Time Taken in Millisecs Rule 6: '+  (methodEnd.getTime() - methodStart.getTime()));  
                    system.debug(Logginglevel.Info,'getCpuTime() Rule 6: '+Limits.getCpuTime());
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule7' && (!isMethod)){   //Rule 7 Run on Class
	              	System.debug('Runing rule 7: ');
	              	 classMethodLevelCommentsCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod);
	              	 system.debug(Logginglevel.Info,'getCpuTime() Rule 7: '+Limits.getCpuTime());
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule8' && (!isMethod)){   //Rule 8 Run on Class
	              	System.debug('Runing rule 8: ');
	              	debugStatementsCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod);
	              	system.debug(Logginglevel.Info,'getCpuTime() Rule 8: '+Limits.getCpuTime());
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule9' && (!isMethod)){   //Rule 9 Run on Class
	              	System.debug('Runing rule 9: ');
	              	constantsCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod);
	              	system.debug(Logginglevel.Info,'getCpuTime() Rule 9: '+Limits.getCpuTime());
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule10' && (!isMethod)){  //Rule 10 Run on Class
	              	System.debug('Runing rule 10: ');
	              	assertStatementsCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod);
	              	system.debug(Logginglevel.Info,'getCpuTime() Rule 10: '+Limits.getCpuTime());
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule11' && isMethod){     //Rule 11 Run on Method
	              	
	              	datetime methodStart = datetime.now();
	                system.debug('Runing rule 11: ');
	              	system.debug('Rule 11 MethodName: ' + parameterMap.get(Constants.APEXNAME));
                    system.debug('Rule 11 MethodBody: ' + parameterMap.get(Constants.APEXBODY));
                    tryCatchCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod);
                    datetime methodEnd = datetime.now();
                    system.debug(Logginglevel.Info,'Time Taken for MethodName Rule 11: ' + parameterMap.get(Constants.APEXNAME) + 'Time Taken in Millisecs Rule 11: '+  (methodEnd.getTime() - methodStart.getTime()));  
                    system.debug(Logginglevel.Info,'getCpuTime() Rule 11: '+Limits.getCpuTime());
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule12' && (!isMethod)){  //Rule 12 Run on Class
	              	System.debug('Runing rule 12: ');
	              	noOfMethodsCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod); 
	              	system.debug(Logginglevel.Info,'getCpuTime() Rule 12: '+Limits.getCpuTime());   
	              }
	              else if(lstRuleVal.RuleKey__c == 'Rule13' && isMethod){     //Rule 13 Run on Method
	              
	              	datetime methodStart = datetime.now();
	                system.debug('Runing rule 13: ');
	              	system.debug('Rule 13 MethodName: ' + parameterMap.get(Constants.APEXNAME));
                    system.debug('Rule 13 MethodBody: ' + parameterMap.get(Constants.APEXBODY));
                    LinesOfCodeCheck(lstRuleVal.RuleKey__c,lstRuleVal.id,isMethod); 
                    datetime methodEnd = datetime.now();
                    system.debug(Logginglevel.Info,'Time Taken for MethodName Rule 13: ' + parameterMap.get(Constants.APEXNAME) + 'Time Taken in Millisecs Rule 13: '+  (methodEnd.getTime() - methodStart.getTime()));  
                   	system.debug(Logginglevel.Info,'getCpuTime() Rule 13: '+Limits.getCpuTime());        	
	              }
            }
       
        }
        
        return resultList;
         
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   15/12/2015
     * @description -   This method check whether the class is test class or global class                        
     */ 
    private static void classTypeCheck(){
        try {
            isTestClass = PatternMatching(Constants.TestClassPattern,outputMap.get(Constants.APEXBODY));
            globalClass = PatternMatching(Constants.ClassPatternGlobal,outputMap.get(Constants.APEXBODY));
        }catch(Exception e) {
               system.debug('Failed to check whether the class is test class or global class: ' + e.getMessage());
            }
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   10/12/2015
     * @description -   This method add the list of identified issue in pages                        
     */ 
    private static void publicWithSharingCheck(String ruleKey,ID ruleKeyID ,Boolean isMethod,Boolean resultvalue){
        try{
        /*System.debug('Constants.RULE1'+Constants.RULE1);
        System.debug('ruleKey'+ruleKey);
        System.debug('isMethod '+isMethod);
        System.debug('(ruleKey.equalsIgnoreCase(Constants.RULE1)) ' + (ruleKey.equalsIgnoreCase(Constants.RULE1)));
        */
        //System.debug('isMethod '+isMethod);
        Boolean conditionMet = ((ruleKey.equalsIgnoreCase(Constants.RULE1)) && (!isMethod));
        //System.debug('conditionMet -'+conditionMet );        
            if(conditionMet){
                //process Rule1
                //System.debug('globalClass - '+globalClass);
                //System.debug('isTestClass - '+isTestClass);
                if( isTestClass == false && globalClass == false) {
                //System.debug('Pattern - '+ Constants.WithSharingPattern);
                //System.debug('Body - \n'+ outputMap.get(Constants.APEXBODY));
                Boolean patternFound = (PatternMatching(Constants.WithSharingPattern,outputMap.get(Constants.APEXBODY)));
                //System.debug('patternFound - '+ patternFound);
                if(patternFound)
                {
                    //System.debug('With Sharing Line Found');
                    outputMap.put(Constants.METHODOUTPUT,String.valueOf(patternFound));
                    outputMap.put(Constants.PROBLEMSTATEMENT,Constants.WITHSHARING);
                    outputMap.put(Constants.SEVERITY,Constants.MAJOR);
                    outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                    outputMap.put(Constants.APEXNAME,apexClassName);
                    checkPublicWithSharing(outputMap);
                }
            }
            }
        }
                
         catch(Exception e){
                system.debug('Failed to check Public with sharing rule: ' + e.getMessage());
            }
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   15/12/2015
     * @description -   This method check where clause in query                        
     */ 
    @TestVisible
    private static void whereClauseCheck(String ruleKey,ID ruleKeyID, Boolean isMethod){
        try{
            system.debug('>>>ruleKey>>>>>>>>'+ruleKey);
            system.debug('>>>ruleKeyID>>>>>>>>'+ruleKeyID);
            system.debug('>>>isMethod>>>>>>>>'+isMethod);
            
            if(ruleKey.equalsIgnoreCase(Constants.RULE3) && !isMethod ){
                if(isTestClass == false){
                outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                outputMap.put(Constants.APEXNAME,apexClassName);
                checkWhereClauseInQuery(outputMap);
                }
                
            }
            system.debug('>>>outputMap>>>>>>>>'+outputMap);
            }catch(Exception e){
                system.debug('Failed to check Where Clause In Query rule: ' + e.getMessage());
            }
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   15/12/2015
     * @description -   This method check Query in loop                        
     */ 
    private static void queryInLoopCheck(String ruleKey,ID ruleKeyID , Boolean isMethod){
        try{System.Debug('Inside Rule2>>>>'+ruleKey);
        System.Debug('Inside Rule2>>>>'+ruleKeyID );
        System.Debug('Inside Rule2>>>>'+isMethod);
            if(ruleKey.equalsIgnoreCase(Constants.RULE2) && isMethod){
                
                System.Debug('Inside Rule2');
                if(isTestClass == false){                
                boolean whileboolean = PatternMatching(Constants.SelectWhileInLoop,outputMap.get(Constants.APEXBODY));                
                boolean forboolean = PatternMatching(Constants.SelectForInLoop,outputMap.get(Constants.APEXBODY));                         
                List<String>methodName = outputMap.get(Constants.APEXBODY).split('\n');
                System.debug('methodName - '+methodName[0]);                
                if(whileboolean == true){
                    System.Debug('Inside whileboolean - '+ whileboolean);
                    LinecountforRule3=0;
                    outputMap.put(Constants.LOOPTYPE,Constants.WHILEPATTERN);
                    outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                    outputMap.put(Constants.APEXNAME,apexClassName );
                    checkQueryInLoop(outputMap);
                }
                if(forboolean == true){
                    System.Debug('Inside forboolean - '+ forboolean);
                    LinecountforRule3=0;
                    outputMap.put(Constants.LOOPTYPE,Constants.FORPATTERN);
                    outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                    outputMap.put(Constants.APEXNAME,apexClassName);
                    checkQueryInLoop(outputMap);
                }
              } 
            }
            }catch(Exception e){
                system.debug('Failed to check Query in loop rule: ' + e.getMessage());
            }
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   15/12/2015
     * @description -   This method check Reflected XSS In Class                      
     */ 
    private static void reflectedXSSCheck(String ruleKey,ID ruleKeyID , Boolean isMethod){
        try{
            if(ruleKey.equalsIgnoreCase(Constants.RULE4) && !isMethod){
                if(isTestClass == false){
                
                if(PatternMatching(Constants.ApexCurrentPattern,outputMap.get(Constants.APEXBODY))==true){
                    outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                    outputMap.put(Constants.APEXNAME,apexClassName);
                    checkReflectedXSSInClass(outputMap);
                }
              }
            }
        }catch(Exception e){
            system.debug('Failed to check Reflected XSS In Class rule: ' + e.getMessage());
        }
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   15/12/2015
     * @description -   This method check SOQL/SOSL Injection                     
     */ 
    private static void soqlOrSoslInjectionCheck(String ruleKey,ID ruleKeyID , Boolean isMethod){
        try{
            if(ruleKey.equalsIgnoreCase(Constants.RULE6) && isMethod){
                if(isTestClass == false){
                   
                if((PatternMatching(Constants.SelectPattern2,outputMap.get(Constants.APEXBODY))==true) ||(PatternMatching(Constants.SelectPattern1,outputMap.get(Constants.APEXBODY))==true)||(PatternMatching(Constants.findPattern,outputMap.get(Constants.APEXBODY))==true)||(PatternMatching(Constants.findPattern1,outputMap.get(Constants.APEXBODY))==true)){
                    outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                    outputMap.put(Constants.APEXNAME,apexClassName);
                    checkSOQLSOSLInjection(outputMap);
                }
             }
            }
        }catch(Exception e){
            system.debug('Failed to check SOQL/SOSL Injection rule: ' + e.getMessage());
        }
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   15/12/2015
     * @description -   This method check Class & Method Level Comments                   
     */ 
    private static void classMethodLevelCommentsCheck(String ruleKey,ID ruleKeyID , Boolean isMethod){
        try{
            //class method level comments
            if(ruleKey.equalsIgnoreCase(Constants.RULE7) && !isMethod){
                if((PatternMatching(Constants.ClassCommentsPattern,outputMap.get(Constants.APEXBODY))==true)){
                     outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                     outputMap.put(Constants.APEXNAME,apexClassName);
                     checkClassMethodLevelComments(outputMap);
                }
            }
        }catch(Exception e){
            system.debug('Failed to check Class & Method Level Comments rule: ' + e.getMessage());
        }
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   15/12/2015
     * @description -   This method check Debug Statements                
     */ 
    private static void debugStatementsCheck(String ruleKey,ID ruleKeyID , Boolean isMethod){
        try{
            //check debug statements
            if(ruleKey.equalsIgnoreCase(Constants.RULE8) && !isMethod){
               if(PatternMatching(Constants.DebugPattern,outputMap.get(Constants.APEXBODY))==true){
                     outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                     outputMap.put(Constants.APEXNAME,apexClassName);
                     checkDebugStatements(outputMap);
                }
           }
        }catch(Exception e){
            system.debug('Failed to check Debug Statements rule: ' + e.getMessage());
        }
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   15/12/2015
     * @description -   This method check Constants               
     */ 
    private static void constantsCheck(String ruleKey,ID ruleKeyID ,Boolean isMethod){
        try{    
           //check constants in classes
           if(ruleKey.equalsIgnoreCase(Constants.RULE9) && !isMethod){
            if(isTestClass == false){
               if((PatternMatching(Constants.ClassPatternConstant,outputMap.get(Constants.APEXBODY))==true)){
                     outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                     outputMap.put(Constants.APEXNAME,apexClassName);
                     checkConstants(outputMap);
                }
            }
           }    
        }catch(Exception e){
            system.debug('Failed to check Constants rule: ' + e.getMessage());
        }
    }
/**
     * Author       -   Dinesh Girase
     * @date        -   15/12/2015
     * @description -   This method check Assert Statements      
     */ 
    private static void assertStatementsCheck(String ruleKey,ID ruleKeyID , Boolean isMethod){
        try{
           //check assert statements in test classes
           if(ruleKey.equalsIgnoreCase(Constants.RULE10) && !isMethod){
               if(PatternMatching(Constants.TestClassPatternForAssert,outputMap.get(Constants.APEXBODY))==true){
                     outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                     outputMap.put(Constants.APEXNAME,apexClassName);
                     checkAssertStatements(outputMap);
                }
           }
        }catch(Exception e){
            system.debug('Failed to check Assert Statements rule: ' + e.getMessage());
        }
    }
/**
 * Author       -   Dinesh Girase
 * @date        -   15/12/2015
 * @description -   This method check Try Catch  
 */
    private static void tryCatchCheck(String ruleKey,ID ruleKeyID , Boolean isMethod){
        try{
           //check try catch in each methods in classes
           if(ruleKey.equalsIgnoreCase(Constants.RULE11) && isMethod){
                if(isTestClass == false){
                outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                outputMap.put(Constants.APEXNAME,apexClassName);
                checkTryCatch(outputMap);
                 
                }   
           }    
        }catch(Exception e){
            system.debug('Failed to check Try Catch rule: ' + e.getMessage());
        }
    } 
/**
 * Author       -   Dinesh Girase
 * @date        -   15/12/2015
 * @description -   This method check Object InstInLoop
 */ 
    private static void objectInstInLoopCheck(String ruleKey,ID ruleKeyID , Boolean isMethod){
        try{
           //check object creation inside loop
           if(ruleKey.equalsIgnoreCase(Constants.RULE14) && isMethod){
                boolean whileResult = PatternMatching(Constants.ObjectInstInsideWhile, outputMap.get(Constants.APEXBODY));
                boolean forResult = PatternMatching(Constants.ObjectInstInsideFor, outputMap.get(Constants.APEXBODY));
                 
                   List<String>methodName = outputMap.get(Constants.APEXBODY).split('\n');
                   
                if(whileResult == true){
                    LinecountforRule3=0;
                    
                    outputMap.put(Constants.LOOPTYPE,Constants.WHILEPATTERN);
                    outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                     outputMap.put(Constants.APEXNAME,apexClassName);
                    checkObjectInstInLoop(outputMap);
                }
                if(forResult == true){
                   LinecountforRule3=0;
                    
                   outputMap.put(Constants.LOOPTYPE,Constants.FORPATTERN);
                   outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                    outputMap.put(Constants.APEXNAME,apexClassName);
                   checkObjectInstInLoop(outputMap);
                }     
           }
        }catch(Exception e){
            system.debug('Failed to check Object InstInLoop rule: ' + e.getMessage());
        }
    }

/**
       Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method is used to check how many rules are active and call those rules
     * @param       -   parameterMap - Map with all apex pages related data
     * @return      -   List<ClassesParse__c> - List of identified issues in respective pages
     * @modifiedby  -
     */
    public static List<ClassesParse__c> performPageLevelCheck(Map<String, String> parameterMap){
    
        resultList = new List<ClassesParse__c>();
        apexClassName = '';
        String apexBody;
        String apexID;
        String apexCreatedById;
        String apexLastModifiedById;
        String apexCreatedByName;
        String apexModifiedByName;
        
        apexBody =  RemovePageCodeComments(parameterMap.get(Constants.APEXBODY));
        apexClassName = parameterMap.get(Constants.APEXNAME);
        apexID = parameterMap.get(Constants.APEXID);
        apexCreatedById = parameterMap.get(Constants.CREATEDBY);
        apexLastModifiedById = parameterMap.get(Constants.MODIFIEDBY);
        apexCreatedByName = parameterMap.get(Constants.CREATEDBYNAME);
        apexModifiedByName = parameterMap.get(Constants.MODIFIEDBYNAME);
        
        outputMap = new Map<String, String>();
        outputMap.put(Constants.APEXBODY,apexBody);
        outputMap.put(Constants.APEXNAME,apexClassName);
        outputMap.put(Constants.RULERESULT,ruleResult);
        outputMap.put(Constants.APEXID,apexID);
        outputMap.put(Constants.CREATEDBY,apexCreatedById);
        outputMap.put(Constants.MODIFIEDBY,apexLastModifiedById);
        outputMap.put(Constants.CREATEDBYNAME,apexCreatedByName);
        outputMap.put(Constants.MODIFIEDBYNAME,apexModifiedByName);
        
        Boolean result = false;
        //Call rulesToExecute() loop that list
     
        if(lstRulesToExecute != null && lstRulesToExecute.size()>0){
            for(RulesMaster__c lstRuleVal : lstRulesToExecute){
                
                try{
                if(lstRuleVal.RuleKey__c.equalsIgnoreCase(Constants.RULE4) ){
                    if(PatternMatching(Constants.ReflectedXSSForPages,outputMap.get(Constants.APEXBODY))==true){
                        outputMap.put(Constants.DESCRIPTION,lstRuleVal.Id);
                        checkReflectedXSSInPage(outputMap);
                    }
                    
                }
                }catch(Exception e){
                    system.debug('Failed to check Reflected XSS In Page rule: ' + e.getMessage());
                }
                
                
                
                if(lstRuleVal.RuleKey__c.equalsIgnoreCase(Constants.RULE5) ){
                    try{
                    if(PatternMatching(Constants.ScriptPattern,outputMap.get(Constants.APEXBODY))==true){
                        outputMap.put(Constants.DESCRIPTION,lstRuleVal.Id);
                        checkStoredXSSScriptTag(outputMap);
                    }
                    }catch(Exception e){
                        system.debug('Failed to check Stored XSS Script Tag rule: ' + e.getMessage());
                    }
                    try{
                    if(PatternMatching(Constants.StylePattern,outputMap.get(Constants.APEXBODY))==true){
                        outputMap.put(Constants.DESCRIPTION,lstRuleVal.Id);
                        checkStoredXSSStyleTag(outputMap);
                    }
                    }catch(Exception e){
                        system.debug('Failed to check Stored XSS Style Tag rule: ' + e.getMessage());
                    }
                    try{
                    if(PatternMatching(Constants.HTMLTagPattern,outputMap.get(Constants.APEXBODY))==true){
                        outputMap.put(Constants.DESCRIPTION,lstRuleVal.Id);
                        checkStoredXSSAnyHTMLTag(outputMap);
                    }
                    }catch(Exception e){
                        system.debug('Failed to check Stored XSS Any HTML Tag rule: ' + e.getMessage());
                    }
                
                 }
            }
        }
          return resultList;
    }
    
    /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method is used to check whether apex class is declared with sharing or not
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
public static void checkPublicWithSharing(Map<String, String> outputParamMap){
        
        Map<String, String> insertData = new Map<String, String>();
        integer count=1;
        integer LineNum=0;
        try{
        String codeWithoutComments = RemoveCodeComments(outputParamMap.get(Constants.APEXBODY));
        //System.Debug('codeWithoutComments: \n' + codeWithoutComments);
        List<String> BodyLine= codeWithoutComments.split(Constants.Newline);  
        System.Debug('Code Lines: \n' + BodyLine.Size());  
        Boolean patternFound = false;       
        for(String Temp:BodyLine)
        {
        //System.Debug('Line - '+Temp);
            patternFound = PatternMatching(Constants.WithSharingPattern,Temp);            
            if(patternFound == true){  
                //System.debug('Pattern Found at line - '+ String.valueOf(count))     ;  
                insertData.put(constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));
                insertData.put(Constants.LINENUM, String.valueOf(count));
                insertData.put(Constants.PROBLEMSTATEMENT,Constants.WITHSHARING);  
                insertData.put(Constants.SEVERITY,Constants.MAJOR); 
                insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));           
                 insertData.put(Constants.RULERESULT,ruleResult); 
                AddObjectClassesParse(insertData);
            }            
            count++;
        }
        
        //throw new MyException('Exception in rule 1');
        //if(Boolean.valueOf(outputParamMap.get(Constants.METHODOUTPUT)) == true) {
        //}
        
        //else{
        //AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),ruleResult,Constants.WITHSHARING,Constants.MAJOR,outputParamMap.get(Constants.APEXID),String.valueOf(1),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
       // }
      }
        catch(Exception e){
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME), e.getMessage(),Constants.WITHSHARING, Constants.MAJOR,outputParamMap.get(Constants.APEXID), String.valueOf(e.getLineNumber()), outputParamMap.get(Constants.CREATEDBYNAME), outputParamMap.get(Constants.MODIFIEDBYNAME), outputParamMap.get(Constants.DESCRIPTION), ''));
        }
        
    }
    
    /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method is used to check whether SOQL query is having where clause or not
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
    public static void checkWhereClauseInQuery(Map<String, String> outputParamMap){
        Map<String, String> insertData = new Map<String, String>();
        integer count = 1;
        integer LineNum = 0; 
        Boolean SoqlWhereCond;
        
        try{
            
       // throw new MyException('Exception in rule 3');
       //*********************New Code ************
        String codeWithoutComments = RemoveCodeComments(outputMap.get(Constants.APEXBODY));
        List<String> BodyLine = codeWithoutComments.split(Constants.SEMICOLON);
       //*************************
       // List<String> BodyLine = outputParamMap.get(Constants.APEXBODY).split(Constants.SEMICOLON);
        system.debug('>>>Bodyline>>>>>>>'+BodyLine);
        
        for(String Temp : BodyLine){
            system.debug('>>>Temp>>>>>>1'+Temp);
            if(count == 1){
                LineNum = LineNum + getCount(Constants.NEWLINE,Temp);    // Get the count of first line
            }else{
                LineNum = LineNum + getCount(Constants.NEWLINE,Temp) - 1;  
            }
                 Boolean result1 = PatternMatching(Constants.SelectPattern1,Temp);   
                if(result1 == false){
                    result1 = PatternMatching(Constants.SelectPattern2,Temp);
                }
                if(result1 == true) {
                    Boolean insideResult = PatternMatching(Constants.SelectPattern3,Temp); 
                    if(insideResult == false){
                        insideResult = PatternMatching(Constants.SelectPattern4,Temp);
                    }
                    if(insideResult == true){
                        SoqlWhereCond = true;
                    }else{
                        AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),ruleResult,Constants.SOQLWITHOUTWHR,Constants.MAJOR,outputParamMap.get(Constants.APEXID),String.valueOf(LineNum),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
                       
                    }
                }
                count++;
            }  
        }catch(Exception e){        
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),Constants.SOQLWITHOUTWHR,Constants.MAJOR,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
        }
    }
    
    public static List<ClassesParse__c> resultList = new List<ClassesParse__c>();
    
    /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method is used to add identified issues into the list, which will be inserted into the database to generate report
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
    public static void AddObjectClassesParse(Map<String, String> outputParamMap){
        try{
         ClassesParse__c parseResult = new ClassesParse__c ();
         parseResult.ClassName__c = outputParamMap.get(Constants.APEXNAME);
         parseResult.Rule__c = outputParamMap.get(Constants.PROBLEMSTATEMENT);
         parseResult.Severity__c = outputParamMap.get(Constants.SEVERITY);
         parseResult.ClassId__c = outputParamMap.get(Constants.APEXID);
         system.debug('>>>outputParamMap.get(Constants.LINENUM)>>>>>>'+outputParamMap.get(Constants.LINENUM));
         parseResult.LineNumber__c = Integer.valueOf(outputParamMap.get(Constants.LINENUM));
         parseResult.CreatedBy__c = outputParamMap.get(Constants.CREATEDBYNAME);
         parseResult.ModifiedBy__c = outputParamMap.get(Constants.MODIFIEDBYNAME);
         parseResult.Description__c = outputParamMap.get(Constants.DESCRIPTION);
         
         if(outputParamMap.get(Constants.RULERESULT)!=null){
            
         parseResult.Result__c = outputParamMap.get(Constants.RULERESULT);
         }
         system.debug('>>>parseResult>>>>>>>>'+parseResult);        
         resultList.add(parseResult);
        
        }catch(Exception e){
            system.debug('Failed to get the list of identified issue: ' + e.getMessage());
        }
    }
     
    /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   map creation
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
    public static Map<String,String> setClassParseParams(String name, String message, String problemStmt, String severity, String Id, String lineNum, String createdByName, String modifiedByName, String description, String loopType) {
            Map<String, String> insertData = new Map<String, String>();
            insertData.put(Constants.APEXNAME, name);
            insertData.put(Constants.RULERESULT,message);
            insertData.put(Constants.PROBLEMSTATEMENT, problemStmt);
            insertData.put(Constants.SEVERITY, severity);
            insertData.put(Constants.APEXID, Id);
            insertData.put(Constants.LINENUM, lineNum);
            insertData.put(Constants.CREATEDBYNAME,createdByName);
            insertData.put(Constants.MODIFIEDBYNAME, modifiedByName);
            insertData.put(Constants.DESCRIPTION, description);
            insertData.put(Constants.LOOPTYPE, loopType);
            return insertData;
         }
    
    /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method is used to get name of user
     * @param       -   userId - Id of user
     * @return      -   name - name of user
     * @modifiedby  -
     */
    public static String getName(String userId) {
        
        User userName = new User();
        if (Schema.sObjectType.User.fields.Name.isAccessible()
         && Schema.sObjectType.User.fields.Id.isAccessible()) 
           userName=[Select Name from User where Id=:userId];
       else
        system.debug('The logged in user does not have acess to the field/object');    
       
       return userName.Name;
        
    }
    
    /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method is used to get all active rules
     * @param       -   
     * @return      -   void
     * @modifiedby  -
     */
    public static void rulesToExecute(String ruleKey){
        //Get all active rules from rules master
        
        List<RulesMaster__c> lstRules;
        lstRulesToExecute = new List<RulesMaster__c>();
        try{
               
                List<String>rulesListFinal = ruleKey.split(',');
                String query = 'SELECT Id,RuleKey__c,RuleDescription__c,RuleNameToDisplay__c FROM RulesMaster__c where isActive__c = true';
                     
             if (Schema.sObjectType.RulesMaster__c.fields.Id.isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.RuleKey__c.isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.RuleDescription__c.isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.RuleNameToDisplay__c .isAccessible() 
              && Schema.sObjectType.RulesMaster__c.fields.isActive__c .isAccessible() )
                lstRules=Database.query(query); 
                 else               
               system.debug('The logged in user does not have access to the field/object');
                for(RulesMaster__c r:lstRules){
                    for(String s:rulesListFinal){
                        if(r.RuleKey__c == s && s!= null){
                            lstRulesToExecute.add(r);   
                      }  
                    }                                 
               }
              }catch(Exception e){
                  system.debug('Failed to get all active rules: ' + e.getMessage());
            }
    }
    
    /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method is used to get line count
     * @param       -   pattern - pattern to split
     *                  str - string to split
     * @return      -   count - number of lines count
     * @modifiedby  -
     */
    public static integer getCount(String pattern, String str){
        List<String> splitStr;
        try{
        splitStr = str.split(pattern);
        system.debug('splitStr: ' + splitStr);   
        
        }catch(Exception e){
             system.debug('Failed to get line count: ' + e.getMessage());
        }
            system.debug('splitStr Size: ' + splitStr.size());
            return splitStr.size();
    }
    
    /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method checks whether pattrens are matched or not
     * @param       -   StringPattern - pattern to match
     *                  MatchString - with this string
     * @return      -   boolean - true - if pattern matched otherwise false
     * @modifiedby  -
     */
     public static Boolean PatternMatching(String StringPattern, String MatchString){
        Boolean MatchResult;
        try{        
        String MatchStringwithoutNewLine = MatchString.replaceAll(Constants.NEWLINE,' ');
        Pattern MyPattern = Pattern.compile(StringPattern);
        System.Debug('MyPattern :'+ MyPattern);
        System.Debug('MatchStringwithoutNewLine :'+ MatchStringwithoutNewLine);
        System.Debug('MatchStringwithoutNewLineLength :'+ MatchStringwithoutNewLine.length());
        System.Debug('StringPattern :'+ StringPattern);
        Matcher MyMatcher = MyPattern.matcher(MatchStringwithoutNewLine);
        System.Debug('MyMatcher :'+ MyMatcher);
            if(MyMatcher.find() == true){
                MatchResult = true;
            }else{
                MatchResult = false;
            }
            System.Debug('MatchResult :'+ MatchResult); 
            return MatchResult;
         
        }catch(Exception e){
            return MatchResult;
        }
        
    }
    
    //--------------------------------------
       
    /**
     * Author       -   Dinesh Girase
     * @date        -   4/12/15
     * @description -   this method checks whether SOQL query is inside for or while loop
     * @param       -   outputParamMap - data related to all apex classes
     * @return      -   void
     * @modifiedby  -
     */
   public static void checkQueryInLoop(Map<String, String> outputParamMap){
   	
        System.debug('outputParamMap:' + outputParamMap);
        Map<String, String> insertData = new Map<String, String>();
        String matchingSelectPattern;
        List<String> methodName;       
        Integer methodStartLineNumber = 0;
        String startLineNumber = outputParamMap.get(Constants.STARTLINENUMBER);
        if(String.isNOTBlank(startLineNumber))
        {
          methodStartLineNumber = Integer.ValueOf(startLineNumber);
        }
        System.debug('checkQueryInLoop > methodStartLineNumber - '+ methodStartLineNumber);
        try{

        insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));   
        //ClassName
        insertData.put(Constants.APEXBODY,outputParamMap.get(Constants.APEXBODY));
        insertData.put(Constants.SEVERITY,Constants.MAJOR);
        insertData.put(Constants.LOOPTYPE,outputParamMap.get(Constants.LOOPTYPE));
        insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
        insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
        insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
        insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
        insertData.put(Constants.RULERESULT,ruleResult);  
        insertData.put(Constants.STARTLINENUMBER,startLineNumber); 
        
       //*************added new code*************
       string apexBodycode = outputParamMap.get(Constants.APEXBODY);
       System.Debug('apexBodycode - '+apexBodycode);      
       
       String codeWithoutComments = RemoveCodeComments(apexBodycode);
       System.Debug('codeWithoutComments - '+codeWithoutComments); 
            
       String MatchStringwithoutNewLine = codeWithoutComments.replaceAll(Constants.NEWLINE,Constants.HASHTAGS);
       System.Debug('MatchStringwithoutNewLine - '+MatchStringwithoutNewLine); 
       //*********************************
                      
       // String MatchStringwithoutNewLine = outputParamMap.get(Constants.APEXBODY).replaceAll(Constants.NEWLINE,Constants.HASHTAGS);        
        String patternString = outputParamMap.get(Constants.LOOPTYPE);
        System.Debug('patternString - '+patternString); 
        
        Pattern MyPattern = Pattern.compile(patternString);
        System.Debug('MyPattern - '+MyPattern); 
        
        Matcher MyMatcher = MyPattern.matcher(MatchStringwithoutNewLine);
        System.Debug('MyMatcher - '+MyMatcher);
        
        if(MyMatcher.find()) {
            String Tempbody = MatchStringwithoutNewLine.replace(MyMatcher.group(1),Constants.SPACE); //get the code block preceding the loop for/while
            System.Debug('Tempbody - '+Tempbody);
            String Afterwhile = MyMatcher.group(1); //get the code block after the loop for/while
            System.Debug('Afterwhile - '+Afterwhile);            
            List<String> whileState = Afterwhile.split(Constants.SPACE); //splits the code block into single characters list  
            System.Debug('whileState - '+whileState);      
            boolean flag = false;
            boolean whileloopflag = true;
            Integer count = 0;
            Integer forloopcount = 0;
            String whilestatement='';
            
            Pattern pattern1 = Pattern.compile('\\{([^}]+)\\}');
			Matcher matcher = pattern1.matcher(Afterwhile);
			String selectString = '';
            if (matcher.find())
			{
			    selectString = matcher.group(1);
			}
            
            /*        
            //Track of the brackets of the loop
            for(String temp: whileState){ 
            	System.Debug('temp - '+temp);               
                //forloopcount++;
                System.Debug('forloopcount - '+forloopcount);
                
                if(whileloopflag == false){
                    break;
                }
                if(temp.equals(Constants.OpeningBracket) && count != 0){                // Check for brackets between the start & end of while loop
                    count++;
                }
                if(temp.equals(Constants.OpeningBracket) && flag==false){                // Track for starting brackets
                    flag=true;
                    count++;
                }
                if(temp.equals(Constants.ClosingBracket)){                               // Track of end brackets & reduce the count
                    count--;
                }
                if(count==0 && flag==true){                        //count==0 and flag = true implies the while loop is completed
                    whileloopflag=false;
                }                
                whilestatement = whilestatement + temp;    //loop block
                //system.debug('whilestatement>>'+whilestatement);
            }
            system.debug('whilestatement>>'+whilestatement);
            system.debug('forloopcount>>'+forloopcount);  
            system.debug('whileState>>'+whileState.size()); 
            */
                
            String remainingString = '';           
            for(Integer i = 0; i < whileState.size() ; i++){ //Code Change by Nitin
            	system.debug('remainingString>>'+remainingString); 
            	system.debug('whileState[i]>>'+whileState[i]); 
                remainingString = remainingString + whileState[i];  //code block after the loop which will be passed for next iteration of search
            }
            system.debug('remainingString>>'+remainingString);
            if(LinecountforRule3==0){ 
                System.debug('if 0 Earlier LinecountforRule3 - ' + LinecountforRule3 );     
                System.debug('	 ' + getCount(Constants.HASHTAGS, Tempbody) );   
                LinecountforRule3 = getCount(Constants.HASHTAGS,Tempbody)-1;  //count number of the lines before the loop start
                System.debug('Later LinecountforRule3 - ' + LinecountforRule3 );              
            }else{
                System.debug('else Earlier LinecountforRule3 - ' + LinecountforRule3 );
                System.debug('Tempbody hastag count - ' + getCount(Constants.HASHTAGS, Tempbody) );             
                //LinecountforRule3 = LinecountforRule3 + getCount(Constants.HASHTAGS, Tempbody) + getCount(Constants.HASHTAGS, whilestatement)-1;          // get the count of codelines after the for/while loop
                LinecountforRule3 = LinecountforRule3 + getCount(Constants.HASHTAGS, Tempbody) -1;          // get the count of codelines after the for/while loop
                System.debug('Later LinecountforRule3 - ' + LinecountforRule3 );
            }
            
            //Search for Select statement within the loop code block
            matchingSelectPattern = Constants.SelectPattern1;
            
            system.debug('Constants.SelectPattern1>>>>>>>'+Constants.SelectPattern1);
            system.debug('whilestatement>>>>>>>'+whilestatement);
            
            //It will Skip the first line of for loop for checking SELECT pattern
            //String whileStatementAfrLeavingFstLine = whilestatement.substringAfter('##');
            String whileStatementAfrLeavingFstLine = selectString.substringAfter('##');
            
            Boolean patternMatch1 = PatternMatching(Constants.SelectPattern1, whileStatementAfrLeavingFstLine);
            if(patternMatch1 == false){
                matchingSelectPattern = Constants.SelectPattern2;
                patternMatch1 = PatternMatching(Constants.SelectPattern2, whileStatementAfrLeavingFstLine);
            }
            if(patternMatch1 == true) {
                Boolean selectPatternFound = false;
                List<string> lines = whileStatementAfrLeavingFstLine.split(Constants.HASHTAGS); 
                Integer linecount = 0;
                for(String line : lines)
                {                     
                    System.debug('Inside loop line - '+line);
                    selectPatternFound = PatternMatching(matchingSelectPattern,line);  
                    if(selectPatternFound) 
                    {                       
                        if(outputParamMap.get(Constants.LOOPTYPE) == Constants.FORPATTERN) {
                        insertData.put(Constants.PROBLEMSTATEMENT,Constants.SOQLINFOR);
                        System.debug('methodStartLineNumber - '+ methodStartLineNumber);
                        System.debug('LinecountforRule3 - '+ LinecountforRule3);
                        System.debug('linecount - '+ linecount);
                        System.debug('CheckQueryInLoop > ForPattern Line# - '+String.valueOf(methodStartLineNumber+LinecountforRule3+linecount));
                        insertData.put(Constants.LINENUM, String.valueOf(methodStartLineNumber+LinecountforRule3+linecount + 1)); //+1 added for the first line skipped for FOR loop (above)
            
                        AddObjectClassesParse(insertData);
                        }
                    if(outputParamMap.get(Constants.LOOPTYPE) == Constants.WHILEPATTERN) {
                        insertData.put(Constants.PROBLEMSTATEMENT,Constants.SOQLINWHILE);                        
                        insertData.put(Constants.LINENUM, String.valueOf(methodStartLineNumber+LinecountforRule3+linecount + 1 ));  //+1 added for the first line skipped for FOR loop (above)
                        AddObjectClassesParse(insertData);                      
                        }                       
                    }
                    linecount++;
                }
              //LinecountforRule3 = LinecountforRule3 + linecount - 1;  // Code Commented by Nitin
              LinecountforRule3 = LinecountforRule3; // New Code added by Nitin
            }
            if(remainingString != null){
                  insertData.put(Constants.APEXBODY,remainingString);
                  checkQueryInLoop(insertData);                         //Repeat the same code for the remaining code after while/for loop
            }
        }
        }catch(Exception e){
        System.debug('Inside Exception checkQueryInLoop - \n'+ e.getMessage());
        insertData.put(Constants.APEXBODY,outputParamMap.get(Constants.APEXBODY));
        insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));                  //ClassName
        insertData.put(Constants.RULERESULT,e.getMessage());                                        //Fail
        insertData.put(Constants.SEVERITY,Constants.MAJOR);
        insertData.put(Constants.LOOPTYPE,outputParamMap.get(Constants.LOOPTYPE));
        insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
        insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
        insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
        insertData.put(Constants.PROBLEMSTATEMENT,'SOQL in loop');
        insertData.put(Constants.LINENUM,String.valueOf(e.getLineNumber()));
        insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
        AddObjectClassesParse(insertData);
        
        }
    }      
    
    //checking with ApexPages.currentPage().getParameters().get();
    /**
     * Author       -   Varuna Nikam
     * @date        -   18/6/2015
     * @description -   this method is used to check Reflected XSS in Apex classes
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
    public static void checkReflectedXSSInClass(Map<String, String> outputParamMap) {
        Map<String, String> insertData = new Map<String, String>();
        integer LineNum=1; 
        try{
       // throw new MyException('Exception in rule 4');
       
         String codeWithoutComments = RemoveCodeComments(outputMap.get(Constants.APEXBODY));
         List<String> BodyLine= codeWithoutComments.split(Constants.NEWLINE);
         //**********************************************
       // List<String> BodyLine= outputParamMap.get(Constants.APEXBODY).split(Constants.NEWLINE);
        for(String Temp:BodyLine){
            
            if(LineNum <= BodyLine.size()){
                   
                    Boolean result = PatternMatching(Constants.ApexCurrentPattern,Temp);
                               
                    if(result == true){
                          if(PatternMatching(Constants.ApexCurrentPatternSecure,Temp)==true || PatternMatching(Constants.ApexCurrentPatternSecure1,Temp)==true){
                          }else if(PatternMatching(Constants.ApexCurrentPatternNotSecure,Temp)==true){
                          
                                insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));
                                insertData.put(Constants.PROBLEMSTATEMENT,Constants.REFLECTEDXSSCLASS);
                                insertData.put(Constants.SEVERITY,Constants.CRITICAL);
                                insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
                                insertData.put(Constants.LINENUM, String.valueOf(LineNum));
                                insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
                                insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
                                insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
                                insertData.put(Constants.RULERESULT,ruleResult);
                                AddObjectClassesParse(insertData);
                        
                          }  
                    }       
              }
              LineNum++;
        }
        }catch(Exception e){
                                insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));
                                insertData.put(Constants.RULERESULT,e.getMessage());
                                insertData.put(Constants.PROBLEMSTATEMENT,Constants.REFLECTEDXSSCLASS);
                                insertData.put(Constants.SEVERITY,Constants.CRITICAL);
                                insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
                                insertData.put(Constants.LINENUM,String.valueOf(e.getLineNumber()));
                                insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
                                insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
                                insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
                                AddObjectClassesParse(insertData);
        }
   }
   //----------------------------------------------------------
   
    
    /**
     * Author       -   Varuna Nikam
     * @date        -   18/6/2015
     * @description -   checking with dynamic soql query
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
    public static void checkSOQLSOSLInjection(Map<String, String> outputParamMap) {
        Map<String, String> insertData = new Map<String, String>();
        integer count=1;
        integer LineNum=0; 
        String startLineNumber = outputParamMap.get(Constants.STARTLINENUMBER);
        Integer methodStartLineNumber = 0;
        if(String.isNOTBlank(startLineNumber))
        {
          methodStartLineNumber = Integer.ValueOf(startLineNumber);
        }
        System.debug('checkSOQLSOSLInjection > methodStartLineNumber - '+methodStartLineNumber);
        List<String> methodName;
        try{
        
        
         String codeWithoutComments = RemoveCodeComments(outputParamMap.get(Constants.APEXBODY));
          methodName = codeWithoutComments.split('\n');
          List<String> BodyLine= codeWithoutComments.split(Constants.SEMICOLON);
        //****************
          //  methodName = outputParamMap.get(Constants.APEXBODY).split('\n');
      
       // List<String> BodyLine= outputParamMap.get(Constants.APEXBODY).split(Constants.SEMICOLON);
        for(String Temp:BodyLine){
           
            if(count == 1){
                LineNum = LineNum + getCount(Constants.NEWLINE,Temp);  
            }else{
                LineNum = LineNum + getCount(Constants.NEWLINE,Temp) - 1; 
            }
            System.debug('Intermediate LineNumber - '+LineNum);
            Boolean dynamicQueryResult = (PatternMatching('\\\'[S|s][E|e][L|l][E|e][C|c][T|t].*',Temp) || PatternMatching('\\[[S|s][E|e][L|l][E|e][C|c][T|t].*',Temp)||(PatternMatching('\\[[F|f][I|i][N|n][D|d].*',Temp)==true)||(PatternMatching('\\\'[F|f][I|i][N|n][D|d].*',Temp)==true));    
            
            if(dynamicQueryResult == true){
                List<String>insideBodyLine = Temp.split('\\+'); //get variables from soql string
                if(insideBodyLine !=null && insideBodyLine.size()>1){
                
                integer i = 1;
                do{
                                    
                    if((PatternMatching('[S|s][T|t][R|r][I|i][N|n][G|g]\\.[E|e][S|s][C|c][A|a][P|p][E|e][S|s][I|i][N|n][G|g][L|l][E|e][Q|q][U|u][O|o][T|t][E|e][S|s]\\(.+\\)',insideBodyLine[i])==true)||(PatternMatching('.*[A-Za-z.]+\\(.+\\).*',insideBodyLine[i])==true)){
                    }else{
                    
                    
                     List<String>bodyAboveSOQL = codeWithoutComments.split(Constants.NEWLINE);//check variable in above code
                    //************************
                      //List<String>bodyAboveSOQL = outputParamMap.get(Constants.APEXBODY).split(Constants.NEWLINE);//check variable in above code
                        
                        
                        String varFromQuery = insideBodyLine[i];
                        Boolean flag = false;
                        for(integer j=LineNum-1;j>=1;j--){
                            Boolean result = PatternMatching('.*'+varFromQuery +'='+'.*',bodyAboveSOQL[j]);
                            if(result == true){
                                if((PatternMatching('.*'+varFromQuery +'='+'.*[S|s][T|t][R|r][I|i][N|n][G|g]\\.[E|e][S|s][C|c][A|a][P|p][E|e][S|s][I|i][N|n][G|g][L|l][E|e][Q|q][U|u][O|o][T|t][E|e][S|s]\\(.+\\).*',bodyAboveSOQL[j])==true)||(PatternMatching('.*'+varFromQuery +'='+'.*[A-Za-z.]+\\(.+\\).*',bodyAboveSOQL[j])==true)){
                                    flag = true;
                                    break;
                                }
                            }
                        }
                        if(flag == false){
                            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),ruleResult,'SOQL SOSL Injection',Constants.MAJOR,outputParamMap.get(Constants.APEXID),String.valueOf(methodStartLineNumber+LineNum-1),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
                           }
                    }
                    i = i + 2;
                }while(insideBodyLine.size()>i);
               } 
            }
            
            count++;
        }
        }catch(Exception e){
            System.debug('Inside checkSOQLSOSLInjection exception - \n'+ e.getMessage());
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),'SOQL SOSL Injection',Constants.MAJOR,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
        }
   }
   //------------------------------------------------------------------ 
       /**
     * Author       -   Nitin Kapoor
     * @date        -   03/03/2017
     * @description -   this method is used to get the extra line count
     * @param       -   pattern - pattern to split
     *                  str - string to split
     * @return      -   count - number of extra lines count
     * @modifiedby  -
     */
   
     public static integer getExtraLinesCount(String pattern, String strToCountExtLines, String identifier){
        List<String> splitStr;
        Map<String,integer> linesCountMap = new Map<String,integer>();
        Integer count=0;
        Integer extraLineToDelete = 0;
        Integer splitStrSize;
        String tempStr;
         
        system.debug('strToCountExtLines: ' + strToCountExtLines);
        
        try{
            
            splitStr = strToCountExtLines.split(pattern);
            system.debug('splitStr: '+ splitStr.size() + ' strToCountExtLines After Split: ' + splitStr);
             if(splitStr.size() >= 1){
            	splitStrSize = splitStr.size() - 1;
            	for(String eachLine : splitStr){
	                linesCountMap.put(eachLine,count);
	                count++;
            	}
            }
            
            system.debug('linesCountMap: ' + linesCountMap);
            
            for(String temp: linesCountMap.keyset()){
                if(String.isNotBlank(temp) && temp != null ){
                    tempStr = temp;
                    Temp = Temp.remove(Constants.NEWLINE);
                    Temp = Temp.trim();
                    Temp = Temp.replaceAll(Constants.SpacePattern,'#');
                    Temp = Temp.remove('#');
                    
                    system.debug('Is String-- ' + Temp + ' --Blank-- '+ String.isNotBlank(Temp));
                    
					if(identifier == 'Test Class Method'){
						if(PatternMatching(Constants.TestMethodPattern,Temp)|| PatternMatching(Constants.TestMethodPattern2,Temp)== true){ //method level checking
							extraLineToDelete = splitStrSize - Integer.valueof(linesCountMap.get(tempStr));
							break;
						}
					}else if(identifier == 'Class Method'){
						if(PatternMatching(Constants.ClassMethodPatternPublic,Temp)==true || PatternMatching(Constants.ClassMethodPatternPrivate,Temp)==true || PatternMatching(Constants.ClassMethodPatternProtected,Temp)==true||PatternMatching(Constants.ClassMethodPatternGlobal,Temp)==true||PatternMatching(Constants.ClassMethodPatternFinal,Temp)==true ||PatternMatching(Constants.ClassMethodPatternWebservice,Temp)==true){ //method level checking
                            extraLineToDelete = splitStrSize - Integer.valueof(linesCountMap.get(tempStr));
							break;
						}
                    }
                }
            }
        }catch(Exception e){
            system.debug('Failed to get Extra line count: ' + e.getMessage());
        }
        system.debug('extraLineToDelete: ' + extraLineToDelete);
        return extraLineToDelete;
    }
   
      
   /**
     * Author       -   Varuna Nikam
     * @date        -   22/6/2015
     * @description -   checking with class and method level comments
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
    public static void checkClassMethodLevelComments(Map<String, String> outputParamMap) {
    	
        Map<String, String> insertData = new Map<String, String>();
        integer count=1;
        integer LineNum=0; 
        String tempForExtraLineCount;
        try{
       // throw new MyException('Exception in rule 7');
        insertData.put(Constants.APEXBODY,outputParamMap.get(Constants.APEXBODY));
        insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME)); //ClassName
                   
        insertData.put(Constants.SEVERITY,Constants.MINOR);
        insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
        insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
        insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
        insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
        insertData.put(Constants.RULERESULT,ruleResult);
        system.debug('ApexBody----- ' + outputParamMap.get(Constants.APEXBODY));
        
        // Code added by Nitish to resolve 'Regex too complicated' issue if class has large number of commented codes , we will replace those lines by new line character
        //String classBody = RemoveCodeComments(outputParamMap.get(Constants.APEXBODY));
        //system.debug('classBody----- ' + classBody);
        
        List<String> BodyLine= outputParamMap.get(Constants.APEXBODY).split(Constants.SEMICOLON);
        
        //List<String> BodyLine= classBody.split(Constants.SEMICOLON);
        //System.Debug('BodyLine - '+BodyLine); 
        //checking for class or test class
        if(PatternMatching(Constants.TestAnnotation,outputParamMap.get(Constants.APEXBODY))==true){      //check for test class
             for(String Temp:BodyLine){
             if(count==1){
                LineNum=LineNum+getCount(Constants.NEWLINE,Temp);  
              }else{
                  LineNum=LineNum+getCount(Constants.NEWLINE,Temp)-1; 
              }
              tempForExtraLineCount =  Temp;
			  system.debug('LineNum: '+ LineNum);
              system.Debug('TempTest - '+ Temp);
			  
              Temp = Temp.remove(Constants.NEWLINE);
              Temp = Temp.trim();
              Temp = Temp.replaceAll(Constants.SpacePattern,'#');
              Temp = Temp.remove('#');
			  if(Temp.length() > 1000)
            {
               Temp = Temp.substring(0,999); 
            }
			  System.Debug('TempTest After Trimming - '+ Temp);
		
             if(PatternMatching(Constants.TestClassPattern,Temp)== true){  //check comments at class level
                if(PatternMatching(Constants.TestClassCommentPattern,Temp)== true){
                }else{
                    insertData.put(Constants.LINENUM, String.valueOf(2));
                    insertData.put(Constants.PROBLEMSTATEMENT,Constants.CLASSCOMMENTS); 
                    AddObjectClassesParse(insertData);
                }
             }
             if(PatternMatching(Constants.TestMethodPattern,Temp)|| PatternMatching(Constants.TestMethodPattern2,Temp)== true){  //check comments at method level
				if(PatternMatching(Constants.TestMethodCommentPattern,Temp)|| PatternMatching(Constants.TestMethodCommentPattern2,Temp)== true){
                }else{
                    insertData.put(Constants.LINENUM, String.valueOf(LineNum - getExtraLinesCount(Constants.NEWLINE,tempForExtraLineCount,'Test Class Method')));
                    insertData.put(Constants.PROBLEMSTATEMENT,Constants.METHODCOMMENTS);    
                    AddObjectClassesParse(insertData);
                }
             }
             
             count ++;
            }//for loop ends here
            
        }else{
        for(String Temp:BodyLine){                                          //check for class
              if(count==1){
                LineNum=LineNum+getCount(Constants.NEWLINE,Temp); 
              }else{
                LineNum=LineNum+getCount(Constants.NEWLINE,Temp)-1; 
              }
              
            tempForExtraLineCount =  Temp;
            
            system.debug('LineNum: '+ LineNum);
            System.Debug('Temp - '+ Temp);
            
            Temp = Temp.remove(Constants.NEWLINE);
            Temp = Temp.trim();
            Temp = Temp.replaceAll(Constants.SpacePattern,'#');
            Temp = Temp.remove('#');
            if(Temp.length() > 1000)
            {
               Temp = Temp.substring(0,999); 
            }
            System.Debug('Temp After Trimming - '+ Temp);
           
            if(PatternMatching(Constants.ClassPatternPublic,Temp)==true || PatternMatching(Constants.ClassPatternPrivate,Temp)==true || PatternMatching(Constants.ClassPatternProtected,Temp)==true || PatternMatching(Constants.ClassPatternGlobal,Temp)==true ||PatternMatching(Constants.ClassPatternFinal,Temp)==true){ //class level checking
                        if(PatternMatching(Constants.ClassCommentPattern,Temp)==true || PatternMatching(Constants.ClassCommentPattern1,Temp)==true){
						}else{
                            insertData.put(Constants.LINENUM, String.valueOf(1));
                            insertData.put(Constants.PROBLEMSTATEMENT,Constants.CLASSCOMMENTS); 
                            AddObjectClassesParse(insertData);
                        }
            }
            if(PatternMatching(Constants.ClassMethodPatternPublic,Temp)==true || PatternMatching(Constants.ClassMethodPatternPrivate,Temp)==true || PatternMatching(Constants.ClassMethodPatternProtected,Temp)==true||PatternMatching(Constants.ClassMethodPatternGlobal,Temp)==true||PatternMatching(Constants.ClassMethodPatternFinal,Temp)==true ||PatternMatching(Constants.ClassMethodPatternWebservice,Temp)==true){ //method level checking
                        if(PatternMatching(Constants.ClassMethodCommentPattern,Temp)==true||PatternMatching(Constants.ClassMethodCommentPattern1,Temp)==true){
                        }else {
                            insertData.put(Constants.LINENUM, String.valueOf(LineNum - getExtraLinesCount(Constants.NEWLINE,tempForExtraLineCount,'Class Method')));
                            insertData.put(Constants.PROBLEMSTATEMENT,Constants.METHODCOMMENTS);    
                            AddObjectClassesParse(insertData);
                        }
            
            }
         
            count++;
        }//end for loop
        }
        }catch(Exception e){  
        	system.debug('Exception Occured: '+ e.getMessage());                    
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),'Class / method level comments',Constants.MINOR,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
        
        }
   }
   //------------------------------------
   
    /**
     * Author       -   Varuna Nikam
     * @date        -   24/6/2015
     * @description -   check debug statements in classes
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
    public static void checkDebugStatements(Map<String, String> outputParamMap) {
        Map<String, String> insertData = new Map<String, String>();
        integer count=1;
        integer LineNum=0;
        try{
        //  throw new MyException('Exception in rule 8');
        insertData.put(Constants.APEXBODY,outputParamMap.get(Constants.APEXBODY));
        insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));  //ClassName
        insertData.put(Constants.SEVERITY,Constants.MINOR);
        insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
        insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
        insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
        insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
        insertData.put(Constants.RULERESULT,ruleResult); 
        System.Debug('outputParamMap.get(Constants.APEXBODY) -'+outputParamMap.get(Constants.APEXBODY));
        
        String codeWithoutComments = RemoveCodeComments(outputParamMap.get(Constants.APEXBODY));
        System.debug('codeWithoutComments output -' +codeWithoutComments);
        List<String> BodyLine= codeWithoutComments.split(Constants.SEMICOLON);
        //*****************************
        System.Debug('BodyLine.size() - '+BodyLine.size());
        for(String Temp:BodyLine){
           
            if(count==1){
                LineNum=LineNum+getCount(Constants.NEWLINE,Temp);  
              }else{
                  LineNum=LineNum+getCount(Constants.NEWLINE,Temp)-1;  
              }
            Boolean debugResult =PatternMatching(Constants.DebugPattern,Temp);   
            
            if(debugResult == true){
                System.Debug('String.valueOf(LineNum) - '+String.valueOf(LineNum));
                insertData.put(Constants.LINENUM, String.valueOf(LineNum));
                insertData.put(Constants.PROBLEMSTATEMENT,Constants.DEBUGSTATEMENT);    
                AddObjectClassesParse(insertData);
               
            }
            
            count++;
        }
        }catch(Exception e){             
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),Constants.DEBUGSTATEMENT,Constants.MINOR,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
                
        }
   }
   
    //------------------------------------
   
    /**
     * Author       -   Alok Kumar
     * @date        -   13/6/2016
     * @description -   Replace comment pharases with ' \n'
     * @param       -   Code with comments removed
     * @return      -   String
     * @modifiedby  -
     */
    public static String RemoveCodeComments(String CodeWithComments) {
        try{
            CodeWithComments = ConvertBlockToSingleLineComments(CodeWithComments);
            System.Debug('CodeWithComments - \n'+CodeWithComments);
            string regex = '\\/\\/(.*)\n'; //regular expression to identify Comment lines
            Pattern patternToSearch = Pattern.Compile(regex);
            Matcher myMatcher = patternToSearch.Matcher(CodeWithComments);
            String updatedString = myMatcher.ReplaceAll(' \n');
            System.Debug('Code Without Comments : \n' + updatedString);
            return updatedString ;
        }
        catch(Exception e){             
            System.Debug('Error in Removing Comment lines. Details - '+e.getMessage());
            return null;    
        }
   }
   //-----------------------------------------------------
   
    /**
     * Author       -   Alok Kumar
     * Edit By      -   Rutvij Pathak
     * @date        -   13/6/2016
     * @description -   Convert the Comment block into Single Line Comments
     * @param       -   Code having multiple comment blocks
     * @return      -   String
     * @modifiedby  -
     */
    public static String ConvertBlockToSingleLineComments(String codeWithCommentBlocks) {
           system.debug('codeWithCommentBlocks>>>>'+codeWithCommentBlocks);
        try{
            string commentBlockRegex = '\\/\\*[\\s\\S]*?\\*\\/';//(/\\*([^*]|[\r\n]|(\\*+([^*/]|[\r\n])))*\\*+/)';
            Pattern commentBlockPattern = Pattern.Compile(commentBlockRegex);
            system.debug('Pattern Found>>>>'+commentBlockPattern);
            Matcher commentBlockMatcher = commentBlockPattern.Matcher(codeWithCommentBlocks);
            system.debug('commentBlockMatcher>>>>'+commentBlockMatcher);
            system.debug('commentBlockMatcher>>>>'+commentBlockMatcher.groupCount());
            integer regionstart = commentBlockMatcher.regionStart();
            integer regionend = commentBlockMatcher.regionEnd();
            string matchReplaceOutputString = codeWithCommentBlocks; //default initial value
                system.debug('matchReplaceOutputString>>>>'+matchReplaceOutputString);
            string strToReplace = '';
            integer strToReplaceLength = 0;
            integer iCount = 0;
            while(commentBlockMatcher.Find())
            {
               	++iCount;
                strToReplace = commentBlockMatcher.group().replace('\n','\n //').replace('/*','// ').replace('*/','').replace('*','');
                system.debug('strToReplace>>>>'+strToReplace);
                
                strToReplaceLength = strToReplace.Length();    
                system.debug('strToReplaceLength>>>>'+strToReplaceLength);
                
                matchReplaceOutputString = commentBlockMatcher.replaceFirst(strToReplace); 
                system.debug('matchReplaceOutputString>>>>'+matchReplaceOutputString); 
                
                regionstart = regionstart + strToReplaceLength;
                system.debug('regionstart>>>>'+regionstart);
                commentBlockMatcher.reset(matchReplaceOutputString);
                regionend = commentBlockMatcher.regionEnd(); 
                system.debug('regionend>>>>'+regionend);    
                //commentBlockMatcher.Region(regionstart,regionend);
                commentBlockMatcher.Region(regionstart,regionend);
            }
            system.debug('Loop executed ## ' + iCount);
            System.Debug('Code Without Comment Blocks : \n' + matchReplaceOutputString);
            system.debug('matchReplaceOutputString>>>>'+matchReplaceOutputString);
            return matchReplaceOutputString ;
        }
        catch(Exception e){             
            System.Debug('Error in Converting Comment blocks to Comment lines. Details - '+e.getMessage());
            return null;    
        }
   }
    
   
   //------------------------------------
   
    /**
     * Author       -   Alok Kumar
     * @date        -   13/6/2016
     * @description -   Replace comment pharases with ' \n'
     * @param       -   Page Code with comments removed
     * @return      -   String
     * @modifiedby  -
     */
    public static String RemovePageCodeComments(String CodeWithComments) {
        try{
            CodeWithComments = ConvertPageBlockToSingleLineComments(CodeWithComments);
            
            string regex = '\\/\\/(.*)\n'; //regular expression to identify Comment lines
            Pattern patternToSearch = Pattern.Compile(regex);
            Matcher myMatcher = patternToSearch.Matcher(CodeWithComments);
            String updatedString = myMatcher.ReplaceAll(' \n');
            //System.Debug('Code Without Comments : \n' + updatedString);
            return updatedString ;
        }
        catch(Exception e){             
            System.Debug('Error in Removing Comment lines');
            return null;    
        }
   }
   //-----------------------------------------------------
   
    /**
     * Author       -   Alok Kumar
     * @date        -   13/6/2016
     * @description -   Convert the Page Comment block into Single Line Comments
     * @param       -   Code having multiple comment blocks
     * @return      -   String
     * @modifiedby  -
     */
    public static String ConvertPageBlockToSingleLineComments(String codeWithCommentBlocks) {
        try{
            //string commentBlockRegex = '<!--(.|[\n])*?-->'; //regular expression to identify Page Comment blocks
            string commentBlockRegex = '\\/\\*(.|\\n)*?\\*\\/';
            Pattern commentBlockPattern = Pattern.Compile(commentBlockRegex);
            Matcher commentBlockMatcher = commentBlockPattern.Matcher(codeWithCommentBlocks);
            integer regionstart = commentBlockMatcher.regionStart();
            integer regionend = commentBlockMatcher.regionEnd();
            string matchReplaceOutputString = codeWithCommentBlocks; //default initial value
            string strToReplace = '';
            integer strToReplaceLength = 0;
            while(commentBlockMatcher.Find())
            {
                strToReplace = commentBlockMatcher.group().replace('$','\\$').replace('\n','\n //').replace('<!--','//').replace('-->','').replace('--','');
                strToReplaceLength = strToReplace.Length();             
                matchReplaceOutputString = commentBlockMatcher.replaceFirst(strToReplace);              
                regionstart = regionstart + strToReplaceLength;
                commentBlockMatcher.reset(matchReplaceOutputString);
                regionend = commentBlockMatcher.regionEnd(); 
                commentBlockMatcher.Region(regionstart,regionend);
            }
            //System.Debug('Code Without Comment Blocks : \n' + matchReplaceOutputString);
            return matchReplaceOutputString ;
        }
        catch(Exception e){             
            System.Debug('Error in Converting Comment blocks to Comment lines');
            return null;    
        }
   }
      
   //-----------------------------------------------------
   
   /**
     * Author       -   Varuna Nikam
     * @date        -   27/6/2015
     * @description -   check constants in classes
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
   
    public static void checkConstants(Map<String, String> outputParamMap) {
        Map<String, String> insertData = new Map<String, String>();
        integer count=1;
        integer LineNum=0; 
        try{
        //  throw new MyException('Exception in rule 9');
        insertData.put(Constants.APEXBODY,outputParamMap.get(Constants.APEXBODY));
        insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));                      //ClassName
        insertData.put(Constants.SEVERITY,Constants.MINOR);
        insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
        insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
        insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
        insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
        insertData.put(Constants.RULERESULT,ruleResult);
        
         String codeWithoutComments = RemoveCodeComments(outputParamMap.get(Constants.APEXBODY));
          List<String> BodyLine= codeWithoutComments.split(Constants.NEWLINE);
        //*********************************
       //List<String> BodyLine= outputParamMap.get(Constants.APEXBODY).split(Constants.NEWLINE);
       
             for(String Temp:BodyLine){
                LineNum=LineNum+getCount(Constants.NEWLINE,Temp);  
              
                    if(PatternMatching(Constants.DebugPattern,Temp)==false){
                            if(PatternMatching(Constants.ConstantPattern,Temp)==true){
                            insertData.put(Constants.LINENUM, String.valueOf(LineNum));
                            insertData.put(Constants.PROBLEMSTATEMENT,Constants.CONSTANT);  
                            AddObjectClassesParse(insertData);
                            
                            }
                    }   
              
             count ++;
            }//for loop ends here
        }catch(Exception e){                           
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),Constants.CONSTANT,Constants.MINOR,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
                            
        }
            
        }
        //---------------------------------
        
     /**
     * Author       -   Varuna Nikam
     * @date        -   29/6/2015
     * @description -   checking assert in each method in test classes
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
    public static void checkAssertStatements(Map<String, String> outputParamMap) {
        Map<String, String> insertData = new Map<String, String>();
        integer count=1;
        integer LineNum=0;
        integer lineCountOfTemp =0; 
        try{
        //throw new MyException('Exception in rule 10');
        insertData.put(Constants.APEXBODY,outputParamMap.get(Constants.APEXBODY));
        insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));                      //ClassName
        insertData.put(Constants.SEVERITY,Constants.MINOR);
        insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
        insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
        insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
        insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
        insertData.put(Constants.RULERESULT,ruleResult);
        
        String codeWithoutComments = RemoveCodeComments(outputParamMap.get(Constants.APEXBODY));
        //************************
        //*********replaced all [outputParamMap.get(Constants.APEXBODY)] with codeWithoutComments
        List<String> BodyLine;
        
        if(PatternMatching(Constants.TestMethodPatternForAssert,codeWithoutComments)==true){
           
             BodyLine= codeWithoutComments.split(Constants.TestMethodPatternForAssert);
           
            
        }else {
          
             BodyLine= codeWithoutComments.split(Constants.TestAnnotation);
        }
        
        for(String Temp:BodyLine){
                if(count==1){
                LineNum=LineNum+getCount(Constants.NEWLINE,Temp);  
              }else{
                  LineNum=LineNum+getCount(Constants.NEWLINE,Temp)-1;  
              }
              List<String>lineCountList = Temp.split(Constants.NEWLINE);  //get line number
              lineCountOfTemp = lineCountList.size();
              if(BodyLine[0]!=Temp){
                    Boolean assertResult =PatternMatching(Constants.AssertPattern,Temp);   
            
                    if(assertResult == false){
                                
                    insertData.put(Constants.LINENUM, String.valueOf(LineNum - (lineCountOfTemp-1)));
                    insertData.put(Constants.PROBLEMSTATEMENT,Constants.ASSERTSTATE);   
                    AddObjectClassesParse(insertData);
                    }else{
                    }
             }
            count++;
        }
        }catch(Exception e){                   
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),Constants.ASSERTSTATE,Constants.MINOR,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
        }
   }
  //---------------------------------------------------------------   
  
     /**
     * Author       -   Varuna Nikam
     * @date        -   1/7/2015
     * @description -   checking try catch in each method in classes
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
   public static void checkTryCatch(Map<String, String> outputParamMap) {
        Map<String, String> insertData = new Map<String, String>();
        integer LineNum=1; 
        String str;
        integer insideLinesNum =0;
        List<String> methodName;
        Integer methodStartLineNumber = 0;
        String startLineNumber = outputParamMap.get(Constants.STARTLINENUMBER);
        if(String.isNOTBlank(startLineNumber))
        {
          methodStartLineNumber = Integer.ValueOf(startLineNumber);
        }
       
        try{
             methodName = outputParamMap.get(Constants.APEXBODY).split('\n');
            //  throw new MyException('Exception in rule 11');
            insertData.put(Constants.APEXBODY,outputParamMap.get(Constants.APEXBODY));
            insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));                      //ClassName
            insertData.put(Constants.SEVERITY,Constants.MAJOR);
            insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
            insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
            insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
            insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
            insertData.put(Constants.RULERESULT,ruleResult);
            
            System.Debug('-----Inside Rule11----');
            System.Debug('outputParamMap.get(Constants.APEXBODY) :\n'+outputParamMap.get(Constants.APEXBODY));
            String codeWithoutComments = RemoveCodeComments(outputParamMap.get(Constants.APEXBODY));
             String body = codeWithoutComments +'\n'+'$';
            //***************************
          //String body = outputParamMap.get(Constants.APEXBODY) +'\n'+'$';
            List<String> BodyLine= body.split('\n');

            for(String Temp:BodyLine){                      
                Temp = Temp.trim();
                Temp = Temp.replaceAll(Constants.SpacePattern,'#');
                Temp = Temp.remove('#');
                Boolean flagMethod = (PatternMatching(Constants.ClassMethodPatternPublic,Temp) || PatternMatching(Constants.ClassMethodPatternPrivate,Temp) || PatternMatching(Constants.ClassMethodPatternProtected,Temp)||PatternMatching(Constants.ClassMethodPatternGlobal,Temp)||PatternMatching(Constants.ClassMethodPatternFinal,Temp));
                Boolean flagClass = (patternMatching(Constants.ClassPatternPublic,Temp)||patternMatching(Constants.ClassPatternPrivate,Temp)||patternMatching(Constants.ClassPatternProtected,Temp)||patternMatching(Constants.ClassPatternGlobal,Temp)||patternMatching(Constants.ClassPatternFinal,Temp));

                //create string if method lines
                if((flagMethod==true || flagClass==true || Temp == '$') && str !=null){
                 
                 if(PatternMatching(Constants.ClassMethodPatternPublic,str)==true || PatternMatching(Constants.ClassMethodPatternPrivate,str)==true || PatternMatching(Constants.ClassMethodPatternProtected,str)==true||PatternMatching(Constants.ClassMethodPatternGlobal,str)==true||PatternMatching(Constants.ClassMethodPatternFinal,str)==true){
                    if(PatternMatching(Constants.TryCatchPattern,str)==true){
                    	if(PatternMatching(Constants.EmptyTryCatchPattern,str)==true){
                    		insertData.put(Constants.LINENUM, String.valueOf(methodStartLineNumber+LineNum-insideLinesNum-1));
	                        insertData.put(Constants.PROBLEMSTATEMENT,Constants.TRYCATCHSTATE); 
	                        AddObjectClassesParse(insertData);
                    	}
                    }else {
                        
                    }
                    
                }
                    flagMethod =false;
                    flagClass = false;
                    str = null;
                    insideLinesNum =0;
                }


                if(flagMethod == false || flagClass == false){
                    str=str+Temp;
                    insideLinesNum ++;
                }
                LineNum ++;
            }        
        }catch(Exception e){                           
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),Constants.TRYCATCHSTATE,Constants.MAJOR,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
        }
    } 
        
        
        /**
     * Author       -   Varuna Nikam
     * @date        -   3/7/2015
     * @description -   checking object cretion inside loop in classes
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
        
    public static void checkObjectInstInLoop(Map<String, String> outputParamMap){
        Map<String, String> insertData = new Map<String, String>();
        List<String> methodName;
        try{
            
            //  throw new MyException('Exception in rule 12');
            insertData.put(Constants.APEXBODY,outputParamMap.get(Constants.APEXBODY));
            insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));                      //ClassName
            insertData.put(Constants.SEVERITY,Constants.MAJOR);
            insertData.put(Constants.LOOPTYPE,outputParamMap.get(Constants.LOOPTYPE));
            insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
            insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
            insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
            insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
            insertData.put(Constants.RULERESULT,ruleResult);
            
           String MatchStringwithoutNewLine=outputParamMap.get(Constants.APEXBODY).replaceAll(Constants.NEWLINE,Constants.HASHTAGS);
            String patternString=outputParamMap.get(Constants.LOOPTYPE);
            Pattern MyPattern = Pattern.compile(patternString);
            Matcher MyMatcher=MyPattern.matcher(MatchStringwithoutNewLine);
            
            //system.debug(MyMatcher.find());
            if(MyMatcher.find()) {
                String Tempbody=MatchStringwithoutNewLine.replace(MyMatcher.group(1),Constants.SPACE);
                       
                String Afterwhile=MyMatcher.group(1);         
                List<String> whileState=Afterwhile.split(Constants.SPACE); 
                boolean flag=false;
                boolean whileloopflag=true;
                Integer count=0;
                Integer forloopcount=0;
                String whilestatement;     
                //Track of the brackets 
                for(String temp:whileState){
                    forloopcount++;
                    if(whileloopflag==false){
                        
                        break;
                    }
                    if(temp.equals('{') && count !=0){                // Check for brackets between the start & end of while loop
                        count++;
                    }
                    if(temp.equals('{') && flag==false){                // Track for first bracket after loop
                        flag=true;
                        count++;
                    }
                    if(temp.equals('}')){                               // Track of end brackets & reduce the count
                        count--;
                    }
                    if(count==0 && flag==true){                        //count==0 and flag = true implies the while loop is completed
                        whileloopflag=false;
                    } 
                    whilestatement=whilestatement+temp;    
                }
            
                String remainingString;
                //for(Integer i=forloopcount;i<whileState.size();i++){
                for(Integer i=0;i<whileState.size();i++){
                    remainingString=remainingString+whileState[i];
                }
                
                
                if(LinecountforRule3==0){
                    LinecountforRule3=getCount(Constants.HASHTAGS,Tempbody);                            // get the count of codelines before the for/while loop
                    }else{
                    LinecountforRule3=LinecountforRule3+getCount(Constants.HASHTAGS,Tempbody)+getCount(Constants.HASHTAGS,whilestatement)-1;          // get the count of codelines after the for/while loop
                    }
                if(PatternMatching(Constants.NewPatten,whilestatement)==true || PatternMatching(Constants.NewPatten1,whilestatement)==true) {
                    if(outputParamMap.get(Constants.LOOPTYPE)==Constants.FORPATTERN) {                  
                        insertData.put(Constants.LINENUM, String.valueOf(LinecountforRule3));
                        insertData.put(Constants.PROBLEMSTATEMENT,Constants.OBJECTINSIDEFOR);
                        AddObjectClassesParse(insertData);
                        }
                      if(outputParamMap.get(Constants.LOOPTYPE)==Constants.WHILEPATTERN) {
                        insertData.put(Constants.LINENUM, String.valueOf(LinecountforRule3));
                        insertData.put(Constants.PROBLEMSTATEMENT,Constants.OBJECTINSIDEWHILE);
                        AddObjectClassesParse(insertData);
                        
                        }                  
                }
                if(remainingString!=null){
                    insertData.put(Constants.APEXBODY,remainingString);
                    checkObjectInstInLoop(insertData);       //Repeat the same code for the remaining code after while/for loop
                        
                }
            }
        }catch(Exception e){
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),'Object Creation Inside Loop',Constants.MAJOR,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),outputParamMap.get(Constants.LOOPTYPE)));
        }
    
  }

  //-------------------------------------------------------------------   
        
    /**
     * Author       -   Varuna Nikam
     * @date        -   18/6/2015
     * @description -   checking with apex outputText for Reflected XSS
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
    public static void checkReflectedXSSInPage(Map<String, String> outputParamMap) {
        Map<String, String> insertData = new Map<String, String>();
        Boolean scriptStartFlag = false;
        Boolean scriptEndFlag = false;
        integer LineNum=1; 
        String linesWithinScriptTag;
        String finalString;
        try{
            //  throw new MyException('Exception in rule 4');
            List<String> BodyLine= outputParamMap.get(Constants.APEXBODY).split(Constants.NEWLINE);
            for(String Temp:BodyLine){
                if(LineNum <= BodyLine.size()){
                    Boolean apexOutputTextWithEscape = PatternMatching(Constants.ReflectedXSSForPages,Temp);  
                    if(apexOutputTextWithEscape == true) {
                        if(PatternMatching(Constants.ReflectedXSSForPagesSecure,Temp)==true){    //Match for apex:outputext escape value with function
                        
                        }else if(PatternMatching(Constants.ReflectedXSSForPagesSecure1,Temp)==true){ //Match for apex:outputext value with function escape order
                        
                        }else if((PatternMatching(Constants.ReflectedXSSForPagesNotSecure,Temp)==true)||(PatternMatching(Constants.ReflectedXSSForPagesNotSecure1,Temp)==true)){ // without script function
                            insertData.put(Constants.APEXNAME,outputParamMap.get(Constants.APEXNAME));
                            insertData.put(Constants.PROBLEMSTATEMENT,Constants.REFLECTEDXSSPAGE);
                            insertData.put(Constants.SEVERITY,Constants.CRITICAL);
                            insertData.put(Constants.APEXID,outputParamMap.get(Constants.APEXID));
                            insertData.put(Constants.LINENUM, String.valueOf(LineNum));
                            insertData.put(Constants.CREATEDBYNAME,outputParamMap.get(Constants.CREATEDBYNAME));
                            insertData.put(Constants.MODIFIEDBYNAME,outputParamMap.get(Constants.MODIFIEDBYNAME));
                            insertData.put(Constants.DESCRIPTION,outputParamMap.get(Constants.DESCRIPTION));
                            insertData.put(Constants.RULERESULT,ruleResult);
                            AddObjectClassesParse(insertData);
                        }
                    }
                           
                }
                LineNum++;
            }
        }catch(Exception e){                      
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),Constants.REFLECTEDXSSPAGE,Constants.CRITICAL,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
        }
    }
    
    //--------------------------------------------------------
    
    /**
     * Author       -   Varuna Nikam
     * @date        -   18/6/2015
     * @description -   checking with script tag for Stored XSS
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
    public static void checkStoredXSSScriptTag(Map<String, String> outputParamMap) {
        Map<String, String> insertData = new Map<String, String>();       
        Boolean scriptStartFlag = false;
        Boolean scriptEndFlag = false;
        integer linesNumInScriptTag =0;
        integer LineNum=1; 
        String linesWithinScriptTag;
        String finalString;
        try{
        //  throw new MyException('Exception in rule 5');
    List<String> BodyLine= outputParamMap.get(Constants.APEXBODY).split(Constants.NEWLINE);
   
    for(String Temp:BodyLine){
        if(LineNum <=BodyLine.size()){
               
            Boolean scriptStartInPage = PatternMatching(Constants.ScriptStartPattern,Temp);
            Boolean scriptEndInPage = PatternMatching(Constants.ScriptEndPattern,Temp);
            
            if(scriptStartInPage == true){
                scriptStartFlag = true ;
                scriptEndFlag = false;
            }
            if(scriptStartFlag == true && scriptEndFlag == false){ 
                                
                    linesWithinScriptTag = linesWithinScriptTag +Temp+Constants.NEWLINE;
                    linesNumInScriptTag = linesNumInScriptTag + 1;
            }
            if(scriptEndInPage == true){
                scriptStartFlag = false;                
                scriptEndFlag = true ;
                finalString = linesWithinScriptTag ;
                linesWithinScriptTag =Constants.SPACE;
            }
            
            if(finalString !=null){
                integer lineNumCount=1;
                List<String> scriptTagBody= finalString.split(Constants.NEWLINE);
                for(String scriptLine:scriptTagBody){
                    if(PatternMatching(Constants.SecureScriptPattern,scriptLine)==true){
                    
                    }else if(PatternMatching(Constants.ScriptPatternNotSecure,scriptLine)==true){
                    
                    AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),ruleResult,Constants.StoredXSS,Constants.CRITICAL,outputParamMap.get(Constants.APEXID),String.valueOf(LineNum-(linesNumInScriptTag-lineNumCount)),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
                                            
                    }
                lineNumCount++;
                }
                finalString =null;
                linesNumInScriptTag =0;
            }
                  
        }
            LineNum++;
        }
        }catch(Exception e){                       
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),Constants.StoredXSS,Constants.CRITICAL,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
        
        }
                
    }
     //-------------------------------------------------------------------
     
     /**
     * Author       -   Varuna Nikam
     * @date        -   18/6/2015
     * @description -   checking with style tag for Stored XSS
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
     public static void checkStoredXSSStyleTag(Map<String, String> outputParamMap) {
        Map<String, String> insertData = new Map<String, String>();
        
        Boolean styleStartFlag = false;
        Boolean styleEndFlag = false;
        integer linesNumInStyleTag =0;
        integer LineNum=1; 
        String linesWithinStyleTag;
        String finalStyleString;
        try{
        //  throw new MyException('Exception in rule 5');
    List<String> BodyLine= outputParamMap.get(Constants.APEXBODY).split(Constants.NEWLINE);
   
    for(String Temp:BodyLine){
         if(LineNum <=BodyLine.size()){
               
                Boolean styleStartInPage = PatternMatching(Constants.StyleStartPattern,Temp);
                Boolean styleEndInPage = PatternMatching(Constants.StyleEndPattern,Temp);
                
                if(styleStartInPage == true){
                    styleStartFlag = true ;
                    styleEndFlag = false;
                }
                if(styleStartFlag == true && styleEndFlag == false){ 
                                    
                        linesWithinStyleTag = linesWithinStyleTag +Temp+Constants.NEWLINE;
                        linesNumInStyleTag = linesNumInStyleTag + 1;
                }
                if(styleEndInPage == true){
                    styleStartFlag = false;                 
                    styleEndFlag = true ;
                    finalStyleString = linesWithinStyleTag ;
                    linesWithinStyleTag =Constants.SPACE;
                }
                
                if(finalStyleString !=null){
                    integer lineNumCount=1;
                    List<String> scriptTagBody= finalStyleString.split(Constants.NEWLINE);
                    for(String scriptLine:scriptTagBody){
                        if(PatternMatching(Constants.SecureStylePattern,scriptLine)==true){
                        
                        }else if(PatternMatching(Constants.StylePatternNotSecure,scriptLine)==true){
                        
                        AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),ruleResult,Constants.StoredXSS,Constants.CRITICAL,outputParamMap.get(Constants.APEXID), String.valueOf(LineNum-(linesNumInStyleTag-lineNumCount)),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
                                                
                        }
                    lineNumCount++;
                    }
                    finalStyleString =null;
                    linesNumInStyleTag =0;
                }
                      
        }
            LineNum++;
        }
        }catch(Exception e){                       
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),Constants.StoredXSS,Constants.CRITICAL,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
        }       
     }
     //-----------------------------------------------------------
     
     /**
     * Author       -   Varuna Nikam
     * @date        -   18/6/2015
     * @description -   checking with any html tag for Stored XSS
     * @param       -   outputParamMap - Map with all apex classes related data
     * @return      -   void
     * @modifiedby  -
     */
      public static void checkStoredXSSAnyHTMLTag(Map<String, String> outputParamMap) {
    
        Map<String, String> insertData = new Map<String, String>();
        integer LineNum=1; 
        try{
        //  throw new MyException('Exception in rule 5');
        List<String> BodyLine= outputParamMap.get(Constants.APEXBODY).split(Constants.NEWLINE);
        for(String Temp:BodyLine){
               if(LineNum <=BodyLine.size()){
               
                Boolean apexInTag = PatternMatching(Constants.ApexPattern,Temp);
                
                if(apexInTag == true){
                }else if(apexInTag == false){
                    Boolean scriptInPage = PatternMatching(Constants.ScriptStartPattern,Temp);
                    Boolean styleInPage = PatternMatching(Constants.StyleStartPattern,Temp); 
                    if(scriptInPage == true || styleInPage == true){
                    }else {
                        if(PatternMatching(Constants.HTMLTagSecurePattern,Temp)==true){
                        }else if(PatternMatching(Constants.HTMLTagNotSecurePattern,Temp)==true){
                            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),ruleResult,Constants.StoredXSS,Constants.CRITICAL,outputParamMap.get(Constants.APEXID),String.valueOf(LineNum),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
                        }
                    }     
              }
        }
            LineNum++;
        }
        }catch(Exception e){                        
            AddObjectClassesParse(setClassParseParams(outputParamMap.get(Constants.APEXNAME),e.getMessage(),Constants.StoredXSS,Constants.CRITICAL,outputParamMap.get(Constants.APEXID),String.valueOf(e.getLineNumber()),outputParamMap.get(Constants.CREATEDBYNAME),outputParamMap.get(Constants.MODIFIEDBYNAME),outputParamMap.get(Constants.DESCRIPTION),''));
        
        }
     }
     //--------------------------------------------
     
     /**
     * Author       -   Dinesh Girase
     * @date        -   24/6/2015
     * @description -   This method will fetch data of identified issues and will generate CSV.
     * @param       -   
     * @return      -   String - identified issues data
     * @modifiedby  -
     */
     
     public static String getReportData(){
        String strRptData = Constants.GetReportStr;
        
        try{
        List<ClassesParse__c> lstReportData = new List<ClassesParse__c>();
        
           if (Schema.sObjectType.ClassesParse__c.fields.ClassName__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.LineNumber__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.Rule__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.Severity__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.Result__c.isAccessible() 
              && Schema.sObjectType.ClassesParse__c.fields.Description__c.isAccessible() )
              
        lstReportData =[SELECT ClassName__c,LineNumber__c,Rule__c,Severity__c,Result__c,Description__r.RuleDescription__c FROM ClassesParse__c where id != null];
        
          else
        
        system.debug('The logged in user does not have access to the field/object');
        
        if(lstReportData != null && lstReportData.size() > 0){
            
            for(ClassesParse__c lstRptData : lstReportData){
                
                strRptData = strRptData + Constants.NEWLINE + '"'+lstRptData.ClassName__c+'"' + Constants.COMMA + lstRptData.Rule__c  + Constants.COMMA + lstRptData.Description__r.RuleDescription__c + Constants.COMMA + lstRptData.LineNumber__c + Constants.COMMA + lstRptData.Severity__c+ Constants.COMMA + lstRptData.Result__c;
                
            }
            return strRptData;
        }else{
            strRptData = strRptData +Constants.NEWLINE + 'No Issues Found ';
            return strRptData;
        }
        }catch(Exception e){
            return strRptData;
        }
        
     }
     /**
     * Author       -   Sakshi Nagpal
     * @date        -   02/06/2016
     * @description -   This method check Lines of Code               
     */ 
    private static void LinesOfCodeCheck(String ruleKey,ID ruleKeyID , Boolean isMethod){
        try{
        //check lines of code in a method should NOT exceed 300
            if(ruleKey.equalsIgnoreCase(Constants.RULE13) && isMethod)
            {               
               //if(PatternMatching(Constants.DebugPattern,outputMap.get(Constants.APEXBODY))==true)
                   
                     String codeWithoutComments = RemoveCodeComments(outputMap.get(Constants.APEXBODY));
                     List<String> BodyLines= codeWithoutComments.split(Constants.NEWLINE);
                     Integer bodyLinesCount = BodyLines.size();
                     System.debug('BodyLines before comment removal : '+bodyLinesCount);
                     for(String line : BodyLines )
                     {
                        if(String.IsBlank(line))
                        {
                            bodyLinesCount--;
                        }
                     }
                     System.debug('BodyLines after comment removal : '+bodyLinesCount);
                     Map<String,String> InsertData = new Map<String, String>();
                     InsertData.put(Constants.SEVERITY,Constants.MINOR);
                     InsertData.put(Constants.DESCRIPTION,ruleKeyID);                     
                     String methodName = outputMap.get(Constants.APEXBODY).split('\n')[0];    
                     InsertData.put(Constants.APEXNAME,apexClassName);
                     insertData.put(Constants.LINENUM,  outputMap.get(Constants.STARTLINENUMBER));
                     insertData.put(Constants.PROBLEMSTATEMENT,Constants.LOCLIMITEXCEED);                    

            if(bodyLinesCount>300)
            {
            //AddObjectClassesParse(setClassParseParams(outputMap.get(Constants.APEXNAME),'testtest',Constants.LOCLIMITEXCEED,Constants.CRITICAL,outputMap.get(Constants.APEXID),'0',outputMap.get(Constants.CREATEDBYNAME),outputMap.get(Constants.MODIFIEDBYNAME),outputMap.get(Constants.DESCRIPTION),''));
            AddObjectClassesParse(insertData);   
            }
        
        }
    }   
          
        catch(Exception e){
            system.debug('Failed to check LinesOf code Rule: ' + e.getMessage());
        }
    }
  /**
     * Author       -   Sakshi Nagpal
     * @date        -   02/06/2016
     * @description -   This method check number of methods in apex code              
     */ 
    private static void noOfMethodsCheck(String ruleKey,ID ruleKeyID , Boolean isMethod){
        try{ 
                if(ruleKey.equalsIgnoreCase(Constants.RULE12) && !isMethod)
            {
                integer counter=0;
                String codeWithoutComments = RemoveCodeComments(outputMap.get(Constants.APEXBODY));
                List<String> BodyLine= codeWithoutComments.split(Constants.NEWLINE);
                 for(String Temp:BodyLine){ 
                     Temp = Temp.remove(Constants.NEWLINE);
                     Temp = Temp.trim();
                     Temp = Temp.replaceAll(Constants.SpacePattern,'#');
                     Temp = Temp.remove('#');
                      if(PatternMatching(Constants.ClassMethodPatternPublic,Temp)==true || PatternMatching(Constants.ClassMethodPatternPrivate,Temp)==true || PatternMatching(Constants.ClassMethodPatternProtected,Temp)==true || PatternMatching(Constants.ClassMethodPatternGlobal,Temp)==true || PatternMatching(Constants.ClassMethodPatternFinal,Temp)==true){
                      counter++;
                      }
                 }
                 outputMap = new Map<String, String>();
                outputMap.put(Constants.PROBLEMSTATEMENT,Constants.WITHSHARING);
                outputMap.put(Constants.SEVERITY,Constants.MINOR);
                outputMap.put(Constants.DESCRIPTION,ruleKeyID);
                outputMap.put(Constants.APEXNAME,apexClassName);
                system.debug('sakshi'+outputMap); 
                system.debug('sakshi'+BodyLine.size()); 
                system.debug('sakshi'+Constants.APEXNAME);
                  if(counter>10)
                 {
                     AddObjectClassesParse(setClassParseParams(outputMap.get(Constants.APEXNAME),'testtest',Constants.NOOFMETHODEXCEED,Constants.CRITICAL,outputMap.get(Constants.APEXID),'0',outputMap.get(Constants.CREATEDBYNAME),outputMap.get(Constants.MODIFIEDBYNAME),outputMap.get(Constants.DESCRIPTION),''));   
                 }
                 }
           }catch(Exception e){
            system.debug('Failed to check LinesOf code Rule: ' + e.getMessage());
        }
    }
}