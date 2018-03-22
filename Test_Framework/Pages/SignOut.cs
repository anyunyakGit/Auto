using OpenQA.Selenium;

namespace Test_Framework.Pages
{
   public class SignOut : SignOutPage
    {
        public  void SignOutFromGmail ()
        {
            ClickOnButton(signOutIcon);
            WaitForElement(signOutButton);
            ClickOnButton(signOutButton);
        }
    }

    public class SignOutPage : CommonMethodHelper
    {
        public readonly By signOutIcon  = By.CssSelector("span.gb_db.gbii");
        public readonly By signOutButton = By.Id("gb_71");
    }
}
