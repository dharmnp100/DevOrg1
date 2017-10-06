/**
 * @author          Dinesh Girase
 * @date            9/6/2015
 * @description -   This class contains all constants.
 * @modifiedby  -   Varun Nikam and Pooja Kanani 
 */
public with sharing class Constants {

    public static final String APEXBODY = 'ApexBody';
    public static final String APEXNAME ='ApexName';
    public static final String RULERESULT ='ruleResult';
    public static final String APEXID ='ApexId';
    public static final String CREATEDBY ='ApexCreatedById';
    public static final String MODIFIEDBY ='ApexLastModifiedById';
    public static final String CREATEDBYNAME ='ApexCreatedByName';
    public static final String MODIFIEDBYNAME ='ApexModifiedByName';
    public static final String SEVERITY ='Severity';
    public static final String METHODOUTPUT ='MethodOutput';
    public static final String APEXCLASS ='ApexClass';
    public static final String APEXPAGE ='ApexPage';
    public static final String FILENAME = 'Report.csv';
    public static final String CONTENT = 'text/csv';
    public static final String SUBJECT = 'Mindtree ApexLint Report';
    public static final String HITEXT = 'Dear ';//'Hi,';
    public static final String NEWLINE2 = '<br><br>';//'\n\n';
    public static final String TEXT1 ='Thanks for using ApexLint – your personal advisor for detecting code vulnerabilities! <br><br> Referring your latest scan, attached herewith are the results. Time for some action. <br> <br> Hope the results served your purpose and helped in saving some of your valuable time. <br><br> ';//'Please find attached ApexLint report.';
    public static final String TEXT2 ='<br<br> We would love to hear from you and ensure you of our committed services. <br><br> Happy scanning.';//'Please find attached ApexLint report.';
    public static final String SALUTATION = 'Regards,<br>ApexLint Team, MINDTREE LTD.';//'Regards,\nApexLint Team, MINDTREE LTD.';
    public static final String STARTLINENUMBER ='StartLineNumber';
    
    //problem statemnts
    public static final String PROBLEMSTATEMENT ='problemStatement';
    public static final String WITHSHARING = 'Class is not "with sharing" keyword';
    public static final String StoredXSS ='Stored XSS';
    public static final String SOQLWITHOUTWHR = 'SOQL query is not with Where Condition';
    public static final String SOQLINFOR = 'SOQL used in for loop';
    public static final String SOQLINWHILE = 'SOQL used in While loop';
    public static final String REFLECTEDXSSCLASS = 'Reflected XSS';
    public static final String CLASSCOMMENTS = 'Class level comment not found';
    public static final String METHODCOMMENTS = 'Method level comment not found';
    public static final String DEBUGSTATEMENT = 'Debug Statement';
    public static final String CONSTANT = 'Constant';
    public static final String ASSERTSTATE = 'Assert Statement not found in method';
    public static final String TRYCATCHSTATE = 'Catch block should not be empty'; //'Try catch not found in method';
    public static final String OBJECTINSIDEFOR = 'Object creation in for loop';
    public static final String OBJECTINSIDEWHILE = 'Object creation in While loop';
    public static final String REFLECTEDXSSPAGE ='Reflected XSS';
    public static final String DESCRIPTION = 'descritpion';
    public static final String LOCLIMITEXCEED = 'Lines of code are more than 300';
    public static final String NOOFMETHODEXCEED = 'Number of method in apex class exceeds 10';
    
    
    //patterns for PatternMatching
    public static final String WithSharingPattern = '(?i)public[\\s]+class[\\s]+[^{}()]+';
    //rule2
    public static final String SelectPattern1 = '\\[[S|s][E|e][L|l][E|e][C|c][T|t]';
    public static final String SelectPattern2 = '\\\'[S|s][E|e][L|l][E|e][C|c][T|t]';
    public static final String SelectPattern3 = '\\[[S|s][E|e][L|l][E|e][C|c][T|t] .* [W|w][H|h][E|e][R|r][E|e]';
    public static final String SelectPattern4 = '\\\'[S|s][E|e][L|l][E|e][C|c][T|t] .* [W|w][H|h][E|e][R|r][E|e]';
    //rule3
    public static final String SelectPatternInLoop1 ='[S|s][E|e][L|l][E|e][C|c][T|t]';
    public static final String SelectWhileInLoop = '[W|w][H|h][I|i][L|l][E|e]\\(.*[S|s][E|e][L|l][E|e][C|c][T|t]';
    public static final String SelectForInLoop = '[F|f][O|o][R|r]\\(.*[S|s][E|e][L|l][E|e][C|c][T|t]';
    
    //rule4 classes
    public static final String ApexCurrentPattern = '[A|a][P|p][E|e][X|x][P|p][A|a][G|g][E|e][S|s]\\.[C|c][U|u][R|r][R|r][E|e][N|n][T|t][P|p][A|a][G|g][E|e]';
    public static final String ApexCurrentPatternSecure ='.*[A|a][P|p][E|e][X|x][P|p][A|a][G|g][E|e][S|s]\\.[C|c][U|u][R|r][R|r][E|e][N|n][T|t][P|p][A|a][G|g][E|e]\\(\\)\\.[G|g][E|e][T|t][P|p][A|a][R|r][A|a][M|m][E|e][T|t][E|e][R|r][S|s]\\(\\)\\.[G|g][E|e][T|t]\\([A-Z|a-z].+\\(.+\\)\\);';
    public static final String ApexCurrentPatternSecure1 ='.*[A-Z|a-z].+\\([A|a][P|p][E|e][X|x][P|p][A|a][G|g][E|e][S|s]\\.[C|c][U|u][R|r][R|r][E|e][N|n][T|t][P|p][A|a][G|g][E|e]\\(\\)\\.[G|g][E|e][T|t][P|p][A|a][R|r][A|a][M|m][E|e][T|t][E|e][R|r][S|s]\\(\\)\\.[G|g][E|e][T|t]\\(.+\\)\\);';
    public static final String ApexCurrentPatternNotSecure ='.*[A|a][P|p][E|e][X|x][P|p][A|a][G|g][E|e][S|s]\\.[C|c][U|u][R|r][R|r][E|e][N|n][T|t][P|p][A|a][G|g][E|e]\\(\\)\\.[G|g][E|e][T|t][P|p][A|a][R|r][A|a][M|m][E|e][T|t][E|e][R|r][S|s]\\(\\)\\.[G|g][E|e][T|t]\\(.+\\);';
    //rule4 pages
    public static final String ReflectedXSSForPages = '<[A|a][P|p][E|e][X|x]:[O|o][U|u][T|t][P|p][U|u][T|t][T|t][E|e][X|x][T|t]';
    public static final String ReflectedXSSForPagesSecure = '<[A|a][P|p][E|e][X|x]:[O|o][U|u][T|t][P|p][U|u][T|t][T|t][E|e][X|x][T|t].* [E|e][S|s][C|c][A|a][P|p][E|e]="[F|f][A|a][L|l][S|s][E|e]".*\\{\\![A-Z|a-z]+\\(.+\\)\\}.*>';
    public static final String ReflectedXSSForPagesSecure1 = '<[A|a][P|p][E|e][X|x]:[O|o][U|u][T|t][P|p][U|u][T|t][T|t][E|e][X|x][T|t].*\\{\\![A-Z|a-z]+\\(.+\\)\\}.*[E|e][S|s][C|c][A|a][P|p][E|e]="[F|f][A|a][L|l][S|s][E|e]".*>';
    public static final String ReflectedXSSForPagesNotSecure ='<[A|a][P|p][E|e][X|x]:[O|o][U|u][T|t][P|p][U|u][T|t][T|t][E|e][X|x][T|t].*\\{\\!.+\\}.*[E|e][S|s][C|c][A|a][P|p][E|e]="[F|f][A|a][L|l][S|s][E|e]".*>';
    public static final String ReflectedXSSForPagesNotSecure1 ='<[A|a][P|p][E|e][X|x]:[O|o][U|u][T|t][P|p][U|u][T|t][T|t][E|e][X|x][T|t].*[E|e][S|s][C|c][A|a][P|p][E|e]="[F|f][A|a][L|l][S|s][E|e]".*\\{\\!.+\\}.*>';
    
    //rule5
    public static final String ScriptPattern ='<[S|s][C|c][R|r][I|i][P|p][T|t]';
    public static final String StylePattern = '<[S|s][T|t][Y|y][L|l][E|e]';
    public static final String HTMLTagPattern = '<[A-z|a-z].*';
    public static final String SecureScriptPattern = '.*\\{\\![A-Z|a-z]+\\(.+\\)\\}.*';
    public static final String ScriptPatternNotSecure = '.*\\{\\!.+\\}.*';
    public static final String ScriptStartPattern = '<[S|s][C|c][R|r][I|i][P|p][T|t].*>';
    public static final String ScriptEndPattern = '.*</[S|s][C|c][R|r][I|i][P|p][T|t]>';
    public static final String StyleStartPattern = '<[S|s][T|t][Y|y][L|l][E|e].*>';
    public static final String StyleEndPattern = '.*</[S|s][T|t][Y|y][L|l][E|e]>';
    public static final String SecureStylePattern ='.*\\{\\![A-Z|a-z]+\\(.+\\)\\}.*';
    public static final String StylePatternNotSecure = '.*\\{\\!.+\\}.*';
    public static final String ApexPattern = '<[A|a][P|p][E|e][X|x].*';
    public static final String HTMLTagSecurePattern = '<[A-z|a-z].*\\{\\![A-Z|a-z]+\\(.+\\)\\}.*>.*';
    public static final String HTMLTagNotSecurePattern ='<[A-z|a-z].*\\{\\!.+\\}.*>.*';
    
    //rule6
    public static final String findPattern = '\\[[F|f][I|i][N|n][D|d].*';
    public static final String findPattern1 = '\\\'[F|f][I|i][N|n][D|d].*';
    
    //rule7
    public static final String ClassCommentsPattern = '[public|private|protected|final|global](.*)class(.+)\\{';
    public static final String TestAnnotation = '@isTest';
    //public static final String TestClassPattern = '@isTest[\\s]+(public|private|global)[\\s]+class[\\s]+(.+)\\{';//'@isTest(.*)[public|private|global]class(.+)\\{';
    public static final String TestClassPattern = '@isTest+(public|private|global)+class+(.+)\\{';//'@isTest(.*)[public|private|global]class(.+)\\{';
    public static final String TestClassCommentPattern = '.*(/\\*(.+?)\\*/)@isTest(.*)[public|private|global]class(.+)\\{.*';
    public static final String TestMethodPattern = '@isTest(.*)staticvoid(.+)';
    public static final String TestMethodPattern2 = 'statictestMethodvoid(.+)';
    public static final String TestMethodCommentPattern = '.*(/\\*(.+?)\\*/)@isTest(.*)staticvoid(.+)';
    public static final String TestMethodCommentPattern2 = '.*(/\\*(.+?)\\*/)statictestMethodvoid(.+)';
    public static final String ClassPatternPublic = 'public+.*class(.+)\\{';
    public static final String ClassPatternPrivate = 'private+.*class(.+)\\{';
    public static final String ClassPatternProtected = 'protected+.*class(.+)\\{';
    public static final String ClassPatternGlobal = 'global+.*class(.+)\\{';
    public static final String ClassPatternFinal = 'final+.*class(.+)\\{';
    
  /*public static final String ClassPatternPublic = 'public[\\s]+.*class(.+)\\{';
    public static final String ClassPatternPrivate = 'private[\\s]+.*class(.+)\\{';
    public static final String ClassPatternProtected = 'protected[\\s]+.*class(.+)\\{';
    public static final String ClassPatternGlobal = '(?i)global[\\s]+.*class(.+)\\{';
    public static final String ClassPatternFinal = 'final.*class(.+)\\{';*/
    
    public static final String ClassCommentPattern = '.*(/\\*(.+?)\\*/)[public|private|protected|final|global].+class(.+)\\{.*';
    public static final String ClassCommentPattern1 = '.*(/\\*(.+?)\\*/).*[public|private|protected|final|global].+class(.+)\\{.*';
    public static final String ClassMethodPatternPublic ='public.+\\(.*\\)\\{';
    public static final String ClassMethodPatternPrivate ='private.+\\(.*\\)\\{';
    public static final String ClassMethodPatternProtected ='protected.+\\(.*\\)\\{';
    public static final String ClassMethodPatternGlobal ='global.+\\(.*\\)\\{';
    public static final String ClassMethodPatternFinal ='final.+\\(.*\\)\\{';
    public static final String ClassMethodPatternWebservice ='[W|w]eb[S|s]ervice.+\\(.*\\)\\{';
    public static final String ClassMethodCommentPattern = '.*(/\\*(.+?)\\*/)[public|private|protected|final|global|[W|w]eb[S|s]ervice].+\\(.*\\)\\{.*';
    public static final String ClassMethodCommentPattern1 = '.*(/\\*(.+?)\\*/).*[public|private|protected|final|global|[W|w]eb[S|s]ervice].+\\(.*\\)\\{.*';
    
    //rule8
    public static final String DebugPattern = '[S|s][Y|y][S|s][T|t][E|e][M|m]\\.[D|d][E|e][B|b][U|u][G|g]';
    public static final String DebugPattern1 = '.*[S|s][Y|y][S|s][T|t][E|e][M|m]\\.[D|d][E|e][B|b][U|u][G|g].*';
    
    //rule9
    public static final String ClassPatternConstant ='[public|private|protected|final|global](.*)class(.+)\\{';
    public static final String ConstantPattern = '\\\'.+\\\'';
    
    //rule10
    public static final String TestClassPatternForAssert = '@[i|I][s|S][t|T][e|E][s|S][t|T].*';
    public static final String TestMethodPatternForAssert ='testMethod';
    public static final String AssertPattern = '[S|s][Y|y][S|s][T|t][E|e][M|m]\\.[A|a][S|s][S|s][E|e][R|r][T|t]';
    
    //rule11
    
    public static final String TryCatchPattern = 'try\\{.*\\}catch\\(.*\\)\\{';
    public static final String EmptyTryCatchPattern = 'catch\\s*(\\(\\s*Exception(\\s*\\w+)?\\))?\\s*\\{\\s*\\}'; //RP
    //'catch\\*(\\*Exception?\\)?\\*;
    //'try\\{.*\\}catch\\(\\)\\{';
    public static final String CatchPatter = '[C|c][A|a][T|t][C|c][H|h]\\(';
    
    //rule12
    public static final String ObjectInstInsideWhile = '[W|w][H|h][I|i][L|l][E|e]\\(.*[N|n][E|e][W|w]';
    public static final String ObjectInstInsideFor = '[F|f][O|o][R|r]\\(.*[N|n][E|e][W|w]';
    public static final String NewPatten = '=\\s+[N|n][E|e][W|w]';
    public static final String NewPatten1 = '=[N|n][E|e][W|w]';
    
    
    //getReportString
    public static final String GetReportStr = 'Class/Page Name,Rule,Description,Line Number,Severity,Exception';
    public static final String GetReportStrWithoutException = 'Class/Page Name,Rule,Line Number,Severity';
    
    
    public static final String LINENUM ='LineNum';
    public static final String LOOPTYPE ='LoopType';
    public static final String FORPATTERN = '[F|f][O|o][R|r]\\((.*)';
    public static final String WHILEPATTERN ='[W|w][H|h][I|i][L|l][E|e]\\((.*)';
    public static final String NEWLINE ='\n';
    public static final String SEMICOLON = ';';
    public static final String HASHTAGS = '##';
    public static final String OpeningBracket = '{';
    public static final String ClosingBracket = '}';
    public static final String SpacePattern = '(\\s+)';
    public static final String COMMA = ',';
    public static final String SPACE ='';
    public static final String MAJOR ='Major';
    public static final String MINOR ='Minor';
    public static final String CRITICAL ='Critical';
    public static final String FAIL ='NA';
    public static final String RULE1 ='Rule1';
    public static final String RULE2 ='Rule2';
    public static final String RULE3 ='Rule3';
    public static final String RULE4 ='Rule4';
    public static final String RULE5 ='Rule5';
    public static final String RULE6 ='Rule6';
    public static final String RULE7 ='Rule7';
    public static final String RULE8 ='Rule8';
    public static final String RULE9 ='Rule9';
    public static final String RULE10 ='Rule10';
    public static final String RULE11 ='Rule11';
    public static final String RULE12 ='Rule12';
    public static final String RULE13 ='Rule13';
     public static final String RULE14 ='Rule14';
    public static final String globalClass = '[G|g][L|l][O|o][B|b][A|a][L|l]';
    
    
}