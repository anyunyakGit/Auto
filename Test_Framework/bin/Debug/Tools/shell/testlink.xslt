<?xml version="1.0" encoding="UTF-8" ?>

<!--    testlink.xslt v3 - 02/18/2014 - Roman Monath
                      - fix http://dev-aus-jira-01.swdev.local/browse/AF-3584
                      - when selecting test-suite related to test case, preceding replaced by ancestor
        testlink.xslt v2 - 11/14/2013 - Roman Monath 
                      - test external-id is parsed from the test-suite element as the first parent of test-case element
                      - remove logic for integration property, we don't track integration testlink project any more -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:swi="http://www.solarwinds.com">
  <xsl:output method='xml' omit-xml-declaration='yes' indent='yes'/>
  
  <xsl:param name="prefix" select="'testlink_product_prefix'" />
   <!-- Parse testID. -->
  <xsl:function name="swi:testID">
    <xsl:param name="testName"/>
    <xsl:analyze-string select="$testName" regex="([a-zA-Z_-]+)(\d*)">
        <xsl:matching-substring>
          <xsl:value-of select="concat(regex-group(1),'-',regex-group(2))" />
        </xsl:matching-substring>  
      </xsl:analyze-string>
  </xsl:function>
  
  <xsl:template match="/">
    <results>
	<xsl:for-each select="//test-case/ancestor::test-suite[1]">
		  <testcase external_id="{swi:testID(@name)}">
			  <xsl:call-template name="test_body" />
			</testcase>     
	</xsl:for-each>
	</results>
  </xsl:template>
  
  <xsl:template name="test_body"> 
      <tester>automation</tester>
      <xsl:if test="@success='True'">
      <result>p</result>
        <notes>
          OS Version=<xsl:value-of select="/test-results/environment/@os-version" />
          Platform=<xsl:value-of select="/test-results/environment/@platform" />
          Machine Name=<xsl:value-of select="/test-results/environment/@machine-name" />
        </notes>
      </xsl:if>
      
      <xsl:if test="@success='False'">
        <result>f</result>
        <notes>
          <xsl:value-of select="failure/message" disable-output-escaping="no"/>
          <xsl:value-of select="failure/stack-trace" disable-output-escaping="no"/>
          OS Version=<xsl:value-of select="/test-results/environment/@os-version" />
          Platform=<xsl:value-of select="/test-results/environment/@platform" />
          Machine Name=<xsl:value-of select="/test-results/environment/@machine-name" />
        </notes>
      </xsl:if>
	  <xsl:if test="@executed='False'">
        <result>d</result>
        <notes>
          <xsl:value-of select="reason/message" disable-output-escaping="no"/>
          OS Version=<xsl:value-of select="/test-results/environment/@os-version" />
          Platform=<xsl:value-of select="/test-results/environment/@platform" />
          Machine Name=<xsl:value-of select="/test-results/environment/@machine-name" />
        </notes>
      </xsl:if>
  </xsl:template>
</xsl:stylesheet>