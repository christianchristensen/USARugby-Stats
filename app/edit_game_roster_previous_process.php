<?php
include_once './include_mini.php';

//Get team_id to prevent direct URL access from another team
$team_id = $_POST['team_id'];

//verify we can edit
if (editCheck(2, $team_id)) {

    //get previous game id
    $query = "SELECT * FROM `games` WHERE comp_id = {$_POST['comp_id']} AND
(home_id = $team_id OR away_id = $team_id) ORDER BY kickoff";
    $result = mysql_query($query);
    while ($row=mysql_fetch_assoc($result)) {
        if ($row['id'] == $_POST['game_id']) {
            $p_id = $temp;
        }
        $temp = $row['id'];
    }

    //get previous roster data
    $prev_roster = $db->getRoster($p_id, $team_id);
    $player_ids = $prev_roster['player_ids'];
    $player_positions = $prev_roster['positions'];
    $numbers = $prev_roster['numbers'];
    $frontrows = $prev_roster['frontrows'];

    //get rest of necessary data to update roster
    $roster_id = $_POST['roster_id'];
    $now = date('Y-m-d H:i:s');

    //update roster
    $query = "UPDATE `game_rosters` SET user_create='{$_SESSION['user']}',last_edit='$now',player_ids='$player_ids',positions='$player_positions',
numbers='$numbers', frontrows='$frontrows' WHERE id='$roster_id'";
    $result = mysql_query($query);
}
