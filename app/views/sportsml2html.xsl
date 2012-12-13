<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:redirect="org.apache.xalan.xslt.extensions.Redirect"
	extension-element-prefixes="redirect"
	>

<xsl:strip-space elements="*"/>

<xsl:output method="html"
            encoding="ISO-8859-1"/>

<!-- Created by Johan Lindgren (TT, Sweden) to show various possible outputs from SportsML.
     It's not intended to handle all possible combinations of data in SportsML -
     but to show how some date can be grouped and presented.
     Primarily for the development process of SportsML itself.
     -->


<!--      MAIN TEMPLATE   -->
<xsl:template match="sports-content">
	<html>
		<head>
			<title><xsl:value-of select="sports-metadata/sports-title"/></title>
			<link rel="stylesheet" type="text/css" href="assets/css/vendor/sportsml.css" />
            <link rel="stylesheet" type="text/css" href="assets/css/sportsml-custom.css" />
		</head>
		<body class="bg_standings">
		<h1 class="docTitle"><xsl:value-of select="sports-metadata/sports-title"/></h1>
            <xsl:choose>
			<xsl:when test="sports-content">
				<xsl:apply-templates/>    <!-- Call all subtemplates -->
			</xsl:when>
			<xsl:otherwise>
				<table width="100%" class="bodyTable" cellpadding="3"><tr valign="top"><td>
				<!--
				<xsl:apply-templates />
				-->

				<!-- comment out below when you do not want metadata block -->
				<!--
				<xsl:apply-templates select="sports-metadata"/>
				-->

				<xsl:apply-templates select="article"/>
				<xsl:apply-templates select="sports-event"/>
				<xsl:apply-templates select="tournament"/>
				<xsl:apply-templates select="standing"/><div class="standings-key">
                  <b>GP</b> = Games Played; 
                  <b>W</b> = Wins; 
                  <b>L</b> = Losses; 
                  <b>T</b> = Ties; 
                  <b>PF</b> = Points For; 
                  <b>PA</b> = Points Against; 
                  <b>PD</b> = Points Differential; 
                  <b>BT</b> = Try Bonus (4 Tries or More); 
                  <b>BL</b> = Loss Bonus (Loss by 7 or Less); 
                  <b>FF</b> = Forfeit Deduction; 
                  <b>PTS</b> = League Points
                </div>
				<xsl:apply-templates select="schedule"/>
				<xsl:apply-templates select="statistic"/>
				</td></tr></table>
			</xsl:otherwise>
            </xsl:choose>
		</body>
	</html>
</xsl:template>
<!-- end main template -->



<!-- below is used for roster -->
<xsl:template match="statistic">
	<br />
	<!-- for a statistic with a list of teams -->
	<xsl:for-each select="team">
	<b>
	<xsl:call-template name="choose-name">
	<xsl:with-param name="team-meta" select="team-metadata"/>
	<xsl:with-param name="shownickname" select="'no'"/>
	</xsl:call-template>:</b>
	<br />
	<table cellpadding="3" border="1" class="roster">
	<tr>
	<xsl:if test="player[1]/player-metadata/@uniform-number"><th>#</th></xsl:if>
	<th>name</th>
	<xsl:if test="player[1]/player-metadata/@date-of-birth"><th>date of birth</th></xsl:if>
	<xsl:if test="player[1]/player-metadata/@height"><th>height</th></xsl:if>
	<xsl:if test="player[1]/player-metadata/@weight"><th>weight</th></xsl:if>
	<xsl:if test="player[1]/player-metadata/@position-regular"><th>position</th></xsl:if>
	<xsl:if test="player[1]/player-metadata/@health"><th>health</th></xsl:if>
	<xsl:if test="player[1]/player-metadata/home-location/@city"><th>home city</th></xsl:if>
	<xsl:if test="player[1]/player-metadata/player-metadata-baseball/@batting-hand"><th>bats</th></xsl:if>
	<xsl:if test="player[1]/player-metadata/player-metadata-baseball/@throwing-hand"><th>throws</th></xsl:if>
	<xsl:if test="player[1]/player-metadata/career-phase/@phase-type='college' and player[1]/player-metadata/career-phase/@name"><th>college</th></xsl:if>
	<xsl:if test="player[1]/player-metadata/career-phase/@phase-type='college' and player[1]/player-metadata/career-phase/@end-date"><th>grad.</th></xsl:if>
	<xsl:if test="player[1]/player-metadata/career-phase/@phase-type='professional' and player[1]/player-metadata/career-phase/@duration"><th>yrs. pro</th></xsl:if>
	</tr>
	<xsl:for-each select="player">
		<tr>
		<xsl:if test="player-metadata/@uniform-number"><td><xsl:value-of select="player-metadata/@uniform-number"/></td></xsl:if>
		<td nowrap="nowrap"><b>
			<xsl:call-template name="choose-name">
				<xsl:with-param name="team-meta" select="player-metadata"/>
				<xsl:with-param name="shownickname" select="'no'"/>
				<xsl:with-param name="showuniform" select="'no'"/>
			</xsl:call-template>
		</b></td>
		<xsl:if test="player-metadata/@date-of-birth"><td nowrap="nowrap"><xsl:value-of select="player-metadata/@date-of-birth"/></td></xsl:if>
		<xsl:if test="player-metadata/@height"><td><xsl:value-of select="player-metadata/@height"/></td></xsl:if>
		<xsl:if test="player-metadata/@weight"><td><xsl:value-of select="player-metadata/@weight"/></td></xsl:if>
		<xsl:if test="player-metadata/@position-regular"><td><xsl:value-of select="player-metadata/@position-regular"/></td></xsl:if>
		<xsl:if test="player-metadata/@health"><td><xsl:value-of select="player-metadata/@health"/></td></xsl:if>
		<xsl:if test="player-metadata/home-location/@city"><td><xsl:value-of select="player-metadata/home-location/@city"/></td></xsl:if>
		<xsl:if test="player-metadata/player-metadata-baseball/@batting-hand"><td><xsl:value-of select="player-metadata/player-metadata-baseball/@batting-hand"/></td></xsl:if>
		<xsl:if test="player-metadata/player-metadata-baseball/@throwing-hand"><td><xsl:value-of select="player-metadata/player-metadata-baseball/@throwing-hand"/></td></xsl:if>
		<xsl:if test="player-metadata/career-phase/@phase-type='college' and player-metadata/career-phase/@name"><td><xsl:value-of select="player-metadata/career-phase/@name"/></td></xsl:if>
		<xsl:if test="player-metadata/career-phase/@phase-type='college' and player-metadata/career-phase/@end-date"><td><xsl:value-of select="player-metadata/career-phase/@end-date"/></td></xsl:if>
		<xsl:if test="player-metadata/career-phase/@phase-type='professional' and player-metadata/career-phase/@duration"><td><xsl:value-of select="player-metadata/career-phase/@duration"/></td></xsl:if>

	<!--
	<career-phase type="professional" duration="R">
	</career-phase>
	<career-phase type="college" name="Colorado" end-date="00">
	</career-phase>
	-->
		<!--
		      <xsl:choose>
		       <xsl:when test="player-metadata/name/@full">
		        <xsl:value-of select="player-metadata/name/@full"/>
		       </xsl:when>
		       <xsl:otherwise>
		        <xsl:value-of select="player-metadata/name/@first"/><xsl:text> </xsl:text>
		        <xsl:value-of select="player-metadata/name/@last"/>
		       </xsl:otherwise>
		      </xsl:choose>
		-->
		</tr>
	</xsl:for-each>
	</table><br/>
	</xsl:for-each>

	<!-- for a statistic with a list of players -->
     <xsl:for-each select="player">

       <li>
       <xsl:call-template name="choose-name">
        <xsl:with-param name="team-meta" select="player-metadata"/>
        <xsl:with-param name="shownickname" select="'no'"/>
        <xsl:with-param name="showuniform" select="'yes'"/>
       </xsl:call-template>
       <xsl:value-of select="player-metadata/@height"/><xsl:text>, </xsl:text>
       <xsl:value-of select="player-metadata/@weight"/><xsl:text> </xsl:text>
       from <xsl:value-of select="player-metadata/home-location/@city"/>

