<?php

namespace RugbyStatsMigrations;

use Doctrine\DBAL\Migrations\AbstractMigration,
    Doctrine\DBAL\Schema\Schema;

/**
 * Adding group above UUID to team relationship.
 */
class Version20130207141002 extends AbstractMigration
{
    public function up(Schema $schema)
    {
        $this->addSql('ALTER TABLE teams ADD group_above_uuid CHAR(36) DEFAULT NULL');
    }

    public function down(Schema $schema)
    {
        $this->addSql('ALTER TABLE teams DROP group_above_uuid;');
    }
}
