@echo off

if "x%1" == "x" (
 goto ERROR
)

if "x%2" == "x" (
 goto ERROR
)

set NUnitResultFile=%1
set SaxonDir=..\Saxon
set SaxonBin=%SaxonDir%\Transform.exe
set NUnitResultPath=..\..\Results\
set ResultHtmlXSLT=AFTestResults.xslt
rem set ResultHtml=AFTestResults.html
set ResultHtml=%2

%SaxonBin% %NUnitResultFile% %ResultHtmlXSLT% > %NUnitResultPath%%ResultHtml%

set FailedTestHtmlXSLT=FailedTests.xslt
set FailedResultHtml=FailedTests.html

%SaxonBin% %NUnitResultFile% %FailedTestHtmlXSLT% > %NUnitResultPath%%FailedResultHtml%

goto EXIT

:ERROR
echo Invalid arguments: NUnitResultFile or ResultHtml

:EXIT