<!--      <xsl:choose>
       <xsl:when test="player-metadata/name/@full">
        <xsl:value-of select="player-metadata/name/@full"/>
       </xsl:when>
       <xsl:otherwise>
        <xsl:value-of select="player-metadata/name/@first"/><xsl:text> </xsl:text>
        <xsl:value-of select="player-metadata/name/@last"/>
       </xsl:otherwise>
      </xsl:choose>
      -->
      </li>

     </xsl:for-each>

 </xsl:template>


<!-- template for standings -->
<xsl:template match="standing">
	<!-- uncomment the part below when debugging -->
	<!--
	<table><tr><td bgcolor="#cccccc">
	<xsl:apply-templates select="standing-metadata/sports-content-codes"/>
	</td></tr></table>
	-->

	<table class="smalltable" valign="top" cellpadding="4">  <!--start a table-->
	<tr class="blueline">
		<td colspan="9"><b><xsl:value-of select="standing-metadata/sports-content-codes/sports-content-code[1]/@code-name"/></b></td>
		<xsl:for-each select="team[1]/team-stats/outcome-totals">
			<xsl:choose>
			<xsl:when test="(@duration-scope = 'events-most-recent-10')">
				<td colspan="3">Last 10</td>
			</xsl:when>
			<xsl:when test="(@competition-scope = 'conference-opposing')">
				<td colspan="3">Interleague</td>
			</xsl:when>
			<xsl:when test="not(@duration-scope) and not(@competition-scope) and (@alignment-scope = 'events-home')">
				<td colspan="3" align="center">home</td>
			</xsl:when>
			<xsl:when test="not(@duration-scope) and not(@competition-scope) and (@alignment-scope = 'events-away')">
				<td colspan="3" align="center">away</td>
			</xsl:when>
			<xsl:when test="not(@duration-scope) and not(@alignment-scope) and (@competition-scope = 'division')">
				<td colspan="3" align="center">division</td>
			</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</tr>
	<tr class="blueline">
		<td><xsl:if test="@date-label or @content-label"><xsl:value-of select="@content-label"/><xsl:text></xsl:text><xsl:value-of select="@date-label"/></xsl:if></td>
        <td>GP</td>
		<td>W</td>
		<td>L</td>
		<td>T</td>
        <td>
          <span title="points scored for">PF</span>
        </td>
        <td>
          <span title="points scored against">PA</span>
        </td>
        <td>
          <span title="points differential">PD</span>
        </td>
		<xsl:if test="team[1]/team-stats/outcome-totals/@try-bonus"><td>BT</td></xsl:if>
		<xsl:if test="team[1]/team-stats/outcome-totals/@loss-bonus"><td>BL</td></xsl:if>
        	<xsl:if test="team[1]/team-stats/outcome-totals/@forfeits"><td>FF</td></xsl:if>
        	<td>PTS</td>
		<xsl:for-each select="team[1]/team-stats/outcome-totals">
		<xsl:choose>
		<xsl:when test="(@duration-scope = 'events-most-recent-10')">
			<td>W</td>
			<td>L</td>
			<td>T</td>
		</xsl:when>
		<xsl:when test="(@competition-scope = 'conference-opposing')">
			<td>W</td>
			<td>L</td>
			<td>T</td>
		</xsl:when>
		<xsl:when test="not(@duration-scope) and not(@competition-scope) and (@alignment-scope = 'events-home')">
			<td>W</td>
			<td>L</td>
			<td>T</td>
		</xsl:when>
		<xsl:when test="not(@duration-scope) and not(@competition-scope) and (@alignment-scope = 'events-away')">
			<td>W</td>
			<td>L</td>
			<td>T</td>
		</xsl:when>
		<xsl:when test="not(@duration-scope) and not(@alignment-scope) and (@competition-scope = 'division')">
			<td>W</td>
			<td>L</td>
			<td>T</td>
		</xsl:when>
		</xsl:choose>
		</xsl:for-each>
	</tr>

	<xsl:for-each select="team">             <!--process all teams-->
		<xsl:call-template name="standing-team">
			<xsl:with-param name="oneteam" select="."/>
		</xsl:call-template>
	</xsl:for-each>
	</table>
</xsl:template>
<!-- end template for standing -->

<!-- Named template to process a  team in a standing -->
<xsl:template name="standing-team">
	<xsl:param name="oneteam"/>
	<tr class="td-stats" valign="baseline">
      <!--one row for each team-->
		<td nowrap="nowrap"><b>
			<xsl:for-each select="$oneteam/team-metadata/name"> <!--Build the name in the second field-->
			<xsl:if test="@language">
			<xsl:value-of select="@language"/>:
			</xsl:if>
			<xsl:call-template name="choose-name">
			<xsl:with-param name="team-meta" select="$oneteam/team-metadata"/>
			<xsl:with-param name="shownickname" select="'yes'"/>
			</xsl:call-template>
			<br/>
			</xsl:for-each>
		</b></td>
        	<td>
			<xsl:value-of select="$oneteam/team-stats/@events-played"/>
		</td>

		<td class="wincell">
			<xsl:value-of select="$oneteam/team-stats/outcome-totals/@wins"/>
		</td>
		<td class="losecell">
			<xsl:value-of select="$oneteam/team-stats/outcome-totals/@losses"/>
		</td>
		<td class="tiecell">
			<xsl:value-of select="$oneteam/team-stats/outcome-totals/@ties"/>
		</td>
		<td>
			<xsl:value-of select="$oneteam/team-stats/outcome-totals/@points-scored-for"/>
		</td>
		<td>
			<xsl:value-of select="$oneteam/team-stats/outcome-totals/@points-scored-against"/>
		</td>
        <td><span title="Points Differential"><xsl:value-of select="$oneteam/team-stats/outcome-totals/@points-differential"/></span></td>
		<xsl:if test="$oneteam/team-stats/outcome-totals/@try-bonus">
        		<td>
            			<xsl:value-of select="$oneteam/team-stats/outcome-totals/@try-bonus"/>
                        </td>
                </xsl:if>
                <xsl:if test="$oneteam/team-stats/outcome-totals/@loss-bonus">
			<td>
				<xsl:value-of select="$oneteam/team-stats/outcome-totals/@loss-bonus"/>
			</td>
		</xsl:if>
                <td>
            		<xsl:value-of select="$oneteam/team-stats/outcome-totals/@forfeits"/>
           	</td>
        	<td>
			<span class="points"><xsl:value-of select="$oneteam/team-stats/@standing-points"/></span>
		</td>
		<!-- NOTE: Should add in logic for overtime losses and other combinations -->

		<xsl:for-each select="$oneteam/team-stats/outcome-totals">
			<xsl:choose>
			<xsl:when test="(@duration-scope = 'events-most-recent-10')">
				<td class="wincell"><xsl:value-of select="@wins"/></td>
				<td><xsl:value-of select="@losses"/></td>
				<td><xsl:value-of select="@ties"/></td>
			</xsl:when>
			<xsl:when test="(@competition-scope = 'conference-opposing')">
				<td class="wincell"><xsl:value-of select="@wins"/></td>
				<td><xsl:value-of select="@losses"/></td>
				<td><xsl:value-of select="@ties"/></td>
			</xsl:when>
			<xsl:when test="not(@duration-scope) and not(@competition-scope) and (@alignment-scope = 'events-home')">
				<td class="wincell"><xsl:value-of select="@wins"/></td>
				<td><xsl:value-of select="@losses"/></td>
				<td><xsl:value-of select="@ties"/></td>
			</xsl:when>
			<xsl:when test="not(@duration-scope) and not(@competition-scope) and (@alignment-scope = 'events-away')">
				<td class="wincell"><xsl:value-of select="@wins"/></td>
				<td><xsl:value-of select="@losses"/></td>
				<td><xsl:value-of select="@ties"/></td>
			</xsl:when>
			<xsl:when test="not(@duration-scope) and not(@alignment-scope) and (@competition-scope = 'division')">
				<td class="wincell"><xsl:value-of select="@wins"/></td>
				<td><xsl:value-of select="@losses"/></td>
				<td><xsl:value-of select="@ties"/></td>
			</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</tr>
</xsl:template>
<!-- end template for team lists in standings -->


