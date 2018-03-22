using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace Test_Framework.Helpers
{
    public  class DriverHelper
    {
        public static IWebDriver driver;
        private string baseUrl = "https://www.google.com.ua/";

        [SetUp]
        protected void InitializeChrome()
        {
            driver = new ChromeDriver();
            driver.Manage().Window.Maximize();
            driver.Navigate().GoToUrl(baseUrl);

        }
        [TearDown]
        protected void Close()
        {
            driver.Close();
            driver.Quit();
        }

    }
}
