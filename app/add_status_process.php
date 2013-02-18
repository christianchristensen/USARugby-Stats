<?php
include_once './include_mini.php';

$game_id = $_POST['game_id'];
$status = mysql_real_escape_string($_POST['status']);

$db->updateGameStatus($status, $game_id);

// Update the score, team that wins gets 4 tries with a score of 20.
$game_status = $db->getGameStatus($game_id);
$game = $db->getGame($game_id);
if ($game_status['status_name'] == 'Home Forfeit') {
    $game['away_score'] = 20;
    $db->updateGame($game_id, $game);
}
elseif ($game_status['status_name'] == 'Away Forfeit') {
    $game['home_score'] = 20;
    $db->updateGame($game_id, $game);
}