<!-- Template to catch schedules -->
<xsl:template match="schedule">
	<h1 class="docTitle"><xsl:value-of select="../sports-metadata/sports-title"/></h1>
	<xsl:if test="@date-label or @content-label">
		<h3 class="schedline"> Schedule: <xsl:value-of select="@content-label"/><xsl:text> </xsl:text><xsl:value-of select="@date-label"/></h3>
	</xsl:if>
	<table class="mediumtable" cellpadding="4">
		<tr bgcolor="#cccccc"><td><b>date</b></td><td><b>home team</b></td><td></td><td><b>visiting team</b></td></tr>
		<xsl:for-each select="sports-event">
			<xsl:call-template name="event-schedule">
				<xsl:with-param name="oneevent" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	<!-- <xsl:apply-templates select="sports-event"/>-->
	</table>
</xsl:template>
<!-- end template for schedules -->



<!-- Template for the elements and attributes of sports-metadata -->
<xsl:template match="sports-metadata">
	<div class="sportsMetadata">
	<table cellpadding="6" width="100%">
		<tr><td bgcolor="#cccccc"><h1 class="titleheading"><xsl:value-of select="sports-title"/></h1></td></tr>
	</table>
	<br/>
	<table cellpadding="3" bgcolor="#ccff99">
	<tr>
	<td><xsl:if test="advisory"><p class="note"><i>Note:  </i><xsl:value-of select="advisory"/></p></xsl:if>

		<table width="100%" class="smalltable" border="1" cellpadding="3">
		<tr><th bgcolor="black" colspan="2"><font color="white">metadata</font></th></tr>
		<tr><td>docpath:</td><td><b><xsl:value-of select="../../@docpath"/></b></td></tr>
		<tr><td>doc-ID:</td><td><b><xsl:value-of select="@doc-id"/></b></td></tr>
		<xsl:if test="@publisher"><tr><td>publisher:</td><td><b><xsl:value-of select="@publisher"/></b></td></tr></xsl:if>
		<xsl:if test="@date-time"><tr><td>date-time:</td><td><b><xsl:call-template name="formatted-date-time"><xsl:with-param name="date-value" select="@date-time"/></xsl:call-template></b></td></tr></xsl:if>
		<xsl:if test="@slug"><tr><td>slug:</td><td><b><xsl:value-of select="@slug"/></b></td></tr></xsl:if>
		<xsl:if test="@language"><tr><td>language:</td><td><b><xsl:value-of select="@language"/></b></td></tr></xsl:if>
		<xsl:if test="@feature-name"><tr><td>feature-name:</td><td><b><xsl:value-of select="@feature-name"/></b></td></tr></xsl:if>
		<xsl:if test="@fixture-key"><tr><td>fixture-key:</td><td><b><xsl:value-of select="@fixture-key"/></b></td></tr></xsl:if>
		<xsl:if test="@fixture-key-source"><tr><td>source:</td><td><b><xsl:value-of select="@fixture-key-source"/></b></td></tr></xsl:if>
		<xsl:if test="@fixture-name"><tr><td>name:</td><td><b><xsl:value-of select="@fixture-name"/></b></td></tr></xsl:if>
		<xsl:if test="@stats-coverage"><tr><td>stats-coverage</td><td><xsl:value-of select="@stats-coverage"/></td></tr></xsl:if>
		<xsl:if test="@event-coverage-type"><tr><td>event-coverage-type</td><td><xsl:value-of select="@event-coverage-type"/></td></tr></xsl:if>
		<xsl:if test="@date-coverage-type"><tr><td>date-coverage-type</td><td><xsl:value-of select="@date-coverage-type"/><xsl:if test="@date-coverage-value"> (<xsl:value-of select="@date-coverage-value"/>)</xsl:if></td></tr></xsl:if>
		<xsl:if test="@competition-scoping"><tr><td>competition-scoping</td><td><xsl:value-of select="@competition-scoping"/></td></tr></xsl:if>
		<xsl:if test="@alignment-scoping"><tr><td>alignment-scoping</td><td><xsl:value-of select="@alignment-scoping"/></td></tr></xsl:if>
		<xsl:if test="@team-scoping"><tr><td>team-scoping</td><td><xsl:value-of select="@team-scoping"/></td></tr></xsl:if>
		</table>
	
		<xsl:apply-templates select="sports-content-codes"/>

	</td>
	</tr>
	</table>
	</div>
</xsl:template>
<!-- end Sports metadata section -->


<!-- Special template for sports-content-codes since they can appear at several places -->
<xsl:template match="sports-content-codes">
	<table width="100%" class="smalltable" border="1">
		<tr><th bgcolor="black" colspan="4"><font color="white">codes</font></th></tr>
		<xsl:for-each select="sports-content-code">
		<tr>
			<xsl:for-each select="@*">
			<td><xsl:value-of select="."/></td>
				<xsl:for-each select="sports-content-qualifier">
				<td>(<xsl:for-each select="@*"><xsl:value-of select="."/> / </xsl:for-each>)</td>
				</xsl:for-each>
			</xsl:for-each>
		</tr>
		</xsl:for-each>
	</table>
</xsl:template>
<!-- end sports-content-codes -->

<!-- Template to handle a tournament  -->
<xsl:template match="tournament">
	<table width="100%" class="tournament">
	<tr>
		<td width="10%">     </td>
		<td>
		<xsl:apply-templates />
		</td>
	</tr>
	</table>
</xsl:template>
<!-- end one tournament -->


<!-- Template to handle a tournament metadata and division metadata -->
<xsl:template match="tournament-metadata|tournament-division-metadata">

 <xsl:if test="@tournament-name"><h3 class="tourname"><xsl:value-of select="@tournament-name"/></h3></xsl:if>
 <xsl:if test="@division-name"><h4 class="tourdivname"><xsl:value-of select="@division-name"/></h4></xsl:if>

 <xsl:if test="@start-date-time">
  <b><xsl:call-template name="formatted-date-time"><xsl:with-param name="date-value" select="@start-date-time"/></xsl:call-template>
  <xsl:if test="@end-date-time">
   - <xsl:call-template name="formatted-date-time"><xsl:with-param name="date-value" select="@end-date-time"/></xsl:call-template>
  </xsl:if></b>
 </xsl:if>

 <small>
  <xsl:value-of select="@tournament-key"/><xsl:if test="@tournament-key-source"> (<xsl:value-of select="@tournament-key-source"/>)</xsl:if>
  <xsl:value-of select="@division-key"/><xsl:if test="@division-key-source"> (<xsl:value-of select="@division-key-source"/>)</xsl:if>
 </small>

 <table class="smalltable">
  <xsl:if test="@stats-coverage or @event-coverage-type or @date-coverage-type">
  <tr>
   <xsl:if test="@stats-coverage"><td><xsl:value-of select="@stats-coverage"/></td></xsl:if>
   <xsl:if test="@event-coverage-type"><td><xsl:value-of select="@event-coverage-type"/></td></xsl:if>
   <xsl:if test="@date-coverage-type"><td><xsl:value-of select="@date-coverage-type"/><xsl:if test="@date-coverage-value"> (<xsl:value-of select="@date-coverage-value"/>)</xsl:if></td></xsl:if>
  </tr>
  </xsl:if>
  <xsl:if test="@competition-scoping or @alignment-scoping or @team-scoping">
  <tr>
   <xsl:if test="@competition-scoping"><td><xsl:value-of select="@competition-scoping"/></td></xsl:if>
   <xsl:if test="@alignment-scoping"><td><xsl:value-of select="@alignment-scoping"/></td></xsl:if>
   <xsl:if test="@team-scoping"><td><xsl:value-of select="@team-scoping"/></td></xsl:if>
  </tr>
  </xsl:if>
  <xsl:for-each select="award">
  <tr>
   <td><xsl:value-of select="@place"/></td><td><xsl:value-of select="@currency"/></td><td><xsl:value-of select="@value"/></td>
  </tr>
  </xsl:for-each>
 </table>
 <table class="smalltable">
  <tr align="center"><th colspan="3"><xsl:value-of select="@site-name"/></th></tr>
  <xsl:if test="@site-key or @site-alignment">
  <tr>
   <xsl:if test="@site-key"><td><xsl:value-of select="@site-key"/><xsl:if test="@site-key-source"> (<xsl:value-of select="@site-key-source"/>)</xsl:if></td></xsl:if>
   <xsl:if test="@site-alignment"><td><xsl:value-of select="@site-alignment"/></td></xsl:if>
  </tr>
  </xsl:if>
  <xsl:if test="@site-city or @site-state or @site-country">
  <tr>
   <xsl:if test="@site-city"><td><xsl:value-of select="@site-city"/><xsl:if test="@site-county"> (<xsl:value-of select="@site-county"/>)</xsl:if></td></xsl:if>
   <xsl:if test="@site-state"><td><xsl:value-of select="@site-state"/></td></xsl:if>
   <xsl:if test="@site-country"><td><xsl:value-of select="@site-country"/></td></xsl:if>
  </tr>
  </xsl:if>
  <xsl:if test="@site-attendance or @site-style or @site-surface">
  <tr>
   <xsl:if test="@site-attendance"><td><xsl:value-of select="@site-attendance"/><xsl:if test="@site-capacity"> (<xsl:value-of select="@site-capacity"/>)</xsl:if></td></xsl:if>
   <xsl:if test="@site-style"><td><xsl:value-of select="@site-style"/></td></xsl:if>
   <xsl:if test="@site-surface"><td><xsl:value-of select="@site-surface"/></td></xsl:if>
  </tr>
  </xsl:if>
  <xsl:if test="@site-temperature or @site-weather-wind or @site-weather-label">
  <tr>
   <xsl:if test="@site-temperature"><td><xsl:value-of select="@site-temperature"/><xsl:if test="@site-temperature-units"> (<xsl:value-of select="@site-temperature-units"/>)</xsl:if></td></xsl:if>
   <xsl:if test="@site-weather-wind"><td><xsl:value-of select="@site-weather-wind"/></td></xsl:if>
   <xsl:if test="@site-weather-label"><td><xsl:value-of select="@site-weather-label"/></td></xsl:if>
  </tr>
  </xsl:if>

 </table>

 <table class="smalltable">
  <tr>
   <xsl:for-each select="sports-content-qualifier">
    <td>(<xsl:for-each select="@*"><xsl:value-of select="."/> / </xsl:for-each>)</td>
   </xsl:for-each>
  </tr>
 </table>

 <xsl:apply-templates select="tournament-division-metadata-golf"/>

