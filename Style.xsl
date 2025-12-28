<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
       xmlns:xt="http://www.jclark.com/xt"
       extension-element-prefixes="xt"
    version="1.0">

    <xsl:param name="base-url">p1</xsl:param>
    <xsl:param name="person-id">p1</xsl:param>
       <xsl:param name="item-id" />
    <xsl:param name="search-string" />

    <xsl:variable name="personStories" select="//Story[xt:intersection(id(@text) | id(@drawings), id($person-id))]" />
    <xsl:variable name="photos" select="//Photo" />
    <xsl:variable name="personIllustrations" select="//Illustration[xt:intersection(id(@drawings), id($person-id))]" />
    <xsl:variable name="personArticles" select="//Article[xt:intersection(id(@persons), id($person-id))]" />
    <xsl:variable name="personAlbums"
        select="//Album" />
    <xsl:variable name="personSeries"
        select="//Series[xt:intersection(id(@stories), ($personStories))]" />
    <xsl:variable name="personAlbumEditions" select="//AlbumEdition" />
    <xsl:variable name="personMagazines"
        select="//Magazine[xt:intersection(id(MagazineItem/@idref), ($personStories) | ($personIllustrations) | ($personArticles))]" />
    <xsl:variable name="personPublishers"
        select="//Publisher[xt:intersection(id(@magazines), ($personMagazines)) | xt:intersection(id(@albumEditions), ($personAlbumEditions))]" />
    <xsl:variable name="personMiscs" select="//Misc[xt:intersection(id(@drawings), id($person-id))]" />

    <xsl:variable name="personAll" select="($personStories) | ($personIllustrations) | ($personArticles) | ($personAlbums) | ($personSeries) | ($personAlbumEditions) | ($personMagazines) | ($personPublishers) | ($personMiscs)" />

    <xsl:output method="html"/>

    <xsl:template match="/">
		<xsl:call-template name="createRSSFeed"/>
        <xsl:call-template name="createFrameSetPage"/>
        <xsl:call-template name="createMenuPage"/>
        <xsl:call-template name="createTopLeftPage"/>
        <xsl:call-template name="createPages"/>
	</xsl:template>

	<xsl:template name="createRSSFeed">
		<xt:document method="xml" href="./site/andreas/_andreas_news.xml">
			
		<feed xmlns="http://www.w3.org/2005/Atom">
		<title type="text">Dossier Andreas</title>
		<link href="http://www.dossier-andreas.net/" rel="alternate" title="Dossier Andreas" type="text/html"/>
		<author>
			<name>Patrick van Bergen</name>
		</author>
		
		<xsl:for-each select="//Comment[@showAt='changes']/TEXT">
			<entry>
				<id>tag:dossier-andreas.net,<xsl:value-of select="@date" /></id>
				<updated><xsl:value-of select="@date" />T12:00:00Z</updated>
				<title type="text"><xsl:value-of select="TITLE" /></title>
				<content type="html" xml:space="preserve">
					<div><xsl:apply-templates select="." /></div>
				</content>
				<link href="http://www.dossier-andreas.net/" rel="alternate" type="text/html" />
			</entry>
		</xsl:for-each>
		
		</feed>
		
		</xt:document>
	</xsl:template>
	
    <xsl:template name="createFrameSetPage">
        <xt:document method="html" href="./site/index.html">
            <HTML lang="en">
                <HEAD>
                    <LINK rel="SHORTCUT ICON" href="/favicon.ico" />
					<LINK rel="alternate" type="application/atom+xml" title="Dossier Andreas" href="http://www.dossier-andreas.net/andreas/_andreas_news.xml" />
                    <META name="Description" content="Andreas Martens (1951), comics author"/>
					<META name="keywords" content="Andreas Martens, comics, strip" />
                    <TITLE>Dossier Andreas</TITLE>
                </HEAD>

                <FRAMESET cols="500,*" border="5">
	                <FRAMESET rows="172,*" border="0">
		                <FRAME src="andreas/_topleft.php" name="topleft" scrolling="no" marginwidth="0" marginheight="0" />
                        <FRAME src="andreas/p1_changes.php" name="overview" scrolling="auto" marginwidth="0" marginheight="0" />
	                </FRAMESET>
                    <FRAMESET rows="45,*" border="0">
	                    <FRAME src="andreas/_menu.php" name="menu" scrolling="no" marginwidth="0" marginheight="0" />
                        <FRAME src="andreas/p1_main.php" name="andreas" marginwidth="0" marginheight="0" />
                    </FRAMESET>
                </FRAMESET>
                
            </HTML>
        </xt:document>
    </xsl:template>
    
   	<xsl:template name="createTopLeftPage">
        <xt:document method="html" href="./site/andreas/_topleft.php">
	        <xsl:processing-instruction name='php'>session_start(); ?</xsl:processing-instruction>
			<HTML lang="en">
	            <HEAD>
	            	<style>
	            		body { background-color: #E9DECC }
	            	</style>
    	        </HEAD>
    	        <BODY>            
    	        <a href="/andreas/p1_changes.php" target="overview"><img name= 'photo' width="500" height="167" border="0" hspace="0" align="center" src="resources/dossier-andreas.jpg" /></a>			        
			    </BODY>
		    </HTML>
    	</xt:document>
    </xsl:template>

	<xsl:template name="createMenuPage">
        <xt:document method="html" href="./site/andreas/_menu.php">
            <xsl:processing-instruction name='php'>session_start(); ?</xsl:processing-instruction>
			<HTML lang="en">
            <HEAD>
                <LINK href="resources/stylesheet.css" type="text/css" rel="stylesheet" />
				<LINK rel="SHORTCUT ICON" href="/favicon.ico" />
                <SCRIPT language="JavaScript">
                    var oldname = '';
                    var names = ['albums', 'articles', 'illustrations', 'links', 'expected', 'guestbook', 'notes', 'photos', 'index'];
                    var unsel = new Object();
                    var sel = new Object();
                    for (var i=0; i != names.length; i++)
                    {
                        unsel[names[i]] = new Image();
                        unsel[names[i]].src = 'resources/tab_' + names[i] + '.gif';
                        sel[names[i]] = new Image();
                        sel[names[i]].src = 'resources/tab_' + names[i] + '_sel.gif';
                    }

                    function select(newtab)
                    {
                        if (oldname != '') document.images[oldname].src = unsel[oldname].src;
                        if (newtab == 0){
                          oldname = '';
                        } else {
                            oldname = newtab.name;
                            document.images[oldname].src = sel[oldname].src;
                        }
                    }
					
                </SCRIPT>
            </HEAD>
            <BODY link="#004080" alink="#400000" vlink="#D9CEBC">
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>

                    <!-- start tabbed menu -->
                    <td height="30" align="left" valign="top">
                    <table cellpadding="0" cellspacing="0" border="0">

                    <tr><td>
                    	<table cellpadding="0" cellspacing="0" border="0" width="525">
						<tr>
                           <td width="105"><a href="/andreas/p1_albums.php" target="overview"><img width="105" height="28" name="albums" onclick="select(this)" border="0" src="resources/tab_albums.gif" /></a></td>
                           <td width="105"><a href="/andreas/p1_illustrations.php" target="overview"><img width="105" height="28" name="illustrations" onclick="select(this)" border="0" src="resources/tab_illustrations.gif" /></a></td>
                       	   <td width="105"><a href="/andreas/p1_photos.php" onclick="window.top.frames.andreas.location.href='/andreas/p1_photo1.php'" target="overview"><img width="105" height="28" name="photos" onclick="select(this)" border="0" src="resources/tab_photos.gif" /></a></td>
                           <td width="105"><a href="/andreas/p1_articles.php" target="overview"><img width="105" height="28" name="articles" onclick="select(this)" border="0" src="resources/tab_articles.gif" /></a></td>
                           <td width="105"><a href="/andreas/p1_art_links.php" target="andreas"><img width="105" height="28" name="links" onclick="select(this)" border="0" src="resources/tab_links.gif" /></a></td>
                           <td width="105"><a href="/andreas/p1_art_expected.php" target="andreas"><img width="105" height="28" name="expected" onclick="select(this)" border="0" src="resources/tab_expected.gif" /></a></td>
						   <td width="105"><a href="/andreas/p1_indexes.php" target="overview"><img width="105" height="28" name="index" onclick="select(this)" border="0" src="resources/tab_index.gif" /></a></td>
                           <td width="105"><a href="/andreas/p1_art_guestbook.php" target="andreas"><img width="105" height="28" name="guestbook" onclick="select(this)" border="0" src="resources/tab_guestbook.gif" /></a></td>
                        </tr>
                        </table>
                     </td></tr>

                    </table>
                    </td> 
                    <!-- end tabbed menu -->
					
					<!-- start extra menu -->
					<td align='right' valign='top'>
					<table cellpadding="0" cellspacing="0" border="0" width='100%'>
					<tr><td align="right" height="28">
                    	<table cellpadding="1" cellspacing="10" border="0"><tr>
                    		<TD class="value">
                    			RSS feed: <a href="http://www.dossier-andreas.net/andreas/_andreas_news.xml" target="external"><IMG src='resources/xml.gif' /></a>
                    		</TD>
							<TD class="value">
								<xsl:processing-instruction name='php'>
									include(dirname(__FILE__) . '/php/andreas.php'); 
									$User->showStatus();
								?</xsl:processing-instruction>
							 </TD>
						</tr></table>	
					</td></tr>
					</table>
					</td>
					<!-- end extra menu -->
                </tr>
                </table>

            </BODY>
            </HTML>
        </xt:document>
    </xsl:template>

    <xsl:template name="createPages">
        <xsl:for-each select="//*[(@id != 'search') and (local-name(.) != 'AlbumEdition')]">
                <xsl:call-template name="onePage">
                    <xsl:with-param name="person-id">p1</xsl:with-param>
                    <xsl:with-param name="item-id" select="@id" />
                </xsl:call-template>p1_s104.php
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="onePage">
        <xsl:param name="person-id" />
        <xsl:param name="item-id" />
        <xsl:param name="search-string" />

        <xsl:message><xsl:value-of select="$item-id" /></xsl:message>
        <xsl:variable name="filename" select="$item-id"></xsl:variable>

        <xt:document method="html" href="./site/andreas/p1_{$filename}.php">
            <xsl:processing-instruction name='php'>session_start(); ?</xsl:processing-instruction>
			<HTML lang="en">
                <HEAD>
                    <LINK href="resources/stylesheet.css" type="text/css" rel="stylesheet" />
					<LINK rel="SHORTCUT ICON" href="/favicon.ico" />
                    <xsl:variable name="description">
                        <xsl:apply-templates select="id($item-id)" mode="cell" />
                    </xsl:variable>
                    <META name="Description" content="{$description}"/>
					<META name="keywords" content="Andreas Martens" />
                    <TITLE>Dossier Andreas - <xsl:apply-templates select="id($item-id)" mode="cell"/></TITLE>
					
					<!-- Google tag (gtag.js) -->
                    <script async="1" src="https://www.googletagmanager.com/gtag/js?id=G-B4T3LKQ7X2"></script>
                    <script>
                    window.dataLayer = window.dataLayer || [];
                    function gtag(){dataLayer.push(arguments);}
                    gtag('js', new Date());

                    gtag('config', 'G-B4T3LKQ7X2');
                    </script>
                    
	                <script type="text/javascript">
	   					function addM()
						{
							document.getElementById('m').href = "mail" + "to:" + "patrick.vanbergen" + "@" + "gmail" + "." + "com";
						}
	                </script>
					
                </HEAD>
                <xsl:variable name="overviewName" select="//PageType[@tag = local-name(id($item-id))]/@id" />
                <BODY link="#004080" alink="#400000" vlink="#D9CEBC" onload='addM()'>
                    <xsl:variable name="item" select="id($item-id)" />
                    <xsl:choose>
                        <xsl:when test="(local-name($item) = 'PageType')" >
                            <xsl:choose>
                                <xsl:when test="($item)/@id = 'main'">
                                    <xsl:call-template name="showMainPage" >
                                        <xsl:with-param name="person" select="id($person-id)" />
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="($item)/@id = 'changes'">
                                    <xsl:call-template name="showChangePage" >
                                        <xsl:with-param name="person" select="id($person-id)" />
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="($item)/@id = 'search'">
                                    <xsl:call-template name="showSearchResults" >
                                        <xsl:with-param name="person" select="id($person-id)" />
                                        <xsl:with-param name="search-string" select="($search-string)" />
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="($item)/@id != 'search'">
                                    <xsl:call-template name="showOverview" >
                                        <xsl:with-param name="person" select="id($person-id)" />
                                        <xsl:with-param name="item" select="id($item-id)" />
                                    </xsl:call-template>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <SCRIPT language="JavaScript">
                                if (document.cookie) {
                                    if (window.name != "andreas") {
                                    
                                        var date = new Date();
                                        date.setTime(date.getTime()+(3*1000));
                                        
                                        document.cookie = "page=p1_<xsl:value-of select="$item-id"/>.php; expires=" + date.toGMTString() + "; path=/";
                                        window.location.replace("../index.html", "_self", "", true);
                                    }
                                }
                                    
                            </SCRIPT> 
                            <xsl:call-template name="showItem">
                                <xsl:with-param name="person" select="id($person-id)" />
                                <xsl:with-param name="item" select="id($item-id)" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--<xsl:if test="$item-id != 'changes'">
                        <SCRIPT language="JavaScript">
                            var cookie = document.cookie;
                            if (!cookie){
                                id = Math.random();
                                var endDate = new Date();
                                endDate.setFullYear(endDate.getFullYear()+100);
                                document.cookie = "id="+id+";expires="+endDate.toGMTString();
                            } else {
                                id = cookie.substring(cookie.indexOf("=")+1);
                            }
                            document.write('&lt;IMG src="/cgi-bin/hit.pl');
                            document.write('?id='+id);
                            document.write('&amp;page=p1_<xsl:value-of select="$item-id"/>.php');
                            document.write('&amp;useragent='+escape(navigator.userAgent));
                            document.write('&amp;app='+escape(navigator.appName+" "+navigator.appVersion));
                            document.write('" width="0" height="0"&gt;');
                        </SCRIPT>
                    </xsl:if>-->
                </BODY>
            </HTML>
        </xt:document>
    </xsl:template>

    <!-- main routines -->

    <xsl:template name="showItem">
        <xsl:param name="person" />
        <xsl:param name="item" />

        <xsl:call-template name="showTitle">
            <xsl:with-param name="item" select="($item)" />
        </xsl:call-template>

        <xsl:if test="local-name($item) = 'Photo'">
             <xsl:call-template name="showPhoto">
                <xsl:with-param name="item" select="($item)" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="local-name($item) != 'Year' and $item/@id != 'art_guestbook' and $item/@id != 'art_expected' and $item/@id != 'art_site' and $item/@id != 'art_links'">
            <xsl:call-template name="showAttributes">
                <xsl:with-param name="person" select="($person)" />
                <xsl:with-param name="item" select="($item)" />
            </xsl:call-template>
		</xsl:if>
        
        <xsl:if test="local-name($item) != 'Album'">
             <xsl:call-template name="showContext">
                <xsl:with-param name="person" select="($person)" />
                <xsl:with-param name="item" select="($item)" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="local-name($item) = 'Language'">
             <xsl:call-template name="showLinks">
                <xsl:with-param name="person" select="($person)" />
                <xsl:with-param name="item" select="($item)" />
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="local-name($item) = 'Magazine'">
             <xsl:call-template name="showMagazineItems">
                <xsl:with-param name="person" select="($person)" />
                <xsl:with-param name="item" select="($item)" />
            </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="showImage">
            <xsl:with-param name="person" select="($person)" />
            <xsl:with-param name="item" select="($item)" />
        </xsl:call-template>

        <!-- show the article if it is available -->
        <xsl:if test="local-name($item) = 'Article' and ($item)/*">
             <xsl:call-template name="showArticle">
                <xsl:with-param name="person" select="($person)" />
                <xsl:with-param name="item" select="($item)" />
            </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="showAllComments">
            <xsl:with-param name="person" select="($person)" />
            <xsl:with-param name="item" select="($item)" />
        </xsl:call-template>
		
		<!-- Note: the ending question-mark should not be necessary!! Looks like a bug. -->
		<xsl:processing-instruction name='php'>
			include(dirname(__FILE__) . '/php/andreas.php'); 
			$CMS->showUserComments("<xsl:value-of select="$item/@id"/>", "<xsl:apply-templates select='$item' mode='cell'/>");
		?</xsl:processing-instruction>

        <xsl:if test="local-name($item) = 'Album'">
            <TABLE class="section">
                <CAPTION class="sectionCaption">
                    <xsl:text>Editions</xsl:text>
                </CAPTION>
                <TR><TD>
                <xsl:for-each select="//AlbumEdition[@album = current()/@id]">
                    <xsl:sort select="@year"/>
                    <BR/>
                    <DIV class="simpleTitle">
                        <xsl:apply-templates select="current()" mode="cell" />
                    </DIV>
                    <xsl:for-each select="//Image[xt:intersection(id(@showAt), current())]">        
                        <xsl:variable name="image" select="current()"/>
                        <P>
                            <IMG src="images/{$image/@file}" width="{$image/@width}" height="{$image/@height}"/>
                            <DIV class="value">
                                <xsl:value-of select="$image/@title" />
                            </DIV>
                            
                        </P>
                    </xsl:for-each>
                    <xsl:call-template name="showAttributes">
                        <xsl:with-param name="person" select="($person)" />
                        <xsl:with-param name="item" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="showAllComments">
                        <xsl:with-param name="person" select="($person)" />
                        <xsl:with-param name="item" select="." />    
                    </xsl:call-template>
                </xsl:for-each>
            </TD></TR></TABLE>
        </xsl:if>
    </xsl:template>

    <xsl:template name="showChangePage">
        <xsl:for-each select="//Comment[@showAt='changes']">
                <xsl:call-template name="showCommentsBody">
                    <xsl:with-param name="comments" select="*" />
                </xsl:call-template>
        </xsl:for-each>
        <SCRIPT language="JavaScript">
            var cookies = document.cookie;
            var start;
            var end;
            var page = "p1_main.php";
            
            if (cookies)
            {
                var pos = cookies.indexOf("page=");
                if (pos != -1)
                {
                    start = pos + 5;
                    end = cookies.indexOf(";", start);
                    if (end == -1) end = cookies.length;
                    page = unescape(cookies.substring(start, end));
                }
            }
            window.open(page, "andreas");
        </SCRIPT>
    </xsl:template>

    <xsl:template name="showMainPage">
        <xsl:param name="person" />

        <TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
            <TR>
            <TD width="50%" valign="top">
				 <xsl:for-each select="//Comment[@showAt='front_welcome']">
				        <xsl:call-template name="showCommentsBody">
				            <xsl:with-param name="comments" select="*" />
				        </xsl:call-template>
				</xsl:for-each>
				 <xsl:for-each select="//Comment[@showAt='front_twitter']">
				        <xsl:call-template name="showCommentsBody">
				            <xsl:with-param name="comments" select="*" />
				        </xsl:call-template>
				</xsl:for-each>
            </TD>
            <TD width="50%" valign="top">
            
				 <xsl:for-each select="//Comment[@showAt='front_search']">
				        <xsl:call-template name="showCommentsBody">
				            <xsl:with-param name="comments" select="*" />
				        </xsl:call-template>
				</xsl:for-each>
				 <xsl:for-each select="//Comment[@showAt='front_notes']">
				        <xsl:call-template name="showCommentsBody">
				            <xsl:with-param name="comments" select="*" />
				        </xsl:call-template>
				</xsl:for-each>
<!--                <xsl:for-each select="//Comment[xt:intersection(id(@showAt), id('main'))]">
                    <TD width="50%" valign="top">
                        <xsl:call-template name="showCommentsBody">
                            <xsl:with-param name="comments" select="*" />
                        </xsl:call-template>
                    </TD>
                </xsl:for-each>-->
            </TD>
            </TR>
        </TABLE>
    </xsl:template>

    <xsl:template name="showOverview">
        <xsl:param name="person" />
        <xsl:param name="item" />

         <xsl:call-template name="showList">
            <xsl:with-param name="person" select="($person)" />
            <xsl:with-param name="item" select="($item)" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="showSearchResults">
        <xsl:param name="person" />
        <xsl:param name="search-string" />

        <xsl:call-template name="showPath">
            <xsl:with-param name="person" select="($person)" />
        </xsl:call-template>

        <xsl:call-template name="showSearchTitle">
            <xsl:with-param name="search-string" select="($search-string)" />
        </xsl:call-template>

        <xsl:call-template name="showSearchedComments">
            <xsl:with-param name="person" select="($person)" />
            <xsl:with-param name="item" select="id('search')" />
            <xsl:with-param name="search-string" select="($search-string)" />
        </xsl:call-template>

        <xsl:call-template name="showPath">
            <xsl:with-param name="person" select="($person)" />
        </xsl:call-template>
    </xsl:template>

	<xsl:template name="showPhoto">
        <xsl:param name="item" />
        
        <xsl:variable name="photoCount" select="count(//Photo)" />
        
        <!-- /andreas/{($person)/@id}_{preceding-sibling::*[position() = 1]/@id}.php" -->
        
        <xsl:variable name="next" select="following-sibling::*[position() = 1]/@id" />
        <xsl:if test='$next != "s1"'>
	        <A href='/andreas/p1_{$next}.php' class='nav'>Next photo</A>	
        </xsl:if>        
        
        <TABLE><TR><TD class='photo_background'>
        	<IMG class='photo' src="/andreas/shrunk_photos/{@file}" width="{@shrunk-width}" height="{@shrunk-height}"/>
        </TD></TR></TABLE>
        
	</xsl:template>
	
    <xsl:template name="showImage">
        <xsl:param name="person" />
        <xsl:param name="item" />
        
        <xsl:for-each select="//Image[xt:intersection(id(@showAt), ($item))]" >
            <TABLE class="section">
                <TR><TD>
                    <xsl:if test="contains(@file, '.wrl')">
                        <EMBED src="images/{@file}" width="{@width}" height="{@height}"/>
                    </xsl:if>
                    <xsl:if test="not(contains(@file, '.wrl'))">
                        <IMG src="images/{@file}" width="{@width}" height="{@height}"/>
                    </xsl:if>
                    <DIV class="value">
                        <xsl:value-of select="@title" />
                    </DIV>
                </TD></TR>
            </TABLE>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="showList">
        <xsl:param name="person"/>
        <xsl:param name="item" />

        <TABLE class="section">
            <CAPTION class="sectionCaption">
                <xsl:value-of select="($item)/@name" />
                <xsl:text> Overview</xsl:text>
            </CAPTION>

            <xsl:choose>
                <xsl:when test="($item)/@tag = 'Album'" >
                    <xsl:for-each select="//Series">
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                        <xsl:for-each select="//Album[xt:intersection(id(@stories), id(current()/@stories))]">
                            <xsl:sort select="@year" />
							<xsl:if test="not(@multialbum)">
								<TR>
									<xsl:call-template name="showLinkedValue">
										<xsl:with-param name="person" select="($person)" />
										<xsl:with-param name="link" select="." />
										<xsl:with-param name="value" select="." />
									</xsl:call-template>
								</TR>
							</xsl:if>
                        </xsl:for-each>
						<xsl:for-each select="//Album[xt:intersection(id(@stories), id(current()/@stories))]">
							<xsl:sort select="@year" />
							<xsl:if test="@multialbum">
								<TR style="background-color: #FFE4B5">
									<xsl:call-template name="showLinkedValue">
										<xsl:with-param name="person" select="($person)" />
										<xsl:with-param name="link" select="." />
										<xsl:with-param name="value" select="." />
									</xsl:call-template>
								</TR>
							</xsl:if>
						</xsl:for-each>
                        <TR>
                            <TD height="25"><HR/></TD><TD><HR/></TD>
                        </TR>
                    </xsl:for-each>
                    <xsl:for-each select="($personAlbums)">
                        <xsl:sort select="@title" />
                        <xsl:if test="count(//Series[xt:intersection(id(@stories), id(current()/@stories))]) = 0">
                            <TR>
                                <xsl:call-template name="showLinkedValue">
                                    <xsl:with-param name="person" select="($person)" />
                                    <xsl:with-param name="link" select="." />
                                    <xsl:with-param name="value" select="." />
                                </xsl:call-template>
                            </TR>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="($item)/@tag = 'Story'" >
                    <xsl:for-each select="($personStories)">
                        <xsl:sort select="@title" />
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="($item)/@tag = 'Photo'" >
                
                	<!-- Photos grouped by tag -->
                
					<xsl:for-each select="//Tag" >
						<xsl:variable name="tag" select="@id" />
						
							<xsl:if test="count(//Photo[@tags=$tag]) > 0">
					
							<TR><TD colspan="2">
								<div class="subSectionCaption" 
									onclick="var node = this.parentNode.getElementsByTagName('table')[0]; node.style.display = (node.style.display == 'block' ? 'none' : 'block')">
									<IMG src="resources/Misc.gif" width="18" height="18" /><xsl:value-of select="current()/@description" />
								</div>
								<TABLE style="display:none">
								<xsl:for-each select="//Photo[xt:intersection(id(@tags), current())]" >
								<xsl:sort select="@year" />
						            <TR>
						                <xsl:call-template name="showLinkedValue">
						                    <xsl:with-param name="person" select="($person)" />
						                    <xsl:with-param name="link" select="." />
						                    <xsl:with-param name="value" select="." />
						                </xsl:call-template>
						            </TR>
								</xsl:for-each>
								</TABLE>
							</TD></TR>
							
						</xsl:if>	
					</xsl:for-each>
                
                </xsl:when>
                <xsl:when test="($item)/@tag = 'Series'" >
                    <xsl:for-each select="($personSeries)">
                        <xsl:sort select="@title" />
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="($item)/@tag = 'Article'" >
                    <xsl:variable name="available" select="//Article[count(child::*) > 0]" />
                    <xsl:variable name="notAvailable" select="xt:difference(//Article, $available)" />
                    <TR><TD class="CommentTitle" colspan="2"><BR/>Full text available<BR/></TD></TR>
                    <xsl:for-each select="($available)" >
                        <xsl:sort select="@year" />
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                    </xsl:for-each>
                    <TR><TD class="CommentTitle" colspan="2"><BR/>Only references<BR/></TD></TR>
                    <xsl:for-each select="($notAvailable)" >
                        <xsl:sort select="@year" />
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="($item)/@tag = 'Magazine'" >
                    <xsl:for-each select="($personMagazines)">
                        <xsl:sort select="@title" />
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="($item)/@tag = 'Misc'" >
                    <xsl:for-each select="($personMiscs)" >
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="($item)/@tag = 'Illustration'" >
                    <!--<xsl:variable name="available" select="//Illustration[xt:intersection(id(//Image/@showAt), id(@id))]" />-->
                    <!--<xsl:variable name="notAvailable" select="xt:difference(//Illustration, $available)" />-->
					<xsl:for-each select="//Tag" >
						<xsl:variable name="tag" select="@id" />
						<xsl:if test="count(//Illustration[@tags=$tag]) > 0">
					
							<TR><TD colspan="2">
								<div class="subSectionCaption" 
									onclick="var node = this.parentNode.getElementsByTagName('table')[0]; node.style.display = (node.style.display == 'block' ? 'none' : 'block')">
									<IMG src="resources/Misc.gif" width="18" height="18" /><xsl:value-of select="current()/@description" />
								</div>
								<TABLE style="display:none">
								<xsl:for-each select="//Illustration[xt:intersection(id(@tags), current())]" >
								<xsl:sort select="@year" />
									<TR>
										<TD width="100" align="right" rowspan="2">
											<A href="/andreas/{($person)/@id}_{@id}.php" target="andreas">
												<xsl:variable name="thumbnail" select="//Image[xt:intersection(id(@showAt), current())]/Thumbnail"/>
												<IMG src="thumbnails/{$thumbnail/@file}" width="{$thumbnail/@width}" height="{$thumbnail/@height}" />
											</A>
										</TD>
										<xsl:call-template name="showLinkedValue">
											<xsl:with-param name="person" select="($person)" />
											<xsl:with-param name="link" select="." />
											<xsl:with-param name="value" select="." />
										</xsl:call-template>
									</TR>
									<TR><TD></TD><TD class="value"><xsl:apply-templates select="id(@year)" mode="cell"/></TD></TR>
								</xsl:for-each>
								</TABLE>
							</TD></TR>
						</xsl:if>
					</xsl:for-each>
                </xsl:when>
                
                <xsl:when test="($item)/@tag = 'Indexes'" >
					<TR><TD>
						<div class="subSectionCaption" 
							onclick="">
							<A href='/andreas/p1_language.php' target='overview'><IMG src="resources/Language.gif" width="18" height="18" />Languages</A>
						</div>
					</TD></TR>
					<TR><TD>
						<div class="subSectionCaption" 
							onclick="">
							<A href='/andreas/p1_magazines.php' target='overview'><IMG src="resources/Magazine.gif" width="18" height="18" />Magazines</A>
						</div>
					</TD></TR>
					<TR><TD>
						<div class="subSectionCaption" 
							onclick="">
							<A href='/andreas/p1_persons.php' target='overview'><IMG src="resources/Person.gif" width="18" height="18" />Persons</A>
						</div>
					</TD></TR>
					<TR><TD>
						<div class="subSectionCaption" 
							onclick="">
							<A href='/andreas/p1_publishers.php' target='overview'><IMG src="resources/Publisher.gif" width="18" height="18" />Publishers</A>
						</div>
					</TD></TR>
					<TR><TD>
						<div class="subSectionCaption" 
							onclick="">
							<A href='/andreas/p1_stories.php' target='overview'><IMG src="resources/Story.gif" width="18" height="18" />Stories</A>
						</div>
					</TD></TR>
					<TR><TD>
						<div class="subSectionCaption" 
							onclick="">
							<A href='/andreas/p1_years.php' target='overview'><IMG src="resources/Year.gif" width="18" height="18" />Years</A>
						</div>
					</TD></TR>
                </xsl:when>
                                
                <xsl:when test="($item)/@tag = 'Publisher'" >
                    <xsl:for-each select="($personPublishers)" >
                    <xsl:sort select="@name" />
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="($item)/@tag = 'Year'" >
                    <xsl:for-each select="//Year[//*[local-name(.) != 'Year']/@* = @id]" >
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="($item)/@tag = 'Language'" >
                    <xsl:for-each select="//Language" >
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="($item)/@tag = 'Person'" >
                    <xsl:for-each select="//Person" >
                    <xsl:sort select="@name" />
                        <TR>
                            <xsl:call-template name="showLinkedValue">
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </TR>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>

        </TABLE>
    </xsl:template>


    <!-- cell templates -->

    <xsl:template match="Person" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@name" />
        </A>
    </xsl:template>

    <xsl:template match="Story" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@title" />
        </A>
    </xsl:template>

    <xsl:template match="Photo" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@title" />
        </A>
    </xsl:template>

    <xsl:template match="Illustration" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@description" />
        </A>
    </xsl:template>

    <xsl:template match="Album" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@title" />
        </A>
    </xsl:template>

    <xsl:template match="Series" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@title" />
        </A>
    </xsl:template>

    <xsl:template match="Preface" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@title" />
        </A>
    </xsl:template>

    <xsl:template match="Language" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
        <IMG src="resources/{@id}.gif" width="23" height="17" /><xsl:text> </xsl:text><xsl:value-of select="@name" />
        </A>
    </xsl:template>

    <xsl:template match="AlbumEdition" mode="cell">
        <A href="/andreas/p1_{@album}.php" target="andreas">
            <xsl:choose>
                <xsl:when test="@title">
                    <xsl:value-of select="@title" />
                </xsl:when>
                <xsl:when test="not (@title)">
                    <xsl:value-of select="id(@album)/@title" />
                </xsl:when>
            </xsl:choose>
        </A>
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="id(@year)" mode="cell"/>
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="//Publisher[xt:intersection(id(@albumEditions), current())]" mode="cell"/>
        <xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="Collection" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
        <xsl:value-of select="@title" />
        </A>
    </xsl:template>

    <xsl:template match="Magazine" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@title" />
        </A>    
    </xsl:template>

    <xsl:template match="MagazineItem" mode="cell">
        <xsl:apply-templates select=".." mode="cell" />
<!--        <xsl:text> </xsl:text>
        <xsl:value-of select="../@title" /> -->
        <xsl:text> (</xsl:text>
        <xsl:for-each select="MI">
            <xsl:if test="position() > 1">
                <xsl:text>; </xsl:text>
            </xsl:if>
            <xsl:apply-templates select="id(@year)" mode="cell"/>
            <xsl:if test="@nrs">
                <xsl:text>, number </xsl:text>
                <xsl:value-of select="@nrs" />
            </xsl:if>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="MI" mode="cell">
        <xsl:apply-templates select="id(../@idref)" mode="cell" />
        <xsl:text> - </xsl:text>
        <xsl:value-of select="../../@title" />
        <xsl:text> (</xsl:text>
        <xsl:text>number </xsl:text>
        <xsl:value-of select="@nrs" />
        <xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="Publisher" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@name" />
        </A>
    </xsl:template>

    <xsl:template match="Article" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@title" />
            <xsl:if test="@year">
    		<xsl:text> (</xsl:text>
            <xsl:apply-templates select="id(@year)" mode="cell"/>
            <xsl:text>)</xsl:text>
    		</xsl:if>
        </A>
    </xsl:template>

    <xsl:template match="PageType" mode="cell">
        <xsl:value-of select="@name" />
    </xsl:template>

    <xsl:template match="Year" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="substring-after(@id, 'y')" />
        </A>
    </xsl:template>

    <xsl:template match="Misc" mode="cell">
        <A href="/andreas/p1_{@id}.php" target="andreas">
            <xsl:value-of select="@shortDescription" />
        </A>
    </xsl:template>

    <xsl:template match="@startDate" mode="cell">
        <xsl:value-of select="substring-before(., '/')" />
    </xsl:template>

    <xsl:template match="@color" mode="cell">
        <xsl:if test=". = 'true'">color</xsl:if>
        <xsl:if test=". = 'false'">black-and-white</xsl:if>
    </xsl:template>

    <xsl:template match="@signed" mode="cell">
        <xsl:if test=". = 'true'">yes</xsl:if>
        <xsl:if test=". = 'false'">no</xsl:if>
    </xsl:template>

    <xsl:template match="@file" mode="cell">
        <A href='/andreas/photos/{.}' target='andreas_photo'><xsl:value-of select="." /></A>
    </xsl:template>

    <xsl:template match="@numbered" mode="cell">
        <xsl:if test=". = 'true'">yes</xsl:if>
        <xsl:if test=". = 'false'">no</xsl:if>
    </xsl:template>

    <xsl:template match="@cover" mode="cell">
        <xsl:if test=". = 'hc'">HardCover</xsl:if>
        <xsl:if test=". = 'sc'">SoftCover</xsl:if>
    </xsl:template>

    <xsl:template match="@language" mode="cell">
        <xsl:value-of select="@name" />
    </xsl:template>


    <!-- row templates -->

    <xsl:template match="MagazineItem" mode="row">
        <xsl:param name="person" />

        <TR>
            <xsl:call-template name="showLinkedValue">
                <xsl:with-param name="person" select="($person)" />
                <xsl:with-param name="link" select="id(@idref)" />
                <xsl:with-param name="value" select="id(@idref)" />
            </xsl:call-template>
            <TD class="value">
                <xsl:apply-templates select="." mode="cell" />
            </TD>
        </TR>
    </xsl:template>
    
        <!-- subroutines -->
        
    <xsl:template name="showPath">
        <xsl:param name="person" />
        <xsl:param name="subject" />

        <TABLE class="path"><TR>
            <TD width="50%">

                <TABLE>
                <TR>
                    <xsl:call-template name="showLinkedValue">
                        <xsl:with-param name="person" select="($person)" />
                        <xsl:with-param name="link" select="//PageType[@id = 'main']" />
                        <xsl:with-param name="value" select="($person)" />
                    </xsl:call-template>
                    <xsl:if test="($subject)">
                        <xsl:call-template name="showLinkedValue">
                            <xsl:with-param name="person" select="($person)" />
                            <xsl:with-param name="link" select="//PageType[@tag = local-name($subject)]" />
                            <xsl:with-param name="value" select="//PageType[@tag = local-name($subject)]" />
                        </xsl:call-template>

                        <xsl:apply-templates select="($subject)" mode="prev" >
                            <xsl:with-param name="person" select="($person)" />
                        </xsl:apply-templates>
                        <xsl:apply-templates select="($subject)" mode="next" >
                            <xsl:with-param name="person" select="($person)" />
                        </xsl:apply-templates>

                    </xsl:if>
                    <TD width="100%"></TD>
                </TR>
                </TABLE>

            </TD>
            <TD width="50%">
                <TABLE>
                <TR>
                    <TD class="link">
                        <A href="/andreas/p1_art_links.php" target="andreas"><IMG src="resources/PageType.gif" width="18" height="18" /></A>
                    </TD>
                    <TD class="value">
                        Links
                    </TD>
                    <TD class="link">
                        <A href="/andreas/p1_art_site.php" target="andreas"><IMG src="resources/PageType.gif" width="18" height="18" /></A>
                    </TD>
                    <TD class="value" nowrap="true">
                        Site History
                    </TD>
                    <TD width="100%"></TD>
                </TR>
                </TABLE>
            </TD>
        </TR></TABLE>
    </xsl:template>


    <xsl:template match="*" mode="prev">
        <xsl:param name="person" />
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[position() = 1 and local-name() = local-name(current())]">
                <TD class="link">
                    <A href="/andreas/{($person)/@id}_{preceding-sibling::*[position() = 1]/@id}.php" target="andreas">
                        <IMG src="resources/prev.gif" width="18" height="18" alt="previous" />
                    </A>
                </TD>
            </xsl:when>
            <xsl:otherwise>
                <TD class="link">
                    <IMG src="resources/empty.gif" width="22" height="22" />
                </TD>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="next">
        <xsl:param name="person" />
        <xsl:choose>
            <xsl:when test="following-sibling::*[position() = 1 and local-name() = local-name(current())]">
                <TD class="link">
                    <A href="/andreas/{($person)/@id}_{following-sibling::*[position() = 1]/@id}.php" target="andreas">
                        <IMG src="resources/next.gif" width="18" height="18" alt="next" />
                    </A>
                </TD>
            </xsl:when>
            <xsl:otherwise>
                <TD class="link">
                    <IMG src="resources/empty.gif" width="22" height="22" />
                </TD>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template name="showTitle">
        <xsl:param name="item" />

        <xsl:if test="local-name($item) = 'PageType'">
            <TABLE height="100" class="simple" background="resources/{@tag}.jpg">
                <TR>
                    <TD>
                        <DIV class="title">
                            <xsl:apply-templates select="($item)" mode="cell" />
                        </DIV>
                    </TD>
                </TR>
            </TABLE>
        </xsl:if>
        <xsl:if test="local-name($item) != 'PageType'">
            <TABLE height="100" class="simple" background="resources/{local-name($item)}.jpg">
                <TR>
                    <TD>
                        <DIV class="subtitle">
                            <xsl:apply-templates select="($item)" mode="name" />
                        </DIV>
                        <DIV class="title">
                            <span><xsl:apply-templates select="($item)" mode="cell" /></span>
                        </DIV>
                    </TD>
                </TR>
            </TABLE>
        </xsl:if>
        <BR/>
    </xsl:template>

    <xsl:template name="showSearchTitle">
        <xsl:param name="search-string" />
        <TABLE class="simple">
            <TR>
                <TD>
                    <DIV class="subtitle">Search results for</DIV>
                    <DIV class="title">
                        <xsl:text>"</xsl:text>
                        <xsl:value-of select="($search-string)" />
                        <xsl:text>"</xsl:text>
                    </DIV>
                </TD>
                <TD align="right">
                    <IMG src="resources/sticker.gif" width="150" height="93" />
                </TD>
            </TR>
        </TABLE>
    </xsl:template>

    <xsl:template name="showAttributes">
        <xsl:param name="person" />
        <xsl:param name="item" />

        <TABLE class="section">
            <CAPTION class="sectionCaption">
                <xsl:apply-templates select="($item)" mode="name" />
                <xsl:text> Information</xsl:text>
            </CAPTION>

            <xsl:for-each select="($item)/@*[local-name() != 'id' and local-name() != 'tags' and local-name() != 'shrunk-width' and local-name() != 'shrunk-height']" >
                <xsl:choose>
                    <xsl:when test="count(id(.))=0">
                        <xsl:call-template name="showAttribute">
                            <xsl:with-param name="person" select="($person)" />
                            <xsl:with-param name="name" select="." />
                            <xsl:with-param name="value" select="." />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="count(id(.)) != 0">
                        <xsl:variable name="attributeName" select="." />
                        <xsl:for-each select="id(.)">
                            <xsl:call-template name="showAttribute">
                                <xsl:with-param name="name" select="($attributeName)" />
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="link" select="." />
                                <xsl:with-param name="value" select="." />
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </TABLE>
    </xsl:template>

    <xsl:template name="showContext">
        <xsl:param name="person"/>
        <xsl:param name="item" />

        <!-- Select all attributes (not 'id') that refer to ($item) -->
        <xsl:variable name="refs"
            select="(//Context//@* | //Article/@*)[(local-name() != 'id') and
            (count(id(.)) > 0) and
            (count(id(.) | ($item)) = count(id(.)))]"/>

        <xsl:if test="count($refs) > 0">
            <TABLE class="section">
                <CAPTION class="sectionCaption">
                    <xsl:text>Context Information</xsl:text>
                </CAPTION>

                <xsl:for-each select="($refs)/.." >
                    <xsl:call-template name="showAttribute">
                        <xsl:with-param name="person" select="($person)" />
                        <xsl:with-param name="name" select="." />
                        <xsl:with-param name="link" select="." />
                        <xsl:with-param name="value" select="." />
                    </xsl:call-template>
                </xsl:for-each>
            </TABLE>
        </xsl:if>
    </xsl:template>

    <xsl:template name="showLinks">
        <xsl:param name="person"/>
        <xsl:param name="item" />

        <!-- Select all links for this language -->
        <xsl:variable name="links" select="//WWWlink[@language = $item/@id]" />

        <xsl:if test="count($links) > 0">
            <TABLE class="section">
                <CAPTION class="sectionCaption">
                    <xsl:text>Links</xsl:text>
                </CAPTION>

                <xsl:for-each select="($links)" >
                    <TR>
                        <TD>
                            <A href="{@href}" target="external">
                                <xsl:value-of select="@href" />
                            </A>
                        </TD>
                    </TR>
                </xsl:for-each>
            </TABLE>
        </xsl:if>
    </xsl:template>

    <xsl:template name="showOverviews">
        <xsl:param name="person"/>

        <TABLE class="section">
            <CAPTION class="sectionCaption">
                <xsl:text>Overviews</xsl:text>
            </CAPTION>

            <xsl:for-each select="//PageType[@tag]" >
                <TR>
                    <xsl:call-template name="showLinkedValue">
                        <xsl:with-param name="person" select="($person)" />
                        <xsl:with-param name="link" select="." />
                        <xsl:with-param name="value" select="@name" />
                    </xsl:call-template>
                </TR>
            </xsl:for-each>
        </TABLE>
    </xsl:template>

    <xsl:template name="showMagazineItems">
        <xsl:param name="person" />
        <xsl:param name="item" />

        <TABLE class="section">
            <CAPTION class="sectionCaption">
                <xsl:text>Publications</xsl:text>
            </CAPTION>

            <xsl:for-each select="($item)/MagazineItem">
                <xsl:sort select="./MI[position()=1]/@year" />
                <xsl:sort select="./MI[position()=1]/@nrs" />

                <xsl:apply-templates select="." mode="row">
                    <xsl:with-param name="person" select="($person)" />
                </xsl:apply-templates>
            </xsl:for-each>
        </TABLE>
    </xsl:template>

    <xsl:template name="showArticle">
        <xsl:param name="person" />
        <xsl:param name="item" />

<xsl:if test="($item)/Comment">		
        <TABLE class="section">
            <CAPTION class="sectionCaption">
                <xsl:text>Article Contents</xsl:text>
            </CAPTION>
            <TR>
                <TD>
                    <xsl:call-template name="showComments">
                        <xsl:with-param name="comments" select="($item)/Comment" />
                        <xsl:with-param name="person" select="($person)" />
                        <xsl:with-param name="item" select="($item)" />
                        <xsl:with-param name="idrefs" select="id(($item)/Comment//REF/@ref)" />
                    </xsl:call-template>
                </TD>
            </TR>
        </TABLE>
</xsl:if>		
    </xsl:template>

    <xsl:template name="showAttribute">
        <xsl:param name="person" />
        <xsl:param name="name" />
        <xsl:param name="link">nolink</xsl:param>
        <xsl:param name="value" />

        <TR>
            <TD class="name">
                <xsl:apply-templates select="($name)" mode="name" />
            </TD>
            <xsl:call-template name="showLinkedValue">
                <xsl:with-param name="person" select="($person)" />
                <xsl:with-param name="link" select="($link)" />
                <xsl:with-param name="value" select="($value)" />
            </xsl:call-template>
        </TR>
    </xsl:template>

    <xsl:template name="showLinkedValue">
        <xsl:param name="person"/>
        <xsl:param name="link">nolink</xsl:param>
        <xsl:param name="value" />

        <xsl:choose>
            <xsl:when test="($link) = 'nolink'">
                <TD></TD>
            </xsl:when>
            <xsl:when test="($link)/@id">
                <xsl:call-template name="showLink">
                    <xsl:with-param name="person" select="($person)" />
                    <xsl:with-param name="link" select="($link)" />
                </xsl:call-template>
            </xsl:when>
            <!-- if the link-element has no @id attribute, take the parent element -->
            <xsl:when test="($link)/../@id">
                <xsl:call-template name="showLink">
                    <xsl:with-param name="person" select="($person)" />
                    <xsl:with-param name="link" select="($link)/.." />
                </xsl:call-template>
            </xsl:when>
            <!-- if the parent has no @id attribute, take the parent's parent element -->
            <xsl:otherwise>
                <xsl:call-template name="showLink">
                    <xsl:with-param name="person" select="($person)" />
                    <xsl:with-param name="link" select="($link)/../.." />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <TD class="value">
            <xsl:apply-templates select="($value)" mode="cell" />
        </TD>
    </xsl:template>
    
    <xsl:template name="showLink">
        <xsl:param name="person"/>
        <xsl:param name="link">nolink</xsl:param>
        
        <TD class="link">
            <xsl:if test="($link) != 'nolink'">
                <xsl:if test="local-name($link) = 'PageType'">
                    <xsl:variable name="image" select="$link/@tag" />
                    <A href="/andreas/{($person)/@id}_{($link)/@id}.php" target="overview">
                        <IMG src="resources/{$image}.gif" width="18" height="18" />
                    </A>
                </xsl:if>
                <xsl:if test="local-name($link) != 'PageType'">
                    <xsl:if test="local-name($link) = 'AlbumEdition'">
                        <A href="/andreas/{($person)/@id}_{($link)/@album}.php" target="andreas">
                            <IMG src="resources/{local-name($link)}.gif" width="18" height="18" />
                        </A>
                    </xsl:if>
                    <xsl:if test="local-name($link) != 'AlbumEdition'">
                        <A href="/andreas/{($person)/@id}_{($link)/@id}.php" target="andreas">
                            <IMG src="resources/{local-name($link)}.gif" width="18" height="18" />
                        </A>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </TD>
    </xsl:template>    

    <xsl:template name="showAllComments">
        <xsl:param name="person"/>
        <xsl:param name="item" />

        <xsl:variable name="comments" select="//Comment[count(id(@showAt) | ($item)) = count(id(@showAt))]" />
        <xsl:if test="count($comments) != 0">
            <TABLE class="section">
                <CAPTION class="sectionCaption">
                    <xsl:text>Comments</xsl:text>
                </CAPTION>

                <!-- loose comments -->
                <xsl:for-each select="//Comments/Comment[count(id(@showAt) | ($item)) = count(id(@showAt))]">
                    <xsl:sort select="@year" />
                    <TR>
                        <TD>
                            <xsl:call-template name="showComments">
                                <xsl:with-param name="comments" select="." />
                                <xsl:with-param name="person" select="($person)" />
                                <xsl:with-param name="item" select="($item)" />
                                <xsl:with-param name="idrefs" select="id(.//REF/@ref)" />
                            </xsl:call-template>
                        </TD>
                    </TR>
                </xsl:for-each>

                <!-- parts of articles -->
                <xsl:for-each select="//Comments/Article">
                    <xsl:sort select="@year" />

                    <!-- select comments with refs. to $item in Comment tags -->
                    <xsl:variable name="articleComments"
                        select="./Comment[count(id(@showAt) | ($item)) = count(id(@showAt))]" />
                    <xsl:if test="count($articleComments) > 0">
                        <TR>
                            <TD>
                                <xsl:call-template name="showComments">
                                    <xsl:with-param name="comments" select="($articleComments)" />
                                    <xsl:with-param name="person" select="($person)" />
                                    <xsl:with-param name="item" select="($item)" />
                                    <xsl:with-param name="idrefs" select=". | id(($articleComments)//REF/@ref)" />
                                </xsl:call-template>
                            </TD>
                        </TR>
                    </xsl:if>
                </xsl:for-each>

            </TABLE>
        </xsl:if>
    </xsl:template>

    <xsl:template name="showSearchedComments">
        <xsl:param name="person"/>
        <xsl:param name="item" />
        <xsl:param name="search-string" />

        <TABLE class="section">
            <CAPTION class="sectionCaption">
                <xsl:text>Search Results</xsl:text>
            </CAPTION>

            <!-- flatten search-string -->
            <xsl:variable name="flat-search-string" select="

                translate(($search-string),'&#xC0;&#xE0;&#xC1;&#xE1;&#xC2;&#xE2;&#xC3;&#xE3;&#xC4;&#xE4;&#xC7;&#xE7;&#xC8;&#xE8;&#xC9;&#xE9;&#xCA;&#xEA;&#xCB;&#xEB;&#xCC;&#xEC;&#xCD;&#xED;&#xCE;&#xEE;&#xCF;&#xEF;&#xD2;&#xF2;&#xD3;&#xF3;&#xD4;&#xF4;&#xD5;&#xF5;&#xD6;&#xF6;&#xD9;&#xF9;&#xDA;&#xFA;&#xDB;&#xFB;ABCDEFGHIJKLMNOPQRSTUVWXYZ','aaaaaaaaaacceeeeeeeeiiiiiiiioooooooooouuuuuuabcdefghijklmnopqrstuvwxyz')
                "></xsl:variable>

            <!-- select items that have tags in which the search string occurs -->
            <xsl:variable name="foundItems" select="(//Context//@* | //Article/@*)[contains(

                translate(.,'&#xC0;&#xE0;&#xC1;&#xE1;&#xC2;&#xE2;&#xC3;&#xE3;&#xC4;&#xE4;&#xC7;&#xE7;&#xC8;&#xE8;&#xC9;&#xE9;&#xCA;&#xEA;&#xCB;&#xEB;&#xCC;&#xEC;&#xCD;&#xED;&#xCE;&#xEE;&#xCF;&#xEF;&#xD2;&#xF2;&#xD3;&#xF3;&#xD4;&#xF4;&#xD5;&#xF5;&#xD6;&#xF6;&#xD9;&#xF9;&#xDA;&#xFA;&#xDB;&#xFB;ABCDEFGHIJKLMNOPQRSTUVWXYZ','aaaaaaaaaacceeeeeeeeiiiiiiiioooooooooouuuuuuabcdefghijklmnopqrstuvwxyz')

                , ($flat-search-string))]/.." />

            <!-- select comments that contain text passages in which the search string occurs -->
            <!-- and those in which REF's are found that refer to the selected items -->
            <xsl:variable name="searchFragments"
                select="//Comments//text()[contains(

                translate(.,'&#xC0;&#xE0;&#xC1;&#xE1;&#xC2;&#xE2;&#xC3;&#xE3;&#xC4;&#xE4;&#xC7;&#xE7;&#xC8;&#xE8;&#xC9;&#xE9;&#xCA;&#xEA;&#xCB;&#xEB;&#xCC;&#xEC;&#xCD;&#xED;&#xCE;&#xEE;&#xCF;&#xEF;&#xD2;&#xF2;&#xD3;&#xF3;&#xD4;&#xF4;&#xD5;&#xF5;&#xD6;&#xF6;&#xD9;&#xF9;&#xDA;&#xFA;&#xDB;&#xFB;ABCDEFGHIJKLMNOPQRSTUVWXYZ','aaaaaaaaaacceeeeeeeeiiiiiiiioooooooooouuuuuuabcdefghijklmnopqrstuvwxyz')


                , ($flat-search-string))] | //Comments//REF[ xt:intersection(($foundItems), id(@ref))]" />

            <xsl:choose>
                <xsl:when test="count($searchFragments | $foundItems) = 0">
                    <TR>
                        <TD>
                            <IMG src="resources/info.gif" width="144" height="130" />
                        </TD>
                    </TR>
                </xsl:when>
                <xsl:when test="count($searchFragments | $foundItems) != 0">

                    <!-- items -->
                    <TR>
                        <TD>
                            <TABLE>
                                <xsl:for-each select="($foundItems)">
                                    <xsl:call-template name="showAttribute">
                                        <xsl:with-param name="person" select="($person)" />
                                        <xsl:with-param name="name" select="." />
                                        <xsl:with-param name="link" select="." />
                                        <xsl:with-param name="value" select="." />
                                    </xsl:call-template>
                                </xsl:for-each>
                            </TABLE>
                        </TD>
                    </TR>

                    <!-- loose comments -->
                    <xsl:for-each select="//Comments/Comment[xt:intersection(.//text() | .//REF, ($searchFragments))]">
                        <TR>
                            <TD>
                                <xsl:call-template name="showComments">
                                    <xsl:with-param name="comments" select="." />
                                    <xsl:with-param name="person" select="($person)" />
                                    <xsl:with-param name="item" select="($item)" />
                                    <xsl:with-param name="idrefs" select="id(.//REF/@ref)" />
                                </xsl:call-template>
                            </TD>
                        </TR>
                    </xsl:for-each>

                    <!-- parts of articles -->
                    <xsl:for-each select="//Comments/Article">

                        <!-- select comments with children that contain the search string -->
                        <xsl:variable name="articleComments"
                            select="Comment[xt:intersection(.//text() | .//REF, ($searchFragments))]"/>
                        <xsl:if test="count($articleComments) > 0">
                            <TR>
                                <TD>
                                    <xsl:call-template name="showComments">
                                        <xsl:with-param name="comments" select="($articleComments)" />
                                        <xsl:with-param name="person" select="($person)" />
                                        <xsl:with-param name="item" select="($item)" />
                                        <xsl:with-param name="idrefs" select=". | id(($articleComments)//REF/@ref)" />
                                    </xsl:call-template>
                                </TD>
                            </TR>
                        </xsl:if>
                    </xsl:for-each>

                </xsl:when>
            </xsl:choose>
        </TABLE>
    </xsl:template>

    <xsl:template name="showComments">
        <xsl:param name="comments"/>
        <xsl:param name="person"/>
        <xsl:param name="item"/>
        <xsl:param name="idrefs" />

        <TABLE border="0" cellpadding="10" cellspacing="0" width="100%">
            <CAPTION class="sourceCaption">
                <xsl:call-template name="showCommentCaption">
                    <xsl:with-param name="item" select="($comments)[position()=1]" />
                </xsl:call-template>
            </CAPTION>
            <TR>
                <TD>
                    <xsl:call-template name="showCommentsBody">
                        <xsl:with-param name="comments" select="($comments)" />
                    </xsl:call-template>
                </TD>
