using System.Security.Cryptography;
using NUnit.Framework;
using Test_Framework.Helpers;
using Test_Framework.Pages;

namespace Test_Framework
{
    [TestFixture]
    public class LoginPageTest : DriverHelper
    {
        
        private Page page = new Page();


       
        [TestCase("nunyakandriy@gmail.com", "Andriy1989")]
        [TestCase("nunyakandriy@gmail.com", "Andriy1989")]
        public void LoginTest(string email, string password)
        {
            page.loginPagePO().LoginToApplication(email, password);
            string emialTextField = DataHelper.GenerateUniqueName(15);
            page.OpenGmailT().OpenGmailPage();
            page.composeEmailAndSend().ComposeEmailAndSendEmail(emialTextField);

            AssertElementContains.TextIsInElements(emialTextField, ComposeEmialPage.emailSubjects);
            page.signOut().SignOutFromGmail();
        }

       
    }
}