<!-- LEGACY: Remove this call to apply-templates after Parser bug is fixed -->
   <xsl:apply-templates />

</xsl:template>
<!-- end tournament-metadata and tournament-division-metadata -->


<xsl:template match="tournament-division-metadata-golf">
 <table class="smalltable">
  <tr>
    <td><xsl:for-each select="@*"><xsl:value-of select="name()"/>: <xsl:value-of select="."/> / </xsl:for-each>)</td>
  </tr>
 </table>
</xsl:template>


<!-- Template to handle a tournament division -->
<xsl:template match="tournament-division">
	<table width="100%" class="tournamentDivision">
	<tr>
		<td width="5%">    </td>
		<td>
		<xsl:apply-templates />
		</td>
	</tr>
	</table>
</xsl:template>
<!-- end one tournament-divison -->


<!-- Template to handle a tournament round -->
<xsl:template match="tournament-round">
 <table width="100%" class="tournamentRound">
  <tr>
   <td width="5%">    </td>
   <td>
    <xsl:if test="@round-name or @start-date-time or @round-number">
     <h5 class="tourroundname">
     <xsl:if test="@round-name">
      <xsl:value-of select="@round-name"/><xsl:text>  </xsl:text>
     </xsl:if>
     <xsl:if test="@round-number"> (Round: <xsl:value-of select="@round-number"/>)    </xsl:if>
      <xsl:if test="@start-date-time">
       <xsl:call-template name="formatted-date-time"><xsl:with-param name="date-value" select="@start-date-time"/></xsl:call-template>
       <xsl:if test="@end-date-time">
        <xsl:text> - </xsl:text><xsl:call-template name="formatted-date-time"><xsl:with-param name="date-value" select="@end-date-time"/></xsl:call-template>
       </xsl:if>
      </xsl:if>
     </h5>
    </xsl:if>

    <small>
     <xsl:value-of select="@round-key"/><xsl:if test="@round-key-source"> (<xsl:value-of select="@round-key-source"/>)</xsl:if>
    </small>

    <table class="smalltable">
     <tr align="center"><th colspan="3"><xsl:value-of select="@site-name"/></th></tr>

     <tr><td>
      <xsl:if test="@site-key"><xsl:value-of select="@site-key"/><xsl:if test="@site-key-source"> (<xsl:value-of select="@site-key-source"/>)</xsl:if>/ </xsl:if>
      <xsl:if test="@site-alignment"><xsl:value-of select="@site-alignment"/>/ </xsl:if>
      <xsl:if test="@site-city"><xsl:value-of select="@site-city"/><xsl:if test="@site-county"> (<xsl:value-of select="@site-county"/>)</xsl:if>/ </xsl:if>
      <xsl:if test="@site-state"><xsl:value-of select="@site-state"/>/ </xsl:if>
      <xsl:if test="@site-country"><xsl:value-of select="@site-country"/>/ </xsl:if>
      <xsl:if test="@site-attendance"><xsl:value-of select="@site-attendance"/><xsl:if test="@site-capacity"> (<xsl:value-of select="@site-capacity"/>)</xsl:if>/ </xsl:if>
      <xsl:if test="@site-style"><xsl:value-of select="@site-style"/>/ </xsl:if>
      <xsl:if test="@site-surface"><xsl:value-of select="@site-surface"/>/ </xsl:if>
      <xsl:if test="@site-temperature"><xsl:value-of select="@site-temperature"/><xsl:if test="@site-temperature-units"> (<xsl:value-of select="@site-temperature-units"/>)</xsl:if>/ </xsl:if>
      <xsl:if test="@site-weather-wind"><xsl:value-of select="@site-weather-wind"/>/ </xsl:if>
      <xsl:if test="@site-weather-label"><xsl:value-of select="@site-weather-label"/>/ </xsl:if>
     </td></tr>
    </table>

    <xsl:apply-templates select="player"/>  <!--call this to process other children of tournament round-->
    <xsl:apply-templates select="sports-event"/>  <!--call this to process all children of tournament round-->
 <xsl:call-template name="teams"/>
 <xsl:call-template name="players"/>

   </td>
  </tr>
 </table>
</xsl:template>
<!-- end one tournament-round  -->


<!-- template for one sports-event within a schedule. We assume this is head-to-head stuff -->
<xsl:template name="event-schedule">
 <xsl:param name="oneevent"/>
 <tr>
  <td>
   <xsl:call-template name="formatted-date-time"><xsl:with-param name="date-value" select="$oneevent/event-metadata/@start-date-time"/></xsl:call-template>
  </td>
  <td>
   <b>
    <xsl:call-template name="choose-name">
     <xsl:with-param name="team-meta" select="$oneevent/team[1]/team-metadata"/>
     <xsl:with-param name="shownickname" select="'no'"/>
    </xsl:call-template>
   </b>
   <xsl:if test="$oneevent/event-metadata/@event-status = 'post-event'">
 	(<xsl:value-of select="$oneevent/team[1]/team-stats/@score"/>)
   </xsl:if>
   <!-- below is temporary, for bug in feed -->
   <xsl:if test="$oneevent/event-metadata/@event-status = 'final'">
 	(<xsl:value-of select="$oneevent/team[1]/team-stats/@score"/>)
   </xsl:if>

  </td>
  <td>vs.</td>
  <td><b>
    <xsl:call-template name="choose-name">
     <xsl:with-param name="team-meta" select="$oneevent/team[2]/team-metadata"/>
     <xsl:with-param name="shownickname" select="'no'"/>
    </xsl:call-template></b>
   <xsl:if test="$oneevent/event-metadata/@event-status = 'post-event'">
 	(<xsl:value-of select="$oneevent/team[2]/team-stats/@score"/>)
   </xsl:if>
   <!-- below is temporary, for bug in feed -->
   <xsl:if test="$oneevent/event-metadata/@event-status = 'final'">
 	(<xsl:value-of select="$oneevent/team[2]/team-stats/@score"/>)
   </xsl:if>
  </td>
 </tr>
</xsl:template>
<!-- end named template for one sports-event within a schedule -->