<!--                <TD valign="top">
                    <xsl:call-template name="showRefs">
                        <xsl:with-param name="person" select="($person)" />
                        <xsl:with-param name="item" select="($item)" />
                        <xsl:with-param name="idrefs" select="($idrefs)" />
                    </xsl:call-template>
                </TD>
-->
            </TR>
        </TABLE>
    </xsl:template>

    <xsl:template name="showCommentsBody">
        <xsl:param name="comments"/>
        
        <TABLE border="0" cellpadding="0" cellspacing="0" width="100%" class="paper">
            <TR>
                <TD height="11" width="12" background="resources/upperleft.gif"></TD>
                <TD height="11" background="resources/uppermiddle.gif"></TD>
                <TD height="11" width="16" background="resources/upperright.gif" ></TD>
            </TR>
            <TR>
                <TD background="resources/left.gif" width="12"></TD>
                <TD bgcolor="#FFFFFF" align="left">
                    <IMG src="resources/staple.gif" />
                    <xsl:for-each select="($comments)">
                        <!-- if the previous comment in ($comments) was not the previous
                            comment in the article, warn the reader -->
                        <xsl:variable name="prevPos" select="position()-1"/>
                        <xsl:if test="position() > 1 and
                            count(preceding-sibling::Comment[position()=1] |
                                ($comments)[position() = ($prevPos)]) = 2">
                            <DIV></DIV>
                            <CENTER>--- part of article left out here ---</CENTER>
                        </xsl:if>
                        <xsl:apply-templates select="." />
                    </xsl:for-each>
                </TD>
                <TD background="resources/right.gif" width="16"></TD>
            </TR>
            <TR>
                <TD background="resources/lowerleft.gif" width="12" height="16"></TD>
                <TD height="16" background="resources/lowermiddle.gif"></TD>
                <TD width="16" height="16" background="resources/lowerright.gif"></TD>
            </TR>
        </TABLE>
    </xsl:template>

    <xsl:template name="showCommentCaption">
        <xsl:param name="item"/>

        <xsl:choose>
            <xsl:when test="local-name(($item)/..) = 'Article'">
                <xsl:text>from the article "</xsl:text>
                <I>
                <!--<xsl:value-of select="($item)/../@title" />-->
                    <A href="/andreas/p1_{($item)/../@id}.php" target="andreas">
                        <xsl:apply-templates select="id(($item)/../@id)" mode="cell"/>
                    </A>
                </I>
                <xsl:text>":</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="id(@authors)/@name" />
                <xsl:text> notes:</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="showRefs">
        <xsl:param name="person"/>
        <xsl:param name="item"/>
        <xsl:param name="idrefs" />

        <TABLE cellspacing="5" cellpadding="0">
            <TR>
                <TD colspan="2" class="value">
                    <xsl:if test="count($idrefs[(./@id != ($person)/@id ) and ( ./@id != ($item)/@id )])">
                    More about...
                    </xsl:if>
                </TD>
            </TR>
            <xsl:for-each select="($idrefs)">
                <xsl:if test="( ./@id != ($person)/@id ) and ( ./@id != ($item)/@id )">
                    <TR>
                        <xsl:call-template name="showLinkedValue">
                            <xsl:with-param name="person" select="($person)" />
                            <xsl:with-param name="link" select="." />
                            <xsl:with-param name="value" select="." />
                        </xsl:call-template>
                    </TR>
                </xsl:if>
            </xsl:for-each>
        </TABLE>
    </xsl:template>
        

    <!-- attribute name templates -->

    <xsl:template match="Album" mode="name">Album</xsl:template>
    <xsl:template match="AlbumEdition" mode="name">Album Edition</xsl:template>
    <xsl:template match="Article" mode="name">Article</xsl:template>
    <xsl:template match="Collection" mode="name">Collection</xsl:template>
    <xsl:template match="Illustration" mode="name">Illustration</xsl:template>
    <xsl:template match="Language" mode="name">Language</xsl:template>
    <xsl:template match="Magazine" mode="name">Magazine</xsl:template>
    <xsl:template match="MagazineItem" mode="name">Magazine Publication</xsl:template>
    <xsl:template match="MI" mode="name">Magazine Publication</xsl:template>
    <xsl:template match="Person" mode="name">Person</xsl:template>
    <xsl:template match="Preface" mode="name">Preface</xsl:template>
    <xsl:template match="Publisher" mode="name">Publisher</xsl:template>
    <xsl:template match="Series" mode="name">Series</xsl:template>
    <xsl:template match="Story" mode="name">Story</xsl:template>
    <xsl:template match="Photo" mode="name">Photo</xsl:template>
    <xsl:template match="Year" mode="name">Year</xsl:template>
    <xsl:template match="WWWlink" mode="name">Link</xsl:template>

    <xsl:template match="@album" mode="name">Album</xsl:template>
    <xsl:template match="@authors" mode="name">Author</xsl:template>
    <xsl:template match="@address" mode="name">Address</xsl:template>
    <xsl:template match="@albumEditions" mode="name">Edition</xsl:template>
    <xsl:template match="@articles" mode="name">Article</xsl:template>
    <xsl:template match="@collection" mode="name">Collection</xsl:template>
    <xsl:template match="@color" mode="name">Drawings in</xsl:template>
    <xsl:template match="@cover" mode="name">Cover</xsl:template>
    <xsl:template match="@d" mode="name">D</xsl:template>
    <xsl:template match="@description" mode="name">Description</xsl:template>
    <xsl:template match="@drawings" mode="name">Draftsman</xsl:template>
    <xsl:template match="@colorist" mode="name">Colorist</xsl:template>
    <xsl:template match="@exCount" mode="name">Number of copies</xsl:template>
    <xsl:template match="@fullName" mode="name">Full Name</xsl:template>
    <xsl:template match="@isbn" mode="name">ISBN</xsl:template>
    <xsl:template match="@issn" mode="name">ISSN</xsl:template>
    <xsl:template match="@illustrations" mode="name">Illustration</xsl:template>
    <xsl:template match="@language" mode="name">Language</xsl:template>
    <xsl:template match="@magazines" mode="name">Magazine</xsl:template>
    <xsl:template match="@name" mode="name">Name</xsl:template>
    <xsl:template match="@numbered" mode="name">Numbered</xsl:template>
    <xsl:template match="@pageCount" mode="name">Number of pages</xsl:template>
    <xsl:template match="@persons" mode="name">About</xsl:template>
    <xsl:template match="@preface" mode="name">Preface</xsl:template>
    <xsl:template match="@shortDescription" mode="name">Short Description</xsl:template>
    <xsl:template match="@signed" mode="name">Signed</xsl:template>
    <xsl:template match="@startDate" mode="name">Started at</xsl:template>
    <xsl:template match="@stories" mode="name">Story</xsl:template>
    <xsl:template match="@text" mode="name">Scenario</xsl:template>
    <xsl:template match="@colorist" mode="name">Colorist</xsl:template>
    <xsl:template match="@title" mode="name">Title</xsl:template>
    <xsl:template match="@year" mode="name">Year</xsl:template>
    <xsl:template match="@width" mode="name">Width</xsl:template>
    <xsl:template match="@height" mode="name">Height</xsl:template>
    <xsl:template match="@file" mode="name">Full size</xsl:template>




    <xsl:template match="Comment">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="Q">
        <DIV></DIV> <!-- BR takes two lines! -->
        <DIV class="question">
            <xsl:apply-templates/>
        </DIV>
    </xsl:template>

    <xsl:template match="A">
        <DIV class="answer">
            <xsl:if test="@text">
                <I>
                    <xsl:value-of select="id(@text)/@name" />
                    <xsl:text>: </xsl:text>
                </I>
            </xsl:if>
            <xsl:apply-templates/>
        </DIV>
    </xsl:template>

    <xsl:template match="TEXT">
        <DIV></DIV> <!-- BR takes two lines! -->
        <xsl:if test="@title">
            <DIV class="commentTitle">
                <xsl:value-of select="@title" />
            </DIV>
        </xsl:if>
        <DIV class="text">
            <xsl:apply-templates/>
        </DIV>
    </xsl:template>

    <xsl:template match="EDITOR">
        <xsl:text>(site-editor: </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="QUOTE">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>

    <xsl:template match="NAME">
        <xsl:text>'</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>'</xsl:text>
    </xsl:template>

    <xsl:template match="REF">
        <A href="/andreas/p1_{@ref}.php" target="andreas">
            <xsl:apply-templates select="id(@ref)" mode="cell"/>
        </A>
    </xsl:template>

    <xsl:template match="EM">
        <I><xsl:apply-templates/></I>
    </xsl:template>

    <xsl:template match="ul">
        <UL><xsl:apply-templates/></UL>
    </xsl:template>

    <xsl:template match="li">
        <LI><xsl:apply-templates/></LI>
    </xsl:template>

    <xsl:template match="B">
        <B><xsl:apply-templates/></B>
    </xsl:template>

    <xsl:template match="BR">
        <BR/>
    </xsl:template>
	
	<xsl:template match="Google_AdSense">
	<center>
	
	
	</center>
	</xsl:template>
	
	
	
	<xsl:template match="Google_Search">
<!-- SiteSearch Google -->
<form method="get" action="http://www.google.com/custom">
<table border="0" bgcolor="#ffffff">
<tr><td nowrap="nowrap" valign="top" align="left" height="32">
<a href="http://www.google.com/">
<img src="http://www.google.com/logos/Logo_25wht.gif"
border="0" alt="Google"></img></a>
<br/>
<input type="hidden" name="domains" value="www.dossier-andreas.net"></input>
<input type="text" name="q" size="25" maxlength="255" value=""></input>
<input type="submit" name="sa" value="Search"></input>
</td></tr>
<tr>
<td nowrap="nowrap">
<table>
<tr>
<td>
<input type="radio" name="sitesearch" value=""></input>
<font size="-1" color="#000000">Web</font>
</td>
<td>
<input type="radio" name="sitesearch" value="www.dossier-andreas.net" checked="checked"></input>
<font size="-1" color="#000000">www.dossier-andreas.net</font>
</td>
</tr>
</table>
<input type="hidden" name="client" value="pub-0013216818667756"></input>
<input type="hidden" name="forid" value="1"></input>
<input type="hidden" name="ie" value="ISO-8859-1"></input>
<input type="hidden" name="oe" value="ISO-8859-1"></input>
<input type="hidden" name="cof" value="GALT:#008000;GL:1;DIV:#336699;VLC:663399;AH:center;BGC:FFFFFF;LBGC:336699;ALC:0000FF;LC:0000FF;T:000000;GFNT:0000FF;GIMP:0000FF;FORID:1;"></input>
<input type="hidden" name="hl" value="en"></input>

</td></tr></table>
</form>
<!-- SiteSearch Google -->
	</xsl:template>

    <xsl:template match="Instagram_Widget">
        <blockquote class="instagram-media" 
            data-instgrm-captioned="1" data-instgrm-permalink="https://www.instagram.com/p/CmtniFBsgwq/" data-instgrm-version="14" style=" background:#FFF; border:0; border-radius:3px; box-shadow:0 0 1px 0 rgba(0,0,0,0.5),0 1px 10px 0 rgba(0,0,0,0.15); margin: 1px; max-width:540px; min-width:326px; padding:0; width:99.375%; width:-webkit-calc(100% - 2px); width:calc(100% - 2px);">
            <div style="padding:16px;"> <a href="https://www.instagram.com/p/CmtniFBsgwq/?utm_source=ig_embed&amp;utm_campaign=loading" style=" background:#FFFFFF; line-height:0; padding:0 0; text-align:center; text-decoration:none; width:100%;" target="_blank"> <div style=" display: flex; flex-direction: row; align-items: center;"> <div style="background-color: #F4F4F4; border-radius: 50%; flex-grow: 0; height: 40px; margin-right: 14px; width: 40px;"></div> <div style="display: flex; flex-direction: column; flex-grow: 1; justify-content: center;"> <div style=" background-color: #F4F4F4; border-radius: 4px; flex-grow: 0; height: 14px; margin-bottom: 6px; width: 100px;"></div> <div style=" background-color: #F4F4F4; border-radius: 4px; flex-grow: 0; height: 14px; width: 60px;"></div></div></div><div style="padding: 19% 0;"></div> <div style="display:block; height:50px; margin:0 auto 12px; width:50px;"><svg width="50px" height="50px" viewBox="0 0 60 60" version="1.1" xmlns="https://www.w3.org/2000/svg" xmlns:xlink="https://www.w3.org/1999/xlink"><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-511.000000, -20.000000)" fill="#000000"><g><path d="M556.869,30.41 C554.814,30.41 553.148,32.076 553.148,34.131 C553.148,36.186 554.814,37.852 556.869,37.852 C558.924,37.852 560.59,36.186 560.59,34.131 C560.59,32.076 558.924,30.41 556.869,30.41 M541,60.657 C535.114,60.657 530.342,55.887 530.342,50 C530.342,44.114 535.114,39.342 541,39.342 C546.887,39.342 551.658,44.114 551.658,50 C551.658,55.887 546.887,60.657 541,60.657 M541,33.886 C532.1,33.886 524.886,41.1 524.886,50 C524.886,58.899 532.1,66.113 541,66.113 C549.9,66.113 557.115,58.899 557.115,50 C557.115,41.1 549.9,33.886 541,33.886 M565.378,62.101 C565.244,65.022 564.756,66.606 564.346,67.663 C563.803,69.06 563.154,70.057 562.106,71.106 C561.058,72.155 560.06,72.803 558.662,73.347 C557.607,73.757 556.021,74.244 553.102,74.378 C549.944,74.521 548.997,74.552 541,74.552 C533.003,74.552 532.056,74.521 528.898,74.378 C525.979,74.244 524.393,73.757 523.338,73.347 C521.94,72.803 520.942,72.155 519.894,71.106 C518.846,70.057 518.197,69.06 517.654,67.663 C517.244,66.606 516.755,65.022 516.623,62.101 C516.479,58.943 516.448,57.996 516.448,50 C516.448,42.003 516.479,41.056 516.623,37.899 C516.755,34.978 517.244,33.391 517.654,32.338 C518.197,30.938 518.846,29.942 519.894,28.894 C520.942,27.846 521.94,27.196 523.338,26.654 C524.393,26.244 525.979,25.756 528.898,25.623 C532.057,25.479 533.004,25.448 541,25.448 C548.997,25.448 549.943,25.479 553.102,25.623 C556.021,25.756 557.607,26.244 558.662,26.654 C560.06,27.196 561.058,27.846 562.106,28.894 C563.154,29.942 563.803,30.938 564.346,32.338 C564.756,33.391 565.244,34.978 565.378,37.899 C565.522,41.056 565.552,42.003 565.552,50 C565.552,57.996 565.522,58.943 565.378,62.101 M570.82,37.631 C570.674,34.438 570.167,32.258 569.425,30.349 C568.659,28.377 567.633,26.702 565.965,25.035 C564.297,23.368 562.623,22.342 560.652,21.575 C558.743,20.834 556.562,20.326 553.369,20.18 C550.169,20.033 549.148,20 541,20 C532.853,20 531.831,20.033 528.631,20.18 C525.438,20.326 523.257,20.834 521.349,21.575 C519.376,22.342 517.703,23.368 516.035,25.035 C514.368,26.702 513.342,28.377 512.574,30.349 C511.834,32.258 511.326,34.438 511.181,37.631 C511.035,40.831 511,41.851 511,50 C511,58.147 511.035,59.17 511.181,62.369 C511.326,65.562 511.834,67.743 512.574,69.651 C513.342,71.625 514.368,73.296 516.035,74.965 C517.703,76.634 519.376,77.658 521.349,78.425 C523.257,79.167 525.438,79.673 528.631,79.82 C531.831,79.965 532.853,80.001 541,80.001 C549.148,80.001 550.169,79.965 553.369,79.82 C556.562,79.673 558.743,79.167 560.652,78.425 C562.623,77.658 564.297,76.634 565.965,74.965 C567.633,73.296 568.659,71.625 569.425,69.651 C570.167,67.743 570.674,65.562 570.82,62.369 C570.966,59.17 571,58.147 571,50 C571,41.851 570.966,40.831 570.82,37.631"></path></g></g></g></svg></div><div style="padding-top: 8px;"> <div style=" color:#3897f0; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:550; line-height:18px;">View this post on Instagram</div></div><div style="padding: 12.5% 0;"></div> <div style="display: flex; flex-direction: row; margin-bottom: 14px; align-items: center;"><div> <div style="background-color: #F4F4F4; border-radius: 50%; height: 12.5px; width: 12.5px; transform: translateX(0px) translateY(7px);"></div> <div style="background-color: #F4F4F4; height: 12.5px; transform: rotate(-45deg) translateX(3px) translateY(1px); width: 12.5px; flex-grow: 0; margin-right: 14px; margin-left: 2px;"></div> <div style="background-color: #F4F4F4; border-radius: 50%; height: 12.5px; width: 12.5px; transform: translateX(9px) translateY(-18px);"></div></div><div style="margin-left: 8px;"> <div style=" background-color: #F4F4F4; border-radius: 50%; flex-grow: 0; height: 20px; width: 20px;"></div> <div style=" width: 0; height: 0; border-top: 2px solid transparent; border-left: 6px solid #f4f4f4; border-bottom: 2px solid transparent; transform: translateX(16px) translateY(-4px) rotate(30deg)"></div></div><div style="margin-left: auto;"> <div style=" width: 0px; border-top: 8px solid #F4F4F4; border-right: 8px solid transparent; transform: translateY(16px);"></div> <div style=" background-color: #F4F4F4; flex-grow: 0; height: 12px; width: 16px; transform: translateY(-4px);"></div> <div style=" width: 0; height: 0; border-top: 8px solid #F4F4F4; border-left: 8px solid transparent; transform: translateY(-4px) translateX(8px);"></div></div></div> <div style="display: flex; flex-direction: column; flex-grow: 1; justify-content: center; margin-bottom: 24px;"> <div style=" background-color: #F4F4F4; border-radius: 4px; flex-grow: 0; height: 14px; margin-bottom: 6px; width: 224px;"></div> <div style=" background-color: #F4F4F4; border-radius: 4px; flex-grow: 0; height: 14px; width: 144px;"></div></div></a><p style=" color:#c9c8cd; font-family:Arial,sans-serif; font-size:14px; line-height:17px; margin-bottom:0; margin-top:8px; overflow:hidden; padding:8px 0 7px; text-align:center; text-overflow:ellipsis; white-space:nowrap;"><a href="https://www.instagram.com/p/CmtniFBsgwq/?utm_source=ig_embed&amp;utm_campaign=loading" style=" color:#c9c8cd; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:normal; line-height:17px; text-decoration:none;" target="_blank">A post shared by Andreas Martens (@andreastries)</a></p></div>
        </blockquote>
        <script async="1" src="//www.instagram.com/embed.js"></script>
    </xsl:template>
	
	<xsl:template match="Twitter_Widget">
	<!-- Twitter Widget -->
	
