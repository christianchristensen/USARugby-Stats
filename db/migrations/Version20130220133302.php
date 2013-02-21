<?php

namespace RugbyStatsMigrations;

use Doctrine\DBAL\Migrations\AbstractMigration,
    Doctrine\DBAL\Schema\Schema;

/**
 * Adding an optional proxy user to the users table.
 */
class Version20130220133302 extends AbstractMigration
{
    public function up(Schema $schema)
    {
        $this->addSql('ALTER TABLE users ADD proxy_user INT(4) DEFAULT NULL');
    }

    public function down(Schema $schema)
    {
        $this->addSql('ALTER TABLE users DROP proxy_user;');
    }
}