<!-- The template for the actual sports-events -->
<xsl:template match="sports-event">
 <xsl:if test="team or player"> <!-- if there are no players or no teams it is an empty sports-event and we skip it. -->
 <!--
 <h1 class="sportseventline">Sports Event</h1>
 -->
 <table width="100%" class="sportsEvent">          <!-- create a table -->
  <tr>                       <!-- One row for the metadata -->
   <td width="5%">    </td>
    <!-- apply templates to event-metadata -->
   <!--
   <td>
    <xsl:apply-templates select="event-metadata"/>
   </td>
   -->
  </tr>
  <tr>  <!-- Another row for teams or players -->
   <td width="5%">    </td>
   <td>
    <xsl:choose>
     <xsl:when test="team">  <!-- We have team(s) in the event -->
      <xsl:choose>
       <xsl:when test="count(./team) = 2">  <!-- if there are two teams we treat it as a duel. IMPROVE!!  -->
        <xsl:call-template name="teamduel"/>
       </xsl:when>
       <xsl:otherwise> <!-- Otherwise we called the named template for listing teams -->
        <xsl:call-template name="teams"/>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:when>
     <xsl:otherwise>  <!-- Otherwise there are player(s) in the event -->
      <xsl:choose>
       <xsl:when test="count(./player) = 2"> <!-- It there are two players we treat it as a duel. IMPROVE!! -->
        <xsl:call-template name="playerduel"/>
       </xsl:when>
       <xsl:otherwise>  <!-- Otherwise we call the named template to list the players -->
        <xsl:call-template name="players"/>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:otherwise>
    </xsl:choose>
   </td>
  </tr>
  <xsl:apply-templates select="officials"/>
  <xsl:apply-templates select="highlight"/>
  <xsl:apply-templates select="event-actions"/>
 </table>
 </xsl:if>
</xsl:template>
<!-- end template for sports-event -->

<!-- template to handle event-actions -->
<xsl:template match="event-actions">
	<xsl:apply-templates select="event-actions-ice-hockey"/>
</xsl:template>
<!-- end template for various event actions -->

<!-- Template for ice hockey events -->
<xsl:template match="event-actions-ice-hockey">
 <tr><th bgcolor="black" colspan="2"><font color="white">actions</font></th></tr>
 <xsl:for-each select="action-ice-hockey-score">
  <tr>
   <td> </td>
   <td class="hockeygoal">
    Period: <xsl:value-of select="@period-value"/> (<xsl:value-of select="@period-time-elapsed"/>) <xsl:value-of select="@score-team"/>-<xsl:value-of select="@score-team-opposing"/>,

    <xsl:call-template name="choose-name">
     <xsl:with-param name="team-meta" select="id(@player-idref)/player-metadata"/>
     <xsl:with-param name="shownickname" select="'yes'"/>
    </xsl:call-template>

<!--    <xsl:choose>
     <xsl:when test="id(@player-idref)/player-metadata/name/@full">
     <xsl:value-of select="id(@player-idref)/player-metadata/name/@full"/>
    </xsl:when>
    <xsl:otherwise>
    <xsl:value-of select="id(@player-idref)/player-metadata/name/@first"/><xsl:text> </xsl:text><xsl:value-of select="id(@player-idref)/player-metadata/name/@last"/>
    </xsl:otherwise>
    </xsl:choose>-->
        <!-- period-value="1" period-time-elapsed="2.16"  team-idref="E3" score-team="0" score-team-opposing="1" player-idref="F1"-->
    <xsl:if test="@comment">
     (<xsl:value-of select="@comment"/>)
    </xsl:if>

   </td>
  </tr>
 </xsl:for-each>

</xsl:template>
<!-- end template for ice hockey events -->


<!-- template for the highlight -->
<xsl:template match="highlight">
	<tr><th bgcolor="black" colspan="2"><font color="white">highlights</font></th></tr>
	<tr>
		<td> </td>
		<td class="highlight">
		<xsl:apply-templates />
		</td>
	</tr>
</xsl:template>
<!-- end template for highlight -->


<!-- Template to output all officials-->
<xsl:template match="officials">
 <tr><th bgcolor="black" colspan="2"><font color="white">officials</font></th></tr>
 <xsl:for-each select="official">
  <tr>
  <td> </td><td class="officialline"><xsl:value-of select="official-metadata/@position"/><b><xsl:text> </xsl:text><xsl:choose>
     <xsl:when test="official-metadata/name/@full">
      <xsl:value-of select="official-metadata/name/@full"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="official-metadata/name/@first"/><xsl:text> </xsl:text>
      <xsl:value-of select="official-metadata/name/@last"/>
     </xsl:otherwise>
    </xsl:choose></b><xsl:text> </xsl:text>
    <xsl:value-of select="official-metadata/home-location/@city"/><xsl:text> </xsl:text>
    <xsl:value-of select="official-metadata/home-location/@county"/><xsl:text> </xsl:text>
    <xsl:value-of select="official-metadata/home-location/@state"/><xsl:text> </xsl:text>
    <xsl:value-of select="official-metadata/home-location/@country"/><xsl:text> </xsl:text>
    </td>
  </tr>
 </xsl:for-each>
</xsl:template>
<!-- end template for officials -->


<!-- The template for each event-metadata -->

<xsl:template match="event-metadata">
 <xsl:for-each select="event-sponsor/@name">
  <marquee bgcolor="#ff80ff" width="256" height="22" align="middle" scrolldelay="95" border="0"><b>EVENT SPONSOR: <xsl:value-of select="."/></b></marquee><br/>
 </xsl:for-each>

 <table class="smalltable" cellpadding="3" border="1" bgcolor="#cccccc">

    <tr><th bgcolor="black" colspan="2"><font color="white">event metadata</font></th></tr>

	<xsl:if test="@event-name">
		<tr><td>name</td><td class="tourroundname"><xsl:value-of select="@event-name"/>
		<xsl:if test="@event-number"> (<xsl:value-of select="@event-number"/>)</xsl:if>
		</td></tr>
	</xsl:if>


 <xsl:if test="@heat-number">
  <tr><td class="heatno">heat</td><td class="heatno"><b><xsl:value-of select="@heat-number"/></b></td></tr>
 </xsl:if>

 <xsl:if test="@event-key">
 <tr><td>key</td><td><xsl:value-of select="@event-key"/>
 <xsl:if test="@event-key-source"> (<xsl:value-of select="@event-key-source"/>)</xsl:if>
 </td></tr>
 </xsl:if>

 <xsl:if test="@start-date-time">
  <tr><td>date</td><td class="dateline">
  <xsl:value-of select="@start-weekday"/>
  <xsl:text> </xsl:text>
  <b><xsl:call-template name="formatted-date-time">
	<xsl:with-param name="date-value" select="@start-date-time"/>
  </xsl:call-template>
  <xsl:if test="@end-date-time">
   - <xsl:value-of select="@end-weekday"/>
   <xsl:text> </xsl:text>
   <xsl:call-template name="formatted-date-time">
 	<xsl:with-param name="date-value" select="@end-date-time"/>
   </xsl:call-template>
  </xsl:if></b></td></tr>
  </xsl:if>

   <xsl:if test="@stats-coverage"><tr><td>coverage</td><td><xsl:value-of select="@stats-coverage"/></td></tr></xsl:if>
   <xsl:if test="@event-coverage-type"><tr><td>coverage type</td><td><xsl:value-of select="@event-coverage-type"/></td></tr></xsl:if>
   <xsl:if test="@date-coverage-type"><tr><td>date coverage</td><td><xsl:value-of select="@date-coverage-type"/><xsl:if test="@date-coverage-value"> (<xsl:value-of select="@date-coverage-value"/>)</xsl:if></td></tr></xsl:if>
   <xsl:if test="@competition-scoping"><tr><td>competition scoping</td><td><xsl:value-of select="@competition-scoping"/></td></tr></xsl:if>
   <xsl:if test="@alignment-scoping"><tr><td>alignment scoping</td><td><xsl:value-of select="@alignment-scoping"/></td></tr></xsl:if>
   <xsl:if test="@team-scoping"><tr><td>team scoping</td><td><xsl:value-of select="@team-scoping"/></td></tr></xsl:if>
   <xsl:if test="@event-status"><tr><td>event status</td><td><xsl:value-of select="@event-status"/></td></tr></xsl:if>
   <xsl:if test="@postponent-status"><tr><td>postponement status</td><td><xsl:value-of select="@postponent-status"/></td></tr></xsl:if>
   <xsl:if test="@postponent-note"><tr><td>postponement note</td><td><xsl:value-of select="@postponent-note"/></td></tr></xsl:if>

    <tr><th bgcolor="black" colspan="2"><font color="white">site metadata</font></th></tr>

   <xsl:if test="@site-name"><tr align="center"><th>site name</th><th><xsl:value-of select="@site-name"/></th></tr></xsl:if>

   <xsl:if test="@site-key"><tr><td>key</td><td><xsl:value-of select="@site-key"/><xsl:if test="@site-key-source"> (<xsl:value-of select="@site-key-source"/>)</xsl:if></td></tr></xsl:if>
   <xsl:if test="@site-alignment"><tr><td>alignment</td><td><xsl:value-of select="@site-alignment"/></td></tr></xsl:if>
   <xsl:if test="@site-city"><tr><td>city</td><td><xsl:value-of select="@site-city"/><xsl:if test="@site-county"> (<xsl:value-of select="@site-county"/>)</xsl:if></td></tr></xsl:if>
   <xsl:if test="@site-state"><tr><td>state</td><td><xsl:value-of select="@site-state"/></td></tr></xsl:if>
   <xsl:if test="@site-country"><tr><td>country</td><td><xsl:value-of select="@site-country"/></td></tr></xsl:if>
   <xsl:if test="@site-attendance"><tr><td>attendance</td><td><xsl:value-of select="@site-attendance"/><xsl:if test="@site-capacity"> (<xsl:value-of select="@site-capacity"/>)</xsl:if></td></tr></xsl:if>
   <xsl:if test="@site-style"><tr><td>style</td><td><xsl:value-of select="@site-style"/></td></tr></xsl:if>
   <xsl:if test="@site-surface"><tr><td>surface</td><td><xsl:value-of select="@site-surface"/></td></tr></xsl:if>
   <xsl:if test="@site-temperature"><tr><td>temperature</td><td><xsl:value-of select="@site-temperature"/><xsl:if test="@site-temperature-units"> (<xsl:value-of select="@site-temperature-units"/>)</xsl:if></td></tr></xsl:if>
   <xsl:if test="@site-weather-wind"><tr><td>weather wind</td><td><xsl:value-of select="@site-weather-wind"/></td></tr></xsl:if>
   <xsl:if test="@site-weather-label"><tr><td>weather label</td><td><xsl:value-of select="@site-weather-label"/></td></tr></xsl:if>

 </table>

 <xsl:apply-templates />  <!-- Apply templates to sub elements of event-metadata -->

