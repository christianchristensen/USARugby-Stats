<?php
include_once './include.php';

$comp_id = $request->get('id');
$comp = $db->getCompetition($comp_id);
?>


<h1><?php print $comp['name']; ?></h1>
<?php include_once './comp_info.php'; ?>
<?php

echo "<h2>Teams</h2>";
echo "<div id='teams' class='span8'>";
// Get the teams in this comp
include_once './comp_teams.php';
echo "</div>";

if (editCheck(1)) {
    echo "<div class='clearfix'></div>";
    echo "<div id='addteamdiv' class='span6'>";
    include_once './add_team.php';
    echo "</div>";
}

echo "<div class='clearfix'></div>";
echo "<h2>Games</h2>";
echo "<div id='games'>";
// Get the games in this comp
// Replace include_once with comp_games.twig
include_once './comp_games.php';
echo "</div>";

if (editCheck(1)) {
    echo "<div id='addgamediv'>";
    include_once './add_game.php';
    echo "</div>";
}

include_once './footer.php';
mysql_close();