<a class="twitter-timeline"  href="https://twitter.com/wattmanworm"  data-widget-id="418010879699865601">Tweets by @wattmanworm</a>
    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>


	<!-- Twitter Widget -->
	</xsl:template>
	
	<xsl:template match="Recent_Comments">
	<xsl:processing-instruction name='php'>
			include(dirname(__FILE__) . '/php/andreas.php'); 
			$CMS->showLatestNotesPreview();
		?</xsl:processing-instruction>
	</xsl:template>

    <xsl:template match="TITLE">
        <B><xsl:apply-templates/></B>
        <BR/>
    </xsl:template>

    <xsl:template match="WWWsite">
        <P>
            <DIV class="paragraphCaption">
                <xsl:value-of select="@title" />
            </DIV>
            <xsl:apply-templates/>
        </P>
    </xsl:template>
    
    <xsl:template match="IMG">
        <IMG src="{@src}" align="{@align}" hspace="5" vspace="5" />
    </xsl:template>

    <xsl:template match="AH">
        <A href="{@href}" target="{@target}" id="{@id}">
			<xsl:apply-templates/>
		</A>
    </xsl:template>

    <xsl:template match="WWWlink">
        <SPAN class="value">
            <xsl:apply-templates select="id(@language)" mode="cell"/>
        </SPAN>
        <BR/>
		<A href="{@href}" target="external">
	        <xsl:choose>
				<xsl:when test="@title">
					<xsl:value-of select="@title" />
				</xsl:when>
				<xsl:when test="@href">
					<xsl:value-of select="@href" />
				</xsl:when>
	        </xsl:choose>
        </A>
        <xsl:apply-templates/>
        <BR/>
    </xsl:template>

</xsl:stylesheet>