</xsl:template>
<!-- end event metadata  -->

<!--  Template to output a formatted string -->
<xsl:template name="formatted-date-time">
 <xsl:param name="date-value"/>
 <xsl:value-of select="concat(substring-before($date-value,'T'),' ',substring-after($date-value,'T'))"/>
</xsl:template>

<!-- Template to output either fullname or name parts -->
<xsl:template name="choose-name">
 <xsl:param name="team-meta"/>
 <xsl:param name="shownickname"/>
 <xsl:param name="showuniform"/>
 <xsl:choose>
  <xsl:when test="$team-meta/@home-page-url">
   <xsl:element name="a">
    <xsl:attribute name="href">http://<xsl:value-of select="$team-meta/@home-page-url"/></xsl:attribute>
    <xsl:choose>
     <xsl:when test="$team-meta/name/@full">
      <xsl:value-of select="$team-meta/name/@full"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="$team-meta/name/@first"/><xsl:text> </xsl:text>
      <xsl:value-of select="$team-meta/name/@last"/>
     </xsl:otherwise>
    </xsl:choose>
       </xsl:element>
  </xsl:when>
  <xsl:otherwise>
    <xsl:choose>
     <xsl:when test="$team-meta/name/@full">
      <xsl:value-of select="$team-meta/name/@full"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="$team-meta/name/@first"/><xsl:text> </xsl:text>
      <xsl:value-of select="$team-meta/name/@last"/>
     </xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
 </xsl:choose>
 <xsl:if test="$shownickname = 'yes'">
  <xsl:if test="$team-meta/name/@nickname">
   <xsl:text> &quot;</xsl:text>
   <xsl:value-of select="$team-meta/name/@nickname"/>
   <xsl:text> &quot;</xsl:text>
  </xsl:if>
 </xsl:if>
 <xsl:if test="$showuniform = 'yes'">
  <xsl:if test="$team-meta/@uniform-number">
   <xsl:text> (</xsl:text>
   <xsl:value-of select="$team-meta/@uniform-number"/>
   <xsl:text>) </xsl:text>
  </xsl:if>
 </xsl:if>
</xsl:template>
<!-- End template to choose name to output -->

<!-- Named template to process a two teams in a duel style event -->
<xsl:template name="teamduel">

 <xsl:variable name="tableclass"> <!-- Set up a variable to hold the classname for the stylesheet depending on this beeing a sub sports-event or not -->
  <xsl:choose>
   <xsl:when test="../../sports-event">
    <xsl:text>smalltable</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>mediumtable</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>

 <xsl:element name="table">  <!-- Start the table and give it the classname we discovered above -->
  <xsl:attribute name="width">100%</xsl:attribute>
  <xsl:attribute name="valign">top</xsl:attribute>
  <xsl:attribute name="class"><xsl:value-of select="$tableclass"/></xsl:attribute>

  <tr>
   <td>  <!-- If there is a rank start with that and possibly a result-effect. -->
    <xsl:if test="team[1]/team-stats/rank">
     <xsl:value-of select="team[1]/team-stats/rank/@value"/>
      <xsl:if test="team[1]/team-stats/@result-effect">
       (<xsl:value-of select="team[1]/team-stats/@result-effect"/>)
      </xsl:if>
     </xsl:if>
    <b>

    <xsl:call-template name="choose-name">
     <xsl:with-param name="team-meta" select="team[1]/team-metadata"/>
     <xsl:with-param name="shownickname" select="'yes'"/>
    </xsl:call-template>

 -
    </b>
    <xsl:if test="team[2]/team-stats/rank">
     <xsl:value-of select="team[2]/team-stats/rank/@value"/>
     <xsl:if test="team[2]/team-stats/@result-effect">
      (<xsl:value-of select="team[2]/team-stats/@result-effect"/>)
     </xsl:if>
    </xsl:if>
    <b>
    <xsl:call-template name="choose-name">
     <xsl:with-param name="team-meta" select="team[2]/team-metadata"/>
     <xsl:with-param name="shownickname" select="'yes'"/>
    </xsl:call-template>
    </b>
    <xsl:text>  </xsl:text>
    <xsl:if test="team[1]/team-stats/@score">
     <table class="smalltable" valign="top">  <!--start a table-->
      <tr class="blueline"><td>Goals</td><td>Total</td><td>1</td><td>2</td><td>3</td><td>OT</td><td>Shootout</td></tr>
      <xsl:for-each select="team">
       <tr>
        <td><b>
         <xsl:call-template name="choose-name">
          <xsl:with-param name="team-meta" select="team-metadata"/>
          <xsl:with-param name="shownickname" select="'no'"/>
         </xsl:call-template>
         </b>
        </td>
        <td><xsl:value-of select="team-stats/@score"/></td>
        <xsl:for-each select="team-stats/sub-score">
         <td><xsl:value-of select="@score"/></td>
        </xsl:for-each>
       </tr>
      </xsl:for-each>
     </table>

    </xsl:if>

    <xsl:if test="team[1]/team-stats/@score-attempts">
     <table class="smalltable" valign="top">  <!--start a table-->
      <tr class="blueline"><td>Shots on goal</td><td>Total</td><td>1</td><td>2</td><td>3</td><td>OT</td><td>Shootout</td></tr>
      <xsl:for-each select="team">
       <tr>
        <td><b>
         <xsl:call-template name="choose-name">
          <xsl:with-param name="team-meta" select="team-metadata"/>
          <xsl:with-param name="shownickname" select="'no'"/>
         </xsl:call-template>
         </b>
        </td>
        <td><xsl:value-of select="team-stats/@score-attempts"/></td>
        <xsl:for-each select="team-stats/sub-score-attempts">
         <td><xsl:value-of select="@score-attempts"/></td>
        </xsl:for-each>
       </tr>
      </xsl:for-each>
     </table>
    </xsl:if>
    </td></tr>

    <xsl:if test="team[1]/team-stats/penalty-stats or team[2]/team-stats/penalty-stats">
     <tr><td>
     <table class="smalltable" valign="top">  <!--start a table-->
     <tr class="blueline"><td>Penalties:</td></tr>
     <xsl:for-each select="team">
      <tr>
        <td><b>
         <xsl:call-template name="choose-name">
          <xsl:with-param name="team-meta" select="team-metadata"/>
          <xsl:with-param name="shownickname" select="'no'"/>
         </xsl:call-template>:
          </b>

       <xsl:for-each select="team-stats/penalty-stats">

         <xsl:value-of select="@count"/>x<xsl:value-of select="@type"/><xsl:text> </xsl:text>

       </xsl:for-each>

       </td></tr>
     </xsl:for-each>
      </table></td></tr>
    </xsl:if>

    <xsl:if test="team[1]/player">
    <tr><td class="playerlist">
    <xsl:for-each select="team">
      <b>
       <xsl:call-template name="choose-name">
        <xsl:with-param name="team-meta" select="team-metadata"/>
        <xsl:with-param name="shownickname" select="'no'"/>
       </xsl:call-template>:</b>
     <xsl:for-each select="player">

       <xsl:call-template name="choose-name">
        <xsl:with-param name="team-meta" select="player-metadata"/>
        <xsl:with-param name="shownickname" select="'no'"/>
        <xsl:with-param name="showuniform" select="'yes'"/>
       </xsl:call-template>
      <xsl:if test="not(position()=last())"> <br /> </xsl:if>
     </xsl:for-each>
     <xsl:text>. </xsl:text> <br/>
    </xsl:for-each>
   </td>
  </tr>
    </xsl:if>
  <tr><td>
    <xsl:apply-templates select="sports-event"/>
   </td>
  </tr>
  </xsl:element>
