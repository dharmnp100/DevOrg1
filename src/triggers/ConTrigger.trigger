trigger ConTrigger on Contact (before update) 
{
    for(Contact con : trigger.new)
    {
        /*if(con.Phone == null)
        {
            con.addError('Please provide email.');
        }
        if(con.Birthdate == null)
        {
            con.addError('Please provide BirthDate.');
        }*/
        String InputString = con.Languages__c;//'email@email.com';
        //String emailRegex = '(^[a-zA-Z0-9][a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,20}|[0-9]{1,3})';
        String emailRegex = '(^[a-zA-Z0-9][a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)))([a-zA-Z]{2,20}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);
        
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher MyMatcher = MyPattern.matcher(InputString);
        
        if (!MyMatcher.matches()) {
            con.addError('Erro');
        }
    }
}