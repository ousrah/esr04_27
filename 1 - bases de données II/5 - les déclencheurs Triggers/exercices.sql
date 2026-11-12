use vols_esr;

select * from pilote;
select * from avion;
select * from vol;

ALTER TABLE vol add dated DATETIME;
ALTER TABLE vol add datea DATETIME;

ALTER TABLE pilote ADD COLUMN NBHV TIME DEFAULT '00:00:00';


DROP TRIGGER IF EXISTS after_insert_vol;
DELIMITER $$
CREATE TRIGGER after_insert_vol 
AFTER INSERT ON vol 
FOR EACH ROW
BEGIN 
    UPDATE pilote SET NBHV = ADDTIME(NBHV, TIMEDIFF(NEW.datea, NEW.dated))
    WHERE numpilote = NEW.numpil;
END$$
DELIMITER ;

select * from vol;
select * from pilote;
insert into vol values (null, 1,1,'2026/11/11 08:00:00','2026/11/11 10:00:00');
insert into vol values (null, 1,1,'2026/11/12 14:00:00','2026/11/12 19:00:00');

DROP TRIGGER IF EXISTS after_delete_vol;
DELIMITER $$
CREATE TRIGGER after_delete_vol 
AFTER DELETE ON vol 
FOR EACH ROW
BEGIN 
	UPDATE pilote SET NBHV = SUBTIME(NBHV, TIMEDIFF(OLD.datea, OLD.dated))
    WHERE numpilote = OLD.numpil;
END$$
DELIMITER ;

select * from vol;
select * from pilote;
delete from vol where numvol = 16;


DROP TRIGGER IF EXISTS after_update_vol;
DELIMITER &&
CREATE TRIGGER after_update_vol
AFTER UPDATE ON vol
FOR EACH ROW
BEGIN
    UPDATE pilote
    SET NBHV = ADDTIME(
                        SUBTIME(NBHV, TIMEDIFF(OLD.datea, OLD.dated)),
                        TIMEDIFF(NEW.datea, NEW.dated)
					)
    WHERE numpilote = NEW.numpil;
END&&
DELIMITER ;

select * from vol;
select * from pilote;

update vol set datea ='2026-11-11 09:30:00' where numvol = 15;

