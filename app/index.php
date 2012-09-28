<?php
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Guzzle\Http\Client;
use Guzzle\Http\Plugin\OauthPlugin;
use AllPlayers\AllPlayersClient;

require_once __DIR__.'/../vendor/autoload.php';

$app = new Silex\Application();

// register the session extension
$app->register(new Silex\Provider\SessionServiceProvider());
$app->register(new Silex\Provider\TwigServiceProvider(), array(
    'twig.path' => __DIR__.'/views',
));

/**
 * Setup app default settings
 */
$app->before(function (Request $request) use ($app) {
        // Include configuration file.
        include_once './config.php';
        $app['config'] = $config;
        $app['session']->start();
        $domain = $app['session']->get('domain');
        if ($domain == null) {
            if ($env = $config['auth_domain']) {
                $app['session']->set('domain', $env);
            } else {
                $app['session']->set('domain', 'https://www.allplayers.com');
            }
        }
        $consumer_key = $app['session']->get('consumer_key');
        if ($consumer_key == null) {
            if ($key = $request->query->get('key')) {
                $secret = $request->query->get('secret');
                $app['session']->set('consumer_key', $key);
                $app['session']->set('consumer_secret', $secret);
            } else {
                $app['session']->set('consumer_key', $config['consumer_key']);
                $app['session']->set('consumer_secret', $config['consumer_secret']);
            }
        }
    });

/**
 *  Default route - simple login page.
 */
$app->get('/', function() use ($app) {
        $app['session']->start();
        // twig/template this section
        if (($token = $app['session']->get('auth_token')) == null) {
            return $app['twig']->render('index.twig', array());
        } else {
            $temp_token = $app['session']->get('access_token');
            $temp_secret = $app['session']->get('access_secret');
            $secret = $app['session']->get('auth_secret');

            // HACK perform access check on Matts app
            include_once './session.php';
            if (empty($_SESSION['user'])) {
                // Error something happened with login...
                session_destroy();
                return $app->redirect('/');
            }
            // @TODO: Change this to use a twig template.
            // Originally "index.php"
            include_once './include.php';
            echo "<h1>Welcome to USA Rugby's National Championship Series!</h1>";

            if (editCheck(1)) {
                echo "<a class='btn btn-info' href='add_comp.php'>Add New Competition</a><br/>\r";
            }

            //List our comps
            echo "<h2>Competitions</h2>";
            echo "<div id='comps'>";
            include_once './comp_list.php';
            echo "</div>";
            include_once './footer.php';
            mysql_close();

            return '';
        }
    });

/**
 *  Login callback for temp OAuth tokens.
 */
$app->get('/login', function(Request $request) use ($app) {
        $app['session']->start();
        // check if the user is already logged-in
        if (null !== ($username = $app['session']->get('username'))) {
            return $app->redirect('/');
        }

        $client = new Client($app['session']->get('domain') . '/oauth', array(
                'curl.CURLOPT_SSL_VERIFYPEER' => isset($app['config']['verify_peer']) ? $app['config']['verify_peer'] : TRUE,
                'curl.CURLOPT_CAINFO' => 'assets/mozilla.pem',
                'curl.CURLOPT_FOLLOWLOCATION' => FALSE,
            ));

        $oauth = new OauthPlugin(array(
                'consumer_key' => $app['session']->get('consumer_key'),
                'consumer_secret' => $app['session']->get('consumer_secret'),
                'token' => FALSE,
                'token_secret' => FALSE,
            ));

        // if $request path !set then set to request_token
        $timestamp = time();
        $params = $oauth->getParamsToSign($client->get('request_token'), $timestamp);
        $params['oauth_signature'] = $oauth->getSignature($client->get('request_token'), $timestamp);
        $response = $client->get('request_token?' . http_build_query($params))->send();

        // Parse oauth tokens from response object
        $oauth_tokens = array();
        parse_str($response->getBody(TRUE), $oauth_tokens);
        $app['session']->set('access_token', $oauth_tokens['oauth_token']);
        $app['session']->set('access_secret', $oauth_tokens['oauth_token_secret']);

        $authorize = '/oauth/authorize?oauth_token=' . $oauth_tokens['oauth_token'];
        $authorize .= '&oauth_callback=' . urlencode($request->getScheme() . '://' . $request->getHost() . '/auth');

        return $app->redirect($app['session']->get('domain') . $authorize);
    });

