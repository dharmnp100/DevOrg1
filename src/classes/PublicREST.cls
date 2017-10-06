@RestResource(urlMapping='/publicREST/*')
global class PublicREST
{
    @HttpPost
    global static String doPOST()//(String wrapperIns) 
    {
        //System.debug('wrapperIns>>>>>>>>>>>>     '+wrapperIns);
        String origin = RestContext.request.headers.get('Origin');
        system.debug('RestContext.request>>>>>>>>>>>              '+RestContext.request);
        
        system.debug('origin >>>>    '+origin );
        
        if(origin != null && origin != '')
        {
            RestContext.response.addHeader('Access-Control-Allow-Origin', origin);
        }
        //RestContext.response.addHeader('Content-Type', 'text/plain');
        system.debug('RestContext.response>>>>>>>>>>>              '+RestContext.response);
        
        if(RestContext.request.requestBody != null)
            system.debug('RestContext.request.requestBody>>>>>>>>>>>              '+RestContext.request.requestBody.toString());
        else
            system.debug('RestContext.request.requestBody>>>>>>>>>>>              '+RestContext.request.requestBody);
        system.debug('RestContext.request.params>>>>>>>>>>>              '+RestContext.request.params);
        system.debug('RestContext.request.params.keyset>>>>>>>>>>>              '+RestContext.request.params.keyset());
        system.debug('RestContext.request.params.values>>>>>>>>>>>              '+RestContext.request.params.values());        
        /*
        Lead ld = new Lead();
        ld.FirstName = wrapperIns.firstName;
        ld.LastName = wrapperIns.lastName;
        ld.Company = wrapperIns.company;
        insert ld;
        //
        return ld.id;*/
        //return wrapperIns;
        return 'static_text';
    }
    
    global class MyWrapper
    {
        global string firstName;
        global string lastName;
        global string company;
        //global MyInternalWrapper iWrapper;
        
        global MyWrapper()
        {
            //iWrapper = new MyInternalWrapper();
        }       
    }
    
    global class MyInternalWrapper
    {
        global string internalName;
        
        global MyInternalWrapper()
        {
            internalName = 'test';
        }
    }
}