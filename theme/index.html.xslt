<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:planet="http://planet.intertwingly.net/"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="atom planet xhtml">

  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:template match="atom:feed">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:text>&#10;</xsl:text>
      <!-- Calling the head template -->
      <xsl:call-template name="htmlhead"/>
      <body>
        <xsl:text>&#10;</xsl:text>
        <h1><xsl:value-of select="atom:title"/></h1>
        <xsl:text>&#10;</xsl:text>
        <!-- CONTENT -->
        <div id="body">
          <xsl:apply-templates select="atom:entry"/>
          <xsl:text>&#10;&#10;</xsl:text>
        </div>
        <xsl:text>&#10;&#10;</xsl:text>
        <xsl:call-template name="subcriptionlist"/>

        <xsl:text>&#10;&#10;</xsl:text>
        <footer>
          <xsl:text>&#10;</xsl:text>
          <span class="updated">Last updated:
            <time datetime="{atom:updated}" title="GMT">
              <xsl:value-of select="atom:updated/@planet:format"/>
            </time>
          </span>
          <xsl:text>&#10;</xsl:text>
          <span class="source">planet.webcompat.com - <a href="https://github.com/miketaylr/planet.webcompat.com/">code</a>
          </span>
          <xsl:text>&#10;</xsl:text>
        </footer>
        <xsl:text>&#10;&#10;</xsl:text>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="atom:entry">
    <xsl:text>&#10;&#10;</xsl:text>
    <section class="newsday">
    <!-- date header -->
    <xsl:variable name="date" select="substring(atom:updated,1,10)"/>
    <xsl:if test="not(preceding-sibling::atom:entry
      [substring(atom:updated,1,10) = $date])">
      <xsl:text>&#10;&#10;</xsl:text>
      <h2 class="day">
        <time datetime="{$date}">
          <xsl:value-of select="substring-before(atom:updated/@planet:format,', ')"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="substring-before(substring-after(atom:updated/@planet:format,', '), ' ')"/>
        </time>
      </h2>
    </xsl:if>

    <xsl:text>&#10;&#10;</xsl:text>
    <article class="news {atom:source/planet:css-id}">

      <xsl:if test="@xml:lang">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="@xml:lang"/>
        </xsl:attribute>
      </xsl:if>

      <!-- entry title -->
      <xsl:text>&#10;</xsl:text>
      <h3 class="posttitle permalink">