</xsl:template>
<!-- end template for teams in duel-type -->


<!-- Named template to process a two players in a duel style event -->
<xsl:template name="playerduel">

 <table xwidth="100%" class="smalltable" valign="top" cellpadding="4">  <!--start a table-->

<xsl:choose>
<xsl:when test=".//player-stats-tennis">
<tr class="blueline"><td>  </td><td>  </td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td></tr>
<xsl:for-each select="player">
<tr>
	<td>
	<xsl:value-of select="player-stats/rank"/>
	
	<xsl:if test="player-stats/@result-effect">
		(<xsl:value-of select="player-stats/@result-effect"/>)
	</xsl:if>  

	<xsl:if test="player-metadata/home-location/@country">
		<xsl:value-of select="player-metadata/home-location/@country"/>
	</xsl:if>  
	</td>



      <td><b><xsl:choose>     <xsl:when test="player-metadata/name/@full">
      <xsl:value-of select="player-metadata/name/@full"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="player-metadata/name/@first"/><xsl:text> </xsl:text>
      <xsl:value-of select="player-metadata/name/@last"/>
     </xsl:otherwise>
    </xsl:choose></b>
    <xsl:if test="player-stats/rank/@value">
		(<xsl:value-of select="player-stats/rank/@value"/>)
	</xsl:if>  
</td>
<xsl:for-each select="player-stats/player-stats-tennis/stats-tennis-set">
<td><xsl:value-of select="@score"/>
	<xsl:if test="@score-tiebreaker">
		<sup><xsl:value-of select="@score-tiebreaker"/></sup>
	</xsl:if> 
</td>
</xsl:for-each>
</tr>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>

  <tr>
   <td>
    <xsl:if test="player[1]/player-stats/rank">
     <xsl:value-of select="player[1]/player-stats/rank/@value"/>
      <xsl:if test="player[1]/player-stats/@result-effect">
       (<xsl:value-of select="player[1]/player-stats/@result-effect"/>)
      </xsl:if>
     </xsl:if>
    <b>
    <xsl:choose>
     <xsl:when test="player[1]/player-metadata/name/@full">
      <xsl:value-of select="player[1]/player-metadata/name/@full"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="player[1]/player-metadata/name/@first"/><xsl:text> </xsl:text>
      <xsl:value-of select="player[1]/player-metadata/name/@last"/>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="player[1]/player-metadata/name/@nickname">
     <xsl:text> &quot;</xsl:text>
     <xsl:value-of select="player[1]/player-metadata/name/@nickname"/>
     <xsl:text> &quot;</xsl:text>
    </xsl:if>
 -
    </b>
        <xsl:if test="player[2]/player-stats/rank/@value">
     <xsl:value-of select="player[2]/player-stats/rank/@value"/>
      <xsl:if test="player[2]/player-stats/@result-effect">
       (<xsl:value-of select="player[2]/player-stats/@result-effect"/>)
      </xsl:if>
     </xsl:if>
     <b>
    <xsl:choose>
     <xsl:when test="player[2]/player-metadata/name/@full">
      <xsl:value-of select="player[2]/player-metadata/name/@full"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="player[2]/player-metadata/name/@first"/><xsl:text> </xsl:text>
      <xsl:value-of select="player[2]/player-metadata/name/@last"/>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="player[2]/player-metadata/name/@nickname">
     <xsl:text> &quot;</xsl:text>
     <xsl:value-of select="player[2]/player-metadata/name/@nickname"/>
     <xsl:text> &quot;</xsl:text>
    </xsl:if></b>
    <xsl:text>  </xsl:text>
    <xsl:if test="player[1]/player-stats/@score">
    <b>
     <xsl:value-of select="player[1]/player-stats/@score"/>-
     <xsl:value-of select="player[2]/player-stats/@score"/>
    </b>
    </xsl:if>
    <xsl:if test="player[1]/player-stats/sub-score">
     <xsl:text>, </xsl:text>
     (<xsl:for-each select="player[1]/player-stats/sub-score">
      <xsl:value-of select="@score"/>-
      <xsl:variable name="periodvalue" select="./@period-value"/>
      <xsl:value-of select="../../../player[2]/player-stats/sub-score[./@period-value = $periodvalue]/@score"/>
      <xsl:if test="not(position() = last())"><xsl:text>, </xsl:text></xsl:if>
     </xsl:for-each>)
    </xsl:if>
    <xsl:if test="player[1]/player-stats/player-stats-tennis">

     <xsl:text>, </xsl:text>
     (<xsl:for-each select="player[1]/player-stats/player-stats-tennis/stats-tennis-set">
      <xsl:value-of select="@score"/>-
      <xsl:variable name="periodvalue" select="./@set-number"/>
      <xsl:value-of select="../../../../player[2]/player-stats/player-stats-tennis/stats-tennis-set[./@set-number = $periodvalue]/@score"/>
      <xsl:if test="not(position() = last())"><xsl:text>, </xsl:text></xsl:if>
     </xsl:for-each>)

    </xsl:if>
    <br/>
    <xsl:apply-templates select="./sports-event"/>

   </td>
  </tr>
</xsl:otherwise>
</xsl:choose>

 </table>

</xsl:template>


