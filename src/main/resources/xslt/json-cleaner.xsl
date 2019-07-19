<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:j="http://www.w3.org/2013/XSL/json"
    exclude-result-prefixes="xs"
    expand-text="yes"
    version="3.0">
    
    <xsl:output method="text" media-type="text/json" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
    <!--<xsl:output indent="yes"/>-->
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="Questionnaire">
       <!-- <xsl:variable name="testJSON">
            <xsl:value-of select="'{&quot;test&quot;:[[{&quot;coucou&quot;:true}],[{&quot;coucou&quot;:false}]]}'"/>
        </xsl:variable>-->
        <xsl:variable name="output-xml">
            <xsl:apply-templates select="json-to-xml(.)" mode="clean"/>
        </xsl:variable>
        <!--<xsl:copy-of select="$output-xml"/>-->
        <xsl:copy-of select="replace(xml-to-json($output-xml, map{'indent':true()}),'\\','')"/>
    </xsl:template>
    
    <!-- delete type attribute -->
    <xsl:template match="*[@key='type']" mode="clean"/>
    
    <!-- delete responses attribute in table responses for Table component -->
    <xsl:template match="*[@key='cells' and preceding-sibling::*[@key='componentType']]" mode="clean">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:for-each select="descendant::*[@key='cells']">
                <xsl:copy>
                    <xsl:apply-templates mode="clean"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*|node()" mode="clean">
        <xsl:choose>
            <xsl:when test="self::text()">
                <xsl:value-of select="." />
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()" mode="clean"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>