<!--         <xsl:choose>
          <xsl:when test="atom:source/atom:icon">
            <img src="{atom:source/atom:icon}" class="icon"/>
          </xsl:when>
          <xsl:when test="atom:source/planet:favicon">
            <img src="{atom:source/planet:favicon}" class="icon"/>
          </xsl:when>
        </xsl:choose> -->
        <xsl:if test="string-length(atom:title) &gt; 0">
          <!-- <xsl:text>&#x2014;</xsl:text> -->
          <a href="{atom:link[@rel='alternate']/@href}">
            <xsl:if test="atom:title/@xml:lang != @xml:lang">
              <xsl:attribute name="xml:lang" select="{atom:title/@xml:lang}"/>
            </xsl:if>
            <xsl:value-of select="atom:title"/>
          </a>
        </xsl:if>
      </h3>
      <!-- entry meta -->
      <div class="meta">
        <!--Blog title-->
        <a class="blogtitle">
          <xsl:if test="atom:source/atom:link[@rel='alternate']/@href">
            <xsl:attribute name="href">
              <xsl:value-of
                select="atom:source/atom:link[@rel='alternate']/@href"/>
            </xsl:attribute>
          </xsl:if>

          <xsl:attribute name="title">
            <xsl:value-of select="atom:source/atom:title"/>
          </xsl:attribute>
          <xsl:value-of select="atom:source/planet:name"/>
        </a>

        <!-- Author name -->
        <xsl:text>&#10;</xsl:text>
        <span class="metaauthor">
          <xsl:choose>
            <xsl:when test="atom:author/atom:name">
                <xsl:text> by </xsl:text>
                <span class="author">
                  <xsl:value-of select="atom:author/atom:name"/>
                </span>
            </xsl:when>
            <xsl:when test="atom:source/atom:author/atom:name">
                <xsl:text> by </xsl:text>
                <span class="author">
                  <xsl:value-of select="atom:source/atom:author/atom:name"/>
                </span>
            </xsl:when>
          </xsl:choose>
        </span>

        <!-- Publication time -->
        <xsl:text>&#10;</xsl:text>
        <span class="time">
          <xsl:text> at </xsl:text>
          <time class="postdate" datetime="{atom:updated}" title="GMT">
            <xsl:value-of select="atom:updated/@planet:format"/>
          </time>
      </span>
      </div>

      <!-- entry content -->
      <div class="post">
        <xsl:text>&#10;</xsl:text>
        <xsl:choose>
          <xsl:when test="atom:content">
            <xsl:apply-templates select="atom:content"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="atom:summary"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>

    </article>
    </section>

  </xsl:template>

  <!-- HEAD TEMPLATE -->
  <xsl:template name="htmlhead">
    <head><xsl:text>&#10;</xsl:text>
      <meta charset="utf-8"/><xsl:text>&#10;</xsl:text>
      <link rel="stylesheet" href="theme.css" type="text/css" /><xsl:text>&#10;</xsl:text>
      <title><xsl:value-of select="atom:title"/></title><xsl:text>&#10;</xsl:text>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" /><xsl:text>&#10;</xsl:text>
      <meta name="robots" content="noindex,nofollow" /><xsl:text>&#10;</xsl:text>
      <meta name="generator" content="{atom:generator}" /><xsl:text>&#10;</xsl:text>
      <xsl:if test="atom:link[@rel='self']">
        <link rel="alternate" href="{atom:link[@rel='self']/@href}"
          title="{atom:title}" type="{atom:link[@rel='self']/@type}" /><xsl:text>&#10;</xsl:text>
      </xsl:if>
      <link rel="shortcut icon" href="/favicon.ico" /><xsl:text>&#10;</xsl:text>
      <script defer="defer" src="personalize.js"><xsl:comment><!--comment--></xsl:comment></script><xsl:text>&#10;</xsl:text>
    </head><xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- SUBSCRIPTION TEMPLATE -->
  <xsl:template name="subcriptionlist">
    <section class="subscription">
    <xsl:text>&#10;</xsl:text>
    <h2>Subscriptions</h2>
    <xsl:text>&#10;&#10;</xsl:text>
    <ul>
      <xsl:for-each select="planet:source">
        <xsl:sort select="planet:name"/>
        <xsl:variable name="id" select="atom:id"/>
        <xsl:variable name="posts"
          select="/atom:feed/atom:entry[atom:source/atom:id = $id]"/>
        <xsl:text>&#10;</xsl:text>
        <li>
          <!-- icon -->
          <a title="subscribe">
            <xsl:choose>
              <xsl:when test="planet:http_location">
                <xsl:attribute name="href">
                  <xsl:value-of select="planet:http_location"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="atom:link[@rel='self']/@href">
                <xsl:attribute name="href">
                  <xsl:value-of select="atom:link[@rel='self']/@href"/>
                </xsl:attribute>
              </xsl:when>
            </xsl:choose>
            <img src="feed.png" alt="(feed)"/>
          </a>
          <xsl:text> </xsl:text>

          <!-- name -->
          <a>
            <xsl:if test="atom:link[@rel='alternate']/@href">
              <xsl:attribute name="href">
                <xsl:value-of select="atom:link[@rel='alternate']/@href"/>
              </xsl:attribute>
            </xsl:if>

            <xsl:choose>
              <xsl:when test="planet:message">
                <xsl:attribute name="class">
                  <xsl:if test="$posts">active message</xsl:if>
                  <xsl:if test="not($posts)">message</xsl:if>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:value-of select="planet:message"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="atom:title">
                <xsl:attribute name="title">
                  <xsl:value-of select="atom:title"/>
                </xsl:attribute>
                <xsl:if test="$posts">
                  <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
              </xsl:when>
            </xsl:choose>
            <xsl:value-of select="planet:name"/>
          </a>
        </li>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>
    </ul>
    <xsl:text>&#10;</xsl:text>
  </section>
  </xsl:template>

  <!-- xhtml content -->
  <xsl:template match="atom:content/xhtml:div | atom:summary/xhtml:div">
    <xsl:copy>
      <xsl:if test="../@xml:lang and not(../@xml:lang = ../../@xml:lang)">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="../@xml:lang"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="class">content</xsl:attribute>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- plain text content -->
  <xsl:template match="atom:content/text() | atom:summary/text()">
    <div class="content" xmlns="http://www.w3.org/1999/xhtml">
      <xsl:if test="../@xml:lang and not(../@xml:lang = ../../@xml:lang)">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="../@xml:lang"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="."/>
    </div>
  </xsl:template>

  <!-- Remove stray atom elements -->
  <xsl:template match="atom:*">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Feedburner detritus -->
  <xsl:template match="xhtml:div[@class='feedflare']"/>

  <!-- Strip site meter -->
  <xsl:template match="xhtml:div[comment()[. = ' Site Meter ']]"/>

  <!-- pass through everything else -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
