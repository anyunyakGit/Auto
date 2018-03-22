<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:swi="http://www.solarwinds.com">
  <xsl:output method='html' doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  
  <!-- FailedTest.xslt v1.0 -->
  <!-- 1.0 - Create HTML table with all failed TCs grouped by product to be used for investigation tracking -->
  
  <!-- Parse testID. -->
  <xsl:function name="swi:testID">
    <xsl:param name="testName"/>
    <xsl:analyze-string select="$testName" regex="\.TestCases\.([a-zA-Z_-]+)(\d+)([a-zA-Z]+)?\.">
        <xsl:matching-substring>
          <xsl:value-of select="concat(regex-group(1),'-',regex-group(2),regex-group(3))" />
        </xsl:matching-substring>  
      </xsl:analyze-string>
  </xsl:function>
  
  <!-- Parse testlink Prefix -->
  <xsl:function name="swi:testlinkPrefix">
    <xsl:param name="testName"/>
    <xsl:analyze-string select="$testName" regex="\.TestCases\.([a-zA-Z_-]+)(\d+)([a-zA-Z]+)?\.">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)" />
        </xsl:matching-substring>  
      </xsl:analyze-string>
  </xsl:function>
  
  <xsl:template match="/">
    <HTML xmlns:html="http://www.w3.org/Profiles/XHTML-transitional">
      <HEAD>
      </HEAD>
      <body>
        <h3>
          <span>List of Failed Tests for Investigation</span>
        </h3>
        <table border="1" cellpadding="2" cellspacing="0" width="50%">
          <tr align="center" valign="top" >
            <td width="10%">
              <b>Product</b>
            </td>
            <td width="15%">
              <b>TestCase ID</b>
            </td>
            <td width="10%">
              <b>Product Issue?</b>
            </td>
            <td width="65%">
              <b>Reason of Failure</b>
            </td>
          </tr>
          <xsl:for-each select="/test-results//test-case[@success='False']">
          <tr valign="top">
            <td><xsl:value-of select="swi:testlinkPrefix(@name)" /></td>
            <td><xsl:value-of select="swi:testID(@name)" /></td>
            <td> </td>
            <td> </td>
          </tr>
          </xsl:for-each> 
        </table>
      </body>
    </HTML>
  </xsl:template>
</xsl:stylesheet>