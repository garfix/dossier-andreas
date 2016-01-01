<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
                extension-element-prefixes="xt">

<xsl:include href="file:Style.xsl" />

<xsl:template match="/">
    <xsl:for-each select="//*[@id = 'changes']">
        <xsl:call-template name="onePage">
            <xsl:with-param name="person-id">p1</xsl:with-param>
            <xsl:with-param name="item-id" select="@id" />
        </xsl:call-template>
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
