echo going to process crawler results

set SaxonDir=..\Saxon
set SaxonBin=%SaxonDir%\Transform.exe
set NUnitResultPath=..\..\Results\

set CrawlerResultXmlFile=CrawlResult.xml
set CrawlerXSLT=CrawlingResults.xslt
set CrawlerResultHtmlFile=CrawlResult.html

%SaxonBin% %NUnitResultPath%%CrawlerResultXmlFile% %CrawlerXSLT% > %NUnitResultPath%%CrawlerResultHtmlFile%