@echo off

if "x%1" == "x" (
 goto ERROR
)

if "x%2" == "x" (
 goto ERROR
)

if "x%3" == "x" (
 goto ERROR
)

set NUnitResultFile=%1
set SaxonDir=..\Saxon
set SaxonBin=%SaxonDir%\Transform.exe
set TestLinkXSLT=testlink.xslt
set NUnitResultPath=..\..\Results\
set TestLinkResult=%NUnitResultPath%\%2
set TestLinkIntegrationResult=%NUnitResultPath%\%3

%SaxonBin% %NUnitResultFile% %TestLinkXSLT% > %TestLinkResult%
%SaxonBin% %NUnitResultFile% %TestLinkXSLT% prefix=Integration > %TestLinkIntegrationResult%
goto EXIT

:ERROR
echo Invalid argument: NUnitResultFile or TestLinkResult or TestLinkIntegrationResult

:EXIT
rem call GenerateCrawlerResults.bat