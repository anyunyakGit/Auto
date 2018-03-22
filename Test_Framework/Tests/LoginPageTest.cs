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

        [TestCase("nunyakandriy@gmail.com", "Andriy1989", "Newly generated text for email ", "New text for subject ")]
        [TestCase("nunyakandriygit@gmail.com", "&n|{dL-5", "Newly generated text for email", "New text for subject second one")]
        public void LoginTest(string email, string password, string emailTextField, string subject)
        {
            page.loginPagePO().LoginToApplication(email, password);

            page.OpenGmailT().OpenGmailPage();
            page.composeEmailAndSend().ComposeEmailAndSendEmail(email, emailTextField, subject );

            AssertElementContains.TextIsInElements(emailTextField, ComposeEmialPage.emailSubjects);
            page.signOut().SignOutFromGmail();
        }
    }
}