/**
 *  OAuth authorization callback once user verifies.
 */
$app->get('/auth', function() use ($app) {
        $app['session']->start();
        // check if the user is already logged-in or we're already auth
        if ((null !== $app['session']->get('username')) || (null !== $app['session']->get('auth_secret'))) {
            return $app->redirect('/');
        }

        $oauth_token = $app['session']->get('access_token');
        $secret = $app['session']->get('access_secret');
        if ($oauth_token == null) {
            $app->abort(400, 'Invalid token');
        }
        $client = new Client($app['session']->get('domain') . '/oauth', array(
                'curl.CURLOPT_SSL_VERIFYPEER' => isset($app['config']['verify_peer']) ? $app['config']['verify_peer'] : TRUE,
                'curl.CURLOPT_CAINFO' => 'assets/mozilla.pem',
                'curl.CURLOPT_FOLLOWLOCATION' => FALSE,
            ));

        $oauth = new OauthPlugin(array(
                'consumer_key' => $app['session']->get('consumer_key'),
                'consumer_secret' => $app['session']->get('consumer_secret'),
                'token' => $oauth_token,
                'token_secret' => $secret,
            ));
        $client->addSubscriber($oauth);

        $response = $client->get('access_token')->send();

        // Parse oauth tokens from response object
        $oauth_tokens = array();
        parse_str($response->getBody(TRUE), $oauth_tokens);
        $app['session']->set('auth_token', $oauth_tokens['oauth_token']);
        $app['session']->set('auth_secret', $oauth_tokens['oauth_token_secret']);
        $token = $oauth_tokens['oauth_token'];
        $secret = $oauth_tokens['oauth_token_secret'];

        // Originally "check.php"
        //Start session and get DB info and start DB connection
        include_once './session.php';
        include_once './include_micro.php';
        //Look for any users with our login and md5'ed password
        if (!empty($token) && !empty($secret)) {
            $client = AllPlayersClient::factory(array(
                'auth' => 'oauth',
                'oauth' => array(
                    'consumer_key' => $app['session']->get('consumer_key'),
                    'consumer_secret' => $app['session']->get('consumer_secret'),
                    'token' => $token,
                    'token_secret' => $secret
                ),
                'host' => parse_url($app['session']->get('domain'), PHP_URL_HOST),
                'curl.CURLOPT_SSL_VERIFYPEER' => isset($app['config']['verify_peer']) ? $app['config']['verify_peer'] : TRUE,
                'curl.CURLOPT_CAINFO' => 'assets/mozilla.pem',
                'curl.CURLOPT_FOLLOWLOCATION' => FALSE
            ));

            $response = $client->get('users/current.json')->send();
            // Note: getLocation returns full URL info, but seems to work as a request in Guzzle
            $response = $client->get($response->getLocation())->send();
            $user = json_decode($response->getBody(TRUE));

            $app['session']->set('user_uuid', $user->uuid);
            $db = new Source\DataSource();
            $local_user = $db->getUser($user->uuid);
            if (empty($local_user)) {
                $local_user = $db->getUser(NULL, $user->email);
            }

            //if we have a user match give them a session user and let them in
            if (!empty($local_user)) {
                // Update uuid if needed.
                $local_user['uuid'] = empty($local_user['uuid']) ? $user->uuid : $local_user['uuid'];
                // Update email if needed.
                $local_user['login'] = empty($local_user['login']) ? $user->email : $local_user['login'];
                // Update token and secret.
                $local_user['token'] = $token;
                $local_user['secret'] = $secret;
                // Pass session info to the legacy app.
                $_SESSION['user'] = $local_user['login'];
                $_SESSION['teamid'] = $local_user['team'];
                $_SESSION['access'] = $local_user['access'];

                $db->updateUser($local_user['id'], $local_user);

                // TODO User management if user is authenticating for the first time insert
                //  them, otherwise update their token records.
            }
            // @TODO figure out a better way to fail authentication.
        }

        return $app->redirect('/');
    });

$app->run();
