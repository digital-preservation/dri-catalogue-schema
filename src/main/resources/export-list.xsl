<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes"/>
    
    <xsl:variable name="tna-uri-root" select="'http://nationalarchives.gov.uk/dri/catalogue/item/'"/>
        
    <xsl:key name="items-by-parent" match="/result/items/item" use="string(./dri_parent/@href)" />
    <xsl:key name="items-by-href" match="/result/items/item" use="string(./@href)" />
    
    <xsl:template name="members">
        <xsl:for-each select="item">
            <xsl:variable name="item-reference" select="key('items-by-href', string(./@href))"/>
            <xsl:variable name="item-uri" select="string(@href)"/>
            <item>
                <uuid>
                    <xsl:value-of select="substring-after($item-uri, $tna-uri-root)"></xsl:value-of>
                </uuid>
                <name>
                    <xsl:value-of select="$item-reference/reference/item/text()"/>
                </name>
                
                <type>
                   <xsl:choose>
                       <xsl:when test="exists($item-reference/dri_parent)">
                           <xsl:text>du</xsl:text>
                       </xsl:when>
                       <xsl:otherwise>
                           <xsl:text>collectiondu</xsl:text>
                       </xsl:otherwise>
                   </xsl:choose> 
                </type>
                <xsl:variable name="children" select="key('items-by-parent', $item-uri)"/>
                <xsl:if test="$children">
                    <children>
                        <xsl:for-each select="$children">
                            <reference>
                                <xsl:value-of select="substring-after(string(@href), $tna-uri-root)"/>
                            </reference>
                        </xsl:for-each>
                    </children>
                </xsl:if>
            </item>            
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="result">
        <xsl:copy>
            <identifier>
                <xsl:text>uuid</xsl:text>
            </identifier>
            <label>
                <xsl:text>name</xsl:text>
            </label>
            <xsl:apply-templates/>
        </xsl:copy>        
    </xsl:template>
   
    <xsl:template match="items">
        <xsl:copy>            
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
   
    <xsl:template match="definition | extendedMetadataVersion | first | isPartOf | itemsPerPage | next | page | startIndex | type | dri_username | dct_created | item/reference/item">
        <!-- do nothing -->
    </xsl:template>
    
    <xsl:template match="rdfs_member">
        <xsl:call-template name="members"/>
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>