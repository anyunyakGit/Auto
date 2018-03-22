using OpenQA.Selenium;

namespace Test_Framework
{
    public class CommonMethodHelper :  WebDriverWaits
    {

        protected void ClickOnButton(By locator)
        {
            driver.FindElement(locator).Click();
        }
        protected void SendKeysTo(By locator, string values)
        {
            driver.FindElement(locator).SendKeys(values);   
        }

        protected void ClearField(By locator)
        {
            driver.FindElement(locator).Clear();
        }
    }
}
