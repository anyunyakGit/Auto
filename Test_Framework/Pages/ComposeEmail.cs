using OpenQA.Selenium;
using Test_Framework.Helpers;


namespace Test_Framework
{
    public class ComposeEmail : ComposeEmialPage
    {
        public void ComposeEmailAndSendEmail(string generateTextField)
        {
            ClickOnButton(compose);
            WaitForElement(recepient);
            SendKeysTo(recepient, DataHelper.userEmailValue);
            SendKeysTo(recepient, Keys.Tab);
            WaitForElement(subjectBox);
            SendKeysTo(subjectBox, DataHelper.GenerateUniqueName(8));
            SendKeysTo(subjectBox, Keys.Tab);
            SendKeysTo(textBox, generateTextField);
            ClickOnButton(sendButton);
            ClickOnButton(Inbox);
        }

       
    }

    public class ComposeEmialPage : CommonMethodHelper
    {

        public readonly By compose = By.XPath("//*[contains(@class, 'T-I J-J5-Ji T-I-KE L3') and text() = 'COMPOSE']");
        public readonly By recepient = By.Name("to");
        public readonly By subjectBox = By.Name("subjectbox");
        public readonly By textBox = By.XPath("//*[contains(@class, 'Am Al editable LW-avf')]");
        public readonly By sendButton = By.XPath("//*[contains(@class, 'T-I J-J5-Ji aoO T-I-atl L3') and text() = 'Send']");
        public readonly By Inbox = By.XPath("//a[contains(text(),'Inbox')]");
        public static By emailSubjects = By.XPath("//*[contains(@class, 'y2')]");

    }
    public class AssertElementContains : DriverHelper
    {
        public static bool TextIsInElements(string textToFind, By element)
        {
            IWebElement webElement = driver.FindElement(element);

            if (webElement.Text.Contains(textToFind))
            {
                return false;
            }
            return false;
        }
    }
}
