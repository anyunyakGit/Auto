<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:swi="http://www.solarwinds.com">
  <xsl:variable name="CHART_PX">200</xsl:variable>
  <xsl:output method='html' doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  
  <!-- AFTestResults.xslt v4.4 -->
  <!-- 4.4 - changed test counts, changed grouping of classes/methods, ui improvements, collapsing buttons -->
  <!-- 4.3 - test case grouping and small UI changes -->
  <!-- 4.2 - added support for inconclusive tests, little css refactor, better test anchor colors -->
  <!-- 4.1.1 - modified regexs for testID to accept also some chars after TC number, FB154096 -->
  <!-- 4.1 - Take <test-suite type="TestFixture"><failure>  message and stack trace for all TCs 
             containing "TestFixtureSetUp failed in" -->
  <!-- 4.0 - Ignored status handling added for skipped TCs (related to known issues)-->
  <!-- 3.1 - HTML tags inside failed TC message and stack-trace elements applied by
             disable-output-escaping="yes" parameter -->
  <!-- 3.0 - Link to testlink automatically generated in the template-->
  
  <!-- Parse testID. -->
  <xsl:variable name="testNameRegex">([a-zA-Z_-]+)(\d+)([a-zA-Z0-9]+)?$</xsl:variable>
  <xsl:function name="swi:testID">
    <xsl:param name="testName"/>
    <xsl:analyze-string select="$testName" regex="{$testNameRegex}">
        <xsl:matching-substring>
          <xsl:value-of select="concat(regex-group(1),'-',regex-group(2),regex-group(3))" />
        </xsl:matching-substring>  
      </xsl:analyze-string>
  </xsl:function>

  <xsl:variable name="fullClassnameRegex">(.*[\.])</xsl:variable>
  <xsl:function name="swi:getClassName">
    <xsl:param name="testName"/>
    <xsl:analyze-string select="$testName" regex="{$fullClassnameRegex}">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)" />
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:function>
  
  <!-- Parse testID for testlink. -->
  <xsl:function name="swi:testIDShort">
    <xsl:param name="testName"/>
    <xsl:analyze-string select="$testName" regex="{$testNameRegex}">
        <xsl:matching-substring>
          <xsl:value-of select="concat(regex-group(1),'-',regex-group(2))" />
        </xsl:matching-substring>  
      </xsl:analyze-string>
  </xsl:function>
  
  <!-- Parse testlink Prefix -->
  <xsl:function name="swi:testlinkPrefix">
    <xsl:param name="testName"/>
    <xsl:analyze-string select="$testName" regex="{$testNameRegex}">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)" />
        </xsl:matching-substring>  
      </xsl:analyze-string>
  </xsl:function>
  
  <!-- Convert time -->
  <xsl:function name="swi:timeConvert">
    <xsl:param name="seconds"/>
      <xsl:value-of select="format-number($seconds idiv 3600,'00')" />:<xsl:value-of select="format-number(($seconds mod 3600) idiv 60,'00')" />:<xsl:value-of select="format-number($seconds mod 60,'00')" />
  </xsl:function>
  
  <!-- It removes teardown string in message -->
  <xsl:function name="swi:removeTeardown">
	<xsl:param name="input"/>
	<xsl:value-of select="replace($input,'(^SetUp\s+:\s+)|(TearDown\s+:\s+)','','si')" />
  </xsl:function>
  
  <!-- It creates nice bargraph with success rate in red/green/blue -->
  <xsl:template name="swi:barGraph">
	<xsl:param name="total"/>
	<xsl:param name="successRate"/>
	<xsl:param name="inconclusive"/>
	<xsl:variable name="successRateChart">
	  <xsl:value-of select="$CHART_PX*($successRate) idiv 100" />
	</xsl:variable>  
	<xsl:variable name="inconclusiveRateChart">
	  <xsl:value-of select="$CHART_PX*($inconclusive) idiv 100" />
	</xsl:variable> 
	<xsl:choose>
		<xsl:when test="$total = 0">
		  <span class="ignored" style="padding-left:{$CHART_PX - $successRateChart}px"></span>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:choose>
			<xsl:when test="$successRateChart=$CHART_PX">
			  <span class="covered" style="padding-left:{$successRateChart}px"></span>
			</xsl:when>
			<xsl:when test="$successRateChart>0">
			  <span class="covered" style="border-right: 0px; padding-left:{$successRateChart}px"></span>
			</xsl:when>
		  </xsl:choose>
		  <xsl:choose>
			<xsl:when test="$inconclusiveRateChart>0">
			  <span class="inconclusive" style="border-left: 0px; border-right: 0px; padding-left:{$inconclusiveRateChart}px"></span>
			</xsl:when>
		  </xsl:choose>
		  <xsl:choose>
			<xsl:when test="($successRateChart+$inconclusiveRateChart)=0">
			  <span class="uncovered" style="padding-left:{$CHART_PX}px"></span>
			</xsl:when>
			<xsl:when test="$CHART_PX>$successRateChart+$inconclusiveRateChart">
			  <span class="uncovered" style="border-left: 0px; padding-left:{$CHART_PX - $successRateChart - $inconclusiveRateChart}px"></span>
			</xsl:when>
		  </xsl:choose>
		</xsl:otherwise>
	  </xsl:choose>
  </xsl:template>
  <xsl:template match="/">
    <HTML xmlns:html="http://www.w3.org/Profiles/XHTML-transitional">
      <HEAD>
		<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.0/themes/base/jquery-ui.css" />
        <style type="text/css">
		body { font:normal 68% verdana,arial,helvetica; color:#000000; } 
		span.covered { background: #00df00; border:#9c9c9c 1px solid; } 
		span.uncovered { background: #df0000; border:#9c9c9c 1px solid; } 
		span.ignored { background: #efefef; border:#9c9c9c 1px solid; } 
		span.inconclusive { background: #0000DF; border:#9c9c9c 1px solid; 	} 
		
		table { border-collapse: collapse;}
		td { FONT-SIZE: 100%; BORDER-BOTTOM: #dcdcdc 1px solid; BORDER-RIGHT: #dcdcdc 1px solid; } 
		p { line-height:1.5em; margin-top:0.5em; margin-bottom:1.0em; } 
		h1 { MARGIN: 0px 0px 5px; FONT: 165% verdana,arial,helvetica;} 
		h2 { MARGIN-TOP: 1em; MARGIN-BOTTOM: 0.5em; FONT: bold 125% verdana,arial,helvetica; padding:3px;} 
		h3 { MARGIN-BOTTOM: 0.5em; FONT: bold 115% verdana,arial,helvetica; padding:3px;} 
		h4 { MARGIN-BOTTOM: 0.5em; FONT: bold 100% verdana,arial,helvetica; } 
		h5 { MARGIN-BOTTOM: 0.5em; FONT: bold 100% verdana,arial,helvetica 	} 
		h6 { MARGIN-BOTTOM: 0.5em; FONT: bold 100% verdana,arial,helvetica 	} 
		
		.Error { font-weight:bold; color:red } 
		.Failure { font-weight:bold; color:red; } 		
		.Inconclusive { padding-left:2px; color:#0000DF; } 
		.Ignored { padding-left:2px; } 
		.FailureDetail { font-size: -1; background:#cdcdcd; padding-left: 1em; } 
		.Pass { padding-left:2px; } 
		.TableHeader { background: #efefef; color: #000; font-weight: bold; horizontal-align: center; } 
		.description { margin-top:1px; padding:3px; background-color:#dcdcdc; color:#000; font-weight:normal; } 
		.method { color:#000; font-weight:normal; padding-left:5px; } 
		
		a:visited { color: #0000df; } 
		a { color: #0000df; } 
		a:active { color: #800000; } 
		a.summarie { color:#000; text-decoration: none; } 
		a.summarie:active { color:#000; text-decoration: none; } 
		a.summarie:visited { color:#000; text-decoration: none; } 
		a.method{ text-decoration: none; color:#000; font-weight:normal; padding-left:5px; } 
		a.Failure, a.Failure:visited, a.Failure:visited { color:red; text-decoration: underline; } 
		a.Pass, a.Pass:visited, a.Pass:active { color: #02AD02;  text-decoration: underline}
		a.Ignored, a.Ignored:visited, a.Ignored:visited { color: #BFBFBF; text-decoration: underline}
		a.error { font-weight:bold; color:red; } 
		a.error:visited { font-weight:bold; color:red; } 
		a.error:active { font-weight:bold; color:red; /*text-decoration: none; padding-left:5px;*/ } 
		a.ignored { font-weight:bold; text-decoration: none; padding-left:5px; } 
		a.ignored:visited { font-weight:bold; text-decoration: none; padding-left:5px; } 
		a.ignored:active { font-weight:bold; text-decoration: none; padding-left:5px; }
		a.resultButton { text-decoration: none; color:white; border-radius: 5px 5px 5px 5px; padding-left: 12px; padding-right: 12px; padding-bottom: 8px; padding-top: 8px; margin-right: 8px;}
		
		a.resultAll { background-color: #888888; background: linear-gradient(to bottom, #888888, #000000); background: -o-linear-gradient(to bottom, #888888, #000000); background: -moz-linear-gradient(to bottom, #888888, #000000); background: -webkit-linear-gradient(to bottom, #888888, #000000); background: -webkit-gradient(linear, center top, center bottom, from(#888888), to(#000000));}
		a.resultPass { background-color: #00df00; background: linear-gradient(to bottom, #00df00, #51A351); background: -o-linear-gradient(to bottom, #00df00, #51A351); background: -moz-linear-gradient(to bottom, #00df00, #51A351); background: -webkit-linear-gradient(to bottom, #00df00, #51A351); background: -webkit-gradient(linear, center top, center bottom, from(#00df00), to(#51A351)); }
		a.resultFailure { background-color: #df0000; background: linear-gradient(to bottom, #df0000, #BD362F); background: -o-linear-gradient(to bottom, #df0000, #BD362F); background: -moz-linear-gradient(to bottom, #df0000, #BD362F); background: -webkit-linear-gradient(to bottom, #df0000, #BD362F); background: -webkit-gradient(linear, center top, center bottom, from(#df0000), to(#BD362F)); }
		a.resultInconclusive { background-color: #0088CC; background: linear-gradient(to bottom, #0088CC, #0000DF); background: -o-linear-gradient(to bottom, #0088CC, #0000DF); background: -moz-linear-gradient(to bottom, #0088CC, #0000DF); background: -webkit-linear-gradient(to bottom, #0088CC, #0000DF); background: -webkit-gradient(linear, center top, center bottom, from(#0088CC), to(#0000DF)); }
		a.resultIgnored { background-color: #efefef; background: linear-gradient(to bottom, #efefef, #dcdcdc); color: black; background: -o-linear-gradient(to bottom, #efefef, #dcdcdc); background: -moz-linear-gradient(to bottom, #efefef, #dcdcdc); background: -webkit-linear-gradient(to bottom, #efefef, #dcdcdc); background: -webkit-gradient(linear, center top, center bottom, from(#efefef), to(#dcdcdc)); }
		
		td.buttonCell { padding-top: 12px; background-color: white; font-weight: normal;}
		.TestDetailBlock { margin-top: 4px; border: 1px solid #E3E3E3;}
		.TestDetailBlock h3 { margin: 0px; background-color: #efefef;}
		.topLink { margin: 5px 0px 0px 0px }
		.clickable { color: blue; margin-bottom: 2px; }
		.clickable:hover { text-decoration: underline; cursor: pointer; }
		.errorMessage { font-weight: bold; }
		.ui-icon { float: left;}
		.text { vertical-align: middle; }
		.indentLeft { color: #666; padding-left: 1em;}
		</style>
		<script src="http://code.jquery.com/jquery-1.9.0.min.js"></script>
		<script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
		<script type="text/javascript">
		//<![CDATA[
		function showAll() {
			$(".TestDetailBlock").show();
			$(".TestDetailRow").show();
			if ($('#showDetailsChb').is(':checked')) {
				$(".TestDescriptionRow").show();
			}
		}
		
		function showOnly(resultType) {
			$(".TestDetailBlock").each( function(index) {
				if ($(this).hasClass('Result' + resultType)) {
					$(this).show();
				} else {
					$(this).hide();
				}
			});
			$(".TestDetailRow").each( function(index) {
				if ($(this).hasClass('Result' + resultType)) {
					$(this).show();
				} else {
					$(this).hide();
				}
			});
			var showDescr = $('#showDetailsChb').is(':checked');
			$(".TestDescriptionRow").each( function(index) {
				if ($(this).hasClass('Result' + resultType) && showDescr) {
					$(this).show();
				} else {
					$(this).hide();
				}
			});
		}
		$(document).ready(function () {
			$(".FailureDetail > .collapsable").each( function(index) {
				var hideElement = $('<div>', { class : "clickable"});
				hideElement.append($('<span>', { class: "ui-icon ui-icon-triangle-1-s" }));
				hideElement.append($('<span>', { class: "text" }));
				hideElement.click( function() {
					var textNode = $(this).children(".text");
					if ($(this).parent().children(".collapsable").is(":visible")) {
						textNode.text("Show test messages");
					} else {
						textNode.text("Hide test messages");
					}
					$(this).children(".ui-icon").toggleClass("ui-icon-triangle-1-e ui-icon-triangle-1-s");
					$(this).parent().children(".collapsable").toggle();
				});
				$(this).parent().prepend(hideElement);
				if ($(this).hasClass('collapsed')) {
					hideElement.click();
				} else {
					hideElement.text("- Hide test messages");
				}
				
			});
			$(".errorMessage").each( function(index) {
				if ($(this).has("span:not([style*='color: red;'])").length) {
					var hideElement = $('<div>', { class : "clickable"});
					hideElement.append($('<span>', { class: "ui-icon ui-icon-triangle-1-s" }));
					hideElement.append($('<span>', { class: "text" }));
					hideElement.click( function() {
						var parentElem = $(this).parent().children(".errorMessage");
						var textNode = $(this).children(".text");
						if (parentElem.children(".okMessage").is(":visible")) {
							textNode.text("Show all messages");
							
						} else {
							textNode.text("Hide non-error messages");
						}
						$(this).children(".ui-icon").toggleClass("ui-icon-triangle-1-e ui-icon-triangle-1-s");
						parentElem.children(".okMessage,.okMessage + br,.okMessage + br + br").toggle();
					});
					$(this).parent().prepend(hideElement);
					$(this).children("span:not([style*='color: red;'])").addClass("okMessage");
					hideElement.click();
				}	
			});
			
			
			$('#showDetailsChb').change( function() {
				if ($(this).is(":checked")) {
					$(".TestDescriptionRow").each(function(index) {
						if ($(this).prev().is(":visible")) {
							$(this).show();
						}
					});
				} else {
					$(".TestDescriptionRow").hide();
				}
			});
			
			$("td:empty").remove();
			showOnly('Failure');
		})
		
		//]]>
		</script>
      </HEAD>
      <body text="#000000" bgColor="#ffffff">
        <a name="top"></a>
        <h1>
          <span>SolarWinds AF Tests Results</span> - Report</h1>
        <table width="100%">
          <tr>
            <td align="left">
              <span>Generated: </span><xsl:value-of select="/test-results/@date" /> - <xsl:value-of select="/test-results/@time" />
            </td>
            <td align="right">
              <a href="#envinfo">Environment Information</a>
            </td>
          </tr>
        </table>
        <hr size="1"></hr>
        
        <!-- SUMMARY PART -->
        <xsl:variable name="totalTestCount"><xsl:value-of select="count(//test-suite[@type='TestFixture' and ./results/test-case])" /></xsl:variable>
		<xsl:variable name="successTestCount"><xsl:value-of select="count(//test-suite[@type='TestFixture' and @result='Success' and ./results/test-case])" /></xsl:variable>
		<xsl:variable name="failureTestCount"><xsl:value-of select="count(//test-suite[@type='TestFixture' and @executed='True' and not(@result='Success') and not(@result='Inconclusive') and ./results/test-case])" /></xsl:variable>
		<xsl:variable name="inconclusiveTestCount"><xsl:value-of select="count(//test-suite[@type='TestFixture' and @result='Inconclusive' and ./results/test-case])" /></xsl:variable>
		<xsl:variable name="skippedTestCount"><xsl:value-of select="count(//test-suite[@type='TestFixture' and @executed='False' and ./results/test-case])" /></xsl:variable>
        <h2>Summary</h2>
        <table border="0" cellpadding="2" cellspacing="0" width="100%" style="border: #dcdcdc 1px solid;">
          <tr valign="top" class="TableHeader">
            <td rowspan="2" class="buttonCell">
              <a href="#" onclick="showAll();" class="resultButton resultAll">All Tests - <b><xsl:value-of select="$totalTestCount" /></b></a>
            
              <a href="#" onclick="showOnly('Pass');" class="resultButton resultPass">Successes - <b><xsl:value-of select="$successTestCount" /></b></a>
            
              <a href="#" onclick="showOnly('Failure');" class="resultButton resultFailure">Failures - <b><xsl:value-of select="$failureTestCount" /></b></a>
            
              <a href="#" onclick="showOnly('Inconclusive');" class="resultButton resultInconclusive">Inconclusive - <b><xsl:value-of select="$inconclusiveTestCount" /></b></a>
            
              <a href="#" onclick="showOnly('Ignored');" class="resultButton resultIgnored">Skipped - <b><xsl:value-of select="$skippedTestCount" /></b></a>
            </td>
            <td style="width:250px" colspan="2">
              <b>Success Rate</b>
            </td>
            <td style="width:80px" nowrap="nowrap">
              <b>Time</b>
            </td>
          </tr>
          <xsl:variable name="SummaryResultClass">
           <xsl:choose>
              <xsl:when test="$failureTestCount > 0">Failure</xsl:when>
              <xsl:otherwise>Pass</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <tr valign="top">
            <xsl:variable name="SummaryResultSuccessRate">
              <xsl:choose>
                <xsl:when test="$totalTestCount != 0">
                  <xsl:value-of select="format-number(100 - 100*(($failureTestCount + $inconclusiveTestCount) div $totalTestCount),'0')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="0" />
                </xsl:otherwise>
              </xsl:choose>              
            </xsl:variable>
			<xsl:variable name="SummaryResultInconclusiveRate">
              <xsl:choose>
                <xsl:when test="$inconclusiveTestCount != 0">
                  <xsl:value-of select="format-number(100*($inconclusiveTestCount div $totalTestCount),'0')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="0" />
                </xsl:otherwise>
              </xsl:choose>              
            </xsl:variable> 
            <td class="{$SummaryResultClass}" nowrap="nowrap" align="right" style="width:40px"><xsl:value-of select="$SummaryResultSuccessRate" /> %</td>
            <td style="width:210px"> 
			  <xsl:call-template name="swi:barGraph">
			    <xsl:with-param name="total"><xsl:value-of select="$totalTestCount" /></xsl:with-param>
				<xsl:with-param name="successRate"><xsl:value-of select="$SummaryResultSuccessRate" /></xsl:with-param>
				<xsl:with-param name="inconclusive"><xsl:value-of select="$SummaryResultInconclusiveRate" /></xsl:with-param>
			  </xsl:call-template>
            </td>
            <td><xsl:value-of select="swi:timeConvert(sum(/test-results/test-suite[@type='Project']/@time))" /></td>
          </tr>
        </table>
        <hr size="1" width="100%" align="left"></hr>
        
        <!-- PRODUCTS SUMMARY PART -->
        
        <h2>Products Summary</h2>
        <table border="0" cellpadding="2" cellspacing="0" width="100%">
          <tr class="TableHeader" valign="top" >
            <td width="39%" colspan="1">
              <b>Name</b>
            </td>
            <td width="26%" colspan="2">
              <b>Success Rate</b>
            </td>
            <td width="7%">
              <b>Tests</b>
            </td>
            <td width="7%">
              <b>Successes</b>
            </td>
            <td width="7%">
              <b>Failures</b>
            </td>
			<td width="7%">
              <b>Inconclusives</b>
            </td>
            <td width="7%">
              <b>Skipped</b>
            </td>
            <td width="7%" nowrap="nowrap">
              <b>Time</b>
            </td>
          </tr>
          <xsl:for-each select="/test-results//test-suite[@type='Namespace']">  
            <xsl:if test="count(.//test-case)>0">    
              <xsl:variable name="ProductSummaryTests">
                <xsl:value-of select="count(.//test-suite[@type='TestFixture']) - count(.//test-suite[@type='TestFixture' and @result='Ignored'])" />
              </xsl:variable>
              <xsl:variable name="ProductSummaryResultClass">
                <xsl:choose>
                  <xsl:when test="$ProductSummaryTests=0">Ignored</xsl:when>
                  <xsl:when test="@success='False'">Failure</xsl:when>
                  <xsl:otherwise>Pass</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              
              <xsl:variable name="ProductSummaryErrors">
                <xsl:value-of select="count(.//test-suite[@type='TestFixture' and (@result='Error' or @result='Failure')])" />
              </xsl:variable>
              <xsl:variable name="ProductSummarySuccesses">
                <xsl:value-of select="count(.//test-suite[@type='TestFixture' and @result='Success'])" />
              </xsl:variable>
			  <xsl:variable name="ProductSummaryInconclusives">
                <xsl:value-of select="count(.//test-suite[@type='TestFixture' and @result='Inconclusive'])" />
              </xsl:variable>
              <xsl:variable name="ProductSummaryIgnores">
                <xsl:value-of select="count(.//test-suite[@type='TestFixture' and @result='Ignored'])" />
              </xsl:variable>
              <xsl:variable name="ProductSummarySuccessRate">
                <xsl:choose>
                  <xsl:when test="$ProductSummaryTests != 0">
                    <xsl:value-of select="format-number(100*($ProductSummarySuccesses div $ProductSummaryTests),'0')" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="0" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable> 
			  <xsl:variable name="ProductSummaryInconclusiveRate">
                <xsl:choose>
                  <xsl:when test="$ProductSummaryTests != 0">
                    <xsl:value-of select="format-number(100*($ProductSummaryInconclusives div $ProductSummaryTests),'0')" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="0" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable> 
            
              <tr valign="top">
                <td>
                  <a class="{$ProductSummaryResultClass}" href="#{(.//test-case)[1]/@name}"><xsl:value-of select="@name" /></a>
                </td>
                <td class="{$ProductSummaryResultClass}" nowrap="nowrap" width="7%" align="right">
                  <xsl:value-of select="$ProductSummarySuccessRate" /> %
                </td>
                <td>
				  <xsl:call-template name="swi:barGraph">
					<xsl:with-param name="total"><xsl:value-of select="$ProductSummaryTests" /></xsl:with-param>
					<xsl:with-param name="successRate"><xsl:value-of select="$ProductSummarySuccessRate" /></xsl:with-param>
					<xsl:with-param name="inconclusive"><xsl:value-of select="$ProductSummaryInconclusiveRate" /></xsl:with-param>
				  </xsl:call-template> 
                </td>
                <td><xsl:value-of select="$ProductSummaryTests" /></td>
                <td><xsl:value-of select="$ProductSummaryTests - ( $ProductSummaryErrors++$ProductSummaryInconclusives )" /></td>
                <td class="{$ProductSummaryResultClass}"><xsl:value-of select=" + $ProductSummaryErrors" /></td>
				<td><xsl:value-of select="$ProductSummaryInconclusives" /></td>
                <td><xsl:value-of select="$ProductSummaryIgnores" /></td>
                <td><xsl:value-of select="swi:timeConvert(@time)" /></td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </table>
        
		<!-- TEST CASE DETAILS PART -->
		<table width="100%">
		<tr>
		  <td style="border-width: 0px; text-align: left;">
		    <h2>Testcase details</h2>
		  </td>
		  <td style="border-width: 0px; text-align: right;">
		    <input type="checkbox" id="showDetailsChb" checked="checked"/><label for="showDetailsChb">Show test class description</label>
		  </td>
		</tr>
		</table>
		
        <xsl:for-each select="/test-results//test-suite[@type='TestFixture']">
        <xsl:variable name="TestCaseResultClass">
          <xsl:choose>
			<xsl:when test="@result='Ignored'">Ignored</xsl:when>
			<xsl:when test="@result='Inconclusive'">Inconclusive</xsl:when>
            <xsl:when test="@success='False' and @result!='Inconclusive'">Failure</xsl:when>
            <xsl:otherwise>Pass</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
		<xsl:variable name="testcasesCount"><xsl:value-of select="count(.//test-case)"/></xsl:variable>
		<xsl:if test="$testcasesCount > 0">
		<div class="TestDetailBlock Result{$TestCaseResultClass}">
			<a name="{@name}" />
			 <xsl:variable name="tcName" select="swi:testID(@name)"/>
			<h3><xsl:if test="not($tcName)">Keywords </xsl:if>TestCase 
        <xsl:if test="$tcName"></xsl:if>    
      <xsl:value-of select="$tcName" /></h3>
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
			<xsl:variable name="TestCaseErrors">
			  <xsl:value-of select="count(.//test-case[@result='Error' or @result='Failure'])" />
			</xsl:variable>
			<xsl:variable name="TestCaseInconclusives">
			  <xsl:value-of select="count(.//test-case[@result='Inconclusive'])" />
			</xsl:variable>
			<xsl:variable name="TestCaseSuccessRate">
			  <xsl:value-of select="format-number(100 - 100*(($TestCaseErrors + $TestCaseInconclusives) div $testcasesCount),'0')" />
			</xsl:variable>
			<xsl:variable name="TestCaseInconclusiveRate">
			  <xsl:value-of select="format-number(100*($TestCaseInconclusives div $testcasesCount),'0')" />
			</xsl:variable>
			  <tr class="TableHeader" valign="top" >
				<td width="50%">
				  <xsl:if test="not(.//test-suite[@type='ParameterizedTest'])">
				  <b><a href="{concat('http://10.110.68.110/linkto.php?tprojectPrefix=',swi:testlinkPrefix(@name),'&amp;item=testcase&amp;id=',swi:testIDShort(@name))}">Link to testlink</a></b>   
          <b><a href="test_logs/{@name}.log" style="padding-left:5em">AF test log</a></b>
            </xsl:if>

            <xsl:if test="@success='False' and @result!='Inconclusive'">
              <b>
              <xsl:choose>
                <xsl:when  test="not(.//test-suite[@type='ParameterizedTest'])">
                  <a href="test_screenshots/{@name}.zip" style="padding-left:5em">Screenshots</a>        
                </xsl:when>
                <xsl:otherwise>
                   <a href="test_screenshots/KeywordScreenshots.zip" style="padding-left:5em">Screenshots</a>                 
                </xsl:otherwise>
              
              </xsl:choose>
              </b>       
            </xsl:if>  
				</td>  
				<td width="8%" class="{$TestCaseResultClass}" nowrap="nowrap">
				  <xsl:value-of select="@result" />
				</td>
				<td width="36%" nowrap="nowrap" style="padding-left:3px">
				  <xsl:call-template name="swi:barGraph">
					<xsl:with-param name="total"><xsl:value-of select="$testcasesCount" /></xsl:with-param>
					<xsl:with-param name="successRate"><xsl:value-of select="$TestCaseSuccessRate" /></xsl:with-param>
					<xsl:with-param name="inconclusive"><xsl:value-of select="$TestCaseInconclusiveRate" /></xsl:with-param>
				  </xsl:call-template> 
				</td>
				<td width="6%" nowrap="nowrap">
				  <xsl:choose>
					<xsl:when test="@time">
					  <xsl:value-of select="swi:timeConvert(@time)" />
					</xsl:when>  
					<xsl:otherwise>
					  <xsl:value-of select="swi:timeConvert(0)" />
					</xsl:otherwise>
				  </xsl:choose>
				</td>  
			  </tr>
			  <xsl:for-each select=".//test-case">
			    <xsl:variable name="TestResultClass">
				  <xsl:choose>
					<xsl:when test="@result='Ignored'">Ignored</xsl:when>
					<xsl:when test="@result='Inconclusive'">Inconclusive</xsl:when>
					<xsl:when test="@success='False' and @result!='Inconclusive'">Failure</xsl:when>
					<xsl:otherwise>Pass</xsl:otherwise>
				  </xsl:choose>
				</xsl:variable>
			    <tr class="TestDetailRow Result{$TestResultClass}">
				  <td class="{$TestResultClass}">
				    <span class="ui-icon ui-icon-play" />
				    <xsl:value-of select="@name" />
            <span>
              <xsl:if test="./ancestor::test-suite[@type='ParameterizedTest']">
                <b><a href="test_logs/{replace(swi:testIDShort(@name),'-','')}.log" style="padding-left:5em">AF test log</a></b>          
              </xsl:if>
            </span>
				  </td>
				  <xsl:choose>
					<xsl:when test="$testcasesCount=$TestCaseErrors or $testcasesCount=$TestCaseInconclusives or $TestCaseErrors+$TestCaseInconclusives=0">
					  <td colspan="2">
					  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text> 
					  </td>
					</xsl:when>
					<xsl:otherwise>
					  <td class="{$TestResultClass}">
						<xsl:value-of select="@result" />
					  </td>
					  <td>
						<xsl:variable name="testcaseSuccess">
						  <xsl:choose>
							<xsl:when test="@result='Success'">100</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						  </xsl:choose>
						</xsl:variable>
						<xsl:variable name="testcaseInconclusive">
						  <xsl:choose>
							<xsl:when test="@result='Inconclusive'">100</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						  </xsl:choose>
						</xsl:variable>
						<xsl:call-template name="swi:barGraph">
						  <xsl:with-param name="total">100</xsl:with-param>
						  <xsl:with-param name="successRate"><xsl:value-of select="$testcaseSuccess" /></xsl:with-param>
						  <xsl:with-param name="inconclusive"><xsl:value-of select="$testcaseInconclusive" /></xsl:with-param>
						</xsl:call-template>
					  </td>
					</xsl:otherwise>
				  </xsl:choose>
				  <td>
				    <xsl:choose>
					<xsl:when test="@time">
					  <xsl:value-of select="swi:timeConvert(@time)" />
					</xsl:when>  
					<xsl:otherwise>
					  <xsl:value-of select="swi:timeConvert(0)" />
					</xsl:otherwise>
				  </xsl:choose>
				  </td>
				</tr>
				<tr class="TestDescriptionRow Result{$TestResultClass}">
				  <td colspan="4" class="indentLeft">
				    <span class="ui-icon ui-icon-note" />
				    <xsl:value-of select="@description" />
				  </td>
				</tr>
				<tr class="TestDetailRow Result{$TestResultClass}">
				  <td colspan="4" class="FailureDetail">
				  <xsl:if test="@success='False'">
				    <xsl:choose>  <!-- Additional condition required for 4.1 version -->
					  <xsl:when test="contains(./failure/message,'TestFixtureSetUp failed in')">
					    <span class="errorMessage">
					    <xsl:value-of select="swi:removeTeardown(./failure/message)" disable-output-escaping="yes" /><br />
					    <xsl:value-of select="swi:removeTeardown(../../failure/message)" disable-output-escaping="yes" />
						</span>
					  </xsl:when>
					  <xsl:when test="@result='Inconclusive'">
					    <b><xsl:value-of select="swi:removeTeardown(./reason/message)" disable-output-escaping="yes" /></b>
					  </xsl:when>
					  <xsl:otherwise>
					    <span class="errorMessage">
					    <xsl:value-of select="swi:removeTeardown(./failure/message)" disable-output-escaping="yes" />
						</span>
					  </xsl:otherwise>
				    </xsl:choose> 
				  </xsl:if>
				  <xsl:if test="@result='Ignored'">
				    <xsl:value-of select="swi:removeTeardown(./reason/message)" disable-output-escaping="yes" />
				  </xsl:if> 
				  <xsl:if test="@result='Success' and ./reason/message">
				    <span class="collapsable collapsed">
				    <xsl:value-of select="swi:removeTeardown(./reason/message)" disable-output-escaping="yes" /><br />
				    </span>
				  </xsl:if> 
				  </td>
				</tr>
			  </xsl:for-each>
			</table>
			<div class="topLink"><a href="#top">Back to top</a></div>
		</div>
		</xsl:if>
        </xsl:for-each>
        
		<!-- TEST CATEGORIES SUMMARY PART -->
        
        <h2>Test Categories Summary</h2>
        <table border="0" cellpadding="2" cellspacing="0" width="100%">
          <tr class="TableHeader" valign="top" >
            <td width="39%" colspan="1">
              <b>Name</b>
            </td>
            <td width="26%" colspan="2">
              <b>Success Rate</b>
            </td>
            <td width="7%">
              <b>Tests</b>
            </td>
            <td width="7%">
              <b>Successes</b>
            </td>
			<td width="7%">
              <b>Failures</b>
            </td>
            <td width="7%">
              <b>Inconclusives</b>
            </td>
            <td width="7%">
              <b>Skipped</b>
            </td>
            <td width="7%" nowrap="nowrap">
              <b>Time</b>
            </td>
          </tr>
          <xsl:for-each select="/test-results//test-suite[@type='Namespace']">
            <xsl:variable name="ProjectName">
               <xsl:value-of select="@name" />
            </xsl:variable>               
            <xsl:for-each-group select=".//test-suite[@type='TestFixture']" group-by=".//category/@name" >
             <xsl:if test="$ProjectName != current-grouping-key()">
              <xsl:variable name="CategorySummaryTests">
                <xsl:value-of select="count(current-group()) - count(current-group()[@result='Ignored'])" />
              </xsl:variable>
              <xsl:variable name="CategorySummaryResultClass">
                <xsl:choose>
                  <xsl:when test="$CategorySummaryTests=0">Ignored</xsl:when>
                  <xsl:when test="count(current-group()[@success='False' and @result!='Inconclusive']) > 0">Failure</xsl:when>
				  <xsl:when test="count(current-group()[@success='False' and @result='Inconclusive']) > 0">Inconclusive</xsl:when>
                  <xsl:otherwise>Pass</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              
              <xsl:variable name="CategorySummarySuccesses">
                <xsl:value-of select="count(current-group()[@result='Success'])" />
              </xsl:variable>
              <xsl:variable name="CategorySummaryErrors">
                <xsl:value-of select="count(current-group()[@result='Error' or @result='Failure'])" />
              </xsl:variable>
			  <xsl:variable name="CategorySummaryInconclusives">
                <xsl:value-of select="count(current-group()[@result='Inconclusive'])" />
              </xsl:variable>
              <xsl:variable name="CategorySummaryIgnores">
                <xsl:value-of select="count(current-group()[@result='Ignored'])" />
              </xsl:variable>
              <xsl:variable name="CategorySummaryTimes">
                <xsl:value-of select="format-number(sum(current-group()/@time),'0.000')" />
              </xsl:variable>
                
              <xsl:variable name="CategorySummarySuccessRate">
                <xsl:choose>
                  <xsl:when test="$CategorySummaryTests != 0">
                    <xsl:value-of select="format-number(100*($CategorySummarySuccesses div $CategorySummaryTests),'0')" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="0" />
                  </xsl:otherwise>
                </xsl:choose>  
              </xsl:variable> 
			  <xsl:variable name="CategorySummaryInconclusiveRate">
                <xsl:choose>
                  <xsl:when test="$CategorySummaryTests != 0">
                    <xsl:value-of select="format-number(100*($CategorySummaryInconclusives div $CategorySummaryTests),'0')" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="0" />
                  </xsl:otherwise>
                </xsl:choose>  
              </xsl:variable>
			  
			  <xsl:variable name="CategorySummaryFailureClass">
			    <xsl:choose>
				  <xsl:when test="count(current-group()[@success='False' and @result!='Inconclusive']) > 0">Failure</xsl:when>
				  <xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			  </xsl:variable>
			  <xsl:variable name="CategorySummaryInconclusiveClass">
			    <xsl:choose>
				  <xsl:when test="count(current-group()[@success='False' and @result='Inconclusive']) > 0">Inconclusive</xsl:when>
				  <xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			  </xsl:variable>
              <tr valign="top">
                <td class="{$CategorySummaryResultClass}">
                  <span><xsl:value-of select="$ProjectName" />.<xsl:value-of select="current-grouping-key()" /></span>
                </td>
                <td class="{$CategorySummaryResultClass}" nowrap="nowrap" width="7%" align="right">
                  <xsl:value-of select="$CategorySummarySuccessRate" /> %
                </td>
                <td>
				  <xsl:call-template name="swi:barGraph">
					<xsl:with-param name="total"><xsl:value-of select="$CategorySummaryTests" /></xsl:with-param>
					<xsl:with-param name="successRate"><xsl:value-of select="$CategorySummarySuccessRate" /></xsl:with-param>
					<xsl:with-param name="inconclusive"><xsl:value-of select="$CategorySummaryInconclusiveRate" /></xsl:with-param>
				  </xsl:call-template> 
                </td>
                <td><xsl:value-of select="$CategorySummaryTests" /></td>
                <td><xsl:value-of select="$CategorySummaryTests - ( $CategorySummaryErrors + $CategorySummaryInconclusives )" /></td>
                <td class="{$CategorySummaryFailureClass}"><xsl:value-of select="$CategorySummaryErrors" /></td>
				<td class="{$CategorySummaryInconclusiveClass}"><xsl:value-of select="$CategorySummaryInconclusives" /></td>
                <td><xsl:value-of select="$CategorySummaryIgnores" /></td>
                <td><xsl:value-of select="swi:timeConvert($CategorySummaryTimes)" /></td>
              </tr>
             </xsl:if> 
            </xsl:for-each-group>       
          </xsl:for-each> 
        </table>
		
        <!-- ENVIRONMENT INFORMATION -->
        
        <hr size="1" width="100%" align="left"></hr>
        <a name="envinfo" ></a>
        <h2 >Environment Information</h2>
        <table border="0" cellpadding="5" cellspacing="2" width="100%" >
          <tr class="TableHeader">
            <td>Property</td>
            <td>Value</td>
          </tr>
          <tr>
            <td>Platform</td>
            <td><xsl:value-of select="/test-results/environment/@platform" /></td>
          </tr>
          <tr>
            <td>Operating System</td>
            <td><xsl:value-of select="/test-results/environment/@os-version" /></td>
          </tr>
          <tr>
            <td>.NET CLR Version</td>
            <td><xsl:value-of select="/test-results/environment/@clr-version" /></td>
          </tr>
          <tr>
            <td>Nunit Version</td>
            <td><xsl:value-of select="/test-results/environment/@nunit-version" /></td>
          </tr>
          <tr>
            <td>Machine Name</td>
            <td><xsl:value-of select="/test-results/environment/@machine-name" /></td>
          </tr>
          <tr>
            <td>Username</td>
            <td><xsl:value-of select="/test-results/environment/@user" /></td>
          </tr>
          <tr>
            <td>User Domain</td>
            <td><xsl:value-of select="/test-results/environment/@user-domain" /></td>
          </tr>
        </table>
        <a href="#top" >Back to top</a>
      </body>
    </HTML>
  </xsl:template>
</xsl:stylesheet>
