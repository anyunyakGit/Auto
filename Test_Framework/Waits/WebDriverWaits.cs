using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System;
using Test_Framework.Helpers;

namespace Test_Framework
{
    public class WebDriverWaits : DriverHelper
    {
        public WebDriverWait wait;
        protected void WaitForElement(By locator)
        {
            if (wait == null)
                wait = new WebDriverWait(driver, TimeSpan.FromSeconds(15));
            wait.Until(ExpectedConditions.ElementToBeClickable(locator));


        }
    }
}
