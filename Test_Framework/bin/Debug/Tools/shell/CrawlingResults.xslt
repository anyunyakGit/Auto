<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:swi="http://www.solarwinds.com">
  <xsl:output method='html' doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  
  <!-- CrawlingResults.xslt v0.1 -->
  <!-- 0.1 - Initial release -->
    
  <xsl:template match="/">
    <xsl:variable name="CHART_PX">200</xsl:variable>
    <HTML xmlns:html="http://www.w3.org/Profiles/XHTML-transitional">
      <HEAD>
		<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.0/themes/base/jquery-ui.css" />
        <style type="text/css">
		body { font:normal 68% verdana,arial,helvetica; color:#000000; } 
		table { width: 100%; border: 1px solid black; border-collapse: collapse; }
		h1 { MARGIN: 0px 0px 5px; FONT: 165% verdana,arial,helvetica;} 
		h2 { MARGIN-TOP: 1em; MARGIN-BOTTOM: 0.5em; FONT: bold 125% verdana,arial,helvetica; padding:3px; background-color:orange;} 
		h3 { MARGIN-BOTTOM: 0.5em; FONT: bold 115% verdana,arial,helvetica; padding:3px; background-color:orange} 
		h4 { MARGIN-BOTTOM: 0.5em; FONT: bold 100% verdana,arial,helvetica; } 
		h5 { MARGIN-BOTTOM: 0.5em; FONT: bold 100% verdana,arial,helvetica 	} 
		h6 { MARGIN-BOTTOM: 0.5em; FONT: bold 100% verdana,arial,helvetica 	} 
		
		a:visited, .collapsingLink, a { color: #0000ff; } 
		a:active, a:hover, collapsingLink:hover { color: #ff0000; text-decoration: underline;} 
		.webPageUrl, .overalTrue, .validationTrue, .overalFalse, .validationFalse { font-weight: bold; }
		.overalTrue, .validationTrue { color: green;}
		.overalFalse, .validationFalse { color: red;}
		.collapsingLink {font-size: 10px;}
		.collapsingLink:hover {cursor: pointer;}
		.tableHeader { background-color: #D3D3D3;}
		.ui-icon { float: left;}
		</style>
		<script src="http://code.jquery.com/jquery-1.9.0.min.js"></script>
		<script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
		<script type="text/javascript">
		//<![CDATA[
		$(document).ready(function () {
			$(".collapsingLink").each( function(index) {
				$(this).click( function() {
					$(this).next().toggle();
					$(this).children(".ui-icon").toggleClass("ui-icon-triangle-1-e ui-icon-triangle-1-s");
				});
			});
			$(".referrerList").hide();
		}); 
		//]]>
		</script>
      </HEAD>
      <body text="#000000" bgColor="#ffffff">
        <a name="top"></a>
        <h1>Web crawler results</h1>
        <hr size="1"></hr>
        
        <xsl:for-each select="/CrawlResults/CrawlResult">
		<table>
			<tr class="tableHeader">
				<td>
				<xsl:variable name="pageUrl">
					<xsl:value-of select="./@location" />
				</xsl:variable>
				Page location : <span class="webPageUrl"><a href="{$pageUrl}"><xsl:value-of select="$pageUrl"/></a></span>
				</td>
			</tr>
			<xsl:if test="count(./ValidationResults) > 0">
			<xsl:variable name="overalResult">
				<xsl:value-of select="./ValidationResults/@successful" />
			</xsl:variable>
			<tr>
				<td>
				Validation results - overal <span class="overal{$overalResult}"><xsl:value-of select="$overalResult" /></span>, execution time <xsl:value-of select="./ValidationResults/@executionTime"/>ms
				<xsl:if test="count(./ValidationResults/ValidationResult) > 0">
					<ul>
					<xsl:for-each select="./ValidationResults/ValidationResult">
					<xsl:variable name="validationlResult">
						<xsl:value-of select="./@successful" />
					</xsl:variable>
					<li><span class="validation{$validationlResult}"><xsl:value-of select="$validationlResult" /></span> - <xsl:value-of select="./@message"/></li>
					</xsl:for-each>
					</ul>
				</xsl:if>
				</td>
			</tr>
			</xsl:if>
			<xsl:if test="count(./Parents/Url) > 0">
			<tr>
				<td>
				Referred from:<br />
				<span class="collapsingLink"><span class="ui-icon ui-icon-triangle-1-e" />Hide/collapse URLs</span>
				<ul class="referrerList">
				<xsl:for-each select="./Parents/Url">
					<xsl:variable name="pageUrl">
						<xsl:value-of select="." />
					</xsl:variable>
					<xsl:variable name="pageDescription">
						<xsl:if test="@linkDescription and string-length(@linkDescription)>0">
						  [<xsl:value-of select="@linkDescription"/>]
						</xsl:if>
					</xsl:variable>
					<li><a href="{$pageUrl}"><xsl:value-of select="$pageUrl" /></a> <xsl:value-of select="$pageDescription" disable-output-escaping="yes"/></li>
				</xsl:for-each>
				</ul>
				</td>
			</tr>
			</xsl:if>
		</table>
		<a href="#top" >Back to top</a><br /><br />
		</xsl:for-each>
      </body>
    </HTML>
  </xsl:template>
</xsl:stylesheet>