<?php

namespace Source;

use AllPlayers\Component\ClientFactory;
use AllPlayers\Client;
use Guzzle\Plugin\Log\LogPlugin;
use Guzzle\Service\Inspector;
use Guzzle\Service\Resource\ResourceIteratorClassFactory;

class APSource extends Client {
    public static function SessionSourceFactory($base_url = 'https://www.pdup.allplayers.com', LogPlugin $log_plugin = null) {
        $attributes = $_SESSION['_sf2_attributes'];
        return APSource::SourceFactory($attributes, $base_url, $log_plugin);
    }

    public static function SourceFactory($attributes = null, $base_url = 'https://www.pdup.allplayers.com', LogPlugin $log_plugin = null) {
        $base_url = (isset($attributes['domain'])) ? $attributes['domain'] : $base_url;
        $oauth_config = array(
            'consumer_key' => $attributes['consumer_key'],
            'consumer_secret' => $attributes['consumer_secret'],
            'token' => $attributes['auth_token'],
            'token_secret' => $attributes['auth_secret']
        );
        $client = new self($base_url, $log_plugin);
        $http_client = $client->getClient();
        $http_client->setSslVerification(!empty($attributes['verify_peer']));
        ClientFactory::OauthFactory($base_url, $oauth_config, $client, $log_plugin);

        return $client;
    }

    public function getGroupMembers($group_uuid) {
        $offset = 0;
        $members = array();
        do {
            $response = $this->groupsGetMembers($group_uuid, NULL, $offset, 10);
            $offset+=1;
            $members = array_merge($members, (array) $response);
        } while (sizeof($response) == 10);
        return $members;
    }

    public function getUserByUUID($uuid) {
        $command = $this->getCommand('GetUser', array('uuid' => $uuid));
        $user = $command->execute();
        return $user;
    }


    public function getGroupResources($group_uuid, $decode = TRUE) {
       $command = $this->getCommand('GetGroupResources', array('uuid' => $group_uuid));
       $command->execute();
       return empty($decode) ? $command->getResponse()->getBody() : json_decode($command->getResponse()->getBody());
    }

    public function createEvent($event_info) {
        $event = $this->eventsCreateEvent($event_info['groups'], $event_info['title'], $event_info['description'], $event_info['date_time'],
                $event_info['category'], $event_info['resources'], $event_info['competitors'], $event_info['published'], $event_info['external_id']);
        return $event;
    }

    public function updateEvent($uuid, $event_info) {
        $event = $this->eventsUpdateEvent($uuid, $event_info['groups'], $event_info['title'], $event_info['description'], $event_info['date_time'],
                $event_info['category'], $event_info['resources'], $event_info['competitors'], $event_info['published'], $event_info['external_id']);
        return $event;
    }

    public function deleteEvent($uuid) {
        // @TODO: Move this to the upstream library.
        $this->delete("/api/v1/rest/events/$uuid");
    }

    public function getSubgroups($uuid) {
        // @TODO: Move this to the upstream library.
        return $this->get("/api/v1/rest/groups/$uuid/subgroups/tree", array(
            'depth' => 17,
            'include_group_info' => 0,
            'include_hidden' => 0,
            'inclusive' => 1,
            'is_admin' => 0,
            'is_member' => 0,
        ));
    }
}