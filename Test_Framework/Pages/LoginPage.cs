using OpenQA.Selenium;


namespace Test_Framework.Pages
{
    public class LoginPage : LogGmailMainPage
    {
        public void LoginToApplication(string email, string pass)
        {

            ClickOnButton(gmailLink);
            ClickOnButton(identifier);
            SendKeysTo(identifier, email);
            ClickOnButton(identifierNext);

            WaitForElement(passValue);

            ClearField(inputPassword);
            SendKeysTo(password, pass);
            WaitForElement(moveNextAfterPass);
            ClickOnButton(moveNextAfterPass);
        }
    }

    public class LogGmailMainPage : CommonMethodHelper
    {

        public readonly By gmailLink = By.Id("gb_70");
        public readonly By identifier = By.Id("identifierId");
        public readonly By identifierNext = By.Id("identifierNext");
        public readonly By password = By.Name("password");
        public readonly By inputPassword = By.XPath("//input[@name='password']");
        public readonly By passValue = By.Name("password");
        public readonly By moveNextAfterPass = By.CssSelector("span.RveJvd.snByac");
    }
}
