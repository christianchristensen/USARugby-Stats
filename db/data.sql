INSERT INTO `event_types` VALUES (1,1,'Try',5),(2,2,'Conversion',2),(3,3,'Penalty Kick',3),(4,4,'Drop Goal',3),(5,11,'Tactical Sub Off',0),(6,12,'Tactical Sub On',0),(7,13,'Injury Sub Off',0),(8,14,'Injury Sub On',0),(9,15,'Blood Sub Off',0),(10,16,'Blood Sub On',0),(11,21,'Yellow Card',0),(12,22,'Red Card',0),(13,17,'Front Row Card Sub Off',0),(14,18,'Front Row Card Sub On',0),(15,5,'Penalty Try',5);
INSERT INTO `game_status` (`status_name`)
VALUES
	('Not Yet Started'),
	('Started'),
	('Finished'),
	('Home Forfeit'),
	('Away Forfeit'),
	('Cancelled');
