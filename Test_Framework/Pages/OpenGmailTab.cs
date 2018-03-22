using OpenQA.Selenium;
using Test_Framework;

namespace Test_Framework
{
    public class OpenGmailTab : OpenGmail
    {

        public void OpenGmailPage()
        {
            WaitForElement(LinkGmail);
            ClickOnButton(gmail);
        }
    }

    public class OpenGmail : CommonMethodHelper
    {
        public OpenGmail()
        {

        }

        public readonly By LinkGmail = By.LinkText("Gmail");
        public readonly By gmail = By.XPath("//a[contains(text(),'Gmail')]");
    }

}
