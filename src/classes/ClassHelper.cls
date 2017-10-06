/**
 * @author Dinesh Girase
 * @date 2/12/2015
 * @description - helper class containing logic to insert the methods of the each class into the metaData__c object
 */ 
 
public with sharing class ClassHelper {
    
     /**
     * Author       -   Dinesh Girase
     * @date        -   2/12/2015
     * @description -   this method insert the methods of each class into the metaData__c object
     * @param       -   classList - List of class 
     *                  requestID - request ID
     * @return      -   Map
     */

    public static List<metaData__c> convertClassesToMethods(List<ApexClass> classList, String requestID){
        List<metaData__c> metaDatas = new List<metaData__c>();
        try{
            System.debug('Inside convertClassesToMethods#') ;   
        //insert the data into appropriate fields in metaData__c object
        for(ApexClass cls : classList) {  
            system.debug('Inside for loop of convertClassesToMethods in classHelper');
            system.debug('cls.Name>>'+cls.Name + 'cls.body>>'+cls.body);
            Map<String, String> clsDef = getMethods(cls.Name, cls.body);
            system.debug('clsDef >>'+clsDef );
            for(String mapKeys: clsDef.keySet()) {              
                metaData__c metaD = new metaData__c();
                metaD.EntityBody__c = clsDef.get(mapKeys);
                metaD.EntityName__c = cls.Name;            
                metaD.EntityType__c = 'ApexMethod';
                metaD.EntityId__c = requestID;
                string[] keysParts = mapKeys.Split('-');
                metaD.EntityLineNumber__c = keysParts[keysParts.Size()-1];      
                System.debug('MethodLine# - '+ metaD.EntityLineNumber__c)   ;
                System.debug('EntityName__c # - '+ metaD.EntityName__c)   ;  
                System.debug('EntityId__c # - '+ metaD.EntityId__c)   ;        
                metaDatas.add(metaD);
            }
        }
          if (Schema.sObjectType.metaData__c.fields.EntityName__c.isCreateable() 
          &&  Schema.sObjectType.metaData__c.fields.EntityType__c.isCreateable()
           &&  Schema.sObjectType.metaData__c.fields.EntityBody__c.isCreateable()
          &&  Schema.sObjectType.metaData__c.fields.EntityId__c.isCreateable())
        //Inserting meta data values for class and pages
        insert metaDatas;
        }catch(Exception e){
            system.debug('Failed to insert the data into metaData__c object: ' + e.getMessage());
        }
        return metaDatas;
    }
    
    /**
     * Author       -   Dinesh Girase
     * @date        -   2/12/2015
     * @description -   this method remove all the space between the code
     * @param       -   className - name of class
     *                  classBody - body of class
     * @return      -   Map
     */
    public static Map<String, String> getMethods(String className,String classBody){
        Map<String, String> methodMap = new Map<String, String>();
        try{
            Integer methodCount = 0;              
            integer LineNum=1; 
            String str = '';
            String tempToFindMethodPattern;
            integer insideLinesNum =0;
            classBody = classBody+'\n'+'$';
            List<String> BodyLine= classBody.split('\n');
            System.Debug('Class Body Lines Count - '+BodyLine.size());
                // loop over one by one class to create the map of the class name, count and class type
                for(String Temp:BodyLine){ 
                    String pattern = '[A-Z|a-z|0-9| |=|]';//']+[\^|@|A-Z|a-z|||[|\]|:| |\\|'|<|?|/| |.|*|{|!|\-|+|(|)|}|=|"|>|;|#|,]*';
                  //  if(Temp.matches(pattern){
                        Temp.replaceAll(pattern,' ');
                  //  }
                    //System.debug('Line#'+LineNum+':'+Temp)      ;
                    Temp = Temp.trim();
                    Temp = Temp.replaceAll(Constants.SpacePattern,'#');
                    Temp = Temp.remove('#');
                    System.Debug('Temp Before '+Temp);
                    Boolean flagMethod = (PatternMatching(Constants.ClassMethodPatternPublic,Temp) || PatternMatching(Constants.ClassMethodPatternPrivate,Temp) || PatternMatching(Constants.ClassMethodPatternProtected,Temp)||PatternMatching(Constants.ClassMethodPatternGlobal,Temp)||PatternMatching(Constants.ClassMethodPatternFinal,Temp));
                    Boolean flagClass = (patternMatching(Constants.ClassPatternPublic,Temp)||patternMatching(Constants.ClassPatternPrivate,Temp)||patternMatching(Constants.ClassPatternProtected,Temp)||patternMatching(Constants.ClassPatternGlobal,Temp)||patternMatching(Constants.ClassPatternFinal,Temp));                                   
                        //create string if method lines
                        System.Debug('Temp after '+Temp);
                    if((flagMethod==true || flagClass==true || Temp == '$') && (str !=null || str !='')){
                         system.debug('Inside if of getMethods in classHelper');
                        if(PatternMatching(Constants.ClassMethodPatternPublic,str)==true || PatternMatching(Constants.ClassMethodPatternPrivate,str)==true || PatternMatching(Constants.ClassMethodPatternProtected,str)==true||PatternMatching(Constants.ClassMethodPatternGlobal,str)==true||PatternMatching(Constants.ClassMethodPatternFinal,str)==true){
                            List<String>  methodName = str.split('\n');                         
                            String s2 =  methodName.get(0).substringBefore('(');                            
                            methodCount++;
                            methodMap.put(className + '-Method-' +methodCount+'-Line-'+(LineNum-insideLinesNum), str);   
                            System.Debug('className '+className+' methodCount '+methodCount+' methodName '+s2);                       
                        }
                        flagMethod =false;
                        flagClass = false;
                        str = '';
                        insideLinesNum =0;
                    }
                    
                    if(flagMethod == false || flagClass == false){
                        System.Debug('Str Before '+str);   
                        str=str+Temp+'\n';                      
                        insideLinesNum ++;
                        System.Debug('Str After '+str);
                    }
                    LineNum ++;                 
                }
            }catch(Exception e){
                system.debug('Failed to remove all the space between the code: ' + e.getMessage());
            }
        return methodMap;
    }
    /**
     * Author       -   Dinesh Girase
     * @date        -   2/12/2015
     * @description -   this method checks whether pattrens are matched or not
     * @param       -   StringPattern - pattern to match
     *                  MatchString - with this string
     * @return      -   boolean - true - if pattern matched otherwise false
     */    
        
    public static Boolean PatternMatching(String StringPattern, String MatchString){
         system.debug('Inside PatternMatching in classHelper');        
        Boolean MatchResult;
        try{
         system.debug('MatchString '+MatchString);
        String MatchStringwithoutNewLine = MatchString.replaceAll(Constants.NEWLINE,' ');
        Pattern MyPattern = Pattern.compile(StringPattern);
        system.debug('MatchStringwithoutNewLine Length '+MatchStringwithoutNewLine.length());
        system.debug('MatchStringwithoutNewLine '+MatchStringwithoutNewLine); 
       if(MatchStringwithoutNewLine.length() >= 2999){
            system.debug('size exceeds');
            MatchStringwithoutNewLine = MatchStringwithoutNewLine.substring(0,2888);
            system.debug('size reduced to '+MatchStringwithoutNewLine.length());
        }
    
        Matcher MyMatcher = MyPattern.matcher(MatchStringwithoutNewLine);
        system.debug('MyMatcher  '+MyMatcher ); 
        system.debug('Inside try of PatternMatching in classHelper'); 
        
            if(MyMatcher.find() == true){
                system.debug('Inside if of PatternMatching in classHelper');  
                MatchResult = true;
            }else{
            system.debug('Inside else of PatternMatching in classHelper');  
                MatchResult = false;
            }
            }catch(Exception e){
                system.debug('Failed to check whether pattrens are matched or not: ' + e.getMessage());
            }
         return MatchResult;
         
    }
}