namespace Test_Framework.Pages
{
    public class Page
    {
        
        public LoginPage loginPagePO()
        {
            return new LoginPage();
        }
        public OpenGmailTab OpenGmailT()
        {
            return new OpenGmailTab();
        }
        public ComposeEmail composeEmailAndSend()
        {
            return new ComposeEmail();
        }
        public SignOut signOut()
        {
            return new SignOut();
        }
    }

}


