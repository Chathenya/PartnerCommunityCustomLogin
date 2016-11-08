public with sharing class CustomLoginController_Doctors {
  
    public string userName {get;set;}
    public string password {get;set;}
    public boolean rememberMe {get; set;}
    public Set<string> userNameSet {get;set;}
    public Integer noOfUserNames {get;set;}
    public Boolean loginWithOtherUser {get;set;}
    
    public CustomLoginController_Doctors () {
        //check the saved user names
        Cookie userNameCookie = ApexPages.currentPage().getCookies().get('userNameList');
        String userNameString = userNameCookie != null? userNameCookie.getValue() : null;
        List<Object> users = userNameString != null? (List<Object>)JSON.deserializeUntyped(userNameString) : new List<Object>();
        userNameSet = new Set<String>();
        if (users != null) {
            for (Object userNameObject : users) {
                userNameSet.add((String)userNameObject);
            }
        }
        noOfUserNames = userNameSet.size();
        loginWithOtherUser = noOfUserNames != 0? false : true;
    }
    
    public PageReference login() {
      
        PageReference pageReference = Site.login(username, password, null);
     
        if (pageReference != null && rememberMe == true) {
          //save user name
          saveUserName();
        }
        return pageReference;
    }
  
    public void saveUserName() {
        userNameSet.add(userName);
        String userNameString = JSON.serialize(userNameSet);
        Cookie userNameCookie  = new Cookie('userNameList', userNameString ,null,2000000000,false);
        ApexPages.currentPage().setCookies(new Cookie[]{userNameCookie});
        system.debug('--------userNameCookie----------'+userNameCookie);
        system.debug('ApexPages.currentPage().getCookies()--->'+ApexPages.currentPage().getCookies());
    }

    public void loginWithUser() {
        loginWithOtherUser = true;
        userName = null;
    }

    public void chooseExistingUser() {
        loginWithOtherUser = false;
    }

    public void chooseThis(){
        String selectedUserName = ApexPages.currentPage().getParameters().get('selected');
        system.debug('selectedUserName-->'+selectedUserName);
        userName = selectedUserName;
        loginWithOtherUser = true;
    }
}