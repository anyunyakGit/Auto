using NUnit.Framework;
using Test_Framework.Helpers;
using Test_Framework.Pages;

namespace Test_Framework
{
    [TestFixture]
    public class LoginPageTest : DriverHelper
    {

        private Page page = new Page();


        [SetUp]
        public void Init()
        {
            InitializeChrome();
            page.loginPagePO().LoginToApplication(DataHelper.userEmailValue, DataHelper.userPass);
        }

        [Test()]
        public void LoginTest()
        {
            string emialTextField = DataHelper.GenerateUniqueName(15);

            page.OpenGmailT().OpenGmailPage();
            page.composeEmailAndSend().ComposeEmailAndSendEmail(emialTextField);

            AssertElementContains.TextIsInElements(emialTextField, ComposeEmialPage.emailSubjects);
        }

        [TearDown]
        public void CleanUp()
        {
            page.signOut().SignOutFromGmail();
            Close();
        }
    }
}
