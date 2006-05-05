<?xml version="1.0" encoding="windows-1250" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:include href="style.xsl" />
    <xsl:param name="filter_name" />

    <xsl:template match="*" mode="content">
        <xsl:if test="not($filter_name)">
            <h1>Log Filters</h1>
            <p>
                The following filters are available. Click on a name for full reference.
            </p>
            <div class="noborder" style="width: 600px">
                <table class="listtable">
                    <xsl:call-template name="supportmatrixheader" />
                    <xsl:apply-templates select="//class[attribute/@id='T:NLog.FilterAttribute']" mode="list">
                        <xsl:sort select="attribute[@id='T:NLog.FilterAttribute']/argument[position()=1]/@value" />
                    </xsl:apply-templates>
                </table>
            </div>
        </xsl:if>
        <xsl:if test="$filter_name">
            <xsl:apply-templates select="//class[attribute/@id='T:NLog.FilterAttribute' and attribute/argument[position()=1]/@value=$filter_name]" mode="details">
                <xsl:sort select="attribute[@id='T:NLog.FilterAttribute']/argument[position()=1]/@value" />
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:template match="class" mode="list">
        <xsl:variable name="type_tag" select="attribute[@id='T:NLog.FilterAttribute']/argument[position()=1]/@value" />
        <tr>
            <td class="name"><a href="filter.{$type_tag}.html"><xsl:value-of select="$type_tag" /></a></td>
            <td class="description"><xsl:apply-templates select="documentation/summary" /></td>
            <xsl:call-template name="supportmatrixvalues" />
        </tr>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="summary">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="class" mode="details">
        <xsl:variable name="type_tag" select="attribute[@id='T:NLog.FilterAttribute']/argument[position()=1]/@value" />
        <h3><xsl:value-of select="$type_tag" /> Filter</h3>
        <hr size="1" />
        <h4>Defined in:</h4>
        <table class="definedin" cellspacing="0">
            <tr><td>Assembly:</td><td><xsl:value-of select="../../@name" /></td></tr>
            <tr><td>Class name:</td><td><xsl:value-of select="substring-after(@id,'T:')" /></td></tr>
        </table>
        <p><xsl:apply-templates select="documentation/summary" /></p>
        <xsl:if test="documentation/remarks">
            <h4>Remarks</h4>
            <xsl:apply-templates select="documentation/remarks" /><p/>
        </xsl:if>
        <h4>Parameters:</h4>
        <table class="paramtable">
            <tr>
                <th>Name</th>
                <th>Type</th>
                <th>Description</th>
            </tr>
            <xsl:apply-templates select="property" mode="parameter">
                <xsl:sort select="count(attribute[@id='T:NLog.Config.RequiredParameterAttribute'])" order="descending" />
                <xsl:sort select="@name" />
            </xsl:apply-templates>
        </table>
        <xsl:if test="documentation/example">
            <h4>Example:</h4>
            <xsl:apply-templates select="documentation/example" />
        </xsl:if>
        <xsl:if test="documentation/remarks">
            <h4>Remarks:</h4>
            <xsl:apply-templates select="documentation/remarks" />
        </xsl:if>
        <hr size="1" />
        <a href="filters.html">Back to the filter list.</a>
    </xsl:template>

    <xsl:template match="property[@set='false']" mode="parameter">
        <!-- ignore -->
    </xsl:template>

    <xsl:template match="property[@name='Name']" mode="parameter">
        <!-- ignore -->
    </xsl:template>

    <xsl:template match="property[@name='Type']" mode="parameter">
        <!-- ignore -->
    </xsl:template>

    <xsl:template match="property[@type='NLog.Layout']" mode="parameter">
        <!-- ignore -->
    </xsl:template>

    <xsl:template match="property" mode="parameter">
        <tr>
            <td class="parametername">
                <span>
                    <xsl:if test="attribute/@id='T:NLog.Config.RequiredParameterAttribute'">
                        <xsl:attribute name="class">required</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="@name" />
                </span>
            </td>
            <td class="parametertype">
                <nobr>
                    <xsl:call-template name="simple-type-name">
                        <xsl:with-param name="type" select="@type" />
                    </xsl:call-template>
                    <xsl:if test="attribute/@id='T:NLog.Config.AcceptsLayoutAttribute'">
                        &#160;<a href="layoutrenderers.html"><span class="acceptslayout" title="This parameter accepts layout specification. Click here to learn more about layouts.">${}</span></a>
                    </xsl:if>
                </nobr>
            </td>
            <td class="parametervalue">
                <xsl:apply-templates select="documentation/summary" />
                <br/>
                <xsl:if test="attribute[@name='System.ComponentModel.DefaultValueAttribute']">
                    <p>Default value is: <code><xsl:value-of select="attribute[@name='System.ComponentModel.DefaultValueAttribute']/property[@name='Value']/@value" /></code>.</p>
                </xsl:if>
                <xsl:if test="documentation/remarks">
                    <h4>Remarks</h4>
                    <p><xsl:apply-templates select="documentation/remarks" /></p>
                </xsl:if>
                <xsl:if test="documentation/example">
                    <h4>Example</h4>
                    <p><xsl:apply-templates select="documentation/example" /></p>
                </xsl:if>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="property[attribute/@id='T:NLog.Config.ArrayParameterAttribute']" mode="parameter2">
        <xsl:variable name="itemtype" select="attribute[@id='T:NLog.Config.ArrayParameterAttribute']/property[@name='ElementType']/@value" />
        <br/>&lt;<xsl:value-of select="@name" />&gt;<br/>
        <xsl:value-of select="$itemtype" />
        <xsl:apply-templates select="//class[@name='$itemtype']" mode="parameter" />
        &lt;/<xsl:value-of select="@name" />&gt;
    </xsl:template>

    <xsl:template match="property" mode="parameter2">
    </xsl:template>

    <xsl:template match="c">
        <code><xsl:apply-templates /></code>
    </xsl:template>

    <xsl:template match="code">
        <code><pre class="example"><xsl:apply-templates /></pre></code>
    </xsl:template>

    <xsl:template match="see">
        <code><xsl:value-of select="@cref" /></code>
    </xsl:template>
</xsl:stylesheet>