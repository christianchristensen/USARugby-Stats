<?php

namespace Source\Job;

use Kue\Job;
use Source\APSource;
use Source\DataSource;

class GroupSyncJob implements Job
{
    private $sessionattributes;

    public function __construct($sessionattributes) {
        $this->sessionattributes = $sessionattributes;
    }

    public function run()
    {
        $db = new DataSource();
        $existing_teams = $db->getAllTeams();
        $attributes = $this->sessionattributes;
        $user = $db->getUser($attributes['user_uuid']);
        $client = APSource::SourceFactory($attributes);
        $teams = array();
        $offset = 0;
        $added = 0;
        $temp = $client->getSubgroups('6a503184-e968-11e1-bf28-12313d186528');
        do {
            $response = $client->userGetMyGroups($attributes['user_uuid'], '*,group_type', $offset, 1000);
            $offset+= 1;
            $teams = array_merge($teams, (array)$response);
        } while (sizeof($response) == 1000);
        foreach ($teams as $team) {
            $team = (is_array($team)) ? $team : (array) $team;
            if (!empty($team['logo'])) {
                $logo_url = substr($team['logo'], strpos($team['logo'], '/sites/default/'));
            }
            else {
                $logo_url = '/sites/default/files/imagecache/img_120x120_s/sites/all/modules/apci_features/apci_defaults/group-icon.png';
            }
            $team_info = array(
                'hidden' => 0,
                'user_create' => $user['login'],
                'uuid' => $team['uuid'],
                'name' => $team['title'],
                'short' => $team['title'],
                'logo_url' => $logo_url,
                'description' => $team['description'],
                'type' => $team['group_type'],
            );
            if (!key_exists($team['uuid'], $existing_teams)) {
                $db->addupdateTeam($team_info);
                $added++;
                $existing_teams[$team['uuid']] = $team_info;
            }
            else {
                if (!empty($existing_teams[$team['uuid']]['id']) && is_numeric($existing_teams[$team['uuid']]['id'])) {
                    $team_info['id'] = $existing_teams[$team['uuid']]['id'];
                    $db->addupdateTeam($team_info);
                    $existing_teams[$team['uuid']] = $team_info;
                }
            }
        }
        // @TODO: Log status of queue operation: "X Groups Added"
    }
}
