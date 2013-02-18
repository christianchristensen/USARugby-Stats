<?php

namespace RugbyStatsMigrations;

use Doctrine\DBAL\Migrations\AbstractMigration,
    Doctrine\DBAL\Schema\Schema;

/**
 * Add a column to the competition to indicate whether or not to bypass player
 * roster checkin.
 */
class Version20130218135727 extends AbstractMigration
{
    public function up(Schema $schema)
    {
        $this->addSql('ALTER TABLE comps ADD bypass_checkin INT(1) DEFAULT NULL');
    }

    public function down(Schema $schema)
    {
        $this->addSql('ALTER TABLE comps DROP bypass_checkin;');
    }
}
