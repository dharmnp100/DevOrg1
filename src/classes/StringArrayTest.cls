public class StringArrayTest
{
    
    public static List<String> generateStringArray(Integer cnt)
    {
        List<String> myStr = new List<String>();
        for(Integer i = 0 ; i<cnt; i++)
        {
            String testString = 'Test '+ i;
            myStr.add(testString);
        }
        return myStr;
    }
}