<!-- Named template to process a list of teams in a competition style event -->
<xsl:template name="teams">

 <table width="100%" class="smalltable" valign="top">  <!--start a table-->
  <xsl:for-each select="team">             <!--process all teams-->
   <tr valign="top">                                    <!--one row for each team-->
    <td>
     <xsl:value-of select="team-stats/rank/@value"/> <!-- put the rank in the first field-->
     <xsl:if test="team-stats/award/@name">
      <xsl:choose>
       <xsl:when test="team-stats/award/@name = 'Guld' or team-stats/award/@name = 'Gold'">
        <img align="absmiddle"  width="30" height="24" border="0" alt="Gold medal" src="images/medal-gold.gif" />
       </xsl:when>
       <xsl:when test="team-stats/award/@name = 'Silver'">
        <img align="absmiddle"  width="30" height="24" border="0" alt="Silver medal" src="images/medal-silver.gif" />
       </xsl:when>
       <xsl:when test="team-stats/award/@name = 'Bronze' or team-stats/award/@name = 'Brons'">
        <img align="absmiddle" width="30" height="24" border="0" alt="Bronze medal" src="images/medal-bronze.gif" />
       </xsl:when>
       <xsl:otherwise>
      (<xsl:value-of select="team-stats/@result-effect"/>)
      </xsl:otherwise>
      </xsl:choose>
     </xsl:if>
     <xsl:if test="team-stats/@result-effect">
      (<xsl:value-of select="team-stats/@result-effect"/>)
     </xsl:if>
    </td>
    <td>
     <xsl:for-each select="team-metadata/name"> <!--Build the name in the second field-->
      <xsl:if test="@language">
       <xsl:value-of select="@language"/>:
      </xsl:if>
      <xsl:choose>
       <xsl:when test="@full">
        <xsl:value-of select="@full"/>
         <xsl:if test="@first">
          <small>
           (<xsl:value-of select="@first"/><xsl:text> </xsl:text><xsl:value-of select="@last"/>)
          </small>
         </xsl:if>
       </xsl:when>
       <xsl:otherwise>
        <xsl:value-of select="@first"/><xsl:text> </xsl:text><xsl:value-of select="@last"/>
       </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@nickname">
       <xsl:text> &quot;</xsl:text><xsl:value-of select="@nickname"/><xsl:text> &quot;</xsl:text>
      </xsl:if><br/>
     </xsl:for-each>
     <xsl:if test="team-stats/@result-effect or team-stats/award/@name">
      (<xsl:for-each select="player">
       <xsl:choose>
        <xsl:when test="player-metadata/name/@full">
         <xsl:value-of select="player-metadata/name/@full"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:value-of select="player-metadata/name/@first"/><xsl:text> </xsl:text><xsl:value-of select="player-metadata/name/@last"/>
        </xsl:otherwise>
       </xsl:choose>
       <xsl:if test="not(position()=last())">, </xsl:if>
      </xsl:for-each>)
     </xsl:if>
    </td>
    <td>  <!--Put the home-information in the third field-->
     <xsl:if test="home-location/@city"><xsl:value-of select="home-location/@city"/>, </xsl:if>
     <xsl:if test="home-location/@county"><xsl:value-of select="home-location/@county"/>, </xsl:if>
     <xsl:if test="home-location/@state"><xsl:value-of select="home-location/@state"/>, </xsl:if>
     <xsl:if test="home-location/@country"><xsl:value-of select="home-location/@country"/>, </xsl:if>
    </td>
    <td>
     <xsl:value-of select="team-stats/@score"/>
     <xsl:if test="team-stats/event-record">
      <b><i color="#FF00FF">
      <xsl:for-each select="team-stats/event-record">
       <xsl:text> </xsl:text>
       <xsl:value-of select="./@type"/>-record
       <xsl:if test="not(position() = last())">, </xsl:if>
      </xsl:for-each>
      </i></b>
     </xsl:if>
    </td>
   </tr>
  </xsl:for-each>
 </table>
</xsl:template>
<!-- end template for team lists in competitions -->


<!-- Named template to process all players in a competitions tyle event -->
<xsl:template name="players">
 <table width="100%" class="smalltable">
  <xsl:for-each select="player"> <!--Process all palyers-->
   <tr> <!--build a row for each player-->
    <td align="right">
     <xsl:value-of select="player-stats/rank/@value"/>  <!--Put the rank in the first field-->
    </td>
    <td>
     <xsl:if test="player-stats/award/@name">
      <xsl:choose>
       <xsl:when test="player-stats/award/@name = 'Gold' or player-stats/award/@name = 'Gold'">
        <img align="absmiddle"  width="30" height="24" border="0" alt="Gold medal" src="images/medal-gold.gif" />
       </xsl:when>
       <xsl:when test="player-stats/award/@name = 'Silver'">
        <img align="absmiddle"  width="30" height="24" border="0" alt="Silver medal" src="images/medal-silver.gif" />
       </xsl:when>
       <xsl:when test="player-stats/award/@name = 'Bronze' or player-stats/award/@name = 'Brons'">
        <img align="absmiddle" width="30" height="24" border="0" alt="Bronze medal" src="images/medal-bronze.gif" />
       </xsl:when>
      </xsl:choose>
     </xsl:if>
     <xsl:if test="player-stats/@result-effect">
      (<xsl:value-of select="player-stats/@result-effect"/>)
     </xsl:if>
    </td>
    <td>                    <!-- Name information is built into second field -->
     <xsl:for-each select="player-metadata/name">
      <xsl:if test="@language">
       <xsl:value-of select="@language"/>:
      </xsl:if>
      <xsl:choose>
       <xsl:when test="@full">
        <xsl:value-of select="@full"/>
        <xsl:if test="@first">
         <small>(<xsl:value-of select="@first"/><xsl:text> </xsl:text><xsl:value-of select="@last"/>)</small>
        </xsl:if>
       </xsl:when>
       <xsl:otherwise>
        <xsl:value-of select="@first"/><xsl:text> </xsl:text><xsl:value-of select="@last"/>
       </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@nickname">
       <xsl:text> &quot;</xsl:text><xsl:value-of select="@nickname"/><xsl:text> &quot;</xsl:text>
      </xsl:if>
     </xsl:for-each>
    </td>
    <td>
     <xsl:if test="player-metadata/home-location/@city"><xsl:value-of select="player-metadata/home-location/@city"/> </xsl:if>
     <xsl:if test="player-metadata/home-location/@county"><xsl:value-of select="player-metadata/home-location/@county"/> </xsl:if>
     <xsl:if test="player-metadata/home-location/@state"><xsl:value-of select="player-metadata/home-location/@state"/> </xsl:if>
     <xsl:if test="player-metadata/home-location/@country"><xsl:value-of select="player-metadata/home-location/@country"/> </xsl:if>
    </td>
    <td>
     <xsl:value-of select="player-stats/@score"/>
     <xsl:if test="player-stats/event-record">
      <b><i color="#FF00FF">
      <xsl:for-each select="player-stats/event-record">
       <xsl:text> </xsl:text>
       <xsl:value-of select="./@type"/>-record
       <xsl:if test="not(position() = last())">, </xsl:if>
      </xsl:for-each>
      </i></b>
     </xsl:if>
    </td>
   </tr>
  </xsl:for-each>
 </table>
</xsl:template>


<!--       Tests and old stuff    -->

<!--<xsl:for-each select="@*">
<tr><td><xsl:value-of select="name()"/></td><td><xsl:value-of select="."/></td></tr>
</xsl:for-each>-->

<!--
<xsl:if test="@">
<tr><td>:</td><td><xsl:value-of select="@"/></td></tr>
</xsl:if>

<xsl:for-each select="@*">
			<xsl:value-of select="{name()}"/><xsl:text>=</xsl:text><xsl:value-of select="."/>
		<br/>
		</xsl:for-each>
	<xsl:element name="{name()}">
		<xsl:for-each select="@*">
		<p>
			<xsl:value-of select="{name()}"/><xsl:text>=</xsl:text><xsl:value-of select="."/>
		</p>
		</xsl:for-each>
		<xsl:apply-templates select="*|text()"/>
	</xsl:element>
-->


<!--	NITF Formatting		-->

<xsl:template match="nitf">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="body.head|body.content|hedline">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="p">
	<p class="nitfp"><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match="note">
	<p class="nitfnote"><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match="byline">
	<p class="nitfbyline"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="person">
<span class="nitfperson"><xsl:value-of select="."/></span>
</xsl:template>

<xsl:template match="byttl">
<br /><span class="nitfbylinetitle"><xsl:value-of select="."/></span>
</xsl:template>

<xsl:template match="hl1">
	<h3 class="nitfhl1"><xsl:apply-templates /></h3>
</xsl:template>

<xsl:template match="hl2">
	<h3 class="nitfhl2"><xsl:apply-templates /></h3>
</xsl:template>

<xsl:template match="hl3">
	<h3 class="nitfhl3"><xsl:apply-templates /></h3>
</xsl:template>

<xsl:template match="td">
	<td class="nitftd"><xsl:apply-templates /></td>
</xsl:template>

<xsl:template match="th">
	<td class="nitfth"><xsl:apply-templates /></td>
</xsl:template>

<xsl:template match="tr">
	<tr class="nitftr"><xsl:apply-templates /></tr>
</xsl:template>

<xsl:template match="table">
	<table class="smalltable" cellspacing="4">
	<xsl:apply-templates /></table>
</xsl:template>

<xsl:template match="ol">
	<ol class="nitfol">
	<xsl:apply-templates />
	</ol>
</xsl:template>

<xsl:template match="ul">
	<dl class="nitful">
	<xsl:apply-templates />
	</dl>
</xsl:template>

<xsl:template match="li">
	<dt class="nitfli">
	<xsl:apply-templates />
	</dt>
</xsl:template>

<xsl:template match="media">
	<xsl:apply-templates /><br /><br />
</xsl:template>

<!--
	What about media-caption, etc.?
	Add stylesheet .css attributes here?
-->

</xsl:stylesheet>
