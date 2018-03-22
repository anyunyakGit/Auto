using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Linq;
using Test_Framework.Helpers;

namespace Test_Framework
{
    public class DataHelper : DriverHelper
    {
        static Random r = new Random();

        public static int Select_Random_Value()
        {
            int value = r.Next(1, 2);
            return value;
        }

        public static string userEmailValue = "nunyakandriy@gmail.com";
        public static string userPass = "Andriy1989";
        public static string GenerateUniqueName(int Lenght)
        {
            var chars = "abcdefghijklmnopqrstuvwxyz0123456789";
            return new string(chars.Select(c => chars[r.Next(chars.Length)]).Take(Lenght).ToArray());
        }
    }
}

